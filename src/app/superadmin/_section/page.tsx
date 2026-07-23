"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { SaCard, SaHeader, SaStat } from "@/components/superadmin/ui";

const META: Record<string, { title: string; description: string; section: string }> = {
  rbac: {
    title: "RBAC",
    description: "System roles and assigned permission sets.",
    section: "rbac",
  },
  permissions: {
    title: "Permissions",
    description: "Fine-grained access keys used by RLS and admin APIs.",
    section: "permissions",
  },
  payments: {
    title: "Payment providers",
    description: "Paystack, Flutterwave, and Stripe configuration health.",
    section: "payments",
  },
  shipping: {
    title: "Shipping providers",
    description: "Courier partners and covered zones.",
    section: "shipping",
  },
  templates: {
    title: "Notification templates",
    description: "Email and SMS copy with merge tags.",
    section: "templates",
  },
  monitoring: {
    title: "API monitoring",
    description: "Latency, error rates, and webhook delivery.",
    section: "monitoring",
  },
  fraud: {
    title: "Fraud detection",
    description: "Heuristic signals on checkout velocity and geo mismatches.",
    section: "fraud",
  },
  database: {
    title: "Database health",
    description: "RLS coverage, connection posture, and backup cadence.",
    section: "database",
  },
  exports: {
    title: "Exports",
    description: "Operational dataset export manifest.",
    section: "exports",
  },
  backups: {
    title: "Backups",
    description: "Schedule, retention, and last successful snapshot.",
    section: "backups",
  },
  audit: {
    title: "Audit center",
    description: "Immutable trail of privileged actions.",
    section: "audit",
  },
  logs: {
    title: "System logs",
    description: "Recent platform events across checkout, webhooks, and mail.",
    section: "logs",
  },
};

