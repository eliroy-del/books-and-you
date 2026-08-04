import Link from "next/link";
import type { Metadata } from "next";
import { listAuthors } from "@/lib/services/authors";
import { siteName, siteUrl } from "@/lib/seo";

export const metadata: Metadata = {
  title: "Authors",
  description:
    "Discover authors at Books & You — Ghanaian voices, African literature, and textbook writers for every classroom.",
  alternates: { canonical: "/authors" },
  openGraph: {
    title: `Authors · ${siteName}`,
    description: "Browse authors and their books at Books & You.",
    url: `${siteUrl}/authors`,
    type: "website",
  },
};

export default async function AuthorsPage() {
  const authors = await listAuthors(50);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    name: `Authors · ${siteName}`,
    url: `${siteUrl}/authors`,
    mainEntity: authors.map((a) => ({
      "@type": "Person",
      name: a.name,
      url: `${siteUrl}/authors/${a.slug}`,
      description: a.bio.slice(0, 200),
    })),
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <h1 className="font-heading text-3xl font-bold tracking-tight">Authors</h1>
      <p className="text-muted-foreground mt-2 max-w-2xl text-sm">
        Writers and educators featured across our catalog.
      </p>
      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {authors.map((a) => (
          <Link
            key={a.id}
            href={`/authors/${a.slug}`}
            className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft transition hover:border-primary/30"
          >
            <div
              className={`flex size-12 items-center justify-center rounded-2xl bg-gradient-to-br text-sm font-bold text-white ${a.avatarColor}`}
            >
              {a.name
                .split(" ")
                .map((p) => p[0])
                .slice(0, 2)
                .join("")}
            </div>
            <h2 className="font-heading mt-4 text-lg font-semibold">{a.name}</h2>
            <p className="text-muted-foreground mt-1 text-xs">{a.nationality}</p>
            <p className="text-muted-foreground mt-3 line-clamp-3 text-sm">{a.bio}</p>
            <p className="text-primary mt-3 text-xs font-medium">{a.bookCount} books</p>
          </Link>
        ))}
      </div>
    </div>
  );
}
