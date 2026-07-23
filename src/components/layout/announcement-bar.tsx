"use client";

import { useEffect, useState } from "react";
import { announcements } from "@/data/mock";
import { AnimatePresence, motion } from "framer-motion";

export function AnnouncementBar() {
  const [index, setIndex] = useState(0);

  useEffect(() => {
    const id = setInterval(() => {
      setIndex((i) => (i + 1) % announcements.length);
    }, 4000);
    return () => clearInterval(id);
  }, []);

  return (
    <div className="bg-primary text-primary-foreground relative overflow-hidden">
      <div className="absolute inset-0 opacity-20 editorial-grid" />
      <div className="relative mx-auto flex h-10 max-w-7xl items-center justify-center px-4 text-center text-xs font-medium tracking-wide sm:text-sm">
        <AnimatePresence mode="wait">
          <motion.p
            key={index}
            initial={{ y: 12, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: -12, opacity: 0 }}
            transition={{ duration: 0.35 }}
          >
            {announcements[index]}
          </motion.p>
        </AnimatePresence>
      </div>
    </div>
  );
}
