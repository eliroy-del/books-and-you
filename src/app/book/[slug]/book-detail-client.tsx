"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { notFound, useParams } from "next/navigation";
import {
  Gift,
  Heart,
  Share2,
  ShoppingBag,
  Star,
  Truck,
} from "lucide-react";
import { toast } from "sonner";
import { BookCover } from "@/components/books/book-cover";
import { BookCard } from "@/components/books/book-card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { LiveInventoryBadge } from "@/components/books/live-inventory-badge";
import { formatMoney } from "@/data/mock";
import { useCartStore, useRecentlyViewedStore, useWishlistStore } from "@/stores/commerce";
import type { Book } from "@/types";
import { cn } from "@/lib/utils";

export default function BookDetailClient() {
  const { slug } = useParams<{ slug: string }>();
  const [book, setBook] = useState<Book | null | undefined>(undefined);
  const [related, setRelated] = useState<Book[]>([]);
  const addItem = useCartStore((s) => s.addItem);
  const toggleRemote = useWishlistStore((s) => s.toggleRemote);
  const wished = useWishlistStore((s) => (book ? s.bookIds.includes(book.id) : false));
  const addRecent = useRecentlyViewedStore((s) => s.add);

  const [qty, setQty] = useState(1);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const res = await fetch(`/api/catalog?resource=books&slug=${encodeURIComponent(slug)}`);
      const json = await res.json();
      if (cancelled) return;
      setBook(json.book ?? null);

      if (json.book) {
        const relatedRes = await fetch("/api/catalog?resource=books&limit=8");
        const relatedJson = await relatedRes.json();
        const others = ((relatedJson.books || []) as Book[])
          .filter((b) => b.id !== json.book.id)
          .slice(0, 4);
        setRelated(others);
      }
    }
    void load();
    return () => {
      cancelled = true;
    };
  }, [slug]);

  useEffect(() => {
    if (book) addRecent(book.id);
  }, [book, addRecent]);

  const selected = useMemo(() => {
    if (!book?.formats.length) return null;
    return book.formats.find((f) => f.inStock > 0) ?? book.formats[0] ?? null;
  }, [book]);

  if (book === undefined) {
    return (
      <div className="mx-auto max-w-7xl px-4 py-16">
        <div className="bg-muted/50 h-96 animate-pulse rounded-3xl" />
      </div>
    );
  }

  if (!book || !selected) {
    notFound();
    return null;
  }

  const stock = selected.inStock;
  const releaseCountdown =
    book.preorder && book.releaseDate ? daysUntil(book.releaseDate) : null;

  function addToCart(buyNow = false) {
    addItem(book!.id, selected!.format, qty);
    toast.success(buyNow ? "Added — continue to checkout" : "Added to cart", {
      description: book!.title,
    });
    if (buyNow) window.location.href = "/checkout";
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="grid gap-10 lg:grid-cols-12">
        <div className="lg:col-span-5">
          <div className="sticky top-28">
            <BookCover book={book} size="xl" className="mx-auto w-full max-w-md" />
          </div>
        </div>

        <div className="lg:col-span-7">
          <div className="flex flex-wrap gap-2">
            {book.bestseller ? <Badge>Bestseller</Badge> : null}
            {book.newArrival ? <Badge variant="secondary">New</Badge> : null}
            {book.staffPick ? <Badge variant="outline">Staff pick</Badge> : null}
            {book.preorder ? <Badge variant="secondary">Preorder</Badge> : null}
          </div>

          <h1 className="font-heading mt-4 text-3xl font-bold tracking-tight sm:text-4xl">
            {book.title}
          </h1>
          {book.subtitle ? (
            <p className="text-muted-foreground mt-2 text-lg">{book.subtitle}</p>
          ) : null}
          <p className="mt-3 text-sm">
            by{" "}
            <Link
              href={book.authorSlug ? `/authors/${book.authorSlug}` : "/authors"}
              className="text-primary font-medium hover:underline"
            >
              {book.authorName}
            </Link>
            <span className="text-muted-foreground"> · {book.publisherName}</span>
          </p>

          <div className="mt-4 flex items-center gap-2 text-sm">
            <Star className="size-4 fill-amber-400 text-amber-400" />
            <span className="font-medium">{book.rating.toFixed(1)}</span>
            <span className="text-muted-foreground">({book.reviewCount} reviews)</span>
            <LiveInventoryBadge bookId={book.id} />
          </div>

          <Separator className="my-6" />

          <p className="font-heading text-3xl font-bold">{formatMoney(selected.price)}</p>
          <p className={cn("mt-1 text-sm", stock > 0 ? "text-teal-700" : "text-destructive")}>
            {stock > 0 ? `${stock} in stock` : "Out of stock"}
            {releaseCountdown != null ? ` · Ships in ${releaseCountdown} days` : null}
          </p>

          <div className="mt-6 flex flex-wrap items-center gap-3">
            <div className="flex items-center rounded-xl border border-border">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setQty((n) => Math.max(1, n - 1))}
              >
                −
              </Button>
              <span className="w-8 text-center text-sm font-medium">{qty}</span>
              <Button variant="ghost" size="sm" onClick={() => setQty((n) => n + 1)}>
                +
              </Button>
            </div>
            <Button onClick={() => addToCart(false)} disabled={stock <= 0}>
              <ShoppingBag className="size-4" />
              Add to cart
            </Button>
            <Button variant="secondary" onClick={() => addToCart(true)} disabled={stock <= 0}>
              Buy now
            </Button>
            <Button
              variant="outline"
              size="icon"
              onClick={() => void toggleRemote(book.id)}
              aria-label="Wishlist"
            >
              <Heart className={cn("size-4", wished && "fill-rose-500 text-rose-500")} />
            </Button>
            <Button
              variant="outline"
              size="icon"
              onClick={() => {
                void navigator.clipboard.writeText(window.location.href);
                toast.success("Link copied");
              }}
            >
              <Share2 className="size-4" />
            </Button>
          </div>

          <div className="text-muted-foreground mt-6 grid gap-3 text-sm sm:grid-cols-3">
            <p className="flex items-center gap-2">
              <Truck className="text-primary size-4" /> Fast delivery
            </p>
            <p className="flex items-center gap-2">
              <Gift className="text-primary size-4" /> Gift wrap available
            </p>
            <p className="flex items-center gap-2">
              <Star className="text-primary size-4" /> Verified reviews
            </p>
          </div>

          <Separator className="my-8" />

          <h2 className="font-heading text-xl font-semibold">About this book</h2>
          <p className="text-muted-foreground mt-3 text-sm leading-relaxed whitespace-pre-line">
            {book.description || book.synopsis}
          </p>
        </div>
      </div>

      {related.length > 0 ? (
        <section className="mt-16">
          <h2 className="font-heading text-2xl font-bold">You may also like</h2>
          <div className="mt-6 grid grid-cols-2 gap-5 md:grid-cols-4">
            {related.map((b, i) => (
              <BookCard key={b.id} book={b} index={i} />
            ))}
          </div>
        </section>
      ) : null}
    </div>
  );
}

function daysUntil(date: string) {
  const diff = new Date(date).getTime() - Date.now();
  return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
}
