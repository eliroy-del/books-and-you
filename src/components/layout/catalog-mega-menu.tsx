"use client";

import Link from "next/link";
import { ChevronDown } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import {
  catalogBrowseHref,
  catalogNav,
  departmentHref,
  featuredCollectionDefs,
  type CatalogNavNode,
} from "@/data/catalog-nav";
import { cn } from "@/lib/utils";

export function CatalogMegaMenu() {
  const [open, setOpen] = useState(false);
  const [activeDept, setActiveDept] = useState(catalogNav[0]?.slug ?? "books");
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

  const dept = catalogNav.find((d) => d.slug === activeDept) ?? catalogNav[0];

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
        Shop
        <ChevronDown className={cn("size-4 transition", open && "rotate-180")} />
      </button>

      {open ? (
        <div
          className="absolute top-full left-0 z-50 mt-2 w-[min(920px,calc(100vw-2rem))] overflow-hidden rounded-2xl border border-border/70 bg-background shadow-elevated"
          onMouseLeave={() => setOpen(false)}
        >
          <div className="grid min-h-[360px] grid-cols-[220px_1fr]">
            <div className="border-r border-border/60 bg-muted/30 p-3">
              <p className="text-muted-foreground px-2 pb-2 text-[11px] font-semibold tracking-wide uppercase">
                Departments
              </p>
              <ul className="space-y-0.5">
                {catalogNav.map((d) => (
                  <li key={d.slug}>
                    <button
                      type="button"
                      onMouseEnter={() => setActiveDept(d.slug)}
                      onFocus={() => setActiveDept(d.slug)}
                      onClick={() => setActiveDept(d.slug)}
                      className={cn(
                        "w-full rounded-xl px-3 py-2.5 text-left text-sm font-medium transition",
                        activeDept === d.slug
                          ? "bg-primary text-primary-foreground"
                          : "hover:bg-background"
                      )}
                    >
                      {d.name}
                    </button>
                  </li>
                ))}
              </ul>
              <div className="mt-4 border-t border-border/60 pt-3">
                <p className="text-muted-foreground px-2 pb-2 text-[11px] font-semibold tracking-wide uppercase">
                  Featured
                </p>
                <ul className="space-y-0.5">
                  {featuredCollectionDefs.map((c) => (
                    <li key={c.slug}>
                      <Link
                        href={`/books?collection=${c.slug}`}
                        onClick={() => setOpen(false)}
                        className="hover:bg-background block rounded-xl px-3 py-2 text-sm"
                      >
                        {c.title}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            <div className="p-5">
              <div className="mb-4 flex items-end justify-between gap-3">
                <div>
                  <h3 className="font-heading text-xl font-semibold">{dept?.name}</h3>
                  {dept?.description ? (
                    <p className="text-muted-foreground mt-1 max-w-lg text-sm">
                      {dept.description}
                    </p>
                  ) : null}
                </div>
                <Link
                  href={departmentHref(dept?.slug ?? "books")}
                  onClick={() => setOpen(false)}
                  className="text-primary shrink-0 text-sm font-medium hover:underline"
                >
                  View all
                </Link>
              </div>
              <DeptPanel dept={dept} onNavigate={() => setOpen(false)} />
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

function DeptPanel({
  dept,
  onNavigate,
}: {
  dept?: CatalogNavNode;
  onNavigate: () => void;
}) {
  if (!dept) return null;
  const sections = dept.children ?? [];
  const hasNested = sections.some((s) => (s.children?.length ?? 0) > 0);

  if (!hasNested) {
    return (
      <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
        {sections.map((item) => (
          <Link
            key={item.slug}
            href={catalogBrowseHref(item.slug)}
            onClick={onNavigate}
            className="hover:bg-muted rounded-xl px-3 py-2 text-sm transition"
          >
            {item.name}
          </Link>
        ))}
      </div>
    );
  }

  return (
    <div className="grid max-h-[420px] gap-5 overflow-y-auto sm:grid-cols-2">
      {sections.map((section) => (
        <div key={section.slug}>
          <Link
            href={catalogBrowseHref(section.slug)}
            onClick={onNavigate}
            className="font-heading text-sm font-semibold hover:text-primary"
          >
            {section.name}
          </Link>
          <ul className="mt-2 space-y-1">
            {(section.children ?? []).slice(0, 8).map((child) => (
              <li key={child.slug}>
                <Link
                  href={catalogBrowseHref(child.slug)}
                  onClick={onNavigate}
                  className="text-muted-foreground hover:text-foreground block text-sm transition"
                >
                  {child.name}
                </Link>
              </li>
            ))}
            {(section.children?.length ?? 0) > 8 ? (
              <li>
                <Link
                  href={catalogBrowseHref(section.slug)}
                  onClick={onNavigate}
                  className="text-primary text-xs font-medium"
                >
                  +{(section.children?.length ?? 0) - 8} more
                </Link>
              </li>
            ) : null}
          </ul>
        </div>
      ))}
    </div>
  );
}

export function MobileCatalogNav({ onNavigate }: { onNavigate: () => void }) {
  const [expanded, setExpanded] = useState<string | null>("books");

  return (
    <div className="space-y-1">
      <p className="text-muted-foreground px-3 pt-2 text-[11px] font-semibold tracking-wide uppercase">
        Shop
      </p>
      {catalogNav.map((dept) => {
        const open = expanded === dept.slug;
        return (
          <div key={dept.slug}>
            <button
              type="button"
              className="flex w-full items-center justify-between rounded-xl px-3 py-3 text-left text-[15px] font-medium hover:bg-muted"
              onClick={() => setExpanded(open ? null : dept.slug)}
            >
              {dept.name}
              <ChevronDown className={cn("size-4 transition", open && "rotate-180")} />
            </button>
            {open ? (
              <div className="mb-2 ml-2 space-y-1 border-l border-border/70 pl-2">
                <Link
                  href={departmentHref(dept.slug)}
                  onClick={onNavigate}
                  className="text-primary block rounded-lg px-3 py-2 text-sm font-medium"
                >
                  All {dept.name}
                </Link>
                {(dept.children ?? []).map((child) => (
                  <div key={child.slug}>
                    <Link
                      href={catalogBrowseHref(child.slug)}
                      onClick={onNavigate}
                      className="hover:bg-muted block rounded-lg px-3 py-2 text-sm font-medium"
                    >
                      {child.name}
                    </Link>
                    {child.children?.length ? (
                      <div className="ml-2 space-y-0.5 pb-1">
                        {child.children.slice(0, 6).map((leaf) => (
                          <Link
                            key={leaf.slug}
                            href={catalogBrowseHref(leaf.slug)}
                            onClick={onNavigate}
                            className="text-muted-foreground hover:text-foreground block rounded-lg px-3 py-1.5 text-xs"
                          >
                            {leaf.name}
                          </Link>
                        ))}
                      </div>
                    ) : null}
                  </div>
                ))}
              </div>
            ) : null}
          </div>
        );
      })}
      <p className="text-muted-foreground px-3 pt-3 text-[11px] font-semibold tracking-wide uppercase">
        Featured Collections
      </p>
      {featuredCollectionDefs.map((c) => (
        <Link
          key={c.slug}
          href={`/books?collection=${c.slug}`}
          onClick={onNavigate}
          className="hover:bg-muted block rounded-xl px-3 py-2.5 text-[15px] font-medium"
        >
          {c.title}
        </Link>
      ))}
    </div>
  );
}