export default function SuperAdminSectionPage() {
  const pathname = usePathname();
  const slug = pathname.split("/").pop() || "rbac";
  const meta = META[slug] || META.rbac;
  const [data, setData] = useState<Record<string, unknown> | null>(null);

  useEffect(() => {
    void fetch(`/api/superadmin?section=${meta.section}`)
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) setData(json);
      });
  }, [meta.section]);

  return (
    <div>
      <SaHeader title={meta.title} description={meta.description} />

      {slug === "rbac" || slug === "permissions" ? (
        <SaCard>
          <div className="space-y-4">
            {((data?.rbac as { roles?: Array<{ key: string; label: string; permissions: string[] }> })
              ?.roles || []).map((role) => (
              <div key={role.key} className="border-b border-white/10 pb-3 last:border-0">
                <p className="font-medium text-white">{role.label}</p>
                <div className="mt-2 flex flex-wrap gap-1">
                  {role.permissions.map((p) => (
                    <Badge key={p} className="border-0 bg-white/10 text-[10px] text-slate-200">
                      {p}
                    </Badge>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </SaCard>
      ) : null}

      {slug === "payments" ? (
        <div className="grid gap-4 sm:grid-cols-3">
          {((data?.providers as Array<Record<string, string>>) || []).map((p) => (
            <SaCard key={p.id} title={p.label}>
              <p className="text-sm text-slate-400">Mode: {p.mode}</p>
              <p className="mt-1 text-sm text-slate-400">Webhook: {p.webhookPath}</p>
              <Badge className="mt-3 border-0 bg-teal-500/20 text-teal-200">{p.status}</Badge>
            </SaCard>
          ))}
        </div>
      ) : null}

      {slug === "shipping" ? (
        <div className="grid gap-4 sm:grid-cols-3">
          {((data?.providers as Array<{ id: string; name: string; zones: string[]; status: string }>) || []).map(
            (p) => (
              <SaCard key={p.id} title={p.name}>
                <p className="text-sm text-slate-400">Zones: {p.zones.join(", ")}</p>
                <Badge className="mt-3 border-0 bg-teal-500/20 text-teal-200">{p.status}</Badge>
              </SaCard>
            )
          )}
        </div>
      ) : null}

      {slug === "templates" ? (
        <div className="space-y-3">
          {((data?.templates as Array<Record<string, string | boolean | null>>) || []).map((t) => (
            <SaCard key={String(t.id)} title={String(t.key)}>
              <p className="text-xs text-slate-400 uppercase">{String(t.channel)}</p>
              {t.subject ? <p className="mt-2 text-sm text-slate-200">{String(t.subject)}</p> : null}
              <p className="mt-2 text-sm text-slate-400">{String(t.body)}</p>
            </SaCard>
          ))}
        </div>
      ) : null}

      {slug === "monitoring" ? (
        <div className="space-y-4">
          <SaCard title="Endpoints">
            <div className="space-y-2 text-sm">
              {(((data?.monitoring as { endpoints?: Array<Record<string, number | string>> })
                ?.endpoints) || []).map((e) => (
                <div
                  key={String(e.path)}
                  className="flex flex-wrap justify-between gap-2 border-b border-white/10 py-2 last:border-0"
                >
                  <span className="font-mono text-teal-200">{String(e.path)}</span>
                  <span className="text-slate-400">
                    p95 {String(e.p95)}ms · err {String(e.errorRate)}%
                  </span>
                </div>
              ))}
            </div>
          </SaCard>
        </div>
      ) : null}

      {slug === "fraud" ? (
        <div className="space-y-3">
          {((data?.signals as Array<Record<string, string>>) || []).map((s) => (
            <SaCard key={s.id}>
              <div className="flex flex-wrap items-center justify-between gap-2">
                <Badge className="border-0 bg-amber-500/20 text-amber-200">{s.severity}</Badge>
                <span className="text-xs text-slate-400">{s.status}</span>
              </div>
              <p className="mt-3 text-sm text-white">{s.signal}</p>
              <p className="mt-1 text-xs text-slate-400">
                {s.orderRef} · {s.at}
              </p>
            </SaCard>
          ))}
        </div>
      ) : null}

      {slug === "database" || slug === "backups" ? (
        <div className="grid gap-4 sm:grid-cols-2">
          <SaStat
            label="Last backup"
            value={String(
              (data?.backups as { lastSuccessful?: string })?.lastSuccessful ||
                (data?.health as { lastBackupAt?: string })?.lastBackupAt ||
                "—"
            ).replace("T", " ").slice(0, 16)}
          />
          <SaStat
            label="RLS coverage"
            value={`${(data?.health as { rlsCoverage?: number })?.rlsCoverage ?? 100}%`}
          />
          <SaCard title="Schedule">
            <p className="text-sm text-slate-300">
              {(data?.backups as { schedule?: string })?.schedule || "Daily 02:00 GMT"}
            </p>
            <p className="mt-2 text-sm text-slate-400">
              Retention: {(data?.backups as { retentionDays?: number })?.retentionDays || 30} days
            </p>
          </SaCard>
          <SaCard title="Targets">
            <ul className="list-inside list-disc text-sm text-slate-300">
              {((data?.backups as { targets?: string[] })?.targets || []).map((t) => (
                <li key={t}>{t}</li>
              ))}
            </ul>
          </SaCard>
        </div>
      ) : null}

      {slug === "exports" ? (
        <SaCard title="Export manifest">
          <p className="mb-3 text-xs text-slate-400">
            Generated {(data?.manifest as { generatedAt?: string })?.generatedAt}
          </p>
          <div className="space-y-2">
            {(((data?.manifest as { datasets?: Array<Record<string, string | number>> })
              ?.datasets) || []).map((d) => (
              <div
                key={String(d.name)}
                className="flex justify-between border-b border-white/10 py-2 text-sm last:border-0"
              >
                <span className="text-white">{String(d.name)}</span>
                <span className="text-slate-400">
                  {String(d.rows)} rows · {String(d.format)}
                </span>
              </div>
            ))}
          </div>
        </SaCard>
      ) : null}

      {slug === "audit" ? (
        <SaCard>
          <div className="space-y-3">
            {((data?.entries as Array<Record<string, unknown>>) || []).map((e) => (
              <div key={String(e.id)} className="border-b border-white/10 pb-3 last:border-0">
                <p className="font-mono text-sm text-teal-200">{String(e.action)}</p>
                <p className="mt-1 text-xs text-slate-400">
                  {String(e.actor)} · {String(e.resource_type)} ·{" "}
                  {String(e.created_at).replace("T", " ").slice(0, 16)}
                </p>
              </div>
            ))}
          </div>
        </SaCard>
      ) : null}

      {slug === "logs" ? (
        <SaCard>
          <div className="space-y-2 font-mono text-xs">
            {((data?.logs as Array<{ level: string; message: string; at: string }>) || []).map(
              (log, i) => (
                <div key={i} className="flex flex-wrap gap-3 border-b border-white/10 py-2 last:border-0">
                  <span
                    className={
                      log.level === "error"
                        ? "text-rose-300"
                        : log.level === "warn"
                          ? "text-amber-300"
                          : "text-teal-300"
                    }
                  >
                    {log.level}
                  </span>
                  <span className="text-slate-300">{log.message}</span>
                  <span className="text-slate-500">{log.at}</span>
                </div>
              )
            )}
          </div>
        </SaCard>
      ) : null}
    </div>
  );
}
