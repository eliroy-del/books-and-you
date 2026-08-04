import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { placeOrderWithClient } from "@/lib/services/orders";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { quoteShipping } from "@/lib/services/shipping";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";
import { checkoutSchema, getFieldErrors, getFirstError } from "@/lib/validation";
import { sanitize, sanitizeEmail, sanitizePhone } from "@/lib/sanitize";
import { corsPreflight, jsonWithCors } from "@/lib/security/cors";

export async function OPTIONS(request: Request) {
  return corsPreflight(request);
}

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`checkout:${ip}`, { limit: 20, windowMs: 60_000 });
    if (!limited.ok) {
      return jsonWithCors(
        request,
        { ok: false, error: "Too many checkout attempts" },
        { status: 429 }
      );
    }

    const body = await request.json();
    const parsed = checkoutSchema.safeParse({
      ...body,
      customerName: body.customerName || body.shippingAddress?.fullName,
      phone: body.phone || body.shippingAddress?.phone,
      email: body.email || body.shippingAddress?.email || "",
    });

    if (!parsed.success) {
      return jsonWithCors(
        request,
        {
          ok: false,
          error: getFirstError(parsed.error),
          errors: getFieldErrors(parsed.error),
        },
        { status: 400 }
      );
    }

    const data = parsed.data;
    const fullName = sanitize(data.customerName);
    const contact = sanitizePhone(data.phone);
    const optionalEmail = data.email ? sanitizeEmail(data.email) : "";
    const line1 = sanitize(data.shippingAddress.line1);
    const city = sanitize(data.shippingAddress.city);
    const region = sanitize(data.shippingAddress.region || "Greater Accra");
    const country = sanitize(data.shippingAddress.country || "Ghana");

    const normalizedAddress = {
      fullName,
      phone: contact,
      email: optionalEmail || undefined,
      line1,
      city,
      region,
      country,
    };

    const shippingQuote = quoteShipping({
      city: normalizedAddress.city,
      region: normalizedAddress.region,
      country: normalizedAddress.country,
      subtotalCents: data.lines.reduce(
        (s, l) => s + Math.round(l.unitPrice * 100) * l.quantity,
        0
      ),
    });

    const payload = {
      lines: data.lines.map((l) => ({
        ...l,
        title: sanitize(l.title),
      })),
      provider: data.provider ?? "moolre",
      shippingAddress: normalizedAddress,
      couponCode: data.couponCode ? sanitize(data.couponCode) : undefined,
      discountCedis: data.discountCedis,
      email: optionalEmail || undefined,
      customerName: fullName,
      phone: contact,
      autoCapture: data.autoCapture ?? false,
    } as const;

    if (!isSupabaseConfigured()) {
      return jsonWithCors(
        request,
        { ok: false, error: "Checkout requires a live database connection" },
        { status: 503 }
      );
    }

    const sessionClient = await tryCreateClient();
    const {
      data: { user },
    } = (await sessionClient?.auth.getUser()) ?? { data: { user: null } };

    let supabase;
    try {
      supabase = createServiceClient();
    } catch {
      return jsonWithCors(
        request,
        { ok: false, error: "Checkout is temporarily unavailable" },
        { status: 500 }
      );
    }

    const shouldAuto =
      data.autoCapture ||
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

    return jsonWithCors(
      request,
      { ...result, shippingQuote, guest: !user },
      { status: result.ok ? 200 : 400 }
    );
  } catch (error) {
    console.error("Checkout API error:", error);
    return jsonWithCors(
      request,
      { ok: false, error: "Checkout failed. Please try again." },
      { status: 500 }
    );
  }
}
