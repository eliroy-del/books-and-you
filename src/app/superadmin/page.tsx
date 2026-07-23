"use client";

import { useEffect, useState } from "react";
import { SaCard, SaHeader, SaStat } from "@/components/superadmin/ui";
import type { PlatformHealth } from "@/lib/superadmin/platform";

export default function SuperAdminOverviewPage() {
  const [health, setHealth] = useState<PlatformHealth | null>(null);

  useEffect(() => {
    void fetch("/api/superadmin?section=overview")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) setHealth(json.health);
      });
  }, []);

  return (
    <div>
      <SaHeader
        title="Super Admin"
        description="Platform control plane — flags, providers, audits, and health."
      />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <SaStat label="Uptime" value={health?.uptime ?? "—"} />
        <SaStat label="Database" value={health?.database ?? "—"} />
        <SaStat label="API p95" value={health ? `${health.apiP95Ms}ms` : "—"} />
        <SaStat
          label="Failed webhooks"
          value={String(health?.failedWebhooks24h ?? "—")}
        />
      </div>
      <div className="mt-6 grid gap-4 md:grid-cols-3">
        <SaCard title="RLS coverage">
          <p className="font-heading text-3xl font-bold text-teal-300">
            {health?.rlsCoverage ?? "—"}%
          </p>
          <p className="mt-2 text-sm text-slate-400">All public tables enforce row-level security.</p>
        </SaCard>
        <SaCard title="Storage">
          <p className="font-heading text-3xl font-bold text-teal-300">
            {health?.storageBuckets ?? "—"}
          </p>
          <p className="mt-2 text-sm text-slate-400">Configured buckets with signed access policies.</p>
        </SaCard>
        <SaCard title="Fraud queue">
          <p className="font-heading text-3xl font-bold text-amber-300">
            {health?.fraudSignalsOpen ?? "—"}
          </p>
          <p className="mt-2 text-sm text-slate-400">Open signals awaiting review.</p>
        </SaCard>
      </div>
    </div>
  );
}
