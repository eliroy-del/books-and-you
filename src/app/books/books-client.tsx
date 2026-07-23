"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { BookCard } from "@/components/books/book-card";
import { SmartSearch } from "@/components/search/smart-search";
import { Button } from "@/components/ui/button";
import type { Book, Category, Collection } from "@/types";
import { cn } from "@/lib/utils";

export default function BooksClient() {
  const params = useSearchParams();
  const q = params.get("q") ?? "";
  const collectionSlug = params.get("collection") ?? "";
  const categorySlug = params.get("category") ?? "";
  const [sort, setSort] = useState<"featured" | "rating" | "price-asc" | "price-desc">(
    "featured"
  );
  const [books, setBooks] = useState<Book[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [collections, setCollections] = useState<Collection[]>([]);
  const [source, setSource] = useState<string>("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      setLoading(true);
      const qs = new URLSearchParams({ resource: "books", limit: "100" });
      if (q) qs.set("q", q);
      if (categorySlug) qs.set("category", categorySlug);
      if (collectionSlug) qs.set("collection", collectionSlug);

      const [booksRes, catsRes, colsRes] = await Promise.all([
        fetch(`/api/catalog?${qs}`).then((r) => r.json()),
        fetch("/api/catalog?resource=categories").then((r) => r.json()),
        fetch("/api/catalog?resource=collections").then((r) => r.json()),
      ]);

      if (cancelled) return;
      setBooks(booksRes.books || []);
      setCategories(catsRes.categories || []);
      setCollections(colsRes.collections || []);
      setSource(booksRes.source || "");
      setLoading(false);
    }
    void load();
    return () => {
      cancelled = true;
    };
  }, [q, categorySlug, collectionSlug]);

  const filtered = useMemo(() => {
    return [...books].sort((a, b) => {
      if (sort === "rating") return b.rating - a.rating;
      if (sort === "price-asc") {
        const ap = Math.min(...a.formats.map((f) => f.price), Infinity);
        const bp = Math.min(...b.formats.map((f) => f.price), Infinity);
        return ap - bp;
      }
      if (sort === "price-desc") {
        const ap = Math.min(...a.formats.map((f) => f.price), Infinity);
        const bp = Math.min(...b.formats.map((f) => f.price), Infinity);
        return bp - ap;
      }
      return Number(b.featured) - Number(a.featured) || b.reviewCount - a.reviewCount;
    });
  }, [books, sort]);

  const activeCollection = collectionSlug
    ? collections.find((c) => c.slug === collectionSlug)
    : null;

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="max-w-2xl">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">Catalog</p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          {activeCollection?.title ?? "All Books"}
        </h1>
        <p className="text-muted-foreground mt-3 text-sm sm:text-base">
          {activeCollection?.description ??
            "Browse the full shelf—fiction, non-fiction, academic, and more."}
          {source ? (
            <span className="text-primary ml-2 text-xs font-medium">· {source}</span>
          ) : null}
        </p>
      </div>

      <div className="mt-8 max-w-xl">
        <SmartSearch />
      </div>

      <div className="mt-8 flex flex-col gap-6 lg:flex-row">
        <aside className="w-full shrink-0 space-y-6 lg:w-56">
          <div>
            <p className="mb-2 text-xs font-semibold tracking-wide uppercase">Collections</p>
            <div className="flex flex-wrap gap-2 lg:flex-col">
              <FilterChip href="/books" active={!collectionSlug && !categorySlug}>
                All
              </FilterChip>
              {collections.map((c) => (
                <FilterChip
                  key={c.id}
                  href={`/books?collection=${c.slug}`}
                  active={collectionSlug === c.slug}
                >
                  {c.title}
                </FilterChip>
              ))}
            </div>
          </div>
          <div>
            <p className="mb-2 text-xs font-semibold tracking-wide uppercase">Categories</p>
            <div className="flex flex-wrap gap-2 lg:flex-col">
              {categories.map((c) => (
                <FilterChip
                  key={c.id}
                  href={`/books?category=${c.slug}`}
                  active={categorySlug === c.slug}
                >
                  {c.name}
                </FilterChip>
              ))}
            </div>
          </div>
        </aside>

        <div className="min-w-0 flex-1">
          <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
            <p className="text-muted-foreground text-sm">
              {loading ? "Loading…" : `${filtered.length} book${filtered.length === 1 ? "" : "s"}`}
              {q ? ` for “${q}”` : ""}
            </p>
            <div className="flex flex-wrap gap-2">
              {(
                [
                  ["featured", "Featured"],
                  ["rating", "Top rated"],
                  ["price-asc", "Price ↑"],
                  ["price-desc", "Price ↓"],
                ] as const
              ).map(([value, label]) => (
                <Button
                  key={value}
                  size="sm"
                  variant={sort === value ? "default" : "outline"}
                  className="rounded-full"
                  onClick={() => setSort(value)}
                >
                  {label}
                </Button>
              ))}
            </div>
          </div>

          {loading ? (
            <div className="grid grid-cols-2 gap-5 md:grid-cols-3 xl:grid-cols-4">
              {Array.from({ length: 8 }).map((_, i) => (
                <div key={i} className="bg-muted/50 aspect-[2/3] animate-pulse rounded-lg" />
              ))}
            </div>
          ) : filtered.length === 0 ? (
            <div className="rounded-2xl border border-dashed border-border p-12 text-center">
              <p className="font-heading text-lg font-semibold">No books found</p>
              <p className="text-muted-foreground mt-2 text-sm">Try another search or collection.</p>
            </div>
          ) : (
            <div className="grid grid-cols-2 gap-5 md:grid-cols-3 xl:grid-cols-4">
              {filtered.map((book, i) => (
                <BookCard key={book.id} book={book} index={i} />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

function FilterChip({
  href,
  active,
  children,
}: {
  href: string;
  active?: boolean;
  children: React.ReactNode;
}) {
  return (
    <a
      href={href}
      className={cn(
        "inline-flex rounded-full px-3 py-1.5 text-xs font-medium transition-colors lg:w-full lg:justify-start",
        active
          ? "bg-primary text-primary-foreground"
          : "bg-secondary text-secondary-foreground hover:bg-primary/10 hover:text-primary"
      )}
    >
      {children}
    </a>
  );
}
