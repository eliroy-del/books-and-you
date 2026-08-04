import type { Metadata } from "next";
import { Suspense } from "react";
import CategoriesClient from "./categories-client";
import { JsonLd } from "@/components/structured-data";
import { siteName, siteUrl } from "@/lib/seo";
import { buildBreadcrumbs } from "@/lib/structured-data";

export const metadata: Metadata = {
  title: "Categories",
  description:
    "Browse Books & You by department, school level, subject, and stationery — built for Ghana classrooms.",
  alternates: { canonical: "/categories" },
  openGraph: {
    title: `Categories · ${siteName}`,
    description:
      "Shop by department, school level, subject, or stationery at Books & You.",
    url: `${siteUrl}/categories`,
    type: "website",
  },
};

export default function CategoriesPage() {
  return (
    <>
      <JsonLd
        data={buildBreadcrumbs([
          { name: "Home", path: "/" },
          { name: "Categories" },
        ])}
      />
      <Suspense fallback={<div className="py-24 text-center text-sm">Loading browse…</div>}>
        <CategoriesClient />
      </Suspense>
    </>
  );
}
