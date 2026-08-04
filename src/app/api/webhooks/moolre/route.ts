import { NextResponse } from "next/server";
import { timingSafeEqual } from "crypto";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { verifyPayment } from "@/lib/providers";
import { fulfillPaidOrder } from "@/lib/services/orders";
import { db } from "@/lib/supabase/typed";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";

type MoolreCallbackBody = {
  status?: number | string;
  code?: string;
  message?: string;
  data?: {
    externalref?: string;
    transactionid?: string | number;
    txstatus?: number | string;
    amount?: string | number;
    reference?: string;
    [key: string]: unknown;
  };
  secret?: string;
  externalref?: string;
};

function extractSecret(request: Request, body: MoolreCallbackBody) {
  const url = new URL(request.url);
  return (
    request.headers.get("x-moolre-secret") ||
    request.headers.get("x-callback-secret") ||
    url.searchParams.get("secret") ||
    body.secret ||
    null
  );
}

function secretsMatch(provided: string | null, expected: string) {
  if (!provided) return false;
  try {
    const a = Buffer.from(provided);
    const b = Buffer.from(expected);
    if (a.length !== b.length) return false;
    return timingSafeEqual(a, b);
  } catch {
    return false;
  }
}

export async function POST(request: Request) {
  const ip = clientIpFromHeaders(request.headers);
  const limited = rateLimit(`moolre-webhook:${ip}`, { limit: 60, windowMs: 60_000 });
  if (!limited.ok) {
    return NextResponse.json(
      { ok: false, error: "Too many requests" },
      { status: 429, headers: { "Retry-After": String(limited.retryAfterSec) } }
    );
  }

  let body: MoolreCallbackBody;
  try {
    body = (await request.json()) as MoolreCallbackBody;
  } catch {
    return NextResponse.json({ ok: false, error: "Invalid JSON" }, { status: 400 });
  }

  const expectedSecret = process.env.MOOLRE_CALLBACK_SECRET;
  if (!expectedSecret) {
    return NextResponse.json(
      { ok: false, error: "Callback secret not configured" },
      { status: 503 }
    );
  }
  const provided = extractSecret(request, body);
  if (!secretsMatch(provided, expectedSecret)) {
    return NextResponse.json({ ok: false, error: "Invalid callback secret" }, { status: 401 });
  }

  const externalRef =
    body.data?.externalref ||
    body.externalref ||
    (body.data?.reference ? String(body.data.reference) : "");

  if (!isSupabaseConfigured()) {
    return NextResponse.json({
      ok: true,
      received: true,
      demo: true,
      externalRef: externalRef || null,
    });
  }

  const supabase = createServiceClient();
  const client = db(supabase);

  await client.from("webhook_logs").insert({
    provider: "moolre",
    event_type: body.code || "payment.callback",
    payload: body,
    status: "received",
  });

  if (!externalRef) {
    return NextResponse.json({ ok: true, received: true, note: "No externalref to process" });
  }

  // Never trust the callback body alone. Re-verify with Moolre status API
  const verification = await verifyPayment("moolre", externalRef);

  if (!verification.ok || verification.status !== "succeeded") {
    await client.from("webhook_logs").insert({
      provider: "moolre",
      event_type: "payment.unverified",
      payload: { externalRef, verification },
      status: "failed",
    });
    return NextResponse.json({ ok: true, received: true, verified: false });
  }

  const { data: tx } = await client
    .from("transactions")
    .select("order_id")
    .eq("provider_reference", externalRef)
    .maybeSingle();

  if (tx?.order_id) {
    await fulfillPaidOrder(supabase, {
      orderId: tx.order_id,
      paymentReference: externalRef,
      providerReference: verification.providerReference || externalRef,
    });
  }

  return NextResponse.json({
    ok: true,
    received: true,
    verified: true,
    fulfilled: Boolean(tx?.order_id),
  });
}

export async function GET() {
  return NextResponse.json({
    ok: true,
    provider: "moolre",
    callback: "/api/webhooks/moolre",
    secretConfigured: Boolean(process.env.MOOLRE_CALLBACK_SECRET),
    paymentCredsConfigured: Boolean(
      process.env.MOOLRE_API_USER &&
        process.env.MOOLRE_ACCOUNT_NUMBER &&
        process.env.MOOLRE_API_PUBKEY
    ),
  });
}
