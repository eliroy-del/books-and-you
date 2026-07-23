import { NextResponse } from "next/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";
import { createHmac, timingSafeEqual } from "crypto";

function verifyStripeSignature(rawBody: string, header: string | null) {
  const secret = process.env.STRIPE_WEBHOOK_SECRET;
  if (!secret || !header) return !secret; // allow unsigned in local/dev without secret

  const parts = Object.fromEntries(
    header.split(",").map((p) => {
      const [k, v] = p.split("=");
      return [k, v];
    })
  );
  const timestamp = parts.t;
  const signature = parts.v1;
  if (!timestamp || !signature) return false;

  const payload = `${timestamp}.${rawBody}`;
  const expected = createHmac("sha256", secret).update(payload).digest("hex");
  try {
    return timingSafeEqual(Buffer.from(expected), Buffer.from(signature));
  } catch {
    return false;
  }
}

export async function POST(request: Request) {
  const rawBody = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (process.env.STRIPE_WEBHOOK_SECRET && !verifyStripeSignature(rawBody, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const event = JSON.parse(rawBody) as {
    type?: string;
    data?: { object?: Record<string, unknown> };
  };

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ received: true, demo: true });
  }

  const supabase = createServiceClient();
  const client = db(supabase);

  await client.from("webhook_logs").insert({
    provider: "stripe",
    event_type: event.type ?? "unknown",
    payload: event,
    status: "received",
  });

  if (event.type === "checkout.session.completed") {
    const session = event.data?.object ?? {};
    const reference =
      (session.client_reference_id as string) ||
      (session.metadata as { reference?: string } | undefined)?.reference;

    if (reference) {
      const { data: tx } = await client
        .from("transactions")
        .select("order_id")
        .eq("provider_reference", reference)
        .maybeSingle();

      if (tx?.order_id) {
        await fulfillPaidOrder(supabase, {
          orderId: tx.order_id,
          paymentReference: reference,
          providerReference: String(session.payment_intent || session.id || ""),
        });
      }
    }
  }

  return NextResponse.json({ received: true });
}
