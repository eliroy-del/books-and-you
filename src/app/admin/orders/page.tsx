"use client";

import { useEffect, useState } from "react";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { AdminPageHeader, AdminPanel, AdminTable } from "@/components/admin/admin-ui";

type OrderRow = {
  id: string;
  number: string;
  status: string;
  totalLabel: string;
  itemCount: number;
  placedAt: string;
  customer?: string;
};

const NEXT: Record<string, string> = {
  ordered: "packed",
  packed: "shipped",
  shipped: "delivered",
  delivered: "completed",
  paid: "processing",
  processing: "shipped",
};

export default function AdminOrdersPage() {
  const [orders, setOrders] = useState<OrderRow[]>([]);

  async function load() {
    const res = await fetch("/api/admin/orders");
    const json = await res.json();
    if (json.ok) setOrders(json.orders);
    else toast.error(json.error || "Failed to load orders");
  }

  useEffect(() => {
    void load();
  }, []);

  async function advance(order: OrderRow) {
    const status = NEXT[order.status];
    if (!status) {
      toast.message("No further status transition");
      return;
    }
    const res = await fetch("/api/admin/orders", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: order.id, status }),
    });
    const json = await res.json();
    if (!json.ok) {
      toast.error(json.error || "Update failed");
      return;
    }
    toast.success(`${order.number} → ${status}`);
    void load();
  }

  return (
    <div>
      <AdminPageHeader
        title="Orders"
        description="Fulfillment queue with status advancement."
        action={
          <Button size="sm" variant="outline" onClick={() => void load()}>
            Refresh
          </Button>
        }
      />
      <AdminPanel>
        <AdminTable headers={["Order", "Customer", "Status", "Items", "Total", ""]}>
          {orders.map((o) => (
            <tr key={o.id}>
              <td className="py-3 font-medium">{o.number}</td>
              <td className="py-3">{o.customer || "-"}</td>
              <td className="py-3">
                <Badge variant="secondary" className="capitalize">
                  {o.status}
                </Badge>
              </td>
              <td className="py-3">{o.itemCount}</td>
              <td className="py-3">{o.totalLabel}</td>
              <td className="py-3 text-right">
                <Button size="xs" variant="outline" onClick={() => void advance(o)}>
                  Advance
                </Button>
              </td>
            </tr>
          ))}
        </AdminTable>
      </AdminPanel>
    </div>
  );
}
