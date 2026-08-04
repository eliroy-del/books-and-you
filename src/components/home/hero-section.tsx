"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { ArrowRight, ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const slides = [
  {
    id: "textbooks",
    eyebrow: "Books & You",
    title: "School books & supplies for every classroom.",
    description:
      "Nursery through SHS textbooks, workbooks, and past questions trusted by Ghana parents and teachers.",
    primary: { href: "/books", label: "Shop Books" },
    secondary: { href: "/categories?dept=by-school-level", label: "Shop by Level" },
    image: "/brand/hero-textbooks.png",
    imageAlt: "Ghana curriculum textbooks for Basic and Junior High School",
    tone: "from-teal-700/25 via-emerald-400/10 to-transparent",
  },
  {
    id: "stationery",
    eyebrow: "Back to School",
    title: "Stationery that keeps the whole term on track.",
    description:
      "Exercise books, pens, mathematical sets, art supplies, and everyday classroom essentials.",
    primary: { href: "/categories?dept=stationery", label: "Shop Stationery" },
    secondary: { href: "/books?collection=back-to-school", label: "Back to School Picks" },
    image: "/brand/hero-textbooks.png",
    imageAlt: "School books and supplies for the new term",
    tone: "from-amber-600/25 via-orange-300/10 to-transparent",
  },
  {
    id: "exams",
    eyebrow: "Exam Ready",
    title: "BECE & WASSCE prep, ready when you are.",
    description:
      "Past questions, practice books, and teacher-recommended titles for confident exam seasons.",
    primary: { href: "/books?collection=exam-preparation", label: "Exam Preparation" },
    secondary: { href: "/categories?dept=books", label: "Browse Subjects" },
    image: "/brand/hero-textbooks.png",
    imageAlt: "Exam preparation textbooks and practice materials",
    tone: "from-sky-700/25 via-cyan-400/10 to-transparent",
  },
] as const;

export function HeroSection() {
  const [index, setIndex] = useState(0);
  const [paused, setPaused] = useState(false);
  const slide = slides[index] ?? slides[0];

  useEffect(() => {
    if (paused) return;
    const id = window.setInterval(() => {
      setIndex((current) => (current + 1) % slides.length);
    }, 6500);
    return () => window.clearInterval(id);
  }, [paused]);

  function go(next: number) {
    setIndex((next + slides.length) % slides.length);
  }

  return (
    <section
      className="relative overflow-hidden gradient-mesh"
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
    >
      <div className="pointer-events-none absolute inset-0 editorial-grid opacity-60" />
      <div
        className={cn(
          "pointer-events-none absolute inset-0 bg-gradient-to-br transition-opacity duration-700",
          slide.tone
        )}
      />

      <div className="relative mx-auto grid min-h-[calc(100vh-7.5rem)] max-w-7xl items-center gap-10 px-4 py-16 sm:px-6 lg:grid-cols-12 lg:gap-8 lg:px-8 lg:py-20">
        <div className="lg:col-span-5 xl:col-span-5">
          <AnimatePresence mode="wait">
            <motion.div
              key={slide.id}
              initial={{ opacity: 0, y: 18 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -12 }}
              transition={{ duration: 0.45 }}
            >
              <p className="font-heading text-primary mb-4 text-sm font-semibold tracking-[0.18em] uppercase">
                {slide.eyebrow}
              </p>
              <h1 className="font-heading text-4xl leading-[1.05] font-bold tracking-tight text-balance sm:text-5xl lg:text-6xl">
                {slide.title}
              </h1>
              <p className="text-muted-foreground mt-5 max-w-lg text-base leading-relaxed sm:text-lg">
                {slide.description}
              </p>
              <div className="mt-8 flex flex-wrap gap-3">
                <Button size="lg" className="h-12 rounded-xl px-6 text-base shadow-glow" asChild>
                  <Link href={slide.primary.href}>
                    {slide.primary.label}
                    <ArrowRight className="ml-1 size-4" />
                  </Link>
                </Button>
                <Button
                  size="lg"
                  variant="outline"
                  className="h-12 rounded-xl border-primary/20 bg-background/60 px-6 text-base backdrop-blur"
                  asChild
                >
                  <Link href={slide.secondary.href}>{slide.secondary.label}</Link>
                </Button>
              </div>
            </motion.div>
          </AnimatePresence>

          <div className="mt-10 flex items-center gap-3">
            <button
              type="button"
              aria-label="Previous slide"
              onClick={() => go(index - 1)}
              className="border-border/70 bg-background/70 hover:bg-background inline-flex size-10 items-center justify-center rounded-full border backdrop-blur transition"
            >
              <ChevronLeft className="size-4" />
            </button>
            <div className="flex items-center gap-2">
              {slides.map((item, i) => (
                <button
                  key={item.id}
                  type="button"
                  aria-label={`Go to slide ${i + 1}`}
                  aria-current={i === index}
                  onClick={() => setIndex(i)}
                  className={cn(
                    "h-2.5 rounded-full transition-all",
                    i === index ? "bg-primary w-8" : "bg-border hover:bg-primary/40 w-2.5"
                  )}
                />
              ))}
            </div>
            <button
              type="button"
              aria-label="Next slide"
              onClick={() => go(index + 1)}
              className="border-border/70 bg-background/70 hover:bg-background inline-flex size-10 items-center justify-center rounded-full border backdrop-blur transition"
            >
              <ChevronRight className="size-4" />
            </button>
          </div>
        </div>

        <div className="relative lg:col-span-7 xl:col-span-7">
          <div className="pointer-events-none absolute -inset-8 rounded-[2.5rem] bg-gradient-to-br from-teal-600/20 via-amber-400/10 to-transparent blur-3xl" />
          <div className="relative mx-auto w-full max-w-[640px] lg:ml-auto lg:max-w-none">
            <AnimatePresence mode="wait">
              <motion.div
                key={slide.id + "-image"}
                initial={{ opacity: 0, scale: 0.98, y: 16 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 1.01, y: -8 }}
                transition={{ duration: 0.5 }}
              >
                <Image
                  src={slide.image}
                  alt={slide.imageAlt}
                  width={984}
                  height={512}
                  priority={index === 0}
                  sizes="(max-width: 1024px) 92vw, 58vw"
                  className="h-auto w-full select-none object-contain"
                  style={{
                    filter:
                      "drop-shadow(0 28px 40px rgba(11, 18, 32, 0.28)) drop-shadow(0 8px 14px rgba(11, 18, 32, 0.14))",
                  }}
                />
              </motion.div>
            </AnimatePresence>
          </div>
        </div>
      </div>
    </section>
  );
}
