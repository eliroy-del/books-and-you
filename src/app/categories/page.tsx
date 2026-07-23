"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import type { Category } from "@/types";

export default function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [source, setSource] = useState("");

  useEffect(() => {
    void fetch("/api/catalog?resource=categories")
      .then((r) => r.json())
      .then((json) => {
        setCategories(json.categories || []);
        setSource(json.source || "");
      });
  }, []);

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Categories</h1>
      <p className="text-muted-foreground mt-2 text-sm">
        Explore the catalog by genre
        {source ? <span className="text-primary"> · {source}</span> : null}
      </p>
      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {categories.map((c) => (
          <Link
            key={c.id}
            href={`/books?category=${c.slug}`}
            className="group overflow-hidden rounded-3xl border border-border/70 bg-card shadow-soft transition hover:-translate-y-0.5"
          >
            <div className={`h-28 bg-gradient-to-br ${c.accent}`} />
            <div className="p-5">
              <h2 className="font-heading text-lg font-semibold group-hover:text-primary">
                {c.name}
              </h2>
              <p className="text-muted-foreground mt-1 line-clamp-2 text-sm">{c.description}</p>
              <p className="text-primary mt-3 text-xs font-medium">{c.bookCount} titles</p>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
