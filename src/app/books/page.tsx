import { Suspense } from "react";
import type { Metadata } from "next";
import BooksClient from "./books-client";
import { Skeleton } from "@/components/ui/skeleton";
import { JsonLd } from "@/components/structured-data";
import { siteName, siteUrl } from "@/lib/seo";
import { buildBreadcrumbs } from "@/lib/structured-data";

export const metadata: Metadata = {
  title: "Books",
  description:
    "Shop textbooks, stationery, and curated titles at Books & You. Browse by class, subject, and collection for Ghana schools and readers.",
  alternates: { canonical: "/books" },
  openGraph: {
    title: `Books · ${siteName}`,
    description:
      "Browse the Books & You catalog — textbooks, stationery, and reading picks.",
    url: `${siteUrl}/books`,
    type: "website",
  },
};

export default function Page() {
  return (
    <>
      <JsonLd
        data={buildBreadcrumbs([
          { name: "Home", path: "/" },
          { name: "Books" },
        ])}
      />
      <Suspense
        fallback={
          <div className="mx-auto max-w-7xl space-y-6 px-4 py-10">
            <Skeleton className="h-10 w-64" />
            <Skeleton className="h-12 w-full max-w-xl" />
            <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
              {Array.from({ length: 8 }).map((_, i) => (
                <Skeleton key={i} className="aspect-[2/3] w-full rounded-lg" />
              ))}
            </div>
          </div>
        }
      >
        <BooksClient />
      </Suspense>
    </>
  );
}
