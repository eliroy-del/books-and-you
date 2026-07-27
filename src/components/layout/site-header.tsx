"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  Heart,
  Menu,
  ShoppingBag,
  User,
  X,
} from "lucide-react";
import { useState } from "react";
import { BrandLogo } from "@/components/brand-logo";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { SmartSearch } from "@/components/search/smart-search";
import { useAuth } from "@/components/providers/auth-provider";
import { useCartStore, useWishlistStore } from "@/stores/commerce";
import { cn } from "@/lib/utils";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";

const nav = [
  { href: "/books", label: "Books" },
  { href: "/categories", label: "Categories" },
  { href: "/authors", label: "Authors" },
  { href: "/subscriptions", label: "Subscriptions" },
  { href: "/library", label: "Library" },
];

export function SiteHeader() {
  const pathname = usePathname();
  const { user, profile, signOut, loading } = useAuth();
  const cartCount = useCartStore((s) => s.items.reduce((n, i) => n + i.quantity, 0));
  const wishlistCount = useWishlistStore((s) => s.bookIds.length);
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/75 backdrop-blur-xl">
      <div className="mx-auto flex h-16 max-w-7xl items-center gap-4 px-4 sm:px-6 lg:px-8">
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger
            render={
              <Button variant="ghost" size="icon" className="lg:hidden" aria-label="Open menu" />
            }
          >
            <Menu className="size-5" />
          </SheetTrigger>
          <SheetContent side="left" className="w-[300px] sm:w-[340px]">
            <SheetHeader>
              <SheetTitle className="font-heading text-left">
                <BrandLogo href="/" size="sm" showWordmark className="rounded-lg" />
              </SheetTitle>
            </SheetHeader>
            <nav className="mt-6 flex flex-col gap-1">
              {nav.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setOpen(false)}
                  className={cn(
                    "rounded-xl px-3 py-2.5 text-sm font-medium transition-colors",
                    pathname.startsWith(item.href)
                      ? "bg-primary/10 text-primary"
                      : "hover:bg-muted"
                  )}
                >
                  {item.label}
                </Link>
              ))}
              <Link
                href="/dashboard"
                onClick={() => setOpen(false)}
                className="hover:bg-muted rounded-xl px-3 py-2.5 text-sm font-medium"
              >
                Dashboard
              </Link>
              <Link
                href="/support"
                onClick={() => setOpen(false)}
                className="hover:bg-muted rounded-xl px-3 py-2.5 text-sm font-medium"
              >
                Support
              </Link>
            </nav>
          </SheetContent>
        </Sheet>

        <BrandLogo
          href="/"
          size="sm"
          showWordmark
          priority
          wordmarkClassName="hidden sm:inline"
        />

        <nav className="ml-2 hidden items-center gap-1 lg:flex">
          {nav.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "rounded-lg px-3 py-2 text-sm font-medium transition-colors",
                pathname.startsWith(item.href)
                  ? "text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="mx-auto hidden max-w-md flex-1 md:block lg:mx-8">
          <SmartSearch />
        </div>

        <div className="ml-auto flex items-center gap-1">
          <ThemeToggle />
          <Button variant="ghost" size="icon" className="relative size-9" asChild>
            <Link href="/wishlist" aria-label="Wishlist">
              <Heart className="size-4" />
              {wishlistCount > 0 && (
                <span className="bg-gold text-gold-foreground absolute -top-0.5 -right-0.5 flex size-4 items-center justify-center rounded-full text-[10px] font-bold">
                  {wishlistCount}
                </span>
              )}
            </Link>
          </Button>
          <Button variant="ghost" size="icon" className="relative size-9" asChild>
            <Link href="/cart" aria-label="Cart">
              <ShoppingBag className="size-4" />
              {cartCount > 0 && (
                <span className="bg-primary text-primary-foreground absolute -top-0.5 -right-0.5 flex size-4 items-center justify-center rounded-full text-[10px] font-bold">
                  {cartCount}
                </span>
              )}
            </Link>
          </Button>
          <Button variant="ghost" size="icon" className="size-9" asChild>
            <Link href="/dashboard" aria-label="Account">
              <User className="size-4" />
            </Link>
          </Button>
          {!loading && user ? (
            <Button
              variant="outline"
              className="ml-1 hidden sm:inline-flex"
              onClick={() => void signOut()}
            >
              {profile?.full_name?.split(" ")[0] ?? "Sign out"}
            </Button>
          ) : (
            <Button className="ml-1 hidden sm:inline-flex" asChild>
              <Link href="/auth">Sign in</Link>
            </Button>
          )}
        </div>
      </div>
      <div className="border-t border-border/40 px-4 py-2 md:hidden">
        <SmartSearch />
      </div>
    </header>
  );
}

export function MobileMenuClose({ onClick }: { onClick: () => void }) {
  return (
    <Button variant="ghost" size="icon" onClick={onClick} aria-label="Close">
      <X className="size-4" />
    </Button>
  );
}
