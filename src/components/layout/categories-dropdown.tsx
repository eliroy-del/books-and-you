"use client";

import Link from "next/link";
import { ChevronDown } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import {
  catalogBrowseHref,
  catalogNav,
  departmentHref,
} from "@/data/catalog-nav";
import { cn } from "@/lib/utils";

export function CategoriesDropdown() {
  const [open, setOpen] = useState(false);
  const rootRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function onDoc(e: MouseEvent) {
      if (!rootRef.current?.contains(e.target as Node)) setOpen(false);
    }
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onDoc);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", onDoc);
      document.removeEventListener("keydown", onKey);
    };
  }, []);

  const bookSections = catalogNav.find((d) => d.slug === "books")?.children ?? [];
  const otherDepts = catalogNav.filter((d) => d.slug !== "books");

  return (
    <div ref={rootRef} className="relative">
      <button
        type="button"
        className={cn(
          "inline-flex items-center gap-1 rounded-xl px-3.5 py-2.5 text-[15px] font-medium transition-colors",
          open ? "text-primary" : "text-muted-foreground hover:text-foreground"
        )}
        aria-expanded={open}
        aria-haspopup="true"
        onClick={() => setOpen((v) => !v)}
        onMouseEnter={() => setOpen(true)}
      >
        Categories
        <ChevronDown className={cn("size-4 transition", open && "rotate-180")} />
      </button>

      {open ? (
        <div
          className="absolute top-full left-0 z-50 mt-2 w-[min(520px,calc(100vw-2rem))] overflow-hidden rounded-2xl border border-border/70 bg-background p-4 shadow-elevated"
          onMouseLeave={() => setOpen(false)}
        >
          <div className="grid gap-5 sm:grid-cols-2">
            <div>
              <p className="text-muted-foreground mb-2 px-1 text-[11px] font-semibold tracking-wide uppercase">
                Books
              </p>
              <ul className="space-y-0.5">
                {bookSections.map((section) => (
                  <li key={section.slug}>
                    <Link
                      href={catalogBrowseHref(section.slug)}
                      onClick={() => setOpen(false)}
                      className="hover:bg-muted block rounded-xl px-3 py-2 text-sm font-medium transition"
                    >
                      {section.name}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
            <div>
              <p className="text-muted-foreground mb-2 px-1 text-[11px] font-semibold tracking-wide uppercase">
                More
              </p>
              <ul className="space-y-0.5">
                {otherDepts.map((dept) => (
                  <li key={dept.slug}>
                    <Link
                      href={departmentHref(dept.slug)}
                      onClick={() => setOpen(false)}
                      className="hover:bg-muted block rounded-xl px-3 py-2 text-sm font-medium transition"
                    >
                      {dept.name}
                    </Link>
                  </li>
                ))}
              </ul>
              <Link
                href="/categories"
                onClick={() => setOpen(false)}
                className="text-primary mt-3 inline-block px-3 text-sm font-medium hover:underline"
              >
                View all categories
              </Link>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

export function MobileCategoriesNav({ onNavigate }: { onNavigate: () => void }) {
  const [open, setOpen] = useState(false);
  const bookSections = catalogNav.find((d) => d.slug === "books")?.children ?? [];
  const otherDepts = catalogNav.filter((d) => d.slug !== "books");

  return (
    <div>
      <button
        type="button"
        className="flex w-full items-center justify-between rounded-xl px-3 py-3 text-left text-[15px] font-medium hover:bg-muted"
        onClick={() => setOpen((v) => !v)}
      >
        Categories
        <ChevronDown className={cn("size-4 transition", open && "rotate-180")} />
      </button>
      {open ? (
        <div className="mb-2 ml-2 space-y-1 border-l border-border/70 pl-2">
          {bookSections.map((section) => (
            <Link
              key={section.slug}
              href={catalogBrowseHref(section.slug)}
              onClick={onNavigate}
              className="hover:bg-muted block rounded-lg px-3 py-2 text-sm font-medium"
            >
              {section.name}
            </Link>
          ))}
          {otherDepts.map((dept) => (
            <Link
              key={dept.slug}
              href={departmentHref(dept.slug)}
              onClick={onNavigate}
              className="hover:bg-muted block rounded-lg px-3 py-2 text-sm font-medium"
            >
              {dept.name}
            </Link>
          ))}
          <Link
            href="/categories"
            onClick={onNavigate}
            className="text-primary block rounded-lg px-3 py-2 text-sm font-medium"
          >
            View all categories
          </Link>
        </div>
      ) : null}
    </div>
  );
}
