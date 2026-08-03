"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense } from "react";
import { Check, CreditCard, Truck } from "lucide-react";
import { toast } from "sonner";
import { useAuth } from "@/components/providers/auth-provider";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { formatMoney, getBookById, savedAddresses, siteConfig } from "@/data/mock";
import { useCartStore } from "@/stores/commerce";
import { cn } from "@/lib/utils";

const providers = [
  { id: "paystack", name: "Paystack", hint: "Cards · Mobile Money" },
] as const;

function CheckoutInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { user, profile, configured, loading: authLoading } = useAuth();
  const items = useCartStore((s) => s.items);
  const clear = useCartStore((s) => s.clear);
  const [addressId, setAddressId] = useState(savedAddresses[0]?.id);
  const [provider, setProvider] = useState<(typeof providers)[number]["id"]>("paystack");
  const [coupon, setCoupon] = useState("");
  const [discount, setDiscount] = useState(0);
  const [placed, setPlaced] = useState(false);
  const [orderNumber, setOrderNumber] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [shippingCents, setShippingCents] = useState(25);
  const [shippingLabel, setShippingLabel] = useState("Nationwide");
  const [verifying, setVerifying] = useState(false);

  const address = savedAddresses.find((a) => a.id === addressId) ?? savedAddresses[0];

  const lines = items
    .map((item) => {
      const book = getBookById(item.bookId);
      const format = book?.formats.find((f) => f.format === item.format);
      if (!book || !format) return null;
      return { book, format, quantity: item.quantity, lineTotal: format.price * item.quantity };
    })
    .filter(Boolean) as {
    book: NonNullable<ReturnType<typeof getBookById>>;
    format: { format: string; price: number };
    quantity: number;
    lineTotal: number;
  }[];

  const subtotal = useMemo(() => lines.reduce((s, l) => s + l.lineTotal, 0), [lines]);
  const total = Math.max(0, subtotal + shippingCents - discount);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const res = await fetch("/api/shipping/quote", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          city: address?.city,
          region: address?.region,
          country: address?.country || "Ghana",
          subtotalCents: Math.round(subtotal * 100),
        }),
      });
      if (!res.ok || cancelled) return;
      const data = await res.json();
      setShippingCents(Number(data.amount ?? 25));
      setShippingLabel(
        data.rate?.free
          ? `Free · ${data.rate.carrier}`
          : `${data.rate?.carrier ?? "Shipping"} · ${data.rate?.etaDaysMin}-${data.rate?.etaDaysMax} days`
      );
    })();
    return () => {
      cancelled = true;
    };
  }, [address?.city, address?.region, address?.country, subtotal]);

  // Return from payment provider
  useEffect(() => {
    const paid = searchParams.get("paid");
    const ref = searchParams.get("ref");
    const payProvider = searchParams.get("provider") as typeof provider | null;
    if (!paid || !ref) return;

    let cancelled = false;
    (async () => {
      setVerifying(true);
      const res = await fetch("/api/payments/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ provider: payProvider || provider, reference: ref }),
      });
      const data = await res.json();
      if (cancelled) return;
      setVerifying(false);
      if (data.ok) {
        clear();
        setOrderNumber(ref.split("-").slice(0, 2).join("-"));
        setPlaced(true);
        toast.success("Payment verified");
      } else {
        toast.error(data.error || "Payment verification failed");
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [searchParams, provider, clear]);

  function applyCoupon() {
    if (coupon.trim().toUpperCase() === "READMORE") {
      setDiscount(30);
      toast.success("Coupon applied", { description: "GH₵30 off" });
    } else {
      toast.error("Invalid coupon");
    }
  }

  async function placeOrder() {
    if (lines.length === 0) {
      toast.error("Your cart is empty");
      return;
    }

    if (configured && !authLoading && !user) {
      toast.error("Please sign in to checkout");
      router.push("/auth?next=/checkout");
      return;
    }

    setSubmitting(true);
    try {
      const res = await fetch("/api/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          provider,
          couponCode: coupon || undefined,
          discountCedis: discount,
          email: profile?.email || user?.email,
          customerName: profile?.full_name || undefined,
          shippingAddress: address
            ? {
                fullName: address.fullName,
                line1: address.line1,
                line2: address.line2,
                city: address.city,
                region: address.region,
                country: address.country,
                phone: address.phone,
              }
            : {},
          lines: lines.map((l) => ({
            bookId: l.book.id,
            format: l.format.format,
            quantity: l.quantity,
            unitPrice: l.format.price,
            title: l.book.title,
          })),
        }),
      });

      const data = (await res.json()) as {
        ok: boolean;
        error?: string;
        orderNumber?: string;
        authorizationUrl?: string;
        demo?: boolean;
        shippingCents?: number;
      };

      if (!res.ok || !data.ok) {
        toast.error(data.error ?? "Checkout failed");
        return;
      }

      if (typeof data.shippingCents === "number") {
        setShippingCents(data.shippingCents / 100);
      }

      // Live provider redirect
      if (data.authorizationUrl && !data.demo && !data.authorizationUrl.includes("mock_pay")) {
        window.location.href = data.authorizationUrl;
        return;
      }

      setOrderNumber(data.orderNumber ?? null);
      setPlaced(true);
      clear();
      toast.success("Order placed", {
        description: data.demo
          ? `Demo payment captured · ${data.orderNumber}`
          : `Paid via ${provider} · ${data.orderNumber}`,
      });
    } catch {
      toast.error("Checkout failed");
    } finally {
      setSubmitting(false);
    }
  }

  if (verifying) {
    return (
      <div className="mx-auto max-w-lg px-4 py-24 text-center">
        <p className="font-heading text-xl font-semibold">Verifying payment…</p>
        <p className="text-muted-foreground mt-2 text-sm">Please wait a moment.</p>
      </div>
    );
  }

  if (placed) {
    return (
      <div className="mx-auto flex max-w-lg flex-col items-center px-4 py-24 text-center">
        <div className="bg-success/15 text-success flex size-16 items-center justify-center rounded-full">
          <Check className="size-8" />
        </div>
        <h1 className="font-heading mt-6 text-3xl font-bold">Order confirmed</h1>
        <p className="text-muted-foreground mt-3 text-sm leading-relaxed">
          {orderNumber ? (
            <>
              Order <span className="text-foreground font-medium">{orderNumber}</span> is confirmed.
            </>
          ) : (
            "Thanks for shopping with Books & You."
          )}{" "}
          A receipt email is on the way. Track shipping from Orders — eBooks are in your Library.
        </p>
        <div className="mt-8 flex flex-wrap justify-center gap-3">
          <Button asChild>
            <Link href="/orders">Track order</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link href="/library">Go to library</Link>
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Checkout</h1>
      <p className="text-muted-foreground mt-2 text-sm">
        Paystack · free delivery above{" "}
        {formatMoney(siteConfig.freeDeliveryThreshold)}
      </p>

      <div className="mt-10 grid gap-10 lg:grid-cols-12">
        <div className="space-y-8 lg:col-span-7">
          <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Shipping address</h2>
            <div className="mt-4 space-y-3">
              {savedAddresses.map((addr) => (
                <button
                  key={addr.id}
                  type="button"
                  onClick={() => setAddressId(addr.id)}
                  className={cn(
                    "w-full rounded-2xl border p-4 text-left transition",
                    addressId === addr.id
                      ? "border-primary bg-primary/5"
                      : "border-border hover:border-primary/30"
                  )}
                >
                  <p className="text-sm font-semibold">
                    {addr.label}
                    {addr.isDefault ? " · Default" : ""}
                  </p>
                  <p className="text-muted-foreground mt-1 text-sm">
                    {addr.fullName} · {addr.line1}
                    {addr.line2 ? `, ${addr.line2}` : ""}, {addr.city}
                  </p>
                </button>
              ))}
            </div>
            <p className="text-muted-foreground mt-4 flex items-center gap-2 text-xs">
              <Truck className="size-3.5" />
              {shippingLabel}
            </p>
          </section>

          <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Payment method</h2>
            <div className="mt-4 grid gap-3 sm:grid-cols-3">
              {providers.map((p) => (
                <button
                  key={p.id}
                  type="button"
                  onClick={() => setProvider(p.id)}
                  className={cn(
                    "rounded-2xl border p-4 text-left transition",
                    provider === p.id
                      ? "border-primary bg-primary/5 shadow-glow"
                      : "border-border hover:border-primary/30"
                  )}
                >
                  <CreditCard className="text-primary mb-2 size-5" />
                  <p className="text-sm font-semibold">{p.name}</p>
                  <p className="text-muted-foreground text-xs">{p.hint}</p>
                </button>
              ))}
            </div>
            <p className="text-muted-foreground mt-4 text-xs">
              Without provider secret keys, checkout auto-captures in demo mode and still sends
              confirmation notifications.
            </p>
          </section>
        </div>

        <aside className="lg:col-span-5">
          <div className="glass-strong sticky top-28 rounded-3xl p-6">
            <h2 className="font-heading text-lg font-semibold">Summary</h2>
            <ul className="mt-4 space-y-3">
              {lines.length === 0 ? (
                <li className="text-muted-foreground text-sm">No items in cart.</li>
              ) : (
                lines.map((l) => (
                  <li
                    key={`${l.book.id}-${l.format.format}`}
                    className="flex justify-between gap-3 text-sm"
                  >
                    <span className="min-w-0 truncate">
                      {l.book.title} × {l.quantity}
                    </span>
                    <span className="shrink-0">{formatMoney(l.lineTotal)}</span>
                  </li>
                ))
              )}
            </ul>
            <div className="mt-4 flex gap-2">
              <Input
                placeholder="Coupon code"
                value={coupon}
                onChange={(e) => setCoupon(e.target.value)}
              />
              <Button variant="outline" onClick={applyCoupon}>
                Apply
              </Button>
            </div>
            <p className="text-muted-foreground mt-2 text-xs">Try READMORE</p>
            <Separator className="my-4" />
            <div className="space-y-2 text-sm">
              <div className="flex justify-between">
                <span className="text-muted-foreground">Subtotal</span>
                <span>{formatMoney(subtotal)}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-muted-foreground">Shipping</span>
                <span>{shippingCents === 0 ? "Free" : formatMoney(shippingCents)}</span>
              </div>
              {discount > 0 && (
                <div className="flex justify-between text-success">
                  <span>Discount</span>
                  <span>−{formatMoney(discount)}</span>
                </div>
              )}
              <div className="flex justify-between text-base font-semibold">
                <span>Total</span>
                <span>{formatMoney(total)}</span>
              </div>
            </div>
            <Button
              className="mt-6 h-12 w-full rounded-xl shadow-glow"
              size="lg"
              onClick={placeOrder}
              disabled={lines.length === 0 || submitting}
            >
              {submitting ? "Processing…" : `Pay ${formatMoney(total)} with ${providers.find((p) => p.id === provider)?.name}`}
            </Button>
            <Button variant="ghost" className="mt-2 w-full" asChild>
              <Link href="/cart">Back to cart</Link>
            </Button>
          </div>
        </aside>
      </div>
    </div>
  );
}

export default function CheckoutPage() {
  return (
    <Suspense fallback={<div className="py-24 text-center text-sm">Loading checkout…</div>}>
      <CheckoutInner />
    </Suspense>
  );
}
