"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { ArrowRight, ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const AUTO_MS = 5500;

const slides = [
  {
    id: "textbooks",
    eyebrow: "Books & You",
    title: "School books & supplies for every classroom.",
    description:
      "Nursery through SHS textbooks, workbooks, and past questions trusted by Ghana parents and teachers.",
    primary: { href: "/books", label: "Shop Books" },
    secondary: { href: "/categories?dept=by-school-level", label: "Shop by Level" },
    background: "/brand/hero-classroom.jpg",
    foreground: "/brand/hero-textbooks.png",
    foregroundAlt: "Ghana curriculum textbooks for Basic and Junior High School",
    overlay: "from-[#06332f]/88 via-[#0b4f47]/70 to-[#0b1220]/40",
    accent: "text-teal-200",
    panel: "bg-[#062823]/35",
    glow: "from-teal-400/30 via-emerald-300/10 to-transparent",
  },
  {
    id: "stationery",
    eyebrow: "Back to School",
    title: "Stationery that keeps the whole term on track.",
    description:
      "Exercise books, pens, mathematical sets, art supplies, and everyday classroom essentials.",
    primary: { href: "/categories?dept=stationery", label: "Shop Stationery" },
    secondary: { href: "/books?collection=back-to-school", label: "Back to School Picks" },
    background: "/brand/hero-stationery.jpg",
    foreground: null,
    foregroundAlt: "",
    overlay: "from-[#4a2808]/85 via-[#8a4b16]/55 to-[#1c1208]/45",
    accent: "text-amber-200",
    panel: "bg-[#3a1f08]/40",
    glow: "from-amber-300/35 via-orange-200/10 to-transparent",
  },
  {
    id: "exams",
    eyebrow: "Exam Ready",
    title: "BECE & WASSCE prep, ready when you are.",
    description:
      "Past questions, practice books, and teacher-recommended titles for confident exam seasons.",
    primary: { href: "/books?collection=exam-preparation", label: "Exam Preparation" },
    secondary: { href: "/categories?dept=books", label: "Browse Subjects" },
    background: "/brand/hero-exams.jpg",
    foreground: null,
    foregroundAlt: "",
    overlay: "from-[#1a2248]/90 via-[#24306a]/65 to-[#0b1220]/50",
    accent: "text-sky-200",
    panel: "bg-[#151c3a]/45",
    glow: "from-sky-300/30 via-indigo-200/10 to-transparent",
  },
] as const;

export function HeroSection() {
  const [index, setIndex] = useState(0);
  const [progress, setProgress] = useState(0);
  const slide = slides[index] ?? slides[0];

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
  }, [index]);

  function go(next: number) {
    setIndex((next + slides.length) % slides.length);
  }

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
          <Image
            src={slide.background}
            alt=""
            fill
            priority={index === 0}
            sizes="100vw"
            className="object-cover"
          />
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

      <div className="relative mx-auto grid min-h-[calc(100vh-7.5rem)] max-w-7xl items-center gap-10 px-4 py-16 sm:px-6 lg:grid-cols-12 lg:gap-8 lg:px-8 lg:py-20">
        <div className="lg:col-span-6 xl:col-span-5">
          <AnimatePresence mode="wait">
            <motion.div
              key={slide.id}
              initial={{ opacity: 0, y: 22 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -14 }}
              transition={{ duration: 0.45 }}
              className={cn(
                "rounded-[1.75rem] border border-white/15 p-6 text-white shadow-[0_20px_60px_rgba(0,0,0,0.28)] backdrop-blur-md sm:p-8",
                slide.panel
              )}
            >
              <p
                className={cn(
                  "font-heading mb-4 text-sm font-semibold tracking-[0.18em] uppercase",
                  slide.accent
                )}
              >
                {slide.eyebrow}
              </p>
              <h1 className="font-heading text-4xl leading-[1.05] font-bold tracking-tight text-balance sm:text-5xl lg:text-[3.25rem]">
                {slide.title}
              </h1>
              <p className="mt-5 max-w-lg text-base leading-relaxed text-white/85 sm:text-lg">
                {slide.description}
              </p>
              <div className="mt-8 flex flex-wrap gap-3">
                <Button
                  size="lg"
                  className="h-12 rounded-xl bg-white px-6 text-base text-slate-900 shadow-glow hover:bg-white/90"
                  asChild
                >
                  <Link href={slide.primary.href}>
                    {slide.primary.label}
                    <ArrowRight className="ml-1 size-4" />
                  </Link>
                </Button>
                <Button
                  size="lg"
                  variant="outline"
                  className="h-12 rounded-xl border-white/35 bg-white/10 px-6 text-base text-white backdrop-blur hover:bg-white/20 hover:text-white"
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
                      i === index ? "opacity-100" : "w-0 opacity-0 group-hover:w-full group-hover:opacity-40"
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

        {slide.foreground ? (
          <div className="relative lg:col-span-6 xl:col-span-7">
            <AnimatePresence mode="wait">
              <motion.div
                key={slide.id + "-fg"}
                initial={{ opacity: 0, y: 24, scale: 0.98 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={{ opacity: 0, y: -12, scale: 1.02 }}
                transition={{ duration: 0.55 }}
                className="relative mx-auto w-full max-w-[640px] lg:ml-auto lg:max-w-none"
              >
                <Image
                  src={slide.foreground}
                  alt={slide.foregroundAlt}
                  width={984}
                  height={512}
                  priority={index === 0}
                  sizes="(max-width: 1024px) 92vw, 50vw"
                  className="h-auto w-full select-none object-contain"
                  style={{
                    filter:
                      "drop-shadow(0 28px 40px rgba(0,0,0,0.35)) drop-shadow(0 8px 14px rgba(0,0,0,0.2))",
                  }}
                />
              </motion.div>
            </AnimatePresence>
          </div>
        ) : null}
      </div>
    </section>
  );
}
