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
import { HeaderSearch } from "@/components/search/header-search";
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
import { CatalogMegaMenu, MobileCatalogNav } from "@/components/layout/catalog-mega-menu";

const nav = [
  { href: "/books", label: "All Books" },
  { href: "/categories", label: "Browse" },
  { href: "/contact", label: "Contact Us" },
  { href: "/blog", label: "Blog" },
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
      <div className="mx-auto flex h-20 max-w-7xl items-center gap-3 pl-2 pr-4 sm:gap-4 sm:pl-3 sm:pr-6 lg:h-24 lg:gap-5 lg:pl-4 lg:pr-8">
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger
            render={
              <Button variant="ghost" size="icon" className="-ml-1 size-11 lg:hidden" aria-label="Open menu" />
            }
          >
            <Menu className="size-5" />
          </SheetTrigger>
          <SheetContent side="left" className="w-[300px] sm:w-[340px]">
            <SheetHeader>
              <SheetTitle className="font-heading text-left">
                <BrandLogo href="/" size="md" showWordmark={false} className="rounded-lg" />
              </SheetTitle>
            </SheetHeader>
            <nav className="mt-4 flex flex-col gap-1 overflow-y-auto pb-8">
              <MobileCatalogNav onNavigate={() => setOpen(false)} />
              <div className="mt-3 border-t border-border/60 pt-3">
                {nav.map((item) => (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setOpen(false)}
                    className={cn(
                      "rounded-xl px-3 py-3 text-[15px] font-medium transition-colors block",
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
                  className="hover:bg-muted block rounded-xl px-3 py-3 text-[15px] font-medium"
                >
                  Dashboard
                </Link>
                <Link
                  href="/support"
                  onClick={() => setOpen(false)}
                  className="hover:bg-muted block rounded-xl px-3 py-3 text-[15px] font-medium"
                >
                  Support
                </Link>
              </div>
            </nav>
          </SheetContent>
        </Sheet>

        <BrandLogo href="/" size="md" showWordmark={false} priority />

        <nav className="ml-1 hidden items-center gap-0.5 lg:flex">
          <CatalogMegaMenu />
          {nav.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "rounded-xl px-3.5 py-2.5 text-[15px] font-medium transition-colors",
                pathname.startsWith(item.href)
                  ? "text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="ml-auto flex items-center gap-1.5 pl-4 sm:gap-2 sm:pl-6 lg:pr-1">
          <HeaderSearch />
          <ThemeToggle />
          <Button variant="ghost" size="icon" className="relative size-11" asChild>
            <Link href="/wishlist" aria-label="Wishlist">
              <Heart className="size-5" />
              {wishlistCount > 0 && (
                <span className="bg-gold text-gold-foreground absolute top-1 right-1 flex size-5 items-center justify-center rounded-full text-[10px] font-bold">
                  {wishlistCount}
                </span>
              )}
            </Link>
          </Button>
          <Button variant="ghost" size="icon" className="relative size-11" asChild>
            <Link href="/cart" aria-label="Cart">
              <ShoppingBag className="size-5" />
              {cartCount > 0 && (
                <span className="bg-primary text-primary-foreground absolute top-1 right-1 flex size-5 items-center justify-center rounded-full text-[10px] font-bold">
                  {cartCount}
                </span>
              )}
            </Link>
          </Button>
          <Button variant="ghost" size="icon" className="size-11" asChild>
            <Link href="/dashboard" aria-label="Account">
              <User className="size-5" />
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
