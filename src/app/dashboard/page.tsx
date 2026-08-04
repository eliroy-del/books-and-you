"use client";

import Link from "next/link";
import {
  Bell,
  BookMarked,
  Gift,
  Package,
  Settings,
  Sparkles,
} from "lucide-react";
import { useAuth } from "@/components/providers/auth-provider";
import { Button } from "@/components/ui/button";

const links = [
  { href: "/library", label: "Library", icon: BookMarked },
  { href: "/orders", label: "Orders", icon: Package },
  { href: "/wishlist", label: "Wishlist", icon: Gift },
  { href: "/blog", label: "Blog", icon: Sparkles },
  { href: "/support", label: "Support", icon: Bell },
  { href: "/auth", label: "Account", icon: Settings },
];

export default function DashboardPage() {
  const { user, profile, loading } = useAuth();

  if (loading) {
    return (
      <div className="mx-auto max-w-7xl px-4 py-24 text-center text-sm text-muted-foreground">
        Loading…
      </div>
    );
  }

  if (!user) {
    return (
      <div className="mx-auto flex max-w-lg flex-col items-center px-4 py-24 text-center">
        <h1 className="font-heading text-3xl font-bold tracking-tight">Your account</h1>
        <p className="text-muted-foreground mt-3 text-sm leading-relaxed">
          Sign in to view orders, wishlist sync, and account details. You can still shop and
          checkout as a guest anytime.
        </p>
        <div className="mt-8 flex flex-wrap justify-center gap-3">
          <Button asChild>
            <Link href="/auth?next=/dashboard">Sign in</Link>
          </Button>
          <Button variant="outline" asChild>
            <Link href="/books">Continue shopping</Link>
          </Button>
        </div>
      </div>
    );
  }

  const firstName =
    profile?.full_name?.split(" ")[0] ||
    user.email?.split("@")[0] ||
    "Reader";

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="text-primary text-sm font-semibold tracking-widest uppercase">
            Account
          </p>
          <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight">
            Welcome, {firstName}
          </h1>
          <p className="text-muted-foreground mt-2 text-sm">
            {user.email || "Signed in"}
          </p>
        </div>
        <Button asChild>
          <Link href="/books">Continue browsing</Link>
        </Button>
      </div>

      <div className="mt-10 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {links.map((item) => {
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              className="flex items-center gap-3 rounded-2xl border border-border/70 bg-card p-4 shadow-soft transition hover:border-primary/30"
            >
              <span className="bg-primary/10 text-primary flex size-10 items-center justify-center rounded-xl">
                <Icon className="size-4" />
              </span>
              <span className="font-medium">{item.label}</span>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
