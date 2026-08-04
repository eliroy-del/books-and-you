import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import {
  applyReferralCode,
  getReferralStats,
  REFERRAL_REWARD_CENTS,
} from "@/lib/services/referrals";
import { formatMoney } from "@/lib/services/mappers";
import { getFieldErrors, referralCodeSchema } from "@/lib/validation";
import { sanitize } from "@/lib/sanitize";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";

export async function GET() {
  if (!isSupabaseConfigured()) {
    return NextResponse.json({
      demo: true,
      code: "DEMO-READS",
      walletBalanceCents: 8500,
      earningsCents: 12000,
      rewardCents: REFERRAL_REWARD_CENTS,
      referrals: [
        { id: "1", status: "rewarded", referral_code: "DEMO-READS", created_at: new Date().toISOString() },
      ],
      rewardLabel: formatMoney(REFERRAL_REWARD_CENTS / 100),
    });
  }

  const supabase = await tryCreateClient();
  if (!supabase) {
    return NextResponse.json({ error: "Supabase unavailable" }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const stats = await getReferralStats(supabase, user.id);
  return NextResponse.json({
    ...stats,
    rewardLabel: formatMoney(REFERRAL_REWARD_CENTS / 100),
  });
}

export async function POST(request: Request) {
  const ip = clientIpFromHeaders(request.headers);
  const limited = rateLimit(`referrals:${ip}`, { limit: 20, windowMs: 60_000 });
  if (!limited.ok) {
    return NextResponse.json(
      { ok: false, error: "Too many attempts. Please try again shortly." },
      { status: 429, headers: { "Retry-After": String(limited.retryAfterSec) } }
    );
  }

  const body = await request.json();
  const parsed = referralCodeSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      {
        ok: false,
        error: "Validation failed",
        errors: getFieldErrors(parsed.error),
      },
      { status: 400 }
    );
  }

  const code = sanitize(parsed.data.code);

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ ok: true, demo: true, code });
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

  const result = await applyReferralCode(supabase, {
    newUserId: user.id,
    referralCode: code,
  });

  return NextResponse.json(result, { status: result.ok ? 200 : 400 });
}
