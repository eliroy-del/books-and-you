import type { Metadata } from "next";
import { createClient } from "@supabase/supabase-js";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";
import { getBookBySlug } from "@/data/mock";
import { siteUrl } from "@/lib/seo";
import BookDetailClient from "./book-detail-client";

type BookMeta = {
  title: string;
  subtitle?: string;
  description: string;
  authorName?: string;
  rating?: number;
  reviewCount?: number;
};

async function fetchBookMeta(slug: string): Promise<BookMeta | null> {
  if (isSupabaseConfigured()) {
    const env = getSupabaseEnv();
    if (env) {
      try {
        const supabase = createClient(env.url, env.anonKey);
        const { data } = await supabase
          .from("books")
          .select(
            "title, subtitle, description, synopsis, rating_avg, review_count, book_authors ( is_primary, authors ( name ) )"
          )
          .eq("slug", slug)
          .maybeSingle();
        if (data) {
          const authors = (data.book_authors ?? []) as Array<{
            is_primary?: boolean;
            authors?: { name?: string } | { name?: string }[] | null;
          }>;
          const primary = authors.find((a) => a.is_primary) ?? authors[0];
          const a = primary?.authors;
          const authorName = Array.isArray(a) ? a[0]?.name : a?.name;
          return {
            title: data.title,
            subtitle: data.subtitle ?? undefined,
            description: data.description || data.synopsis || "",
            authorName: authorName ?? undefined,
            rating: data.rating_avg ?? undefined,
            reviewCount: data.review_count ?? undefined,
          };
        }
      } catch {
        // fall through to mock
      }
    }
  }
  const mock = getBookBySlug(slug);
  if (!mock) return null;
  return {
    title: mock.title,
    subtitle: mock.subtitle,
    description: mock.description || mock.synopsis || "",
    authorName: mock.authorName,
    rating: mock.rating,
    reviewCount: mock.reviewCount,
  };
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const book = await fetchBookMeta(slug);
  if (!book) {
    return { title: "Book not found" };
  }
  const title = book.authorName ? `${book.title} by ${book.authorName}` : book.title;
  const description =
    (book.description || book.subtitle || `Buy ${book.title} at Books & You.`).slice(0, 300);
  const url = `${siteUrl}/book/${slug}`;
  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: {
      type: "book",
      url,
      title: `${title} · Books & You`,
      description,
    },
    twitter: {
      card: "summary_large_image",
      title: `${title} · Books & You`,
      description,
    },
  };
}

export default async function BookDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const book = await fetchBookMeta(slug);

  const jsonLd = book
    ? {
        "@context": "https://schema.org",
        "@type": "Book",
        name: book.title,
        description: (book.description || "").slice(0, 500),
        url: `${siteUrl}/book/${slug}`,
        ...(book.authorName
          ? { author: { "@type": "Person", name: book.authorName } }
          : {}),
        ...(book.rating && book.reviewCount
          ? {
              aggregateRating: {
                "@type": "AggregateRating",
                ratingValue: book.rating,
                reviewCount: book.reviewCount,
                bestRating: 5,
              },
            }
          : {}),
      }
    : null;

  return (
    <>
      {jsonLd ? (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      ) : null}
      <BookDetailClient />
    </>
  );
}
