"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Bookmark, Highlighter, StickyNote } from "lucide-react";
import { BookCover } from "@/components/books/book-cover";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { getBookById, libraryBooks as mockLibrary } from "@/data/mock";
import type { LibraryBook } from "@/types";
import { useAuth } from "@/components/providers/auth-provider";

export default function LibraryPage() {
  const { user } = useAuth();
  const [items, setItems] = useState<LibraryBook[]>(mockLibrary);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const res = await fetch("/api/me?type=library");
        if (res.ok) {
          const data = (await res.json()) as { items?: LibraryBook[] };
          if (!cancelled && data.items?.length) setItems(data.items);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [user]);

  const continueReading = [...items].sort(
    (a, b) => new Date(b.lastOpenedAt).getTime() - new Date(a.lastOpenedAt).getTime()
  );

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="font-heading text-3xl font-bold tracking-tight">Digital library</h1>
          <p className="text-muted-foreground mt-2 text-sm">
            Purchased eBooks, progress, bookmarks, notes, and highlights.
          </p>
        </div>
        <Button variant="outline" asChild>
          <Link href="/books">Find more eBooks</Link>
        </Button>
      </div>

      {loading ? (
        <p className="text-muted-foreground mt-10 text-sm">Loading library…</p>
      ) : (
        <>
          <section className="mt-10">
            <h2 className="font-heading text-xl font-semibold">Continue reading</h2>
            <div className="mt-5 grid gap-4 md:grid-cols-2">
              {continueReading.map((item) => {
                const book = getBookById(item.bookId);
                if (!book) return null;
                return (
                  <div
                    key={item.bookId}
                    className="flex gap-4 rounded-3xl border border-border/70 bg-card p-5 shadow-soft"
                  >
                    <BookCover book={book} size="sm" className="w-20" />
                    <div className="min-w-0 flex-1">
                      <p className="font-heading font-semibold">{book.title}</p>
                      <p className="text-muted-foreground text-sm">{book.authorName}</p>
                      <Progress value={item.progress} className="mt-4 h-2" />
                      <div className="text-muted-foreground mt-3 flex flex-wrap gap-4 text-xs">
                        <span className="inline-flex items-center gap-1">
                          <Bookmark className="size-3.5" />
                          {item.bookmarks} bookmarks
                        </span>
                        <span className="inline-flex items-center gap-1">
                          <Highlighter className="size-3.5" />
                          {item.highlights} highlights
                        </span>
                        <span className="inline-flex items-center gap-1">
                          <StickyNote className="size-3.5" />
                          Notes ready
                        </span>
                      </div>
                      <Button className="mt-4" size="sm">
                        {item.progress === 100 ? "Read again" : "Resume"}
                      </Button>
                    </div>
                  </div>
                );
              })}
            </div>
          </section>

          <section className="mt-12">
            <h2 className="font-heading text-xl font-semibold">Recently opened</h2>
            <div className="mt-5 grid grid-cols-2 gap-5 sm:grid-cols-3 lg:grid-cols-4">
              {continueReading.map((item) => {
                const book = getBookById(item.bookId);
                if (!book) return null;
                return (
                  <div key={`recent-${item.bookId}`} className="group">
                    <BookCover
                      book={book}
                      size="md"
                      className="w-full transition group-hover:-translate-y-1"
                    />
                    <p className="mt-3 truncate text-sm font-semibold">{book.title}</p>
                    <p className="text-muted-foreground text-xs">
                      {item.progress}% · {item.format}
                    </p>
                  </div>
                );
              })}
            </div>
          </section>
        </>
      )}
    </div>
  );
}
