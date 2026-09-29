import { createClient } from "@supabase/supabase-js";
import {
  authors as mockAuthors,
  getAuthorBySlug,
  getBooksByAuthor,
} from "@/data/mock";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";
import { bookSelect, isUploadedBook, mapDbBook } from "@/lib/services/mappers";
import type { Author, Book } from "@/types";

function mapAuthor(a: Record<string, unknown>, bookCount: number): Author {
  return {
    id: String(a.id),
    slug: String(a.slug),
    name: String(a.name),
    bio: String(a.bio || ""),
    nationality: String(a.nationality || ""),
    bookCount,
    followers: Number(a.followers_count || 0),
    avatarColor: String(a.avatar_color || "from-[#001f3e] to-[#3d5a80]"),
  };
}

export async function listAuthors(limit = 50): Promise<Author[]> {
  if (isSupabaseConfigured()) {
    const env = getSupabaseEnv();
    if (env) {
      try {
        const supabase = createClient(env.url, env.anonKey);
        const { data, error } = await supabase
          .from("authors")
          .select("*")
          .order("name")
          .limit(limit);
        if (!error && data) {
          const { data: links } = await supabase
            .from("books")
            .select("book_authors(author_id)")
            .not("cover_url", "is", null);
          const countMap = new Map<string, number>();
          for (const row of links || []) {
            const authors =
              (row as { book_authors?: { author_id: string }[] }).book_authors || [];
            for (const link of authors) {
              countMap.set(link.author_id, (countMap.get(link.author_id) || 0) + 1);
            }
          }
          return data
            .map((a) => mapAuthor(a as Record<string, unknown>, countMap.get(String(a.id)) || 0))
            .filter((author) => author.bookCount > 0);
        }
      } catch {
        // fall through
      }
    }
  }
  return mockAuthors.slice(0, limit);
}

export async function getAuthorWithBooks(
  slug: string
): Promise<{ author: Author; books: Book[] } | null> {
  if (isSupabaseConfigured()) {
    const env = getSupabaseEnv();
    if (env) {
      try {
        const supabase = createClient(env.url, env.anonKey);
        const { data, error } = await supabase
          .from("authors")
          .select("*")
          .eq("slug", slug)
          .maybeSingle();
        if (!error && data) {
          const { data: links } = await supabase
            .from("book_authors")
            .select("book_id")
            .eq("author_id", data.id);
          const ids = (links || []).map((l: { book_id: string }) => l.book_id);
          const { data: bookRows } = ids.length
            ? await supabase
                .from("books")
                .select(bookSelect)
                .in("id", ids)
                .not("cover_url", "is", null)
            : { data: [] as Record<string, unknown>[] };
          return {
            author: mapAuthor(data as Record<string, unknown>, (bookRows || []).length),
            books: ((bookRows || []) as Record<string, unknown>[])
              .map(mapDbBook)
              .filter(isUploadedBook),
          };
        }
        if (!error && !data) return null;
      } catch {
        // fall through
      }
    }
  }

  const author = getAuthorBySlug(slug);
  if (!author) return null;
  const books = getBooksByAuthor(author.id).filter(isUploadedBook);
  return { author: { ...author, bookCount: books.length }, books };
}
