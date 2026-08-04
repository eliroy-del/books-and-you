"use client";

import { Suspense, useMemo } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import {
  accentForSlug,
  catalogBrowseHref,
  catalogNav,
  departmentHref,
  featuredCollectionDefs,
  findCatalogNode,
  type CatalogNavNode,
} from "@/data/catalog-nav";
import { cn } from "@/lib/utils";

function CategoriesInner() {
  const params = useSearchParams();
  const deptSlug = params.get("dept") ?? catalogNav[0]?.slug ?? "books";
  const dept = findCatalogNode(deptSlug) ?? catalogNav[0];
  const sections = dept?.children ?? [];

  const levels = useMemo(
    () => catalogNav.find((d) => d.slug === "by-school-level")?.children ?? [],
    []
  );

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <h1 className="font-heading text-3xl font-bold tracking-tight">Browse the store</h1>
      <p className="text-muted-foreground mt-2 max-w-2xl text-sm sm:text-base">
        Shop by department, school level, subject, or stationery — built for Ghana classrooms.
      </p>

      <div className="mt-8 flex flex-wrap gap-2">
        {catalogNav.map((d) => (
          <Link
            key={d.slug}
            href={departmentHref(d.slug)}
            className={cn(
              "rounded-full border px-4 py-2 text-sm font-medium transition",
              deptSlug === d.slug
                ? "border-primary bg-primary text-primary-foreground"
                : "border-border hover:border-primary/40"
            )}
          >
            {d.name}
          </Link>
        ))}
      </div>

      <section className="mt-10">
        <div className="mb-6 flex items-end justify-between gap-3">
          <div>
            <h2 className="font-heading text-2xl font-semibold">{dept?.name}</h2>
            {dept?.description ? (
              <p className="text-muted-foreground mt-1 text-sm">{dept.description}</p>
            ) : null}
          </div>
          <Link
            href={catalogBrowseHref(dept?.slug ?? "books")}
            className="text-primary text-sm font-medium hover:underline"
          >
            Shop all
          </Link>
        </div>

        <DeptSections sections={sections} />
      </section>

      <section className="mt-16">
        <h2 className="font-heading text-2xl font-semibold">By School Level</h2>
        <p className="text-muted-foreground mt-1 text-sm">
          Jump straight to Nursery through SHS 3.
        </p>
        <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-7">
          {levels.map((level) => (
            <Link
              key={level.slug}
              href={catalogBrowseHref(level.slug)}
              className="rounded-2xl border border-border/70 bg-card px-3 py-4 text-center shadow-soft transition hover:-translate-y-0.5 hover:border-primary/40"
            >
              <span className="font-heading text-sm font-semibold">{level.name}</span>
            </Link>
          ))}
        </div>
      </section>

      <section className="mt-16">
        <h2 className="font-heading text-2xl font-semibold">Featured Collections</h2>
        <p className="text-muted-foreground mt-1 text-sm">
          Curated shelves for shopping with purpose.
        </p>
        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {featuredCollectionDefs.map((col) => (
            <Link
              key={col.slug}
              href={`/books?collection=${col.slug}`}
              className="group overflow-hidden rounded-3xl border border-border/70 bg-card shadow-soft transition hover:-translate-y-0.5"
            >
              <div className={`h-24 bg-gradient-to-br ${accentForSlug(col.slug)}`} />
              <div className="p-5">
                <h3 className="font-heading text-lg font-semibold group-hover:text-primary">
                  {col.title}
                </h3>
                <p className="text-muted-foreground mt-1 text-sm">{col.description}</p>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  );
}

function DeptSections({ sections }: { sections: CatalogNavNode[] }) {
  if (!sections.length) {
    return (
      <p className="text-muted-foreground rounded-2xl border border-dashed border-border p-8 text-sm">
        No subcategories yet.
      </p>
    );
  }

  const nested = sections.some((s) => (s.children?.length ?? 0) > 0);

  if (!nested) {
    return (
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {sections.map((item) => (
          <CategoryCard key={item.slug} node={item} />
        ))}
      </div>
    );
  }

  return (
    <div className="space-y-10">
      {sections.map((section) => (
        <div key={section.slug}>
          <div className="mb-4 flex items-center justify-between gap-3">
            <h3 className="font-heading text-lg font-semibold">
              <Link href={catalogBrowseHref(section.slug)} className="hover:text-primary">
                {section.name}
              </Link>
            </h3>
            <Link
              href={catalogBrowseHref(section.slug)}
              className="text-muted-foreground text-xs font-medium hover:text-primary"
            >
              View section
            </Link>
          </div>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {(section.children ?? []).map((child) => (
              <Link
                key={child.slug}
                href={catalogBrowseHref(child.slug)}
                className="rounded-2xl border border-border/70 bg-card px-4 py-3 text-sm font-medium shadow-soft transition hover:border-primary/40 hover:text-primary"
              >
                {child.name}
              </Link>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}

function CategoryCard({ node }: { node: CatalogNavNode }) {
  return (
    <Link
      href={catalogBrowseHref(node.slug)}
      className="group overflow-hidden rounded-3xl border border-border/70 bg-card shadow-soft transition hover:-translate-y-0.5"
    >
      <div className={`h-24 bg-gradient-to-br ${accentForSlug(node.slug)}`} />
      <div className="p-5">
        <h3 className="font-heading text-lg font-semibold group-hover:text-primary">
          {node.name}
        </h3>
        {node.description ? (
          <p className="text-muted-foreground mt-1 line-clamp-2 text-sm">{node.description}</p>
        ) : null}
      </div>
    </Link>
  );
}

export default function CategoriesPage() {
  return (
    <Suspense fallback={<div className="py-24 text-center text-sm">Loading browse…</div>}>
      <CategoriesInner />
    </Suspense>
  );
}
