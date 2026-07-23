"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ArrowRight, Gift, Headphones, Lock, Package, ShieldCheck, Sparkles } from "lucide-react";
import { motion } from "framer-motion";
import { BookCard } from "@/components/books/book-card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { currentUser, formatMoney, testimonials } from "@/data/mock";
import { useRecentlyViewedStore, useWishlistStore } from "@/stores/commerce";
import type { Book, Collection } from "@/types";

function SectionHeader({
  title,
  description,
  href,
  linkLabel = "View all",
}: {
  title: string;
  description?: string;
  href?: string;
  linkLabel?: string;
}) {
  return (
    <div className="mb-8 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
      <div>
        <h2 className="font-heading text-2xl font-bold tracking-tight sm:text-3xl">{title}</h2>
        {description && (
          <p className="text-muted-foreground mt-2 max-w-xl text-sm sm:text-base">{description}</p>
        )}
      </div>
      {href && (
        <Button variant="ghost" className="self-start text-primary" asChild>
          <Link href={href}>
            {linkLabel}
            <ArrowRight className="size-4" />
          </Link>
        </Button>
      )}
    </div>
  );
}

function useCatalogBooks() {
  const [books, setBooks] = useState<Book[]>([]);
  const [collections, setCollections] = useState<Collection[]>([]);

  useEffect(() => {
    void Promise.all([
      fetch("/api/catalog?resource=books&limit=100").then((r) => r.json()),
      fetch("/api/catalog?resource=collections").then((r) => r.json()),
    ]).then(([booksJson, colsJson]) => {
      setBooks(booksJson.books || []);
      setCollections(colsJson.collections || []);
    });
  }, []);

  return { books, collections };
}

export function FeaturedCollections() {
  const { books, collections } = useCatalogBooks();
  const byId = useMemo(() => new Map(books.map((b) => [b.id, b])), [books]);

  return (
    <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <SectionHeader
        title="Featured Collections"
        description="Editorial shelves curated for every kind of reader."
        href="/books"
      />
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {collections.slice(0, 8).map((col, i) => (
          <motion.div
            key={col.id}
            initial={{ opacity: 0, y: 12 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.04 }}
          >
            <Link
              href={`/books?collection=${col.slug}`}
              className="group block overflow-hidden rounded-2xl border border-border/70 bg-card p-5 shadow-soft transition hover:-translate-y-0.5 hover:shadow-elevated"
            >
              <div className="mb-4 flex -space-x-3">
                {col.bookIds.slice(0, 3).map((id) => {
                  const b = byId.get(id);
                  if (!b) return null;
                  return (
                    <div
                      key={id}
                      className={`size-12 rounded-lg border-2 border-card bg-gradient-to-br ${b.coverGradient}`}
                    />
                  );
                })}
              </div>
              <h3 className="font-heading font-semibold group-hover:text-primary">{col.title}</h3>
              <p className="text-muted-foreground mt-1 text-sm">{col.description}</p>
              <p className="text-muted-foreground mt-3 text-xs">{col.bookIds.length} titles</p>
            </Link>
          </motion.div>
        ))}
      </div>
    </section>
  );
}

export function SmartRecommendations() {
  const { books } = useCatalogBooks();
  const wishlistIds = useWishlistStore((s) => s.bookIds);
  const recentIds = useRecentlyViewedStore((s) => s.bookIds);

  const recommended = books
    .filter(
      (b) =>
        currentUser.favoriteGenres.some((g) => b.genres.includes(g)) ||
        wishlistIds.includes(b.id) ||
        recentIds.includes(b.id) ||
        b.staffPick
    )
    .filter((b, i, arr) => arr.findIndex((x) => x.id === b.id) === i)
    .slice(0, 8);

  const fallback = recommended.length ? recommended : books.filter((b) => b.featured).slice(0, 8);

  return (
    <section className="border-y border-border/50 bg-secondary/40 py-16">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <SectionHeader
          title="Smart Recommendations"
          description="Based on your genres, wishlist, and browsing history."
          href="/dashboard"
          linkLabel="Reading dashboard"
        />
        <div className="grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-4">
          {fallback.map((book, i) => (
            <BookCard key={book.id} book={book} index={i} />
          ))}
        </div>
      </div>
    </section>
  );
}

export function BestsellersShelf() {
  const { books } = useCatalogBooks();
  const bestsellers = books.filter((b) => b.bestseller).slice(0, 6);
  const shelf = bestsellers.length ? bestsellers : books.slice(0, 6);
  return (
    <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <SectionHeader
        title="Best Sellers"
        description="Trusted favorites flying off the shelf."
        href="/books?collection=best-sellers"
      />
      <div className="grid grid-cols-2 gap-5 md:grid-cols-3 lg:grid-cols-6">
        {shelf.map((book, i) => (
          <BookCard key={book.id} book={book} index={i} />
        ))}
      </div>
    </section>
  );
}

