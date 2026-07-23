import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { verifyPayment, type PaymentProviderId } from "@/lib/providers";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { provider, reference } = body as {
      provider: PaymentProviderId;
      reference: string;
    };

    if (!provider || !reference) {
      return NextResponse.json(
        { ok: false, error: "provider and reference required" },
        { status: 400 }
      );
    }

    const verification = await verifyPayment(provider, reference);
    if (!verification.ok || verification.status !== "succeeded") {
      return NextResponse.json(
        {
          ok: false,
          status: verification.status,
          error: verification.error || "Payment not completed",
        },
        { status: 402 }
      );
    }

    if (!isSupabaseConfigured()) {
      return NextResponse.json({
        ok: true,
        demo: true,
        reference,
        status: "succeeded",
      });
    }

    // Prefer user client; fall back to service role for webhook-style verifies
    let supabase = await tryCreateClient();
    const {
      data: { user },
    } = (await supabase?.auth.getUser()) ?? { data: { user: null } };

    if (!user) {
      try {
        supabase = createServiceClient();
      } catch {
        return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
      }
    }

    if (!supabase) {
      return NextResponse.json({ ok: false, error: "Supabase unavailable" }, { status: 500 });
    }

    const client = db(supabase);
    const { data: tx } = await client
      .from("transactions")
      .select("id, order_id, user_id, status")
      .eq("provider_reference", reference)
      .maybeSingle();

    if (!tx?.order_id) {
      return NextResponse.json({ ok: false, error: "Transaction not found" }, { status: 404 });
    }

    const result = await fulfillPaidOrder(supabase, {
      orderId: tx.order_id,
      paymentReference: reference,
      providerReference: verification.providerReference,
    });

    await client.from("webhook_logs").insert({
      provider,
      event_type: "payment.verify",
      payload: verification,
      status: result.ok ? "processed" : "failed",
      error: result.error ?? null,
    });

    return NextResponse.json({
      ok: result.ok,
      orderId: tx.order_id,
      reference,
      error: result.error,
    });
  } catch (error) {
    return NextResponse.json(
      { ok: false, error: error instanceof Error ? error.message : "Verify failed" },
      { status: 500 }
    );
  }
}
