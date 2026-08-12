"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Heart, Menu, ShoppingBag, X } from "lucide-react";
import { useState } from "react";
import { BrandLogo } from "@/components/brand-logo";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { HeaderSearch } from "@/components/search/header-search";
import { useCartStore, useWishlistStore } from "@/stores/commerce";
import { cn } from "@/lib/utils";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import {
  CategoriesDropdown,
  MobileCategoriesNav,
} from "@/components/layout/categories-dropdown";

const simpleNav = [
  { href: "/blog", label: "Blog" },
  { href: "/contact", label: "Contact Us" },
];

export function SiteHeader() {
  const pathname = usePathname();
  const cartCount = useCartStore((s) => s.items.reduce((n, i) => n + i.quantity, 0));
  const wishlistCount = useWishlistStore((s) => s.bookIds.length);
  const [open, setOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-border/60 bg-background/75 backdrop-blur-xl">
      <div className="relative mx-auto flex h-14 w-full max-w-7xl items-center gap-2 px-4 sm:gap-3 sm:px-6 lg:h-16 lg:px-8">
        <BrandLogo href="/" size="sm" showWordmark={false} priority />

        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger
            render={
              <Button variant="ghost" size="icon" className="size-8 lg:hidden" aria-label="Open menu" />
            }
          >
            <Menu className="size-4" />
          </SheetTrigger>
          <SheetContent side="left" className="w-[280px] sm:w-[300px]">
            <SheetHeader>
              <SheetTitle className="font-heading text-left">
                <BrandLogo href="/" size="sm" showWordmark={false} className="rounded-lg" />
              </SheetTitle>
            </SheetHeader>
            <nav className="mt-3 flex flex-col gap-0.5 overflow-y-auto pb-6">
              <Link
                href="/"
                onClick={() => setOpen(false)}
                className={cn(
                  "rounded-lg px-2.5 py-2 text-sm font-medium transition-colors",
                  pathname === "/" ? "bg-primary/10 text-primary" : "hover:bg-muted"
                )}
              >
                Home
              </Link>
              <Link
                href="/books"
                onClick={() => setOpen(false)}
                className={cn(
                  "rounded-lg px-2.5 py-2 text-sm font-medium transition-colors",
                  pathname.startsWith("/books")
                    ? "bg-primary/10 text-primary"
                    : "hover:bg-muted"
                )}
              >
                Shop
              </Link>
              <MobileCategoriesNav onNavigate={() => setOpen(false)} />
              {simpleNav.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setOpen(false)}
                  className={cn(
                    "rounded-lg px-2.5 py-2 text-sm font-medium transition-colors",
                    pathname.startsWith(item.href)
                      ? "bg-primary/10 text-primary"
                      : "hover:bg-muted"
                  )}
                >
                  {item.label}
                </Link>
              ))}
              <div className="mt-2 border-t border-border/60 pt-2">
                <Link
                  href="/support"
                  onClick={() => setOpen(false)}
                  className="hover:bg-muted block rounded-lg px-2.5 py-2 text-sm font-medium"
                >
                  Support
                </Link>
              </div>
            </nav>
          </SheetContent>
        </Sheet>

        <nav className="absolute top-1/2 left-1/2 hidden -translate-x-1/2 -translate-y-1/2 items-center gap-0.5 lg:flex">
          <Link
            href="/"
            className={cn(
              "rounded-lg px-2.5 py-1.5 text-sm font-medium transition-colors",
              pathname === "/"
                ? "text-primary"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            Home
          </Link>
          <Link
            href="/books"
            className={cn(
              "rounded-lg px-2.5 py-1.5 text-sm font-medium transition-colors",
              pathname.startsWith("/books")
                ? "text-primary"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            Shop
          </Link>
          <CategoriesDropdown />
          {simpleNav.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                "rounded-lg px-2.5 py-1.5 text-sm font-medium transition-colors",
                pathname.startsWith(item.href)
                  ? "text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="ml-auto flex shrink-0 items-center justify-end gap-0.5">
          <HeaderSearch />
          <ThemeToggle />
          <Button variant="ghost" size="icon" className="relative size-8" asChild>
            <Link href="/wishlist" aria-label="Wishlist">
              <Heart className="size-4" />
              {wishlistCount > 0 && (
                <span className="bg-gold text-gold-foreground absolute top-0 right-0 flex size-3.5 items-center justify-center rounded-full text-[9px] font-bold">
                  {wishlistCount}
                </span>
              )}
            </Link>
          </Button>
          <Button variant="ghost" size="icon" className="relative size-8" asChild>
            <Link href="/cart" aria-label="Cart">
              <ShoppingBag className="size-4" />
              {cartCount > 0 && (
                <span className="bg-primary text-primary-foreground absolute top-0 right-0 flex size-3.5 items-center justify-center rounded-full text-[9px] font-bold">
                  {cartCount}
                </span>
              )}
            </Link>
          </Button>
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
