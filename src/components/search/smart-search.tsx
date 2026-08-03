"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Search, TrendingUp } from "lucide-react";
import { Input } from "@/components/ui/input";
import { trendingSearches } from "@/data/mock";
import { cn } from "@/lib/utils";
import type { Book } from "@/types";

interface SmartSearchProps {
  className?: string;
  large?: boolean;
  autoFocus?: boolean;
}

export function SmartSearch({ className, large, autoFocus }: SmartSearchProps) {
  const router = useRouter();
  const [query, setQuery] = useState("");
  const [open, setOpen] = useState(false);
  const [results, setResults] = useState<Book[]>([]);

  useEffect(() => {
    let cancelled = false;
    const q = query.trim();
    const url = q
      ? `/api/catalog?resource=books&q=${encodeURIComponent(q)}&limit=6`
      : "/api/catalog?resource=books&limit=8";

    const handle = window.setTimeout(() => {
      void fetch(url)
        .then((r) => r.json())
        .then((json) => {
          if (cancelled) return;
          const books = (json.books || []) as Book[];
          if (q) {
            setResults(books.slice(0, 6));
            return;
          }
          const featured = books
            .filter((b) => b.featured || b.bestseller)
            .slice(0, 5);
          setResults(featured.length ? featured : books.slice(0, 5));
        })
        .catch(() => {
          if (!cancelled) setResults([]);
        });
    }, q ? 180 : 0);

    return () => {
      cancelled = true;
      window.clearTimeout(handle);
    };
  }, [query]);

  function submit(e?: React.FormEvent) {
    e?.preventDefault();
    const q = query.trim();
    setOpen(false);
    router.push(q ? `/books?q=${encodeURIComponent(q)}` : "/books");
  }

  return (
    <div className={cn("relative w-full", className)}>
      <form onSubmit={submit} className="relative">
        <Search
          className={cn(
            "text-muted-foreground pointer-events-none absolute top-1/2 left-4 -translate-y-1/2",
            large ? "size-5" : "size-4"
          )}
        />
        <Input
          value={query}
          onChange={(e) => {
            setQuery(e.target.value);
            setOpen(true);
          }}
          onFocus={() => setOpen(true)}
          onBlur={() => setTimeout(() => setOpen(false), 150)}
          autoFocus={autoFocus}
          placeholder="Search titles, authors, ISBN, genres…"
          className={cn(
            "border-border/80 bg-background/80 pr-4 shadow-soft backdrop-blur-md",
            large
              ? "h-14 rounded-2xl pl-12 text-base md:h-16 md:text-lg"
              : "h-11 rounded-xl pl-11"
          )}
          aria-label="Search books"
        />
      </form>

      {open && (
        <div className="glass-strong absolute z-50 mt-2 w-full overflow-hidden rounded-2xl p-2">
          {!query && (
            <div className="px-3 py-2">
              <p className="text-muted-foreground mb-2 flex items-center gap-1.5 text-xs font-medium tracking-wide uppercase">
                <TrendingUp className="size-3.5" />
                Trending searches
              </p>
              <div className="flex flex-wrap gap-2">
                {trendingSearches.map((term) => (
                  <button
                    key={term}
                    type="button"
                    className="bg-secondary text-secondary-foreground hover:bg-primary hover:text-primary-foreground rounded-full px-3 py-1 text-xs transition-colors"
                    onMouseDown={() => {
                      setQuery(term);
                      router.push(`/books?q=${encodeURIComponent(term)}`);
                    }}
                  >
                    {term}
                  </button>
                ))}
              </div>
            </div>
          )}

          <div className="mt-1">
            <p className="text-muted-foreground px-3 py-1.5 text-xs font-medium tracking-wide uppercase">
              {query ? "Results" : "Popular books"}
            </p>
            {results.length === 0 ? (
              <p className="text-muted-foreground px-3 py-4 text-sm">No books found.</p>
            ) : (
              results.map((book) => (
                <Link
                  key={book.id}
                  href={`/book/${book.slug}`}
                  className="hover:bg-muted flex items-start gap-3 rounded-xl px-3 py-2.5 transition-colors"
                  onMouseDown={(e) => e.preventDefault()}
                >
                  <div
                    className={cn(
                      "mt-0.5 size-10 shrink-0 rounded-md bg-gradient-to-br",
                      book.coverGradient
                    )}
                  />
                  <div className="min-w-0">
                    <p className="truncate text-sm font-medium">{book.title}</p>
                    <p className="text-muted-foreground truncate text-xs">
                      {book.authorName}
                      {book.genres[0] ? ` · ${book.genres[0]}` : ""}
                    </p>
                  </div>
                </Link>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
