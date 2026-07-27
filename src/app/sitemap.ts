import type { MetadataRoute } from "next";
import { createClient } from "@supabase/supabase-js";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";
import { authors as mockAuthors, books as mockBooks, categories as mockCategories } from "@/data/mock";
import { getAllBlogPosts } from "@/data/blog";
import { siteUrl } from "@/lib/seo";

export const revalidate = 3600;

type SlugRow = { slug: string; updated_at?: string | null };

async function fetchSlugs(): Promise<{
  books: SlugRow[];
  authors: SlugRow[];
  categories: SlugRow[];
}> {
  if (isSupabaseConfigured()) {
    const env = getSupabaseEnv();
    if (env) {
      try {
        const supabase = createClient(env.url, env.anonKey);
        const [books, authors, categories] = await Promise.all([
          supabase.from("books").select("slug, updated_at").limit(5000),
          supabase.from("authors").select("slug").limit(2000),
          supabase.from("categories").select("slug").limit(500),
        ]);
        if (!books.error) {
          return {
            books: books.data ?? [],
            authors: authors.data ?? [],
            categories: categories.data ?? [],
          };
        }
      } catch {
        // fall through to mock
      }
    }
  }
  return {
    books: mockBooks.map((b) => ({ slug: b.slug })),
    authors: mockAuthors.map((a) => ({ slug: a.slug })),
    categories: mockCategories.map((c) => ({ slug: c.slug })),
  };
}

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const now = new Date();
  const { books, authors, categories } = await fetchSlugs();

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: `${siteUrl}/`, lastModified: now, changeFrequency: "daily", priority: 1 },
    { url: `${siteUrl}/books`, lastModified: now, changeFrequency: "daily", priority: 0.9 },
    { url: `${siteUrl}/categories`, lastModified: now, changeFrequency: "weekly", priority: 0.7 },
    { url: `${siteUrl}/authors`, lastModified: now, changeFrequency: "weekly", priority: 0.7 },
    { url: `${siteUrl}/blog`, lastModified: now, changeFrequency: "weekly", priority: 0.7 },
    { url: `${siteUrl}/contact`, lastModified: now, changeFrequency: "monthly", priority: 0.6 },
    { url: `${siteUrl}/support`, lastModified: now, changeFrequency: "monthly", priority: 0.4 },
  ];

  const bookRoutes: MetadataRoute.Sitemap = books.map((b) => ({
    url: `${siteUrl}/book/${b.slug}`,
    lastModified: b.updated_at ? new Date(b.updated_at) : now,
    changeFrequency: "weekly",
    priority: 0.8,
  }));

  const authorRoutes: MetadataRoute.Sitemap = authors.map((a) => ({
    url: `${siteUrl}/authors/${a.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.6,
  }));

  const categoryRoutes: MetadataRoute.Sitemap = categories.map((c) => ({
    url: `${siteUrl}/books?category=${c.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.5,
  }));

  const blogRoutes: MetadataRoute.Sitemap = getAllBlogPosts().map((p) => ({
    url: `${siteUrl}/blog/${p.slug}`,
    lastModified: new Date(p.publishedAt),
    changeFrequency: "monthly",
    priority: 0.65,
  }));

  return [...staticRoutes, ...bookRoutes, ...authorRoutes, ...categoryRoutes, ...blogRoutes];
}
