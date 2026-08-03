import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { placeOrder, placeOrderWithClient, type CheckoutLine } from "@/lib/services/orders";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import type { PaymentProviderId } from "@/lib/providers";
import { quoteShipping } from "@/lib/services/shipping";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`checkout:${ip}`, { limit: 20, windowMs: 60_000 });
    if (!limited.ok) {
      return NextResponse.json(
        { ok: false, error: "Too many checkout attempts" },
        {
          status: 429,
          headers: { "Retry-After": String(limited.retryAfterSec) },
        }
      );
    }

    const body = await request.json();
    const {
      lines,
      provider,
      shippingAddress,
      couponCode,
      discountCedis,
      email,
      customerName,
      phone,
      autoCapture,
    } = body as {
      lines: CheckoutLine[];
      provider: PaymentProviderId;
      shippingAddress: Record<string, unknown>;
      couponCode?: string;
      discountCedis?: number;
      email?: string;
      customerName?: string;
      phone?: string;
      autoCapture?: boolean;
    };

    if (!Array.isArray(lines) || lines.length === 0) {
      return NextResponse.json({ ok: false, error: "Cart is empty" }, { status: 400 });
    }

    const shippingQuote = quoteShipping({
      city: String(shippingAddress?.city || ""),
      region: String(shippingAddress?.region || ""),
      country: String(shippingAddress?.country || "Ghana"),
      subtotalCents: lines.reduce(
        (s, l) => s + Math.round(l.unitPrice * 100) * l.quantity,
        0
      ),
    });

    const payload = {
      lines,
      provider: provider ?? "paystack",
      shippingAddress: shippingAddress ?? {},
      couponCode,
      discountCedis,
      email,
      customerName,
      phone,
      autoCapture: autoCapture ?? false,
    } as const;

    if (!isSupabaseConfigured()) {
      const result = await placeOrder({
        userId: "demo-user-local",
        ...payload,
      });
      return NextResponse.json({ ...result, shippingQuote });
    }

    const supabase = await tryCreateClient();
    if (!supabase) {
      return NextResponse.json({ ok: false, error: "Supabase unavailable" }, { status: 500 });
    }

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
    }

    // Demo capture when provider keys missing — still creates DB order
    const shouldAuto = autoCapture || !process.env.PAYSTACK_SECRET_KEY;

    const result = await placeOrderWithClient(supabase, {
      userId: user.id,
      ...payload,
      email: email || user.email || undefined,
      autoCapture: shouldAuto,
    });

    return NextResponse.json(
      { ...result, shippingQuote },
      { status: result.ok ? 200 : 400 }
    );
  } catch (error) {
    return NextResponse.json(
      { ok: false, error: error instanceof Error ? error.message : "Checkout failed" },
      { status: 500 }
    );
  }
}
