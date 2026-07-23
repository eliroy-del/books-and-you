"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import type { Author } from "@/types";

export default function AuthorsPage() {
  const [authors, setAuthors] = useState<Author[]>([]);
  const [source, setSource] = useState("");

  useEffect(() => {
    void fetch("/api/catalog?resource=authors&limit=50")
      .then((r) => r.json())
      .then((json) => {
        setAuthors(json.authors || []);
        setSource(json.source || "");
      });
  }, []);

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Authors</h1>
      <p className="text-muted-foreground mt-2 text-sm">
        Voices from Ghana and beyond
        {source ? <span className="text-primary"> · {source}</span> : null}
      </p>
      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {authors.map((a) => (
          <Link
            key={a.id}
            href={`/authors/${a.slug}`}
            className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft transition hover:border-primary/30"
          >
            <div
              className={`flex size-12 items-center justify-center rounded-2xl bg-gradient-to-br text-sm font-bold text-white ${a.avatarColor}`}
            >
              {a.name
                .split(" ")
                .map((p) => p[0])
                .slice(0, 2)
                .join("")}
            </div>
            <h2 className="font-heading mt-4 text-lg font-semibold">{a.name}</h2>
            <p className="text-muted-foreground mt-1 text-xs">{a.nationality}</p>
            <p className="text-muted-foreground mt-3 line-clamp-3 text-sm">{a.bio}</p>
            <p className="text-primary mt-3 text-xs font-medium">{a.bookCount} books</p>
          </Link>
        ))}
      </div>
    </div>
  );
}
