"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { AdminPageHeader, AdminPanel, AdminStat, AdminTable } from "@/components/admin/admin-ui";
import type { DashboardOverview } from "@/lib/services/admin-analytics";

export default function AdminDashboardPage() {
  const [overview, setOverview] = useState<DashboardOverview | null>(null);
  const [role, setRole] = useState<string>("");

  useEffect(() => {
    void fetch("/api/admin/overview")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) {
          setOverview(json.overview);
          setRole(json.session?.role || "");
        }
      });
  }, []);

  return (
    <div>
      <AdminPageHeader
        title="Operations dashboard"
        description="Live inventory, sales, and support pulse."
        action={role ? <Badge variant="secondary">{role}</Badge> : null}
      />

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <AdminStat label="Catalog titles" value={String(overview?.catalogTitles ?? "-")} />
        <AdminStat label="Open orders" value={String(overview?.openOrders ?? "-")} />
        <AdminStat label="Revenue" value={overview?.revenueLabel ?? "-"} />
        <AdminStat
          label="Low stock"
          value={String(overview?.lowStockAlerts ?? "-")}
          hint={`${overview?.ticketsOpen ?? 0} open tickets`}
        />
      </div>

      <div className="mt-6 grid gap-6 xl:grid-cols-2">
        <AdminPanel
          title="Recent orders"
          action={
            <Button asChild size="sm" variant="outline">
              <Link href="/admin/orders">View all</Link>
            </Button>
          }
        >
          <AdminTable headers={["Order", "Status", "Items", "Total"]}>
            {(overview?.recentOrders || []).map((o) => (
              <tr key={o.id}>
                <td className="py-3 font-medium">{o.number}</td>
                <td className="py-3 capitalize">{o.status}</td>
                <td className="py-3">{o.itemCount}</td>
                <td className="py-3 text-right">{o.totalLabel}</td>
              </tr>
            ))}
          </AdminTable>
        </AdminPanel>

        <AdminPanel
          title="Low stock alerts"
          action={
            <Button asChild size="sm" variant="outline">
              <Link href="/admin/inventory?low=1">Manage</Link>
            </Button>
          }
        >
          <div className="space-y-3">
            {(overview?.lowStockItems || []).map((item) => (
              <div
                key={`${item.bookId}-${item.format}`}
                className="flex flex-wrap items-center justify-between gap-2 border-b border-border/50 py-2 text-sm last:border-0"
              >
                <div>
                  <p className="font-medium">{item.title}</p>
                  <p className="text-muted-foreground text-xs capitalize">{item.format}</p>
                </div>
                <Badge variant={item.quantity < 5 ? "destructive" : "secondary"}>
                  {item.quantity} left
                </Badge>
              </div>
            ))}
            {!overview?.lowStockItems?.length && (
              <p className="text-muted-foreground text-sm">No low-stock items.</p>
            )}
          </div>
        </AdminPanel>
      </div>
    </div>
  );
}
