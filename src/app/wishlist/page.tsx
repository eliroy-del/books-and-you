"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { BookCard } from "@/components/books/book-card";
import { Button } from "@/components/ui/button";
import { useWishlistStore } from "@/stores/commerce";
import type { Book } from "@/types";

export default function WishlistPage() {
  const bookIds = useWishlistStore((s) => s.bookIds);
  const [catalog, setCatalog] = useState<Book[]>([]);

  useEffect(() => {
    void fetch("/api/catalog?resource=books&limit=100")
      .then((r) => r.json())
      .then((json) => setCatalog(json.books || []));
  }, []);

  const byId = useMemo(() => new Map(catalog.map((b) => [b.id, b])), [catalog]);
  const books = bookIds.map((id) => byId.get(id)).filter(Boolean) as Book[];

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="font-heading text-3xl font-bold tracking-tight">Wishlist</h1>
          <p className="text-muted-foreground mt-2 text-sm">
            Synced across devices when you are signed in.
          </p>
        </div>
        <Button variant="outline" asChild>
          <Link href="/books">Add more books</Link>
        </Button>
      </div>

      {bookIds.length > 0 && books.length === 0 ? (
        <div className="mt-12 rounded-3xl border border-dashed border-border p-12 text-center">
          <p className="font-heading text-xl font-semibold">Loading wishlist…</p>
        </div>
      ) : books.length === 0 ? (
        <div className="mt-12 rounded-3xl border border-dashed border-border p-12 text-center">
          <p className="font-heading text-xl font-semibold">Nothing saved yet</p>
          <p className="text-muted-foreground mt-2 text-sm">
            Tap the heart on any book to build your wishlist.
          </p>
        </div>
      ) : (
        <div className="mt-10 grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4">
          {books.map((book, i) => (
            <BookCard key={book.id} book={book} index={i} />
          ))}
        </div>
      )}
    </div>
  );
}
