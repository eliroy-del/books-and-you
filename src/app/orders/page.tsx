"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Download, RotateCcw, Truck } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { formatMoney } from "@/data/mock";
import { subscribeOrderStatus } from "@/lib/services/inventory";
import type { Order, OrderStatus } from "@/types";
import { cn } from "@/lib/utils";
import { useAuth } from "@/components/providers/auth-provider";

const steps: OrderStatus[] = ["ordered", "packed", "shipped", "delivered", "completed"];

export default function OrdersPage() {
  const { user, loading: authLoading } = useAuth();
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (authLoading) return;
    let cancelled = false;

    if (!user) {
      setOrders([]);
      setLoading(false);
      return;
    }

    setLoading(true);
    (async () => {
      try {
        const res = await fetch("/api/me?type=orders");
        if (res.ok) {
          const data = (await res.json()) as { orders?: Order[] };
          if (!cancelled) setOrders(data.orders || []);
        } else if (!cancelled) {
          setOrders([]);
        }
      } catch {
        if (!cancelled) setOrders([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [user, authLoading]);

  useEffect(() => {
    if (!user || !orders[0]?.id || orders[0].id.startsWith("ord-")) return;
    return subscribeOrderStatus(orders[0].id, (status) => {
      setOrders((prev) =>
        prev.map((o, i) =>
          i === 0 ? { ...o, status: status as OrderStatus } : o
        )
      );
    });
  }, [user, orders]);

  if (!authLoading && !user) {
    return (
      <div className="mx-auto flex max-w-lg flex-col items-center px-4 py-24 text-center">
        <h1 className="font-heading text-3xl font-bold tracking-tight">Orders</h1>
        <p className="text-muted-foreground mt-3 text-sm leading-relaxed">
          Sign in to view order history. Guest checkouts are confirmed by phone or email after
          payment.
        </p>
        <div className="mt-8 flex flex-wrap justify-center gap-3">
          <Button asChild>
            <Link href="/auth?next=/orders">Sign in</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link href="/books">Continue shopping</Link>
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="font-heading text-3xl font-bold tracking-tight">Orders</h1>
          <p className="text-muted-foreground mt-2 text-sm">
            Timeline tracking, invoices, and repeat purchases.
          </p>
        </div>
        <Button variant="outline" asChild>
          <Link href="/support">Need help?</Link>
        </Button>
      </div>

      {loading || authLoading ? (
        <p className="text-muted-foreground mt-10 text-sm">Loading orders…</p>
      ) : orders.length === 0 ? (
        <div className="mt-16 text-center">
          <p className="text-muted-foreground text-sm">No orders yet.</p>
          <Button className="mt-6" asChild>
            <Link href="/books">Browse books</Link>
          </Button>
        </div>
      ) : (
        <div className="mt-10 space-y-6">
          {orders.map((order) => {
            const currentIdx = steps.indexOf(
              order.status === "cancelled" ? "ordered" : order.status
            );
            return (
              <article
                key={order.id}
                className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft"
              >
                <div className="flex flex-wrap items-start justify-between gap-4">
                  <div>
                    <div className="flex flex-wrap items-center gap-2">
                      <h2 className="font-heading text-lg font-semibold">{order.number}</h2>
                      <Badge className="capitalize">{order.status}</Badge>
                    </div>
                    <p className="text-muted-foreground mt-1 text-sm">
                      Placed{" "}
                      {new Date(order.placedAt).toLocaleDateString("en-GH", {
                        year: "numeric",
                        month: "short",
                        day: "numeric",
                      })}{" "}
                      · {order.shippingAddress}
                    </p>
                    {order.trackingNumber && (
                      <p className="text-muted-foreground mt-1 flex items-center gap-1.5 text-sm">
                        <Truck className="size-3.5" />
                        Tracking {order.trackingNumber}
                      </p>
                    )}
                  </div>
                  <p className="font-heading text-lg font-bold">{formatMoney(order.total)}</p>
                </div>

                <div className="mt-6 flex items-center gap-1 overflow-x-auto pb-1">
                  {steps.map((step, i) => (
                    <div key={step} className="flex min-w-0 flex-1 items-center gap-1">
                      <div
                        className={cn(
                          "flex size-8 shrink-0 items-center justify-center rounded-full text-[10px] font-bold uppercase",
                          i <= currentIdx
                            ? "bg-primary text-primary-foreground"
                            : "bg-muted text-muted-foreground"
                        )}
                      >
                        {i + 1}
                      </div>
                      <span
                        className={cn(
                          "hidden text-xs capitalize sm:inline",
                          i <= currentIdx ? "text-foreground" : "text-muted-foreground"
                        )}
                      >
                        {step}
                      </span>
                      {i < steps.length - 1 && (
                        <div
                          className={cn(
                            "mx-1 h-0.5 flex-1 rounded-full",
                            i < currentIdx ? "bg-primary" : "bg-muted"
                          )}
                        />
                      )}
                    </div>
                  ))}
                </div>

                <ul className="mt-6 space-y-2 text-sm">
                  {order.items.map((item, i) => (
                    <li key={i} className="flex justify-between gap-3">
                      <span>
                        {item.title}{" "}
                        <span className="text-muted-foreground capitalize">
                          · {item.format} × {item.quantity}
                        </span>
                      </span>
                      <span>{formatMoney(item.price * item.quantity)}</span>
                    </li>
                  ))}
                </ul>

                <div className="mt-6 flex flex-wrap gap-2">
                  <Button size="sm" variant="outline">
                    <Download className="size-3.5" />
                    Invoice
                  </Button>
                  <Button size="sm" variant="outline">
                    <Truck className="size-3.5" />
                    Track shipment
                  </Button>
                  <Button size="sm" variant="ghost">
                    <RotateCcw className="size-3.5" />
                    Buy again
                  </Button>
                </div>
              </article>
            );
          })}
        </div>
      )}
    </div>
  );
}
