"use client";

import { useEffect, useMemo, useState } from "react";
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
import { formatMoney, getReviewsForBook } from "@/data/mock";
import { useCartStore, useRecentlyViewedStore, useWishlistStore } from "@/stores/commerce";
import type { Book, BookFormat } from "@/types";
import { cn } from "@/lib/utils";

export default function BookDetailClient({
  book,
  related,
}: {
  book: Book;
  related: Book[];
}) {
  const addItem = useCartStore((s) => s.addItem);
  const toggleRemote = useWishlistStore((s) => s.toggleRemote);
  const wished = useWishlistStore((s) => s.bookIds.includes(book.id));
  const addRecent = useRecentlyViewedStore((s) => s.add);

  const [format, setFormat] = useState<BookFormat | null>(book.formats[0]?.format ?? null);
  const [qty, setQty] = useState(1);

  useEffect(() => {
    addRecent(book.id);
  }, [book.id, addRecent]);

  const selected = useMemo(() => {
    return book.formats.find((f) => f.format === format) ?? book.formats[0];
  }, [book, format]);

  if (!selected) return null;

  const currentBook = book;
  const currentFormat = selected;
  const reviews = getReviewsForBook(currentBook.id);
  const stock = currentFormat.inStock;
  const releaseCountdown =
    currentBook.preorder && currentBook.releaseDate
      ? daysUntil(currentBook.releaseDate)
      : null;

  function addToCart(buyNow = false) {
    addItem(currentBook.id, currentFormat.format, qty);
    toast.success(buyNow ? "Added — continue to checkout" : "Added to cart", {
      description: `${currentBook.title} (${currentFormat.format})`,
    });
    if (buyNow) window.location.href = "/checkout";
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="grid gap-10 lg:grid-cols-12">
        <div className="lg:col-span-5">
          <div className="sticky top-24">
            <BookCover book={currentBook} size="xl" className="mx-auto w-full max-w-md" />
          </div>
        </div>

        <div className="lg:col-span-7">
          <div className="flex flex-wrap gap-2">
            {currentBook.bestseller && (
              <Badge className="bg-gold text-gold-foreground border-0">Bestseller</Badge>
            )}
            {currentBook.newArrival && <Badge>New arrival</Badge>}
            {currentBook.staffPick && <Badge variant="secondary">Staff pick</Badge>}
          </div>

          <h1 className="font-heading mt-4 text-3xl font-bold tracking-tight sm:text-4xl">
            {currentBook.title}
          </h1>
          <p className="mt-3 text-sm">
            by <span className="text-primary font-medium">{currentBook.authorName}</span>
            <span className="text-muted-foreground"> · {currentBook.publisherName}</span>
          </p>

          <p className="text-muted-foreground mt-6 leading-relaxed">{currentBook.description}</p>

          <div className="mt-8">
            <p className="mb-3 text-xs font-semibold tracking-wide uppercase">Format</p>
            <div className="flex flex-wrap gap-2">
              {currentBook.formats.map((f) => (
                <button
                  key={f.format}
                  type="button"
                  onClick={() => setFormat(f.format)}
                  className={cn(
                    "rounded-xl border px-4 py-3 text-left transition",
                    (format ?? currentBook.formats[0]?.format) === f.format
                      ? "border-primary bg-primary/5 shadow-glow"
                      : "border-border hover:border-primary/40"
                  )}
                >
                  <p className="text-sm font-medium capitalize">{f.format}</p>
                  <p className="font-heading text-sm font-semibold">{formatMoney(f.price)}</p>
                </button>
              ))}
            </div>
          </div>

          <div className="mt-6 flex flex-wrap items-center gap-4">
            <div className="flex items-center rounded-xl border border-border">
              <Button variant="ghost" size="icon" className="rounded-none" onClick={() => setQty((q) => Math.max(1, q - 1))}>−</Button>
              <span className="w-10 text-center text-sm font-medium">{qty}</span>
              <Button variant="ghost" size="icon" className="rounded-none" onClick={() => setQty((q) => q + 1)}>+</Button>
            </div>
            <p className="text-muted-foreground flex items-center gap-1.5 text-sm">
              <Truck className="size-4" />
              {stock > 0 ? `In stock · ${stock} available` : "Out of stock"}
              <LiveInventoryBadge bookId={currentBook.id} />
            </p>
          </div>

          <div className="mt-6 flex flex-wrap gap-3">
            <Button size="lg" className="h-12 rounded-xl shadow-glow" onClick={() => addToCart(true)}>Buy Now</Button>
            <Button size="lg" variant="outline" className="h-12 rounded-xl" onClick={() => addToCart(false)}>
              <ShoppingBag className="size-4" /> Add to Cart
            </Button>
            <Button
              size="lg"
              variant="ghost"
              className={cn("h-12 rounded-xl", wished && "text-destructive")}
              onClick={() => {
                void toggleRemote(currentBook.id);
                toast.success(wished ? "Removed from wishlist" : "Saved to wishlist");
              }}
            >
              <Heart className={cn("size-4", wished && "fill-current")} /> Wishlist
            </Button>
            <Button size="lg" variant="ghost" className="h-12 rounded-xl"><Gift className="size-4" /> Gift</Button>
            <Button
              size="lg"
              variant="ghost"
              className="h-12 rounded-xl"
              onClick={() => {
                navigator.clipboard?.writeText(window.location.href);
                toast.success("Link copied");
              }}
            >
              <Share2 className="size-4" /> Share
            </Button>
          </div>

          <Separator className="my-10" />

          <div className="grid gap-8 sm:grid-cols-2">
            <div>
              <h2 className="font-heading text-lg font-semibold">Synopsis</h2>
              <p className="text-muted-foreground mt-3 text-sm leading-relaxed">{currentBook.synopsis}</p>
            </div>
            <div>
              <h2 className="font-heading text-lg font-semibold">Details</h2>
              <dl className="mt-3 space-y-2 text-sm">
                {[
                  ["ISBN", currentBook.isbn],
                  ["Pages", String(currentBook.pages)],
                  ["Language", currentBook.language],
                  ["Publisher", currentBook.publisherName],
                ].map(([k, v]) => (
                  <div key={k} className="flex justify-between gap-4 border-b border-border/60 py-2">
                    <dt className="text-muted-foreground">{k}</dt>
                    <dd className="font-medium">{v}</dd>
                  </div>
                ))}
              </dl>
            </div>
          </div>

          <div className="mt-10">
            <h2 className="font-heading text-lg font-semibold">Reviews</h2>
            {reviews.length === 0 ? (
              <p className="text-muted-foreground mt-3 text-sm">No reviews yet for this title.</p>
            ) : (
              <div className="mt-4 space-y-4">
                {reviews.map((r) => (
                  <div key={r.id} className="rounded-2xl border border-border/70 bg-card p-5 shadow-soft">
                    <div className="flex items-center justify-between gap-3">
                      <p className="font-medium">{r.userName}</p>
                      <div className="flex items-center gap-0.5">
                        {Array.from({ length: r.rating }).map((_, i) => (
                          <Star key={i} className="fill-gold text-gold size-3.5" />
                        ))}
                      </div>
                    </div>
                    <p className="mt-2 text-sm font-semibold">{r.title}</p>
                    <p className="text-muted-foreground mt-1 text-sm">{r.body}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>

      {related.length > 0 && (
        <section className="mt-16">
          <h2 className="font-heading text-2xl font-bold">Related books</h2>
          <div className="mt-6 grid grid-cols-2 gap-5 md:grid-cols-4">
            {related.map((b, i) => (
              <BookCard key={b.id} book={b} index={i} />
            ))}
          </div>
        </section>
      )}
    </div>
  );
}

function daysUntil(date: string) {
  const diff = new Date(date).getTime() - Date.now();
  return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
}
