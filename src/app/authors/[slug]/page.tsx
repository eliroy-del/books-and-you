import Link from "next/link";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { BookCard } from "@/components/books/book-card";
import { listAuthors, getAuthorWithBooks } from "@/lib/services/authors";
import { siteName, siteUrl } from "@/lib/seo";

type Props = { params: Promise<{ slug: string }> };

export async function generateStaticParams() {
  const authors = await listAuthors(200);
  return authors.map((a) => ({ slug: a.slug }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const data = await getAuthorWithBooks(slug);
  if (!data) {
    return { title: "Author not found" };
  }
  const { author } = data;
  const description = (
    author.bio || `Books by ${author.name} at Books & You.`
  ).slice(0, 160);
  const url = `${siteUrl}/authors/${slug}`;
  return {
    title: author.name,
    description,
    alternates: { canonical: url },
    openGraph: {
      title: `${author.name} · ${siteName}`,
      description,
      url,
      type: "profile",
    },
    twitter: {
      card: "summary_large_image",
      title: `${author.name} · ${siteName}`,
      description,
    },
  };
}

export default async function AuthorDetailPage({ params }: Props) {
  const { slug } = await params;
  const data = await getAuthorWithBooks(slug);
  if (!data) notFound();

  const { author, books } = data;
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "ProfilePage",
    mainEntity: {
      "@type": "Person",
      name: author.name,
      description: author.bio,
      url: `${siteUrl}/authors/${author.slug}`,
      nationality: author.nationality || undefined,
    },
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <Link href="/authors" className="text-primary text-sm font-medium hover:underline">
        ← All authors
      </Link>
      <div className="mt-6 flex flex-wrap items-start gap-5">
        <div
          className={`flex size-20 items-center justify-center rounded-3xl bg-gradient-to-br text-xl font-bold text-white ${author.avatarColor}`}
        >
          {author.name
            .split(" ")
            .map((p) => p[0])
            .slice(0, 2)
            .join("")}
        </div>
        <div>
          <h1 className="font-heading text-3xl font-bold tracking-tight">{author.name}</h1>
          <p className="text-muted-foreground mt-1 text-sm">{author.nationality}</p>
          <p className="mt-4 max-w-2xl text-sm leading-relaxed">{author.bio}</p>
        </div>
      </div>
      <h2 className="font-heading mt-10 text-xl font-semibold">Books</h2>
      <div className="mt-6 grid grid-cols-2 gap-5 md:grid-cols-3 xl:grid-cols-4">
        {books.map((book, i) => (
          <BookCard key={book.id} book={book} index={i} />
        ))}
      </div>
    </div>
  );
}
