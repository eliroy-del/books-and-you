"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { ArrowRight, ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { BookCover } from "@/components/books/book-cover";
import { formatMoney } from "@/data/mock";
import { cn } from "@/lib/utils";
import type { Book } from "@/types";

const AUTO_MS = 5500;
const SLIDE_LIMIT = 8;

type HeroSlide = {
  id: string;
  eyebrow: string;
  title: string;
  description: string;
  primary: { href: string; label: string };
  secondary: { href: string; label: string };
  book: Book | null;
  overlay: string;
  accent: string;
  panel: string;
  glow: string;
};

const FALLBACK_SLIDES: HeroSlide[] = [
  {
    id: "textbooks",
    eyebrow: "Books & You",
    title: "School books & supplies for every classroom.",
    description:
      "Nursery through SHS textbooks, workbooks, and past questions trusted by Ghana parents and teachers.",
    primary: { href: "/books", label: "Shop Books" },
    secondary: { href: "/categories?dept=by-school-level", label: "Shop by Level" },
    book: null,
    overlay: "from-[#00101f]/85 via-[#001f3e]/60 to-[#061829]/40",
    accent: "text-gold",
    panel: "bg-[#00101f]/45",
    glow: "from-[#efc076]/25 via-[#3d5a80]/15 to-transparent",
  },
];

function pickHeroBooks(books: Book[]): Book[] {
  const withCover = books.filter((b) => Boolean(b.coverUrl));
  const featured = withCover.filter((b) => b.featured || b.newArrival || b.bestseller);
  const pool = featured.length >= 3 ? featured : withCover;
  return pool.slice(0, SLIDE_LIMIT);
}

function slidesFromBooks(books: Book[]): HeroSlide[] {
  return books.map((book, i) => {
    return {
      id: book.id || book.slug || `book-${i}`,
      eyebrow: book.newArrival ? "New Arrival" : book.bestseller ? "Best Seller" : "Featured",
      title: book.title,
      description:
        book.subtitle ||
        book.synopsis ||
        book.description ||
        `By ${book.authorName}. In stock at Books & You.`,
      primary: { href: `/book/${book.slug}`, label: "View book" },
      secondary: { href: "/books", label: "Shop all" },
      book,
      overlay: "from-[#00101f]/88 via-[#001f3e]/70 to-[#061829]/45",
      accent: "text-gold",
      panel: "bg-[#00101f]/50",
      glow: "from-[#efc076]/25 via-[#3d5a80]/15 to-transparent",
    };
  });
}

