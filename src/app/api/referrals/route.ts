import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import {
  applyReferralCode,
  getReferralStats,
  REFERRAL_REWARD_CENTS,
} from "@/lib/services/referrals";
import { formatMoney } from "@/lib/services/mappers";

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
  const body = await request.json();
  const code = String(body.code || "").trim();

  if (!code) {
    return NextResponse.json({ ok: false, error: "Referral code required" }, { status: 400 });
  }

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
