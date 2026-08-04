import type { Metadata } from "next";
import { createClient } from "@supabase/supabase-js";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";
import { books as mockBooks, getBookBySlug } from "@/data/mock";
import { siteUrl } from "@/lib/seo";
import { JsonLd } from "@/components/structured-data";
import {
  bookProductSchema,
  buildBreadcrumbs,
  schemaBaseUrl,
} from "@/lib/structured-data";
import BookDetailClient from "./book-detail-client";

type BookMeta = {
  title: string;
  subtitle?: string;
  description: string;
  authorName?: string;
  rating?: number;
  reviewCount?: number;
  coverUrl?: string | null;
  priceGhs?: number | null;
  inStock?: boolean;
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
            "title, subtitle, description, synopsis, cover_url, rating_avg, review_count, book_authors ( is_primary, authors ( name ) ), book_inventory ( format, price_cents, quantity_on_hand, is_active )"
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
          const inventory = (
            (data.book_inventory ?? []) as Array<{
              price_cents?: number;
              quantity_on_hand?: number;
              is_active?: boolean;
            }>
          ).filter((i) => i.is_active !== false);
          const prices = inventory
            .map((i) => i.price_cents)
            .filter((p): p is number => typeof p === "number" && p > 0);
          const priceGhs = prices.length
            ? Math.min(...prices.map((c) => Math.round(c / 100)))
            : null;
          const inStock = inventory.some((i) => (i.quantity_on_hand ?? 0) > 0);
          return {
            title: data.title,
            subtitle: data.subtitle ?? undefined,
            description: data.description || data.synopsis || "",
            authorName: authorName ?? undefined,
            rating: data.rating_avg ?? undefined,
            reviewCount: data.review_count ?? undefined,
            coverUrl: data.cover_url ?? undefined,
            priceGhs,
            inStock,
          };
        }
      } catch {
        // fall through to mock
      }
    }
  }
  const mock = getBookBySlug(slug);
  if (!mock) return null;
  const prices = mock.formats?.map((f) => f.price).filter((p) => p > 0) ?? [];
  return {
    title: mock.title,
    subtitle: mock.subtitle,
    description: mock.description || mock.synopsis || "",
    authorName: mock.authorName,
    rating: mock.rating,
    reviewCount: mock.reviewCount,
    coverUrl: mock.coverUrl,
    priceGhs: prices.length ? Math.min(...prices) : null,
    inStock: true,
  };
}

export async function generateStaticParams() {
  if (isSupabaseConfigured()) {
    const env = getSupabaseEnv();
    if (env) {
      try {
        const supabase = createClient(env.url, env.anonKey);
        const { data } = await supabase.from("books").select("slug").limit(500);
        if (data?.length) return data.map((b) => ({ slug: String(b.slug) }));
      } catch {
        // fall through
      }
    }
  }
  return mockBooks.map((b) => ({ slug: b.slug }));
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
  const images = book.coverUrl
    ? [{ url: book.coverUrl, width: 800, height: 1200, alt: `${book.title} cover` }]
    : undefined;
  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: {
      type: "book",
      url,
      title: `${title} · Books & You`,
      description,
      images,
    },
    twitter: {
      card: "summary_large_image",
      title: `${title} · Books & You`,
      description,
      images: book.coverUrl ? [book.coverUrl] : undefined,
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
  const base = schemaBaseUrl();
  const url = `${base}/book/${slug}`;

  return (
    <>
      {book ? (
        <JsonLd
          data={[
            bookProductSchema({
              name: book.title,
              description: book.description || book.subtitle || "",
              url,
              image: book.coverUrl,
              authorName: book.authorName,
              rating: book.rating,
              reviewCount: book.reviewCount,
              priceGhs: book.priceGhs,
              availability: book.inStock === false ? "OutOfStock" : "InStock",
            }),
            buildBreadcrumbs([
              { name: "Home", path: "/" },
              { name: "Books", path: "/books" },
              { name: book.title },
            ]),
          ]}
        />
      ) : null}
      <BookDetailClient />
    </>
  );
}
