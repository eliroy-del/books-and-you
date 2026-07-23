import { NextResponse } from "next/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { verifyPayment } from "@/lib/providers";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";
import { createHmac, timingSafeEqual } from "crypto";

function verifyPaystackSignature(rawBody: string, signature: string | null) {
  const secret = process.env.PAYSTACK_SECRET_KEY;
  if (!secret || !signature) return false;
  const hash = createHmac("sha512", secret).update(rawBody).digest("hex");
  try {
    return timingSafeEqual(Buffer.from(hash), Buffer.from(signature));
  } catch {
    return false;
  }
}

export async function POST(request: Request) {
  const rawBody = await request.text();
  const signature = request.headers.get("x-paystack-signature");

  let event: {
    event?: string;
    data?: { reference?: string; status?: string; id?: number };
  };

  try {
    event = JSON.parse(rawBody);
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  if (process.env.PAYSTACK_SECRET_KEY && !verifyPaystackSignature(rawBody, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ received: true, demo: true });
  }

  const supabase = createServiceClient();
  const client = db(supabase);

  await client.from("webhook_logs").insert({
    provider: "paystack",
    event_type: event.event ?? "unknown",
    payload: event,
    status: "received",
  });

  if (event.event === "charge.success" && event.data?.reference) {
    const reference = event.data.reference;
    const verification = await verifyPayment("paystack", reference);

    const { data: tx } = await client
      .from("transactions")
      .select("order_id")
      .eq("provider_reference", reference)
      .maybeSingle();

    if (tx?.order_id && verification.ok) {
      await fulfillPaidOrder(supabase, {
        orderId: tx.order_id,
        paymentReference: reference,
        providerReference: verification.providerReference || String(event.data.id ?? ""),
      });
    }
  }

  return NextResponse.json({ received: true });
}
