"use client";

import { useEffect, useState } from "react";
import { Copy, Gift } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { formatMoney } from "@/data/mock";
import { useAuth } from "@/components/providers/auth-provider";
import {
  getFirstError,
  referralCodeSchema,
} from "@/lib/validation";
import { sanitize } from "@/lib/sanitize";
import { cn } from "@/lib/utils";

type ReferralStats = {
  code: string | null;
  walletBalanceCents: number;
  earningsCents: number;
  rewardCents: number;
  rewardLabel?: string;
  referrals: { id: string; status: string; created_at: string }[];
  demo?: boolean;
};

export function ReferralPanel() {
  const { user } = useAuth();
  const [stats, setStats] = useState<ReferralStats | null>(null);
  const [code, setCode] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function load() {
    const res = await fetch("/api/referrals");
    if (!res.ok) return;
    const data = (await res.json()) as ReferralStats;
    setStats(data);
  }

  useEffect(() => {
    void load();
  }, [user]);

  async function applyCode(e?: React.FormEvent) {
    e?.preventDefault();
    const parsed = referralCodeSchema.safeParse({ code });
    if (!parsed.success) {
      const message = getFirstError(parsed.error);
      setError(message);
      toast.error(message);
      return;
    }

    setLoading(true);
    setError("");
    try {
      const res = await fetch("/api/referrals", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code: sanitize(parsed.data.code) }),
      });
      const data = await res.json();
      if (!res.ok || !data.ok) {
        if (data.errors?.code) setError(data.errors.code);
        toast.error(data.error || "Could not apply code");
        return;
      }
      toast.success("Referral code applied");
      setCode("");
      await load();
    } finally {
      setLoading(false);
    }
  }

  if (!stats) return null;

  return (
    <section className="mt-8 overflow-hidden rounded-3xl border border-primary/15 bg-gradient-to-br from-teal-700 to-slate-900 p-6 text-white sm:p-8">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-2">
            <Gift className="size-5 text-amber-300" />
            <h2 className="font-heading text-xl font-semibold">Referral rewards</h2>
          </div>
          <p className="mt-2 max-w-xl text-sm text-teal-50/80">
            Share code{" "}
            <span className="font-semibold text-amber-300">{stats.code || "-"}</span> and earn{" "}
            {stats.rewardLabel || formatMoney((stats.rewardCents || 5000) / 100)} when friends
            complete their first order.
          </p>
          <p className="mt-3 text-sm text-teal-100/80">
            Wallet {formatMoney(stats.walletBalanceCents / 100)} · Lifetime referral earnings{" "}
            {formatMoney(stats.earningsCents / 100)} · {stats.referrals.length} invites
          </p>
        </div>
        {stats.code && (
          <Button
            className="bg-white text-teal-900 hover:bg-teal-50"
            onClick={async () => {
              await navigator.clipboard.writeText(stats.code!);
              toast.success("Referral code copied");
            }}
          >
            <Copy className="size-4" />
            Copy code
          </Button>
        )}
      </div>

      <form className="mt-6 flex max-w-md flex-col gap-2 sm:flex-row" onSubmit={applyCode} noValidate>
        <div className="min-w-0 flex-1">
          <Input
            value={code}
            onChange={(e) => {
              setCode(e.target.value);
              if (error) setError("");
            }}
            placeholder="Have a friend's code?"
            className={cn(
              "border-white/20 bg-white/10 text-white placeholder:text-teal-100/50",
              error && "border-destructive"
            )}
            aria-invalid={Boolean(error)}
            autoComplete="off"
          />
          {error ? <p className="mt-1 text-xs text-amber-200">{error}</p> : null}
        </div>
        <Button
          type="submit"
          variant="outline"
          className="border-white/30 bg-transparent text-white hover:bg-white/10"
          disabled={loading || !code.trim()}
        >
          Apply
        </Button>
      </form>
    </section>
  );
}
