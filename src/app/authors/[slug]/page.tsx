"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { notFound, useParams } from "next/navigation";
import { BookCard } from "@/components/books/book-card";
import type { Author, Book } from "@/types";

export default function AuthorDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const [author, setAuthor] = useState<Author | null | undefined>(undefined);
  const [books, setBooks] = useState<Book[]>([]);

  useEffect(() => {
    void fetch(`/api/catalog?resource=authors&slug=${encodeURIComponent(slug)}`)
      .then((r) => r.json())
      .then((json) => {
        setAuthor(json.author ?? null);
        setBooks(json.books || []);
      });
  }, [slug]);

  if (author === undefined) {
    return (
      <div className="mx-auto max-w-7xl px-4 py-16">
        <div className="bg-muted/50 h-40 animate-pulse rounded-3xl" />
      </div>
    );
  }

  if (!author) {
    notFound();
    return null;
  }

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <Link href="/authors" className="text-primary text-sm font-medium hover:underline">
        ← All authors
      </Link>
      <div className="mt-6 flex flex-wrap items-start gap-5">
        <div
          className={`flex size-20 items-center justify-center rounded-3xl bg-gradient-to-br text-xl font-bold text-white ${author.avatarColor}`}
        >
          {author.name
            .split(" ")
            .map((p) => p[0])
            .slice(0, 2)
            .join("")}
        </div>
        <div>
          <h1 className="font-heading text-3xl font-bold tracking-tight">{author.name}</h1>
          <p className="text-muted-foreground mt-1 text-sm">{author.nationality}</p>
          <p className="mt-4 max-w-2xl text-sm leading-relaxed">{author.bio}</p>
        </div>
      </div>
      <h2 className="font-heading mt-10 text-xl font-semibold">Books</h2>
      <div className="mt-6 grid grid-cols-2 gap-5 md:grid-cols-3 xl:grid-cols-4">
        {books.map((book, i) => (
          <BookCard key={book.id} book={book} index={i} />
        ))}
      </div>
    </div>
  );
}
