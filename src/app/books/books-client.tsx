"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { BookCard } from "@/components/books/book-card";
import { SmartSearch } from "@/components/search/smart-search";
import { Button } from "@/components/ui/button";
import {
  catalogBrowseHref,
  catalogNav,
  featuredCollectionDefs,
  findCatalogNode,
} from "@/data/catalog-nav";
import type { Book, Collection } from "@/types";
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

      const [booksRes, colsRes] = await Promise.all([
        fetch(`/api/catalog?${qs}`).then((r) => r.json()),
        fetch("/api/catalog?resource=collections").then((r) => r.json()),
      ]);

      if (cancelled) return;
      setBooks(booksRes.books || []);
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
    return [..books].sort((a, b) => {
      if (sort === "rating") return b.rating - a.rating;
      if (sort === "price-asc") {
        const ap = Math.min(..a.formats.map((f) => f.price), Infinity);
        const bp = Math.min(..b.formats.map((f) => f.price), Infinity);
        return ap - bp;
      }
      if (sort === "price-desc") {
        const ap = Math.min(..a.formats.map((f) => f.price), Infinity);
        const bp = Math.min(..b.formats.map((f) => f.price), Infinity);
        return bp - ap;
      }
      return Number(b.featured) - Number(a.featured) || b.reviewCount - a.reviewCount;
    });
  }, [books, sort]);

  const activeCollection = collectionSlug
    ? collections.find((c) => c.slug === collectionSlug) ??
      featuredCollectionDefs.find((c) => c.slug === collectionSlug)
    : null;
  const activeCategory = categorySlug ? findCatalogNode(categorySlug) : null;
  const sidebarChildren = activeCategory?.children?.length
    ? activeCategory.children
    : activeCategory
      ? []
      : catalogNav.find((d) => d.slug === "books")?.children ?? [];

  const title =
    (activeCollection && ("title" in activeCollection ? activeCollection.title : "")) ||
    activeCategory?.name ||
    "All Books";
  const description =
    (activeCollection &&
      ("description" in activeCollection ? activeCollection.description : "")) ||
    activeCategory?.description ||
    "Textbooks, stationery, and school essentials for every Ghana classroom.";

  const levels = catalogNav.find((d) => d.slug === "by-school-level")?.children ?? [];

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="max-w-2xl">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">Catalog</p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          {title}
        </h1>
        <p className="text-muted-foreground mt-3 text-sm sm:text-base">
          {description}
          {source ? (
            <span className="text-primary ml-2 text-xs font-medium">· {source}</span>
          ) : null}
        </p>
      </div>

      <div className="mt-8 max-w-xl">
        <SmartSearch />
      </div>

      <div className="mt-8 flex flex-col gap-6 lg:flex-row">
        <aside className="w-full shrink-0 space-y-6 lg:w-60">
          <div>
            <p className="mb-2 text-xs font-semibold tracking-wide uppercase">Departments</p>
            <div className="flex flex-wrap gap-2 lg:flex-col">
              <FilterChip href="/books" active={!collectionSlug && !categorySlug}>
                All
              </FilterChip>
              {catalogNav.map((d) => (
                <FilterChip
                  key={d.slug}
                  href={catalogBrowseHref(d.slug)}
                  active={categorySlug === d.slug}
                >
                  {d.name}
                </FilterChip>
              ))}
            </div>
          </div>

          <div>
            <p className="mb-2 text-xs font-semibold tracking-wide uppercase">
              Featured Collections
            </p>
            <div className="flex flex-wrap gap-2 lg:flex-col">
              {featuredCollectionDefs.map((c) => (
                <FilterChip
                  key={c.slug}
                  href={`/books?collection=${c.slug}`}
                  active={collectionSlug === c.slug}
                >
                  {c.title}
                </FilterChip>
              ))}
            </div>
          </div>

          <div>
            <p className="mb-2 text-xs font-semibold tracking-wide uppercase">School Level</p>
            <div className="flex flex-wrap gap-2 lg:flex-col">
              {levels.map((level) => (
                <FilterChip
                  key={level.slug}
                  href={catalogBrowseHref(level.slug)}
                  active={categorySlug === level.slug}
                >
                  {level.name}
                </FilterChip>
              ))}
            </div>
          </div>

          {sidebarChildren.length > 0 ? (
            <div>
              <p className="mb-2 text-xs font-semibold tracking-wide uppercase">
                {activeCategory ? activeCategory.name : "Book Sections"}
              </p>
              <div className="flex flex-wrap gap-2 lg:flex-col">
                {sidebarChildren.map((c) => (
                  <FilterChip
                    key={c.slug}
                    href={catalogBrowseHref(c.slug)}
                    active={categorySlug === c.slug}
                  >
                    {c.name}
                  </FilterChip>
                ))}
              </div>
            </div>
          ) : null}
        </aside>

        <div className="min-w-0 flex-1">
          <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
            <p className="text-muted-foreground text-sm">
              {loading ? "Loading…" : `${filtered.length} item${filtered.length === 1 ? "" : "s"}`}
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
              <p className="font-heading text-lg font-semibold">No items found</p>
              <p className="text-muted-foreground mt-2 text-sm">
                This shelf is ready. Products will appear as inventory is added. Try another
                category or collection.
              </p>
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
