"use client";

import Image from "next/image";
import { useState } from "react";
import { cn } from "@/lib/utils";
import { BookCover } from "@/components/books/book-cover";
import type { Book } from "@/types";

type GalleryImage = { url: string; alt?: string };

type Props = {
  book: Book;
  className?: string;
};

function resolveImages(book: Book): GalleryImage[] {
  if (book.images?.length) return book.images;
  if (book.coverUrl) return [{ url: book.coverUrl, alt: `${book.title} cover` }];
  return [];
}

export function BookImageGallery({ book, className }: Props) {
  const images = resolveImages(book);
  const [active, setActive] = useState(0);

  if (images.length === 0) {
    return (
      <BookCover
        book={book}
        size="xl"
        className={cn("mx-auto w-full max-w-sm rounded-md shadow-md lg:mx-0", className)}
      />
    );
  }

  const current = images[Math.min(active, images.length - 1)]!;

  function select(index: number) {
    setActive(index);
  }

  function cycle() {
    if (images.length < 2) return;
    setActive((i) => (i + 1) % images.length);
  }

  return (
    <div className={cn("mx-auto w-full max-w-sm lg:mx-0", className)}>
      <button
        type="button"
        onClick={cycle}
        className="group relative aspect-[2/3] w-full overflow-hidden rounded-md bg-muted shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
        aria-label={
          images.length > 1
            ? `View next image (${active + 1} of ${images.length})`
            : current.alt || `${book.title} cover`
        }
      >
        <Image
          src={current.url}
          alt={current.alt || `${book.title} — view ${active + 1}`}
          fill
          sizes="(max-width: 768px) 90vw, 420px"
          className="object-contain object-center transition duration-300 group-hover:scale-[1.02]"
          priority
        />
        {images.length > 1 ? (
          <span className="pointer-events-none absolute right-3 bottom-3 rounded-full bg-black/55 px-2.5 py-1 text-[11px] font-medium tracking-wide text-white">
            {active + 1} / {images.length} · tap for next
          </span>
        ) : null}
      </button>

      {images.length > 1 ? (
        <div
          className="mt-3 flex flex-wrap gap-2"
          role="listbox"
          aria-label="Product image variations"
        >
          {images.map((img, index) => {
            const selected = index === active;
            return (
              <button
                key={`${img.url}-${index}`}
                type="button"
                role="option"
                aria-selected={selected}
                onClick={() => select(index)}
                className={cn(
                  "relative h-16 w-14 overflow-hidden rounded-md border bg-muted transition",
                  selected
                    ? "border-primary ring-2 ring-primary/30"
                    : "border-border/70 hover:border-foreground/40"
                )}
              >
                <Image
                  src={img.url}
                  alt={img.alt || `${book.title} thumbnail ${index + 1}`}
                  fill
                  sizes="56px"
                  className="object-cover object-center"
                />
              </button>
            );
          })}
        </div>
      ) : null}
    </div>
  );
}
