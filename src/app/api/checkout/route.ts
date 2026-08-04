import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/admin";
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

    const fullName = String(customerName || shippingAddress?.fullName || "").trim();
    const contact = String(phone || shippingAddress?.phone || "").trim();
    const locationLine = String(shippingAddress?.line1 || "").trim();
    const city = String(shippingAddress?.city || "").trim();
    const region = String(shippingAddress?.region || "").trim();
    const optionalEmail = String(email || shippingAddress?.email || "").trim();

    if (!fullName) {
      return NextResponse.json(
        { ok: false, error: "Full name is required" },
        { status: 400 }
      );
    }
    if (!contact || contact.replace(/\D/g, "").length < 9) {
      return NextResponse.json(
        { ok: false, error: "A valid phone number is required" },
        { status: 400 }
      );
    }
    if (!locationLine && !city) {
      return NextResponse.json(
        { ok: false, error: "Delivery location is required" },
        { status: 400 }
      );
    }
    if (optionalEmail && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(optionalEmail)) {
      return NextResponse.json(
        { ok: false, error: "Email looks invalid" },
        { status: 400 }
      );
    }

    const normalizedAddress = {
      ...(shippingAddress ?? {}),
      fullName,
      phone: contact,
      email: optionalEmail || undefined,
      line1: locationLine || city,
      city: city || locationLine,
      region: region || "Greater Accra",
      country: String(shippingAddress?.country || "Ghana"),
    };

    const shippingQuote = quoteShipping({
      city: normalizedAddress.city,
      region: normalizedAddress.region,
      country: normalizedAddress.country,
      subtotalCents: lines.reduce(
        (s, l) => s + Math.round(l.unitPrice * 100) * l.quantity,
        0
      ),
    });

    const payload = {
      lines,
      provider: provider ?? "moolre",
      shippingAddress: normalizedAddress,
      couponCode,
      discountCedis,
      email: optionalEmail || undefined,
      customerName: fullName,
      phone: contact,
      autoCapture: autoCapture ?? false,
    } as const;

    if (!isSupabaseConfigured()) {
      const result = await placeOrder({
        userId: "demo-user-local",
        ...payload,
      });
      return NextResponse.json({ ...result, shippingQuote });
    }

    const sessionClient = await tryCreateClient();
    const {
      data: { user },
    } = (await sessionClient?.auth.getUser()) ?? { data: { user: null } };

    // Guests and signed-in users both place orders via service role so RLS doesn't block inserts.
    let supabase;
    try {
      supabase = createServiceClient();
    } catch {
      return NextResponse.json(
        { ok: false, error: "Checkout is temporarily unavailable" },
        { status: 500 }
      );
    }

    const shouldAuto =
      autoCapture ||
      !(
        process.env.MOOLRE_API_USER &&
        process.env.MOOLRE_API_PUBKEY &&
        process.env.MOOLRE_ACCOUNT_NUMBER
      );

    const result = await placeOrderWithClient(supabase, {
      userId: user?.id ?? null,
      ...payload,
      email: optionalEmail || user?.email || undefined,
      autoCapture: shouldAuto,
    });

    return NextResponse.json(
      { ...result, shippingQuote, guest: !user },
      { status: result.ok ? 200 : 400 }
    );
  } catch (error) {
    return NextResponse.json(
      { ok: false, error: error instanceof Error ? error.message : "Checkout failed" },
      { status: 500 }
    );
  }
}