export function HeroSection() {
  const [books, setBooks] = useState<Book[]>([]);
  const [index, setIndex] = useState(0);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    let cancelled = false;
    void fetch("/api/catalog?resource=books&limit=48")
      .then((r) => r.json())
      .then((json) => {
        if (cancelled) return;
        setBooks(Array.isArray(json.books) ? json.books : []);
      })
      .catch(() => {
        if (!cancelled) setBooks([]);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const slides = useMemo(() => {
    const fromDb = slidesFromBooks(pickHeroBooks(books));
    return fromDb.length ? fromDb : FALLBACK_SLIDES;
  }, [books]);

  // Reset index when slide set changes length
  useEffect(() => {
    setIndex(0);
  }, [slides.length]);

  const slide = slides[index] ?? slides[0]!;

  useEffect(() => {
    setProgress(0);
    const started = Date.now();
    const tick = window.setInterval(() => {
      const elapsed = Date.now() - started;
      setProgress(Math.min(100, (elapsed / AUTO_MS) * 100));
    }, 50);
    const advance = window.setTimeout(() => {
      setIndex((current) => (current + 1) % slides.length);
    }, AUTO_MS);
    return () => {
      window.clearInterval(tick);
      window.clearTimeout(advance);
    };
  }, [index, slides.length]);

  function go(next: number) {
    setIndex((next + slides.length) % slides.length);
  }

  const price = slide.book?.formats[0]?.price;
  const coverSrc = slide.book?.coverUrl;

  return (
    <section className="relative min-h-[calc(100vh-7.5rem)] overflow-hidden">
      <AnimatePresence mode="sync">
        <motion.div
          key={slide.id + "-bg"}
          initial={{ opacity: 0, scale: 1.04 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 1.02 }}
          transition={{ duration: 0.9, ease: "easeOut" }}
          className="absolute inset-0"
        >
          {coverSrc ? (
            <>
              <Image
                src={coverSrc}
                alt=""
                fill
                priority={index === 0}
                sizes="100vw"
                className="object-cover object-center scale-110 blur-2xl opacity-50"
              />
              <div className="absolute inset-0 bg-[#00101f]/75" />
            </>
          ) : (
            <div className="absolute inset-0 bg-gradient-to-br from-[#00101f] via-[#001f3e] to-[#0d2136]" />
          )}
          <div className={cn("absolute inset-0 bg-gradient-to-r", slide.overlay)} />
          <div
            className={cn(
              "pointer-events-none absolute -top-20 right-0 h-[70%] w-[55%] bg-gradient-to-bl blur-3xl",
              slide.glow
            )}
          />
          <div className="pointer-events-none absolute inset-0 opacity-[0.12] editorial-grid" />
        </motion.div>
      </AnimatePresence>

      <div className="relative mx-auto grid min-h-[calc(100vh-5.5rem)] max-w-site items-center gap-8 px-4 py-10 sm:px-6 lg:grid-cols-12 lg:gap-6 lg:px-8 lg:py-14">
        <div className="lg:col-span-6 xl:col-span-5">
          <AnimatePresence mode="wait">
            <motion.div
              key={slide.id}
              initial={{ opacity: 0, y: 22 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -14 }}
              transition={{ duration: 0.45 }}
              className={cn(
                "rounded-2xl border border-white/15 p-5 text-white shadow-[0_20px_60px_rgba(0,0,0,0.28)] backdrop-blur-md sm:p-6",
                slide.panel
              )}
            >
              <p
                className={cn(
                  "font-heading mb-3 text-xs font-semibold tracking-[0.18em] uppercase",
                  slide.accent
                )}
              >
                {slide.eyebrow}
              </p>
              <h1 className="font-heading text-3xl leading-[1.05] font-bold tracking-tight text-balance sm:text-4xl lg:text-[2.75rem]">
                {slide.title}
              </h1>
              {slide.book ? (
                <p className="mt-2 text-sm text-white/75">
                  {slide.book.authorName}
                  {typeof price === "number" ? (
                    <>
                      {" · "}
                      <span className="text-gold font-semibold">{formatMoney(price)}</span>
                    </>
                  ) : null}
                </p>
              ) : null}
              <p className="mt-3 max-w-lg text-sm leading-relaxed text-white/85 sm:text-base line-clamp-3">
                {slide.description}
              </p>
              <div className="mt-6 flex flex-wrap gap-2.5">
                <Button
                  size="default"
                  className="h-10 rounded-lg bg-white px-5 text-sm text-slate-900 shadow-glow hover:bg-white/90"
                  asChild
                >
                  <Link href={slide.primary.href}>
                    {slide.primary.label}
                    <ArrowRight className="ml-1 size-3.5" />
                  </Link>
                </Button>
                <Button
                  size="default"
                  variant="outline"
                  className="h-10 rounded-lg border-white/35 bg-white/10 px-5 text-sm text-white backdrop-blur hover:bg-white/20 hover:text-white"
                  asChild
                >
                  <Link href={slide.secondary.href}>{slide.secondary.label}</Link>
                </Button>
              </div>
            </motion.div>
          </AnimatePresence>

          <div className="mt-8 flex items-center gap-3">
            <button
              type="button"
              aria-label="Previous slide"
              onClick={() => go(index - 1)}
              className="inline-flex size-10 items-center justify-center rounded-full border border-white/30 bg-black/25 text-white backdrop-blur transition hover:bg-black/40"
            >
              <ChevronLeft className="size-4" />
            </button>
            <div className="flex flex-1 items-center gap-2">
              {slides.map((item, i) => (
                <button
                  key={item.id}
                  type="button"
                  aria-label={`Go to slide ${i + 1}`}
                  aria-current={i === index}
                  onClick={() => setIndex(i)}
                  className="group relative h-1.5 flex-1 overflow-hidden rounded-full bg-white/25"
                >
                  <span
                    className={cn(
                      "absolute inset-y-0 left-0 rounded-full bg-white transition-all",
                      i === index
                        ? "opacity-100"
                        : "w-0 opacity-0 group-hover:w-full group-hover:opacity-40"
                    )}
                    style={i === index ? { width: `${progress}%` } : undefined}
                  />
                </button>
              ))}
            </div>
            <button
              type="button"
              aria-label="Next slide"
              onClick={() => go(index + 1)}
              className="inline-flex size-10 items-center justify-center rounded-full border border-white/30 bg-black/25 text-white backdrop-blur transition hover:bg-black/40"
            >
              <ChevronRight className="size-4" />
            </button>
          </div>
        </div>

        <div className="relative lg:col-span-6 xl:col-span-7">
          <AnimatePresence mode="wait">
            <motion.div
              key={slide.id + "-fg"}
              initial={{ opacity: 0, y: 24, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: -12, scale: 1.02 }}
              transition={{ duration: 0.55 }}
              className="relative mx-auto flex w-full max-w-[420px] justify-center lg:ml-auto lg:max-w-[480px]"
            >
              {slide.book ? (
                <Link href={`/book/${slide.book.slug}`} className="block w-full max-w-[320px] sm:max-w-[360px]">
                  <BookCover book={slide.book} size="xl" className="w-full shadow-[0_28px_60px_rgba(0,0,0,0.45)]" />
                </Link>
              ) : (
                <div className="aspect-[2/3] w-full max-w-[320px] rounded-lg bg-white/10" />
              )}
            </motion.div>
          </AnimatePresence>
        </div>
      </div>
    </section>
  );
}
