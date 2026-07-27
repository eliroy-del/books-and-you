import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { ArrowLeft, Clock } from "lucide-react";
import {
  formatBlogDate,
  getAllBlogPosts,
  getBlogPostBySlug,
} from "@/data/blog";
import { siteName, siteUrl } from "@/lib/seo";

type Props = {
  params: Promise<{ slug: string }>;
};

export function generateStaticParams() {
  return getAllBlogPosts().map((p) => ({ slug: p.slug }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const post = getBlogPostBySlug(slug);
  if (!post) return { title: "Post not found" };

  const url = `${siteUrl}/blog/${post.slug}`;
  return {
    title: post.title,
    description: post.excerpt,
    alternates: { canonical: url },
    openGraph: {
      type: "article",
      url,
      title: `${post.title} · ${siteName}`,
      description: post.excerpt,
      publishedTime: post.publishedAt,
      authors: [post.author],
      tags: post.tags,
    },
    twitter: {
      card: "summary_large_image",
      title: `${post.title} · ${siteName}`,
      description: post.excerpt,
    },
  };
}

export default async function BlogPostPage({ params }: Props) {
  const { slug } = await params;
  const post = getBlogPostBySlug(slug);
  if (!post) notFound();

  const related = getAllBlogPosts()
    .filter((p) => p.slug !== post.slug)
    .slice(0, 3);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: post.title,
    description: post.excerpt,
    datePublished: post.publishedAt,
    author: { "@type": "Person", name: post.author },
    mainEntityOfPage: `${siteUrl}/blog/${post.slug}`,
    publisher: {
      "@type": "Organization",
      name: siteName,
      logo: { "@type": "ImageObject", url: `${siteUrl}/icon.png` },
    },
  };

  return (
    <article className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <Link
        href="/blog"
        className="text-muted-foreground hover:text-primary inline-flex items-center gap-1.5 text-sm"
      >
        <ArrowLeft className="size-3.5" />
        Back to blog
      </Link>

      <header className="mx-auto mt-6 max-w-3xl">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">
          {post.category}
        </p>
        <h1 className="font-heading mt-3 text-3xl font-bold tracking-tight text-balance sm:text-4xl lg:text-5xl">
          {post.title}
        </h1>
        <p className="text-muted-foreground mt-4 text-base leading-relaxed sm:text-lg">
          {post.excerpt}
        </p>
        <div className="text-muted-foreground mt-5 flex flex-wrap items-center gap-x-4 gap-y-2 text-sm">
          <span className="font-medium text-foreground">{post.author}</span>
          <time dateTime={post.publishedAt}>{formatBlogDate(post.publishedAt)}</time>
          <span className="inline-flex items-center gap-1">
            <Clock className="size-3.5" />
            {post.readingMinutes} min read
          </span>
        </div>
      </header>

      <div
        className={`mx-auto mt-10 max-w-3xl overflow-hidden rounded-[1.75rem] bg-gradient-to-br ${post.coverGradient} shadow-elevated`}
      >
        <div className="flex min-h-[180px] items-end p-6 sm:min-h-[220px] sm:p-8">
          <div className="flex flex-wrap gap-2">
            {post.tags.map((tag) => (
              <span
                key={tag}
                className="rounded-full bg-white/15 px-3 py-1 text-xs font-medium text-white backdrop-blur"
              >
                {tag}
              </span>
            ))}
          </div>
        </div>
      </div>

      <div className="prose-bay mx-auto mt-10 max-w-3xl space-y-5">
        {post.content.map((paragraph) => (
          <p key={paragraph.slice(0, 48)} className="text-base leading-relaxed text-foreground/90">
            {paragraph}
          </p>
        ))}
      </div>

      {related.length > 0 ? (
        <section className="mx-auto mt-16 max-w-3xl border-t border-border/70 pt-10">
          <h2 className="font-heading text-xl font-semibold">More from the journal</h2>
          <ul className="mt-5 space-y-4">
            {related.map((p) => (
              <li key={p.slug}>
                <Link
                  href={`/blog/${p.slug}`}
                  className="group block rounded-2xl border border-border/60 bg-card px-4 py-4 transition hover:border-primary/30"
                >
                  <p className="text-muted-foreground text-xs">
                    {p.category} · {formatBlogDate(p.publishedAt)}
                  </p>
                  <p className="font-heading mt-1 font-semibold group-hover:text-primary">
                    {p.title}
                  </p>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </article>
  );
}
