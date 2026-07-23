import Link from "next/link";
import { Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { formatMoney, subscriptionPlans } from "@/data/mock";
import { cn } from "@/lib/utils";

export const metadata = {
  title: "Subscriptions",
};

export default function SubscriptionsPage() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-2xl text-center">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">
          Book subscriptions
        </p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          A curated shelf, delivered
        </h1>
        <p className="text-muted-foreground mt-3">
          Monthly, quarterly, or annual plans with member pricing and early access.
        </p>
      </div>

      <div className="mt-12 grid gap-5 lg:grid-cols-3">
        {subscriptionPlans.map((plan) => (
          <div
            key={plan.id}
            className={cn(
              "relative flex flex-col rounded-3xl border bg-card p-6 shadow-soft",
              plan.popular
                ? "border-primary shadow-glow scale-[1.02]"
                : "border-border/70"
            )}
          >
            {plan.popular && (
              <span className="bg-gold text-gold-foreground absolute -top-3 left-6 rounded-full px-3 py-1 text-xs font-semibold">
                Most popular
              </span>
            )}
            <h2 className="font-heading text-xl font-semibold">{plan.name}</h2>
            <p className="text-muted-foreground mt-1 text-sm capitalize">{plan.interval}</p>
            <p className="font-heading mt-4 text-4xl font-bold">
              {formatMoney(plan.price)}
              <span className="text-muted-foreground text-base font-normal">
                /{plan.interval === "monthly" ? "mo" : plan.interval === "quarterly" ? "qtr" : "yr"}
              </span>
            </p>
            <p className="text-muted-foreground mt-2 text-sm">
              {plan.booksPerPeriod} book{plan.booksPerPeriod === 1 ? "" : "s"} per period
            </p>
            <ul className="mt-6 flex-1 space-y-3">
              {plan.features.map((f) => (
                <li key={f} className="flex gap-2 text-sm">
                  <Check className="text-success mt-0.5 size-4 shrink-0" />
                  {f}
                </li>
              ))}
            </ul>
            <Button
              className={cn("mt-8 h-11 rounded-xl", plan.popular && "shadow-glow")}
              variant={plan.popular ? "default" : "outline"}
              asChild
            >
              <Link href="/auth">Start {plan.name}</Link>
            </Button>
          </div>
        ))}
      </div>
    </div>
  );
}
