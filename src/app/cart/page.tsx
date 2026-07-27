"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { Minus, Plus, Trash2 } from "lucide-react";
import { BookCover } from "@/components/books/book-cover";
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { formatMoney, siteConfig } from "@/data/mock";
import { useCartStore } from "@/stores/commerce";
import type { Book } from "@/types";

export default function CartPage() {
  const items = useCartStore((s) => s.items);
  const updateQuantity = useCartStore((s) => s.updateQuantity);
  const removeItem = useCartStore((s) => s.removeItem);
  const [books, setBooks] = useState<Book[]>([]);

  useEffect(() => {
    void fetch("/api/catalog?resource=books&limit=100")
      .then((r) => r.json())
      .then((json) => setBooks(json.books || []));
  }, []);

  const byId = useMemo(() => new Map(books.map((b) => [b.id, b])), [books]);

  const lines = items
    .map((item) => {
      const book = byId.get(item.bookId);
      const format = book?.formats.find((f) => f.format === item.format);
      if (!book || !format) return null;
      return { item, book, format, lineTotal: format.price * item.quantity };
    })
    .filter(Boolean) as {
    item: (typeof items)[number];
    book: Book;
    format: { format: string; price: number };
    lineTotal: number;
  }[];

  const subtotal = lines.reduce((s, l) => s + l.lineTotal, 0);
  const shipping = subtotal >= siteConfig.freeDeliveryThreshold || subtotal === 0 ? 0 : 25;
  const total = subtotal + shipping;

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Your cart</h1>
      <p className="text-muted-foreground mt-2 text-sm">
        Free nationwide delivery above {formatMoney(siteConfig.freeDeliveryThreshold)}.
      </p>

      {items.length > 0 && lines.length === 0 ? (
        <div className="mt-12 rounded-3xl border border-dashed border-border p-12 text-center">
          <p className="font-heading text-xl font-semibold">Loading cart…</p>
        </div>
      ) : lines.length === 0 ? (
        <div className="mt-12 rounded-3xl border border-dashed border-border p-12 text-center">
          <p className="font-heading text-xl font-semibold">Your cart is empty</p>
          <p className="text-muted-foreground mt-2 text-sm">Discover something wonderful to read.</p>
          <Button className="mt-6" asChild>
            <Link href="/books">Browse books</Link>
          </Button>
        </div>
      ) : (
        <div className="mt-10 grid gap-10 lg:grid-cols-12">
          <div className="space-y-4 lg:col-span-8">
            {lines.map(({ item, book, format, lineTotal }) => (
              <div
                key={`${item.bookId}-${item.format}`}
                className="flex gap-4 rounded-2xl border border-border/70 bg-card p-4 shadow-soft sm:p-5"
              >
                <Link href={`/book/${book.slug}`} className="shrink-0">
                  <BookCover book={book} size="sm" />
                </Link>
                <div className="min-w-0 flex-1">
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <Link
                        href={`/book/${book.slug}`}
                        className="font-heading font-semibold hover:text-primary"
                      >
                        {book.title}
                      </Link>
                      <p className="text-muted-foreground mt-1 text-sm capitalize">
                        {book.authorName} · {format.format}
                      </p>
                    </div>
                    <p className="font-heading shrink-0 font-semibold">{formatMoney(lineTotal)}</p>
                  </div>
                  <div className="mt-4 flex flex-wrap items-center gap-3">
                    <div className="flex items-center rounded-xl border border-border">
                      <Button
                        variant="ghost"
                        size="icon"
                        className="size-8"
                        onClick={() =>
                          updateQuantity(item.bookId, item.format, Math.max(1, item.quantity - 1))
                        }
                      >
                        <Minus className="size-3.5" />
                      </Button>
                      <span className="w-8 text-center text-sm">{item.quantity}</span>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="size-8"
                        onClick={() =>
                          updateQuantity(item.bookId, item.format, item.quantity + 1)
                        }
                      >
                        <Plus className="size-3.5" />
                      </Button>
                    </div>
                    <Button
                      variant="ghost"
                      size="sm"
                      className="text-destructive"
                      onClick={() => removeItem(item.bookId, item.format)}
                    >
                      <Trash2 className="size-3.5" />
                      Remove
                    </Button>
                  </div>
                </div>
              </div>
            ))}
          </div>

          <aside className="lg:col-span-4">
            <div className="sticky top-28 rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
              <h2 className="font-heading text-lg font-semibold">Order summary</h2>
              <div className="mt-4 space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Subtotal</span>
                  <span>{formatMoney(subtotal)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Shipping</span>
                  <span>{shipping === 0 ? "Free" : formatMoney(shipping)}</span>
                </div>
                <Separator className="my-3" />
                <div className="flex justify-between text-base font-semibold">
                  <span>Total</span>
                  <span>{formatMoney(total)}</span>
                </div>
              </div>
              <Button className="mt-6 w-full" asChild>
                <Link href="/checkout">Checkout</Link>
              </Button>
            </div>
          </aside>
        </div>
      )}
    </div>
  );
}
