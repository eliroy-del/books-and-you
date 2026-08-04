"use client";

import { useEffect, useMemo, useRef, useState } from "react";
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
import {
  checkoutDetailsSchema,
  checkoutDetailsSchemaForMode,
  checkoutSchema,
  getFieldErrors,
  getFirstError,
  GHANA_REGIONS,
  type CheckoutDetailsData,
  type GhanaRegion,
} from "@/lib/validation";
import { sanitize, sanitizeEmail, sanitizePhone } from "@/lib/sanitize";
import { analytics } from "@/lib/analytics";
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
  const [errors, setErrors] = useState<Record<string, string>>({});

  const [fullName, setFullName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [line1, setLine1] = useState("");
  const [city, setCity] = useState("Accra");
  const [region, setRegion] = useState<GhanaRegion>("Greater Accra");

  function detailsValues(): CheckoutDetailsData {
    return {
      fullName,
      phone,
      email,
      password,
      line1,
      city,
      region,
    };
  }

  function validateDetailsField(field: keyof CheckoutDetailsData, value: unknown) {
    const fieldSchema = checkoutDetailsSchema.shape[field];
    const result = fieldSchema.safeParse(value);
    setErrors((prev) => {
      const next = { ...prev };
      if (!result.success) {
        next[field] = result.error.issues[0]?.message || "Invalid";
      } else {
        delete next[field];
      }
      return next;
    });
  }

  function handleDetailsChange(
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) {
    const { name, value } = e.target;
    switch (name) {
      case "fullName":
        setFullName(value);
        break;
      case "phone":
        setPhone(value);
        break;
      case "email":
        setEmail(value);
        break;
      case "password":
        setPassword(value);
        break;
      case "line1":
        setLine1(value);
        break;
      case "city":
        setCity(value);
        break;
      case "region":
        setRegion(value as GhanaRegion);
        break;
      default:
        break;
    }
    validateDetailsField(name as keyof CheckoutDetailsData, value);
  }

  useEffect(() => {
    pruneInvalid();
  }, [pruneInvalid]);

  useEffect(() => {
    // Only fill from account when the shopper chooses account checkout.
    if (checkoutMode !== "account" || !user) return;
    if (profile?.full_name && !fullName) setFullName(profile.full_name);
    if ((profile?.email || user.email) && !email) {
      setEmail(profile?.email || user.email || "");
    }
  }, [checkoutMode, profile, user, fullName, email]);

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
  const beginCheckoutTracked = useRef(false);

  useEffect(() => {
    if (lines.length === 0 || beginCheckoutTracked.current) return;
    beginCheckoutTracked.current = true;
    analytics.trackBeginCheckout(total, lines.length);
  }, [lines.length, total]);

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
        analytics.trackPurchase(ref, total, lines.length || items.length);
        toast.success("Payment verified");
      } else {
        toast.error(data.error || "Payment verification failed");
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [searchParams, clear]);

  async function placeOrder(e?: React.FormEvent) {
    e?.preventDefault();

    if (lines.length === 0) {
      toast.error(
        staleCart
          ? "Your cart had outdated demo items. Browse the catalog and add books again."
          : "Your cart is empty"
      );
      if (staleCart) clear();
      return;
    }

    const wantsAccount = !user && checkoutMode === "account";
    const detailsResult = checkoutDetailsSchemaForMode(
      checkoutMode,
      Boolean(user)
    ).safeParse(detailsValues());

    if (!detailsResult.success) {
      const fieldErrors = getFieldErrors(detailsResult.error);
      setErrors(fieldErrors);
      toast.error(Object.values(fieldErrors)[0] || "Please fix the form");
      return;
    }

    const details = detailsResult.data;
    const safeName = sanitize(details.fullName);
    const safePhone = sanitizePhone(details.phone);
    const safeEmail = details.email ? sanitizeEmail(details.email) : "";
    const safeLine1 = sanitize(details.line1);
    const safeCity = sanitize(details.city);
    const safeRegion = sanitize(details.region);

    const checkoutPayload = {
      provider: "moolre" as const,
      paymentMethod,
      email: safeEmail,
      customerName: safeName,
      phone: safePhone,
      shippingAddress: {
        fullName: safeName,
        line1: safeLine1,
        city: safeCity,
        region: details.region,
        country: "Ghana",
        phone: safePhone,
        email: safeEmail,
      },
      lines: lines.map((l) => ({
        bookId: l.book.id,
        format: l.format.format as "hardcover" | "paperback" | "ebook" | "audiobook",
        quantity: l.quantity,
        unitPrice: l.format.price,
        title: sanitize(l.book.title),
      })),
    };

    const validated = checkoutSchema.safeParse(checkoutPayload);
    if (!validated.success) {
      const fieldErrors = getFieldErrors(validated.error);
      const mapped: Record<string, string> = { ...fieldErrors };
      if (fieldErrors.customerName) mapped.fullName = fieldErrors.customerName;
      if (fieldErrors["shippingAddress.line1"]) {
        mapped.line1 = fieldErrors["shippingAddress.line1"];
      }
      if (fieldErrors["shippingAddress.city"]) {
        mapped.city = fieldErrors["shippingAddress.city"];
      }
      if (fieldErrors["shippingAddress.region"]) {
        mapped.region = fieldErrors["shippingAddress.region"];
      }
      setErrors(mapped);
      toast.error(getFirstError(validated.error));
      return;
    }

    setErrors({});
    setSubmitting(true);
    try {
      if (wantsAccount) {
        const created = await signUp(
          safeEmail,
          details.password || "",
          safeName
        );
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
          ...validated.data,
          email: safeEmail || undefined,
          customerName: safeName,
          phone: safePhone,
          shippingAddress: {
            ...validated.data.shippingAddress,
            fullName: safeName,
            line1: safeLine1,
            city: safeCity,
            region: safeRegion,
            phone: safePhone,
            email: safeEmail || undefined,
          },
        }),
      });

      const data = (await res.json()) as {
        ok: boolean;
        error?: string;
        errors?: Record<string, string>;
        orderNumber?: string;
        authorizationUrl?: string;
        demo?: boolean;
        shippingCents?: number;
      };

      if (!res.ok || !data.ok) {
        if (data.errors) {
          const mapped: Record<string, string> = { ...data.errors };
          if (data.errors.customerName) mapped.fullName = data.errors.customerName;
          if (data.errors["shippingAddress.line1"]) {
            mapped.line1 = data.errors["shippingAddress.line1"];
          }
          if (data.errors["shippingAddress.city"]) {
            mapped.city = data.errors["shippingAddress.city"];
          }
          setErrors(mapped);
        }
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
      analytics.trackPurchase(data.orderNumber || "order", total, lines.length);
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

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Checkout</h1>

      <div className="mt-8 grid gap-10 lg:grid-cols-12">
        <div className="space-y-8 lg:col-span-7">
          <section>
            <h2 className="font-heading text-lg font-semibold">Checkout as</h2>
            <div className="mt-4 grid gap-3 sm:grid-cols-2">
                <button
                  type="button"
                  onClick={() => {
                    setCheckoutMode("guest");
                    setErrors((prev) => {
                      const next = { ...prev };
                      delete next.password;
                      delete next.email;
                      return next;
                    });
                  }}
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
                    {user ? "Use my account" : "Create Account"}
                  </span>
                  <span className="text-muted-foreground mt-1 block text-sm leading-snug">
                    {user
                      ? `Continue as ${profile?.full_name || user.email || "signed-in customer"}.`
                      : "Save info, track orders & earn loyalty points."}
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
            {checkoutMode === "account" && !user ? (
              <p className="text-muted-foreground mt-3 text-xs">
                Already have an account?{" "}
                <Link href="/auth?next=/checkout" className="text-primary hover:underline">
                  Sign in
                </Link>
              </p>
            ) : null}
          </section>

          <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Your details</h2>
            <p className="text-muted-foreground mt-1 text-sm">
              {checkoutMode === "account" && !user
                ? "Create your account while placing this order."
                : "We only need this to deliver your order."}
            </p>
            <form
              id="checkout-details"
              className="mt-5 grid gap-4 sm:grid-cols-2"
              onSubmit={placeOrder}
              noValidate
            >
              <div className="sm:col-span-2">
                <Label htmlFor="fullName">Full name *</Label>
                <Input
                  id="fullName"
                  name="fullName"
                  className={cn("mt-1.5", errors.fullName && "border-destructive")}
                  value={fullName}
                  onChange={handleDetailsChange}
                  placeholder="Ama Darko"
                  autoComplete="name"
                  aria-invalid={Boolean(errors.fullName)}
                  aria-describedby={errors.fullName ? "fullName-error" : undefined}
                />
                {errors.fullName ? (
                  <p id="fullName-error" className="text-destructive mt-1 text-xs">
                    {errors.fullName}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="phone">Phone / WhatsApp *</Label>
                <Input
                  id="phone"
                  name="phone"
                  type="tel"
                  className={cn("mt-1.5", errors.phone && "border-destructive")}
                  value={phone}
                  onChange={handleDetailsChange}
                  placeholder="0247140856"
                  autoComplete="tel"
                  inputMode="tel"
                  aria-invalid={Boolean(errors.phone)}
                  aria-describedby={errors.phone ? "phone-error" : undefined}
                />
                {errors.phone ? (
                  <p id="phone-error" className="text-destructive mt-1 text-xs">
                    {errors.phone}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="email">
                  Email {checkoutMode === "account" && !user ? "*" : "(optional)"}
                </Label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  className={cn("mt-1.5", errors.email && "border-destructive")}
                  value={email}
                  onChange={handleDetailsChange}
                  placeholder="you@email.com"
                  autoComplete="email"
                  aria-invalid={Boolean(errors.email)}
                  aria-describedby={errors.email ? "email-error" : undefined}
                />
                {errors.email ? (
                  <p id="email-error" className="text-destructive mt-1 text-xs">
                    {errors.email}
                  </p>
                ) : null}
              </div>
              {checkoutMode === "account" && !user ? (
                <div className="sm:col-span-2">
                  <Label htmlFor="password">Password *</Label>
                  <Input
                    id="password"
                    name="password"
                    type="password"
                    className={cn("mt-1.5", errors.password && "border-destructive")}
                    value={password}
                    onChange={handleDetailsChange}
                    placeholder="At least 6 characters"
                    autoComplete="new-password"
                    aria-invalid={Boolean(errors.password)}
                    aria-describedby={errors.password ? "password-error" : undefined}
                  />
                  {errors.password ? (
                    <p id="password-error" className="text-destructive mt-1 text-xs">
                      {errors.password}
                    </p>
                  ) : null}
                </div>
              ) : null}
              <div className="sm:col-span-2">
                <Label htmlFor="line1">Street address *</Label>
                <Input
                  id="line1"
                  name="line1"
                  className={cn("mt-1.5", errors.line1 && "border-destructive")}
                  value={line1}
                  onChange={handleDetailsChange}
                  placeholder="14 Boundary Rd, East Legon"
                  autoComplete="street-address"
                  aria-invalid={Boolean(errors.line1)}
                  aria-describedby={errors.line1 ? "line1-error" : undefined}
                />
                {errors.line1 ? (
                  <p id="line1-error" className="text-destructive mt-1 text-xs">
                    {errors.line1}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="city">City / town *</Label>
                <Input
                  id="city"
                  name="city"
                  className={cn("mt-1.5", errors.city && "border-destructive")}
                  value={city}
                  onChange={handleDetailsChange}
                  placeholder="Accra"
                  autoComplete="address-level2"
                  aria-invalid={Boolean(errors.city)}
                  aria-describedby={errors.city ? "city-error" : undefined}
                />
                {errors.city ? (
                  <p id="city-error" className="text-destructive mt-1 text-xs">
                    {errors.city}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="region">Region *</Label>
                <select
                  id="region"
                  name="region"
                  className={cn(
                    "border-input bg-background mt-1.5 flex h-10 w-full rounded-md border px-3 text-sm",
                    errors.region && "border-destructive"
                  )}
                  value={region}
                  onChange={handleDetailsChange}
                  aria-invalid={Boolean(errors.region)}
                  aria-describedby={errors.region ? "region-error" : undefined}
                >
                  {GHANA_REGIONS.map((r) => (
                    <option key={r} value={r}>
                      {r}
                    </option>
                  ))}
                </select>
                {errors.region ? (
                  <p id="region-error" className="text-destructive mt-1 text-xs">
                    {errors.region}
                  </p>
                ) : null}
              </div>
            </form>
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
              type="submit"
              form="checkout-details"
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
