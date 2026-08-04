import Link from "next/link";
import type { Metadata } from "next";
import { ArrowRight, Clock } from "lucide-react";
import { formatBlogDate, getAllBlogPosts } from "@/data/blog";
import { siteDescription, siteName, siteUrl } from "@/lib/seo";

export const metadata: Metadata = {
  title: "Blog",
  description:
    "Essays, reading guides, and bookstore notes from Books & You: habits, African literature, formats, gifting, and education.",
  alternates: { canonical: "/blog" },
  openGraph: {
    title: `Blog · ${siteName}`,
    description:
      "Essays, reading guides, and bookstore notes from Books & You.",
    url: `${siteUrl}/blog`,
    type: "website",
  },
};

export default function BlogPage() {
  const posts = getAllBlogPosts();

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Blog",
    name: `${siteName} Blog`,
    description: siteDescription,
    url: `${siteUrl}/blog`,
    blogPost: posts.map((p) => ({
      "@type": "BlogPosting",
      headline: p.title,
      description: p.excerpt,
      datePublished: p.publishedAt,
      author: { "@type": "Person", name: p.author },
      url: `${siteUrl}/blog/${p.slug}`,
    })),
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <div className="mx-auto max-w-2xl text-center">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">
          Books & You Journal
        </p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          Stories for curious readers
        </h1>
        <p className="text-muted-foreground mt-3">
          Reading habits, African literature, formats, gifting, and education.
          Notes from our shelves to yours.
        </p>
      </div>

      <div className="mt-12 grid gap-6 md:grid-cols-2 xl:grid-cols-3">
        {posts.map((post, index) => (
          <article
            key={post.slug}
            className={
              index === 0
                ? "md:col-span-2 xl:col-span-2"
                : undefined
            }
          >
            <Link
              href={`/blog/${post.slug}`}
              className="group flex h-full flex-col overflow-hidden rounded-3xl border border-border/70 bg-card shadow-soft transition hover:-translate-y-0.5 hover:shadow-elevated"
            >
              <div
                className={`relative overflow-hidden bg-gradient-to-br ${post.coverGradient} ${
                  index === 0 ? "min-h-[200px] sm:min-h-[240px]" : "min-h-[140px]"
                }`}
              >
                <div
                  className="absolute inset-x-6 bottom-0 h-1/2 rounded-t-2xl opacity-90"
                  style={{ background: `linear-gradient(180deg, transparent, ${post.coverAccent}33)` }}
                />
                <div className="absolute top-4 left-4">
                  <span className="rounded-full bg-white/15 px-3 py-1 text-xs font-medium text-white backdrop-blur">
                    {post.category}
                  </span>
                </div>
              </div>
              <div className="flex flex-1 flex-col p-5 sm:p-6">
                <div className="text-muted-foreground flex flex-wrap items-center gap-x-3 gap-y-1 text-xs">
                  <time dateTime={post.publishedAt}>{formatBlogDate(post.publishedAt)}</time>
                  <span className="inline-flex items-center gap-1">
                    <Clock className="size-3.5" />
                    {post.readingMinutes} min read
                  </span>
                </div>
                <h2
                  className={`font-heading mt-3 font-semibold tracking-tight group-hover:text-primary ${
                    index === 0 ? "text-2xl sm:text-3xl" : "text-xl"
                  }`}
                >
                  {post.title}
                </h2>
                <p
                  className={`text-muted-foreground mt-2 text-sm leading-relaxed ${
                    index === 0 ? "line-clamp-3" : "line-clamp-2"
                  }`}
                >
                  {post.excerpt}
                </p>
                <div className="mt-auto flex items-center justify-between pt-5">
                  <p className="text-sm font-medium">{post.author}</p>
                  <span className="text-primary inline-flex items-center gap-1 text-sm font-medium">
                    Read
                    <ArrowRight className="size-3.5 transition group-hover:translate-x-0.5" />
                  </span>
                </div>
              </div>
            </Link>
          </article>
        ))}
      </div>
    </div>
  );
}
