"use client";

import Image from "next/image";
import Link from "next/link";
import { motion } from "framer-motion";
import { ArrowRight, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { SmartSearch } from "@/components/search/smart-search";

export function HeroSection() {
  return (
    <section className="relative overflow-hidden gradient-mesh">
      <div className="pointer-events-none absolute inset-0 editorial-grid opacity-60" />
      <div className="relative mx-auto grid min-h-[calc(100vh-7.5rem)] max-w-7xl items-center gap-10 px-4 py-16 sm:px-6 lg:grid-cols-12 lg:gap-8 lg:px-8 lg:py-20">
        <div className="lg:col-span-5 xl:col-span-5">
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
            School books & supplies for every classroom.
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
                Shop Books
                <ArrowRight className="ml-1 size-4" />
              </Link>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="h-12 rounded-xl border-primary/20 bg-background/60 px-6 text-base backdrop-blur"
              asChild
            >
              <Link href="/categories">Browse by Level</Link>
            </Button>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, scale: 0.96, y: 16 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.15 }}
          className="relative lg:col-span-7 xl:col-span-7"
        >
          <div className="pointer-events-none absolute -inset-8 rounded-[2.5rem] bg-gradient-to-br from-teal-600/20 via-amber-400/10 to-transparent blur-3xl" />
          <div className="relative mx-auto w-full max-w-[640px] lg:ml-auto lg:max-w-none">
            <motion.div
              initial={{ opacity: 0, y: 28 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.75, delay: 0.28 }}
              className="relative"
            >
              <Image
                src="/brand/hero-textbooks.png"
                alt="Ghana curriculum textbooks — English and Mathematics for Basic and Junior High School"
                width={984}
                height={512}
                priority
                sizes="(max-width: 1024px) 92vw, 58vw"
                className="h-auto w-full select-none object-contain"
                style={{
                  filter:
                    "drop-shadow(0 28px 40px rgba(11, 18, 32, 0.28)) drop-shadow(0 8px 14px rgba(11, 18, 32, 0.14))",
                }}
              />
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.7 }}
              className="glass absolute right-1 bottom-1 flex items-center gap-2 rounded-full px-3 py-2 text-xs font-medium sm:right-3 sm:bottom-3 sm:text-sm"
            >
              <Sparkles className="text-gold size-3.5" />
              Textbooks for curious minds
            </motion.div>
          </div>
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
