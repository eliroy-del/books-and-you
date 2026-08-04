import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { verifyPayment, type PaymentProviderId } from "@/lib/providers";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";
import { getAdminSession } from "@/lib/admin/guard";
import { hasAnyPermission } from "@/lib/admin/permissions";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`payments-verify:${ip}`, { limit: 30, windowMs: 60_000 });
    if (!limited.ok) {
      return NextResponse.json(
        { ok: false, error: "Too many verification attempts" },
        { status: 429, headers: { "Retry-After": String(limited.retryAfterSec) } }
      );
    }

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

    let service;
    try {
      service = createServiceClient();
    } catch {
      return NextResponse.json({ ok: false, error: "Supabase unavailable" }, { status: 500 });
    }

    const client = db(service);
    const { data: tx } = await client
      .from("transactions")
      .select("id, order_id, user_id, status")
      .eq("provider_reference", reference)
      .maybeSingle();

    if (!tx?.order_id) {
      return NextResponse.json({ ok: false, error: "Transaction not found" }, { status: 404 });
    }

    // Object-level authorization (separate from "payment succeeded"):
    // - Guest tx (user_id null): reference + provider success is the capability.
    // - Owned tx: session must match owner, or staff with finance/orders write.
    // - Never let an anonymous caller fulfill a registered user's order.
    const sessionClient = await tryCreateClient();
    const {
      data: { user },
    } = (await sessionClient?.auth.getUser()) ?? { data: { user: null } };

    if (tx.user_id) {
      if (!user) {
        return NextResponse.json(
          { ok: false, error: "Sign in to verify this payment" },
          { status: 401 }
        );
      }

      if (tx.user_id !== user.id) {
        const admin = await getAdminSession();
        const canFulfill =
          admin &&
          hasAnyPermission(admin.permissions, ["finance.write", "orders.write"]);
        if (!canFulfill) {
          return NextResponse.json(
            { ok: false, error: "Forbidden: not your payment" },
            { status: 403 }
          );
        }
      }
    }

    const result = await fulfillPaidOrder(service, {
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
