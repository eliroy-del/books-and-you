"use client";

import { useEffect, useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { AdminPageHeader, AdminPanel, AdminStat } from "@/components/admin/admin-ui";
import type { ReportBundle } from "@/lib/services/admin-analytics";

export default function AdminReportsPage() {
  const [reports, setReports] = useState<ReportBundle | null>(null);

  useEffect(() => {
    void fetch("/api/admin/analytics?type=reports")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) setReports(json.reports);
      });
  }, []);

  function downloadCsv() {
    if (!reports) return;
    const blob = new Blob([reports.csvPreview], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `books-and-you-report-${reports.generatedAt.slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    toast.success("Report downloaded");
  }

  return (
    <div>
      <AdminPageHeader
        title="Reports"
        description="Operational summaries for sales, inventory, and customers."
        action={
          <Button size="sm" onClick={downloadCsv} disabled={!reports}>
            Export CSV
          </Button>
        }
      />

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <AdminStat
          label="Period orders"
          value={String(reports?.salesSummary.orders ?? "-")}
          hint={reports?.salesSummary.period}
        />
        <AdminStat label="Gross revenue" value={reports?.salesSummary.revenueLabel ?? "-"} />
        <AdminStat label="Refunds" value={reports?.salesSummary.refundsLabel ?? "-"} />
        <AdminStat label="Net" value={reports?.salesSummary.netLabel ?? "-"} />
      </div>

      <div className="mt-6 grid gap-6 md:grid-cols-2">
        <AdminPanel title="Inventory summary">
          <dl className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <dt className="text-muted-foreground">SKUs</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.inventorySummary.skus ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">Low stock</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.inventorySummary.lowStock ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">Out of stock</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.inventorySummary.outOfStock ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">Reserved</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.inventorySummary.reserved ?? "-"}
              </dd>
            </div>
          </dl>
        </AdminPanel>

        <AdminPanel title="Customer summary">
          <dl className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <dt className="text-muted-foreground">Active</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.customerSummary.active ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">New this month</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.customerSummary.newThisMonth ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">Subscribers</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.customerSummary.subscribers ?? "-"}
              </dd>
            </div>
            <div>
              <dt className="text-muted-foreground">Referral credits</dt>
              <dd className="font-heading text-xl font-semibold">
                {reports?.customerSummary.referralCreditsLabel ?? "-"}
              </dd>
            </div>
          </dl>
        </AdminPanel>
      </div>

      <AdminPanel title="CSV preview" className="mt-6">
        <pre className="bg-muted/50 overflow-x-auto rounded-2xl p-4 text-xs leading-relaxed">
          {reports?.csvPreview || "Loading…"}
        </pre>
      </AdminPanel>
    </div>
  );
}
