"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { Suspense } from "react";
import {
  Check,
  CreditCard,
  CircleUserRound,
  Smartphone,
  Truck,
  User,
} from "lucide-react";
import { toast } from "sonner";
import { useAuth } from "@/components/providers/auth-provider";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { formatMoney } from "@/data/mock";
import { useCartStore } from "@/stores/commerce";
import { cn } from "@/lib/utils";
import type { Book } from "@/types";

type CheckoutMode = "guest" | "account";

const paymentMethods = [
  {
    id: "momo",
    name: "Mobile Money",
    hint: "MTN · Telecel · AirtelTigo",
    icon: Smartphone,
  },
  {
    id: "card",
    name: "Debit / Card",
    hint: "Visa · Mastercard",
    icon: CreditCard,
  },
] as const;

const GHANA_REGIONS = [
  "Greater Accra",
  "Ashanti",
  "Western",
  "Central",
  "Eastern",
  "Volta",
  "Northern",
  "Upper East",
  "Upper West",
  "Bono",
  "Bono East",
  "Ahafo",
  "Western North",
  "Oti",
  "North East",
  "Savannah",
];

function CheckoutInner() {
  const searchParams = useSearchParams();
  const { user, profile, signUp } = useAuth();
  const items = useCartStore((s) => s.items);
  const clear = useCartStore((s) => s.clear);
  const pruneInvalid = useCartStore((s) => s.pruneInvalid);
  const [catalog, setCatalog] = useState<Book[]>([]);
  const [catalogLoaded, setCatalogLoaded] = useState(false);
  const [paymentMethod, setPaymentMethod] =
    useState<(typeof paymentMethods)[number]["id"]>("momo");
  const [placed, setPlaced] = useState(false);
  const [orderNumber, setOrderNumber] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [shippingCents, setShippingCents] = useState(25);
  const [shippingLabel, setShippingLabel] = useState("Nationwide");
  const [verifying, setVerifying] = useState(false);
  const [checkoutMode, setCheckoutMode] = useState<CheckoutMode>("guest");

  const [fullName, setFullName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [line1, setLine1] = useState("");
  const [city, setCity] = useState("Accra");
  const [region, setRegion] = useState("Greater Accra");

  useEffect(() => {
    pruneInvalid();
  }, [pruneInvalid]);

  useEffect(() => {
    if (profile?.full_name && !fullName) setFullName(profile.full_name);
    if ((profile?.email || user?.email) && !email) {
      setEmail(profile?.email || user?.email || "");
    }
  }, [profile, user, fullName, email]);

  useEffect(() => {
    let cancelled = false;
    void fetch("/api/catalog?resource=books&limit=100")
      .then((r) => r.json())
      .then((json) => {
        if (cancelled) return;
        setCatalog((json.books || []) as Book[]);
        setCatalogLoaded(true);
      })
      .catch(() => {
        if (!cancelled) setCatalogLoaded(true);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const byId = useMemo(() => new Map(catalog.map((b) => [b.id, b])), [catalog]);

  const lines = useMemo(
    () =>
      items
        .map((item) => {
          const book = byId.get(item.bookId);
          const format = book?.formats.find((f) => f.format === item.format);
          if (!book || !format) return null;
          return {
            book,
            format,
            quantity: item.quantity,
            lineTotal: format.price * item.quantity,
          };
        })
        .filter(Boolean) as {
        book: Book;
        format: { format: string; price: number };
        quantity: number;
        lineTotal: number;
      }[],
    [items, byId]
  );

  const staleCart = catalogLoaded && items.length > 0 && lines.length === 0;

  const subtotal = useMemo(() => lines.reduce((s, l) => s + l.lineTotal, 0), [lines]);
  const total = Math.max(0, subtotal + shippingCents);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const res = await fetch("/api/shipping/quote", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          city,
          region,
          country: "Ghana",
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
  }, [city, region, subtotal]);

  useEffect(() => {
    const paid = searchParams.get("paid");
    const ref = searchParams.get("ref");
    const payProvider = searchParams.get("provider") || "moolre";
    if (!paid || !ref) return;

    let cancelled = false;
    (async () => {
      setVerifying(true);
      const res = await fetch("/api/payments/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ provider: payProvider, reference: ref }),
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
  }, [searchParams, clear]);

  async function placeOrder() {
    if (lines.length === 0) {
      toast.error(
        staleCart
          ? "Your cart had outdated demo items. Browse the catalog and add books again."
          : "Your cart is empty"
      );
      if (staleCart) clear();
      return;
    }

    if (!fullName.trim()) {
      toast.error("Enter your full name");
      return;
    }
    if (phone.replace(/\D/g, "").length < 9) {
      toast.error("Enter a valid phone number");
      return;
    }
    if (!line1.trim() && !city.trim()) {
      toast.error("Enter your delivery location");
      return;
    }

    const wantsAccount = !user && checkoutMode === "account";
    if (wantsAccount) {
      if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
        toast.error("Email is required to create an account");
        return;
      }
      if (password.length < 6) {
        toast.error("Password must be at least 6 characters");
        return;
      }
    }

    setSubmitting(true);
    try {
      if (wantsAccount) {
        const created = await signUp(email.trim(), password, fullName.trim());
        if (created.error) {
          toast.error(created.error);
          setSubmitting(false);
          return;
        }
        toast.success("Account created");
      }

      const res = await fetch("/api/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          provider: "moolre",
          paymentMethod,
          email: email.trim() || undefined,
          customerName: fullName.trim(),
          phone: phone.trim(),
          shippingAddress: {
            fullName: fullName.trim(),
            line1: line1.trim() || city.trim(),
            city: city.trim() || line1.trim(),
            region,
            country: "Ghana",
            phone: phone.trim(),
            email: email.trim() || undefined,
          },
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

      if (data.authorizationUrl && !data.demo && !data.authorizationUrl.includes("mock_pay")) {
        window.location.href = data.authorizationUrl;
        return;
      }

      const methodLabel =
        paymentMethods.find((m) => m.id === paymentMethod)?.name ?? "Moolre";
      setOrderNumber(data.orderNumber ?? null);
      setPlaced(true);
      clear();
      toast.success("Order placed", {
        description: data.demo
          ? `Demo payment captured · ${data.orderNumber}`
          : `Paid via ${methodLabel} · ${data.orderNumber}`,
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
          We&apos;ll contact you on your phone about delivery
          {email.trim() ? " and send a receipt if email was provided" : ""}.
        </p>
        <div className="mt-8 flex flex-wrap justify-center gap-3">
          <Button asChild>
            <Link href="/books">Continue shopping</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link href="/contact">Contact us</Link>
          </Button>
        </div>
      </div>
    );
  }

  const showModePicker = !user;

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Checkout</h1>

      <div className="mt-8 grid gap-10 lg:grid-cols-12">
        <div className="space-y-8 lg:col-span-7">
          {showModePicker ? (
            <section>
              <h2 className="font-heading text-lg font-semibold">Checkout as</h2>
              <div className="mt-4 grid gap-3 sm:grid-cols-2">
                <button
                  type="button"
                  onClick={() => setCheckoutMode("guest")}
                  className={cn(
                    "relative flex items-start gap-3 rounded-2xl border p-4 text-left transition",
                    checkoutMode === "guest"
                      ? "border-primary bg-primary/5 shadow-soft"
                      : "border-border bg-card hover:border-primary/30"
                  )}
                >
                  <span
                    className={cn(
                      "mt-0.5 flex size-10 shrink-0 items-center justify-center rounded-full",
                      checkoutMode === "guest"
                        ? "bg-primary/15 text-primary"
                        : "bg-muted text-muted-foreground"
                    )}
                  >
                    <User className="size-5" />
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="font-heading block text-base font-semibold">
                      Guest Checkout
                    </span>
                    <span className="text-muted-foreground mt-1 block text-sm leading-snug">
                      Quick checkout without creating an account.
                    </span>
                  </span>
                  <span
                    className={cn(
                      "absolute top-3 right-3 flex size-5 items-center justify-center rounded-full border",
                      checkoutMode === "guest"
                        ? "border-primary bg-primary text-primary-foreground"
                        : "border-border"
                    )}
                  >
                    {checkoutMode === "guest" ? <Check className="size-3" /> : null}
                  </span>
                </button>

                <button
                  type="button"
                  onClick={() => setCheckoutMode("account")}
                  className={cn(
                    "relative flex items-start gap-3 rounded-2xl border p-4 text-left transition",
                    checkoutMode === "account"
                      ? "border-primary bg-primary/5 shadow-soft"
                      : "border-border bg-card hover:border-primary/30"
                  )}
                >
                  <span
                    className={cn(
                      "mt-0.5 flex size-10 shrink-0 items-center justify-center rounded-full",
                      checkoutMode === "account"
                        ? "bg-primary/15 text-primary"
                        : "bg-muted text-muted-foreground"
                    )}
                  >
                    <CircleUserRound className="size-5" />
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="font-heading block text-base font-semibold">
                      Create Account
                    </span>
                    <span className="text-muted-foreground mt-1 block text-sm leading-snug">
                      Save info, track orders &amp; earn loyalty points.
                    </span>
                  </span>
                  <span
                    className={cn(
                      "absolute top-3 right-3 flex size-5 items-center justify-center rounded-full border",
                      checkoutMode === "account"
                        ? "border-primary bg-primary text-primary-foreground"
                        : "border-border"
                    )}
                  >
                    {checkoutMode === "account" ? <Check className="size-3" /> : null}
                  </span>
                </button>
              </div>
              {checkoutMode === "account" ? (
                <p className="text-muted-foreground mt-3 text-xs">
                  Already have an account?{" "}
                  <Link href="/auth?next=/checkout" className="text-primary hover:underline">
                    Sign in
                  </Link>
                </p>
              ) : null}
            </section>
          ) : (
            <section className="rounded-2xl border border-primary/20 bg-primary/5 px-4 py-3 text-sm">
              Checking out as{" "}
              <span className="font-medium">
                {profile?.full_name || user?.email || "signed-in customer"}
              </span>
            </section>
          )}

          <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Your details</h2>
            <p className="text-muted-foreground mt-1 text-sm">
              {checkoutMode === "account" && !user
                ? "Create your account while placing this order."
                : "We only need this to deliver your order."}
            </p>
            <div className="mt-5 grid gap-4 sm:grid-cols-2">
              <div className="sm:col-span-2">
                <Label htmlFor="fullName">Full name *</Label>
                <Input
                  id="fullName"
                  className="mt-1.5"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="Ama Darko"
                  autoComplete="name"
                  required
                />
              </div>
              <div>
                <Label htmlFor="phone">Phone / WhatsApp *</Label>
                <Input
                  id="phone"
                  className="mt-1.5"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="0247140856"
                  autoComplete="tel"
                  inputMode="tel"
                  required
                />
              </div>
              <div>
                <Label htmlFor="email">
                  Email {checkoutMode === "account" && !user ? "*" : "(optional)"}
                </Label>
                <Input
                  id="email"
                  type="email"
                  className="mt-1.5"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="you@email.com"
                  autoComplete="email"
                  required={checkoutMode === "account" && !user}
                />
              </div>
              {checkoutMode === "account" && !user ? (
                <div className="sm:col-span-2">
                  <Label htmlFor="password">Password *</Label>
                  <Input
                    id="password"
                    type="password"
                    className="mt-1.5"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="At least 6 characters"
                    autoComplete="new-password"
                    required
                  />
                </div>
              ) : null}
              <div className="sm:col-span-2">
                <Label htmlFor="line1">Street address *</Label>
                <Input
                  id="line1"
                  className="mt-1.5"
                  value={line1}
                  onChange={(e) => setLine1(e.target.value)}
                  placeholder="14 Boundary Rd, East Legon"
                  autoComplete="street-address"
                  required
                />
              </div>
              <div>
                <Label htmlFor="city">City / town *</Label>
                <Input
                  id="city"
                  className="mt-1.5"
                  value={city}
                  onChange={(e) => setCity(e.target.value)}
                  placeholder="Accra"
                  autoComplete="address-level2"
                  required
                />
              </div>
              <div>
                <Label htmlFor="region">Region</Label>
                <select
                  id="region"
                  className="border-input bg-background mt-1.5 flex h-10 w-full rounded-md border px-3 text-sm"
                  value={region}
                  onChange={(e) => setRegion(e.target.value)}
                >
                  {GHANA_REGIONS.map((r) => (
                    <option key={r} value={r}>
                      {r}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <p className="text-muted-foreground mt-4 flex items-center gap-2 text-xs">
              <Truck className="size-3.5" />
              {shippingLabel}
            </p>
          </section>

          <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Payment method</h2>
            <div className="mt-4 grid gap-3 sm:grid-cols-2">
              {paymentMethods.map((method) => {
                const Icon = method.icon;
                const selected = paymentMethod === method.id;
                return (
                  <button
                    key={method.id}
                    type="button"
                    onClick={() => setPaymentMethod(method.id)}
                    className={cn(
                      "rounded-2xl border p-4 text-left transition",
                      selected
                        ? "border-primary bg-primary/5 shadow-soft"
                        : "border-border hover:border-primary/30"
                    )}
                  >
                    <Icon className="text-primary mb-2 size-5" />
                    <p className="text-sm font-semibold">{method.name}</p>
                    <p className="text-muted-foreground text-xs">{method.hint}</p>
                  </button>
                );
              })}
            </div>
          </section>
        </div>

        <aside className="lg:col-span-5">
          <div className="glass-strong sticky top-28 rounded-3xl p-6">
            <h2 className="font-heading text-lg font-semibold">Summary</h2>
            <ul className="mt-4 space-y-3">
              {lines.length === 0 ? (
                <li className="text-muted-foreground text-sm">
                  {staleCart
                    ? "Cart items were from an old demo catalog. Clear cart and add books from the store."
                    : !catalogLoaded
                      ? "Loading cart…"
                      : "No items in cart."}
                </li>
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
              {submitting
                ? "Processing…"
                : checkoutMode === "account" && !user
                  ? `Create account & pay ${formatMoney(total)}`
                  : `Pay ${formatMoney(total)}`}
            </Button>
            {staleCart ? (
              <Button
                variant="outline"
                className="mt-2 w-full"
                onClick={() => {
                  clear();
                  toast.success("Cart cleared");
                }}
              >
                Clear outdated cart
              </Button>
            ) : null}
            <Button variant="ghost" className="mt-2 w-full" asChild>
              <Link href={staleCart ? "/books" : "/cart"}>
                {staleCart ? "Browse books" : "Back to cart"}
              </Link>
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
