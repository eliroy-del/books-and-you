import type { SupabaseClient } from "@supabase/supabase-js";
import { db } from "@/lib/supabase/typed";
import { notifyUser } from "@/lib/services/notifications";
import {
  renderReferralRewardEmail,
  sendEmail,
} from "@/lib/services/email";
import { formatMoney } from "@/lib/services/mappers";

export const REFERRAL_REWARD_CENTS = Number(
  process.env.REFERRAL_REWARD_CENTS || 5000
);

export async function getOrCreateWallet(supabase: SupabaseClient, userId: string) {
  const client = db(supabase);
  const { data: existing } = await client
    .from("wallets")
    .select("id, balance_cents, currency")
    .eq("user_id", userId)
    .maybeSingle();

  if (existing) return existing;

  const { data, error } = await client
    .from("wallets")
    .insert({ user_id: userId, balance_cents: 0, currency: "GHS" })
    .select("id, balance_cents, currency")
    .single();

  if (error) throw new Error(error.message);
  return data;
}

export async function creditWallet(
  supabase: SupabaseClient,
  input: {
    userId: string;
    amountCents: number;
    type: "referral_reward" | "credit" | "refund" | "adjustment";
    description: string;
    referenceType?: string;
    referenceId?: string;
  }
) {
  const client = db(supabase);
  const wallet = await getOrCreateWallet(supabase, input.userId);
  const next = Number(wallet.balance_cents) + input.amountCents;

  const { error: updateError } = await client
    .from("wallets")
    .update({ balance_cents: next })
    .eq("id", wallet.id);

  if (updateError) throw new Error(updateError.message);

  const { data: tx, error: txError } = await client
    .from("wallet_transactions")
    .insert({
      wallet_id: wallet.id,
      type: input.type,
      amount_cents: input.amountCents,
      balance_after_cents: next,
      description: input.description,
      reference_type: input.referenceType ?? null,
      reference_id: input.referenceId ?? null,
    })
    .select("id")
    .single();

  if (txError) throw new Error(txError.message);
  return { walletId: wallet.id, balanceCents: next, transactionId: tx.id as string };
}

export async function applyReferralCode(
  supabase: SupabaseClient,
  input: { newUserId: string; referralCode: string }
) {
  const client = db(supabase);
  const code = input.referralCode.trim().toUpperCase();

  const { data: referrer } = await client
    .from("profiles")
    .select("id, referral_code, full_name, email")
    .eq("referral_code", code)
    .maybeSingle();

  if (!referrer || referrer.id === input.newUserId) {
    return { ok: false, error: "Invalid referral code" };
  }

  const { data: existing } = await client
    .from("referrals")
    .select("id")
    .eq("referred_id", input.newUserId)
    .maybeSingle();

  if (existing) {
    return { ok: false, error: "Referral already applied" };
  }

  const { error } = await client.from("referrals").insert({
    referrer_id: referrer.id,
    referred_id: input.newUserId,
    referral_code: code,
    status: "pending",
  });

  if (error) return { ok: false, error: error.message };

  await client
    .from("profiles")
    .update({ referred_by: referrer.id })
    .eq("id", input.newUserId);

  return { ok: true, referrerId: referrer.id as string };
}

/**
 * Qualify referral after referred user's first successful paid order.
 */
export async function qualifyReferralForOrder(
  supabase: SupabaseClient,
  input: { userId: string; orderId: string; orderNumber: string }
) {
  const client = db(supabase);

  const { data: referral } = await client
    .from("referrals")
    .select("id, referrer_id, referral_code, status")
    .eq("referred_id", input.userId)
    .eq("status", "pending")
    .maybeSingle();

  if (!referral) {
    return { rewarded: false, reason: "no_pending_referral" as const };
  }

  await client
    .from("referrals")
    .update({
      status: "qualified",
      qualified_at: new Date().toISOString(),
    })
    .eq("id", referral.id);

  const credit = await creditWallet(supabase, {
    userId: referral.referrer_id,
    amountCents: REFERRAL_REWARD_CENTS,
    type: "referral_reward",
    description: `Referral reward for order ${input.orderNumber}`,
    referenceType: "order",
    referenceId: input.orderId,
  });

  await client.from("referral_rewards").insert({
    referral_id: referral.id,
    wallet_transaction_id: credit.transactionId,
    amount_cents: REFERRAL_REWARD_CENTS,
    status: "paid",
  });

  await client
    .from("referrals")
    .update({ status: "rewarded" })
    .eq("id", referral.id);

  const { data: referrer } = await client
    .from("profiles")
    .select("id, full_name, email")
    .eq("id", referral.referrer_id)
    .maybeSingle();

  if (referrer) {
    const amountLabel = formatMoney(REFERRAL_REWARD_CENTS / 100);
    const emailContent = renderReferralRewardEmail({
      customerName: referrer.full_name || "Reader",
      amountLabel,
      code: referral.referral_code,
    });

    await notifyUser(supabase, {
      userId: referrer.id,
      email: referrer.email ?? undefined,
      title: "Referral reward earned",
      body: `${amountLabel} was added to your Books & You wallet.`,
      type: "referral_reward",
      link: "/dashboard",
      channels: ["in_app", "email"],
      emailSubject: emailContent.subject,
      emailHtml: emailContent.html,
    });

    if (referrer.email) {
      await sendEmail({
        to: referrer.email,
        subject: emailContent.subject,
        html: emailContent.html,
        text: emailContent.text,
      });
    }
  }

  return {
    rewarded: true,
    amountCents: REFERRAL_REWARD_CENTS,
    referrerId: referral.referrer_id as string,
  };
}

export async function getReferralStats(supabase: SupabaseClient, userId: string) {
  const client = db(supabase);
  const { data: profile } = await client
    .from("profiles")
    .select("referral_code")
    .eq("id", userId)
    .maybeSingle();

  const { data: referrals } = await client
    .from("referrals")
    .select("id, status, created_at, referral_code")
    .eq("referrer_id", userId)
    .order("created_at", { ascending: false });

  const wallet = await getOrCreateWallet(supabase, userId);

  const rewarded = (referrals ?? []).filter((r: { status: string }) => r.status === "rewarded");
  const earningsCents = rewarded.length * REFERRAL_REWARD_CENTS;

  return {
    code: profile?.referral_code ?? null,
    referrals: referrals ?? [],
    walletBalanceCents: Number(wallet.balance_cents),
    earningsCents,
    rewardCents: REFERRAL_REWARD_CENTS,
  };
}