export function WhyBooksAndYou() {
  const items = [
    {
      icon: Package,
      title: "Premium service",
      body: "Careful packing, clear tracking, and delivery you can trust.",
    },
    {
      icon: Sparkles,
      title: "Fast delivery",
      body: "Same-day Accra options and nationwide shipping that stays on schedule.",
    },
    {
      icon: Lock,
      title: "Secure payments",
      body: "Paystack, Stripe, and Flutterwave—encrypted and reliable.",
    },
    {
      icon: ShieldCheck,
      title: "Verified publishers",
      body: "Authentic editions from trusted houses and independent authors.",
    },
    {
      icon: Headphones,
      title: "Excellent support",
      body: "Human help via chat, email, and WhatsApp when you need it.",
    },
    {
      icon: Gift,
      title: "Digital library",
      body: "Keep eBooks, notes, and reading progress in one elegant place.",
    },
  ];

  return (
    <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <SectionHeader
        title="Why Books & You"
        description="A bookstore engineered like a premium product."
      />
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {items.map((item, i) => (
          <motion.div
            key={item.title}
            initial={{ opacity: 0, y: 12 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: i * 0.05 }}
            className="rounded-2xl border border-border/70 bg-card p-6 shadow-soft"
          >
            <div className="bg-primary/10 text-primary mb-4 flex size-11 items-center justify-center rounded-xl">
              <item.icon className="size-5" />
            </div>
            <h3 className="font-heading text-lg font-semibold">{item.title}</h3>
            <p className="text-muted-foreground mt-2 text-sm leading-relaxed">{item.body}</p>
          </motion.div>
        ))}
      </div>
    </section>
  );
}

export function TestimonialsSection() {
  return (
    <section className="bg-[#0B1220] py-16 text-slate-100">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mb-10 max-w-2xl">
          <h2 className="font-heading text-2xl font-bold sm:text-3xl">Loved by readers</h2>
          <p className="mt-2 text-slate-400">
            Reader reviews, author stories, and university endorsements.
          </p>
        </div>
        <div className="grid gap-5 lg:grid-cols-3">
          {testimonials.map((t, i) => (
            <motion.blockquote
              key={t.id}
              initial={{ opacity: 0, y: 12 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.08 }}
              className="rounded-2xl border border-white/10 bg-white/5 p-6 backdrop-blur"
            >
              <p className="text-sm leading-relaxed text-slate-200">&ldquo;{t.quote}&rdquo;</p>
              <footer className="mt-6">
                <p className="font-heading font-semibold text-white">{t.name}</p>
                <p className="text-xs text-slate-400">{t.role}</p>
              </footer>
            </motion.blockquote>
          ))}
        </div>
      </div>
    </section>
  );
}

export function ReferralSection() {
  return (
    <section className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
      <div className="relative overflow-hidden rounded-[2rem] border border-primary/15 bg-gradient-to-br from-teal-700 via-teal-800 to-slate-900 p-8 text-white shadow-elevated sm:p-12">
        <div className="absolute inset-0 editorial-grid opacity-20" />
        <div className="relative grid gap-8 lg:grid-cols-2 lg:items-center">
          <div>
            <p className="text-teal-200 text-sm font-semibold tracking-widest uppercase">
              Referral program
            </p>
            <h2 className="font-heading mt-3 text-3xl font-bold tracking-tight sm:text-4xl">
              Invite friends. Earn store credits.
            </h2>
            <p className="mt-4 max-w-md text-teal-50/80">
              Share your code and unlock exclusive discounts when friends make their first
              purchase. Your code:{" "}
              <span className="font-semibold text-amber-300">{currentUser.referralCode}</span>
            </p>
            <p className="mt-2 text-sm text-teal-100/70">
              Earnings to date: {formatMoney(currentUser.referralEarnings)}
            </p>
          </div>
          <div className="flex flex-wrap gap-3 lg:justify-end">
            <Button size="lg" className="bg-white text-teal-900 hover:bg-teal-50" asChild>
              <Link href="/dashboard">Open rewards</Link>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="border-white/30 bg-transparent text-white hover:bg-white/10"
              asChild
            >
              <Link href="/auth">Create account</Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}

export function NewsletterSection() {
  return (
    <section className="border-t border-border/60 bg-secondary/30 py-16">
      <div className="mx-auto max-w-2xl px-4 text-center sm:px-6">
        <h2 className="font-heading text-2xl font-bold sm:text-3xl">Stay on the shelf</h2>
        <p className="text-muted-foreground mt-3 text-sm sm:text-base">
          Receive new releases, discounts, and author events—never spam.
        </p>
        <form className="mx-auto mt-6 flex max-w-md flex-col gap-2 sm:flex-row" action="#">
          <Input type="email" required placeholder="Email address" className="h-11 bg-background" />
          <Button type="submit" className="h-11 shrink-0">
            Subscribe
          </Button>
        </form>
      </div>
    </section>
  );
}
