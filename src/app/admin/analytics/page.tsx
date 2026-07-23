"use client";

import { useEffect, useState } from "react";
import { AdminPageHeader, AdminPanel, AdminStat, BarChart } from "@/components/admin/admin-ui";
import type { AnalyticsSnapshot } from "@/lib/services/admin-analytics";

export default function AdminAnalyticsPage() {
  const [data, setData] = useState<AnalyticsSnapshot | null>(null);

  useEffect(() => {
    void fetch("/api/admin/analytics?type=analytics")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) setData(json.analytics);
      });
  }, []);

  return (
    <div>
      <AdminPageHeader
        title="Analytics"
        description="Revenue trend, funnel health, and category mix."
      />

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <AdminStat label="Avg order value" value={data?.kpis.aovLabel ?? "—"} />
        <AdminStat
          label="Repeat rate"
          value={data ? `${data.kpis.repeatRate}%` : "—"}
        />
        <AdminStat
          label="Digital share"
          value={data ? `${data.kpis.digitalShare}%` : "—"}
        />
        <AdminStat
          label="Fulfillment ETA"
          value={data ? `${data.kpis.fulfillmentHours}h` : "—"}
        />
      </div>

      <div className="mt-6 grid gap-6 xl:grid-cols-2">
        <AdminPanel title="Revenue (14 days)">
          <BarChart
            items={(data?.revenueByDay || []).map((d) => ({
              label: d.day.slice(5),
              value: d.amountCents,
              display: d.label,
            }))}
          />
        </AdminPanel>

        <AdminPanel title="Orders by status">
          <BarChart
            items={(data?.ordersByStatus || []).map((d) => ({
              label: d.status,
              value: d.count,
            }))}
          />
        </AdminPanel>

        <AdminPanel title="Top categories">
          <BarChart
            items={(data?.topCategories || []).map((d) => ({
              label: d.name,
              value: d.share,
              display: `${d.share}%`,
            }))}
          />
        </AdminPanel>

        <AdminPanel title="Conversion funnel">
          <BarChart
            items={(data?.conversionFunnel || []).map((d) => ({
              label: d.stage,
              value: d.value,
            }))}
          />
        </AdminPanel>
      </div>
    </div>
  );
}
