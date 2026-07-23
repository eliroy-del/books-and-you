import { NextResponse } from "next/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { verifyPayment } from "@/lib/providers";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";

export async function POST(request: Request) {
  const body = await request.json().catch(() => null);
  const secretHash = request.headers.get("verif-hash");

  if (
    process.env.FLUTTERWAVE_SECRET_HASH &&
    secretHash !== process.env.FLUTTERWAVE_SECRET_HASH
  ) {
    return NextResponse.json({ error: "Invalid hash" }, { status: 401 });
  }

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ received: true, demo: true });
  }

  const supabase = createServiceClient();
  const client = db(supabase);

  await client.from("webhook_logs").insert({
    provider: "flutterwave",
    event_type: body?.event ?? "unknown",
    payload: body ?? {},
    status: "received",
  });

  const reference = body?.data?.tx_ref as string | undefined;
  const status = String(body?.data?.status || "").toLowerCase();

  if (reference && status === "successful") {
    const verification = await verifyPayment("flutterwave", reference);
    const { data: tx } = await client
      .from("transactions")
      .select("order_id")
      .eq("provider_reference", reference)
      .maybeSingle();

    if (tx?.order_id && verification.ok) {
      await fulfillPaidOrder(supabase, {
        orderId: tx.order_id,
        paymentReference: reference,
        providerReference: verification.providerReference,
      });
    }
  }

  return NextResponse.json({ received: true });
}
