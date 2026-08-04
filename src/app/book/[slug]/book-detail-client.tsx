"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { notFound, useParams, useRouter } from "next/navigation";
import { ArrowLeft, Heart, ShoppingBag, Star } from "lucide-react";
import { toast } from "sonner";
import { BookCover } from "@/components/books/book-cover";
import { BookCard } from "@/components/books/book-card";
import { Button } from "@/components/ui/button";
import { useCartStore, useRecentlyViewedStore, useWishlistStore } from "@/stores/commerce";
import type { Book } from "@/types";
import { cn } from "@/lib/utils";

export default function BookDetailClient() {
  const router = useRouter();
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
      <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6 lg:px-8">
        <div className="bg-muted/40 h-96 animate-pulse rounded-lg" />
      </div>
    );
  }

  if (!book || !selected) {
    notFound();
    return null;
  }

  const stock = selected.inStock;
  const categoryLabel = book.genres[0] || "Books";
  const categorySlug = categoryLabel.toLowerCase().replace(/\s+/g, "-");
  const description = book.description || book.synopsis;
  const priceLabel = `GHS ${selected.price.toLocaleString("en-GH", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;

  function addToCart(buyNow = false) {
    addItem(book!.id, selected!.format, qty);
    toast.success(buyNow ? "Added. Continue to checkout" : "Added to cart", {
      description: book!.title,
    });
    if (buyNow) window.location.href = "/checkout";
  }

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8 lg:py-12">
      <div className="mb-8 flex flex-wrap items-center justify-between gap-3 text-sm">
        <button
          type="button"
          onClick={() => router.back()}
          className="text-foreground/80 hover:text-foreground inline-flex items-center gap-1.5 transition"
        >
          <ArrowLeft className="size-4" />
          Back
        </button>
        <nav aria-label="Breadcrumb" className="text-muted-foreground flex flex-wrap items-center gap-1.5">
          <Link href="/" className="hover:text-foreground transition">
            Home
          </Link>
          <span aria-hidden>/</span>
          <Link href="/books" className="hover:text-foreground transition">
            Shop
          </Link>
          <span aria-hidden>/</span>
          <Link
            href={`/books?category=${encodeURIComponent(categorySlug)}`}
            className="hover:text-foreground capitalize transition"
          >
            {categoryLabel}
          </Link>
        </nav>
      </div>

      <div className="grid items-start gap-10 lg:grid-cols-12 lg:gap-14">
        <div className="lg:col-span-5">
          <BookCover
            book={book}
            size="xl"
            className="mx-auto w-full max-w-sm rounded-md shadow-md lg:mx-0"
          />
        </div>

        <div className="lg:col-span-7">
          <h1 className="font-heading text-3xl font-bold tracking-tight text-foreground sm:text-4xl">
            {book.title}
          </h1>

          <div className="mt-4 flex flex-wrap items-center gap-x-4 gap-y-2 text-sm">
            <div className="flex items-center gap-1" aria-label={`${book.rating.toFixed(1)} out of 5`}>
              {Array.from({ length: 5 }).map((_, i) => {
                const filled = i < Math.round(book.rating);
                return (
                  <Star
                    key={i}
                    className={cn(
                      "size-4",
                      filled
                        ? "fill-amber-400 text-amber-400"
                        : "fill-none text-muted-foreground/40"
                    )}
                  />
                );
              })}
              <span className="text-muted-foreground ml-1">({book.reviewCount})</span>
            </div>
            <p className="text-muted-foreground">
              By (author){" "}
              <Link
                href={book.authorSlug ? `/authors/${book.authorSlug}` : "/authors"}
                className="text-foreground hover:text-primary transition"
              >
                {book.authorName}
              </Link>
            </p>
          </div>

          <p className="mt-5 text-xl font-semibold tracking-tight">{priceLabel}</p>

          {description ? (
            <div className="text-foreground/85 mt-6 space-y-4 text-[15px] leading-relaxed whitespace-pre-line">
              {description}
            </div>
          ) : null}

          <div className="mt-8 flex flex-wrap items-center gap-3">
            <div className="flex items-center rounded-md border border-border">
              <Button
                variant="ghost"
                size="sm"
                className="rounded-none"
                onClick={() => setQty((n) => Math.max(1, n - 1))}
              >
                −
              </Button>
              <span className="w-10 text-center text-sm font-medium">{qty}</span>
              <Button
                variant="ghost"
                size="sm"
                className="rounded-none"
                onClick={() => setQty((n) => n + 1)}
              >
                +
              </Button>
            </div>
            <Button
              className="min-w-[140px] rounded-md"
              onClick={() => addToCart(false)}
              disabled={stock <= 0}
            >
              <ShoppingBag className="size-4" />
              Add to cart
            </Button>
            <Button
              variant="secondary"
              className="rounded-md"
              onClick={() => addToCart(true)}
              disabled={stock <= 0}
            >
              Buy now
            </Button>
            <Button
              variant="outline"
              size="icon"
              className="rounded-md"
              onClick={() => void toggleRemote(book.id)}
              aria-label="Wishlist"
            >
              <Heart className={cn("size-4", wished && "fill-rose-500 text-rose-500")} />
            </Button>
          </div>

          {stock <= 0 ? (
            <p className="text-destructive mt-3 text-sm">Out of stock</p>
          ) : null}
        </div>
      </div>

      {related.length > 0 ? (
        <section className="mt-20 border-t border-border/70 pt-12">
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
