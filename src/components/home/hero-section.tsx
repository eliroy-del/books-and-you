"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowRight, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { SmartSearch } from "@/components/search/smart-search";
import { BookCover } from "@/components/books/book-cover";
import { books } from "@/data/mock";

export function HeroSection() {
  const featured = books.filter((b) => b.featured).slice(0, 3);

  return (
    <section className="relative overflow-hidden gradient-mesh">
      <div className="pointer-events-none absolute inset-0 editorial-grid opacity-60" />
      <div className="relative mx-auto grid min-h-[calc(100vh-6.5rem)] max-w-7xl items-center gap-12 px-4 py-16 sm:px-6 lg:grid-cols-12 lg:gap-8 lg:px-8 lg:py-20">
        <div className="lg:col-span-6 xl:col-span-5">
          <motion.p
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="font-heading text-primary mb-4 text-sm font-semibold tracking-[0.18em] uppercase"
          >
            Books & You
          </motion.p>
          <motion.h1
            initial={{ opacity: 0, y: 18 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.55, delay: 0.05 }}
            className="font-heading text-4xl leading-[1.05] font-bold tracking-tight text-balance sm:text-5xl lg:text-6xl"
          >
            Discover Your Next Favorite Book.
          </motion.h1>
          <motion.p
            initial={{ opacity: 0, y: 18 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.55, delay: 0.12 }}
            className="text-muted-foreground mt-5 max-w-lg text-base leading-relaxed sm:text-lg"
          >
            Browse thousands of books from bestselling authors, discover personalized
            recommendations, and build a library you&apos;ll love.
          </motion.p>
          <motion.div
            initial={{ opacity: 0, y: 18 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.55, delay: 0.18 }}
            className="mt-8 flex flex-wrap gap-3"
          >
            <Button size="lg" className="h-12 rounded-xl px-6 text-base shadow-glow" asChild>
              <Link href="/books">
                Browse Books
                <ArrowRight className="ml-1 size-4" />
              </Link>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="h-12 rounded-xl border-primary/20 bg-background/60 px-6 text-base backdrop-blur"
              asChild
            >
              <Link href="/categories">Explore Categories</Link>
            </Button>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, scale: 0.96 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.7, delay: 0.15 }}
          className="relative lg:col-span-6 xl:col-span-7"
        >
          <div className="absolute -inset-6 rounded-[2rem] bg-gradient-to-br from-teal-600/15 via-transparent to-amber-400/10 blur-2xl" />
          <div className="relative flex items-end justify-center gap-3 sm:gap-5 lg:justify-end">
            {featured.map((book, i) => (
              <motion.div
                key={book.id}
                initial={{ opacity: 0, y: 40 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.25 + i * 0.1 }}
                className={
                  i === 1
                    ? "z-10 w-[42%] max-w-[220px] -translate-y-4 sm:w-[38%]"
                    : i === 0
                      ? "w-[30%] max-w-[160px] rotate-[-8deg] opacity-90"
                      : "w-[30%] max-w-[160px] rotate-[8deg] opacity-90"
                }
              >
                <Link href={`/book/${book.slug}`}>
                  <BookCover book={book} size="xl" className="w-full shadow-elevated" />
                </Link>
              </motion.div>
            ))}
          </div>
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7 }}
            className="glass absolute right-2 bottom-2 hidden items-center gap-2 rounded-full px-3 py-2 text-xs font-medium sm:flex"
          >
            <Sparkles className="text-gold size-3.5" />
            Curated for curious readers
          </motion.div>
        </motion.div>
      </div>

      <div className="relative mx-auto max-w-3xl px-4 pb-16 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 16 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.45 }}
        >
          <SmartSearch large />
        </motion.div>
      </div>
    </section>
  );
}
