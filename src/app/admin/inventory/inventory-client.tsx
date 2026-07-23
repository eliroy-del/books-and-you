"use client";

import { useCallback, useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { AdminPageHeader, AdminPanel, AdminTable } from "@/components/admin/admin-ui";
import type { InventoryRow } from "@/lib/services/admin-inventory";

export default function AdminInventoryPage() {
  const searchParams = useSearchParams();
  const [rows, setRows] = useState<InventoryRow[]>([]);
  const [q, setQ] = useState("");
  const [lowOnly, setLowOnly] = useState(searchParams.get("low") === "1");
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    setLoading(true);
    const params = new URLSearchParams();
    if (lowOnly) params.set("low", "1");
    if (q) params.set("q", q);
    const res = await fetch(`/api/admin/inventory?${params}`);
    const json = await res.json();
    if (json.ok) setRows(json.rows);
    else toast.error(json.error || "Failed to load inventory");
    setLoading(false);
  }, [lowOnly, q]);

  useEffect(() => {
    void load();
  }, [load]);

  async function adjust(id: string, delta: number) {
    const res = await fetch("/api/admin/inventory", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id, delta, reason: "manual_admin_adjust" }),
    });
    const json = await res.json();
    if (!json.ok) {
      toast.error(json.error || "Adjust failed");
      return;
    }
    toast.success(`Stock updated to ${json.row.quantity}`);
    setRows((prev) => prev.map((r) => (r.id === id ? json.row : r)));
  }

  return (
    <div>
      <AdminPageHeader
        title="Inventory"
        description="Adjust stock, monitor low-SKU alerts, and reserve awareness."
      />

      <AdminPanel>
        <div className="mb-4 flex flex-wrap items-center gap-2">
          <Input
            placeholder="Search title, format, SKU…"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            className="max-w-xs"
          />
          <Button
            variant={lowOnly ? "default" : "outline"}
            size="sm"
            onClick={() => setLowOnly((v) => !v)}
          >
            Low stock only
          </Button>
          <Button variant="outline" size="sm" onClick={() => void load()}>
            Refresh
          </Button>
        </div>

        {loading ? (
          <p className="text-muted-foreground text-sm">Loading inventory…</p>
        ) : (
          <AdminTable headers={["Title", "Format", "On hand", "Reserved", "Available", ""]}>
            {rows.map((row) => (
              <tr key={row.id}>
                <td className="py-3">
                  <p className="font-medium">{row.title}</p>
                  <p className="text-muted-foreground text-xs">{row.sku}</p>
                </td>
                <td className="py-3 capitalize">{row.format}</td>
                <td className="py-3">
                  <Badge variant={row.lowStock ? "destructive" : "secondary"}>
                    {row.quantity}
                  </Badge>
                </td>
                <td className="py-3">{row.reserved}</td>
                <td className="py-3">{row.available}</td>
                <td className="py-3 text-right">
                  <div className="inline-flex gap-1">
                    <Button size="xs" variant="outline" onClick={() => void adjust(row.id, -1)}>
                      −1
                    </Button>
                    <Button size="xs" variant="outline" onClick={() => void adjust(row.id, 1)}>
                      +1
                    </Button>
                    <Button size="xs" onClick={() => void adjust(row.id, 10)}>
                      +10
                    </Button>
                  </div>
                </td>
              </tr>
            ))}
          </AdminTable>
        )}
      </AdminPanel>
    </div>
  );
}
