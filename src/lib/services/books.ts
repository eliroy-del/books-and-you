import { browserDb } from "@/lib/supabase/typed";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import type { Book } from "@/types";
import {
  bookSelect,
  mapDbBook,
  mockFallbackBook,
  mockFallbackBooks,
  mockFallbackSearch,
} from "@/lib/services/mappers";

export async function listBooks(options?: {
  q?: string;
  categorySlug?: string;
  collectionSlug?: string;
  limit?: number;
}): Promise<Book[]> {
  if (!isSupabaseConfigured()) {
    let list = mockFallbackBooks();
    if (options?.q) list = mockFallbackSearch(options.q);
    return list.slice(0, options?.limit ?? list.length);
  }

  const supabase = browserDb();
  if (!supabase) return mockFallbackBooks();

  let query = supabase.from("books").select(bookSelect).limit(options?.limit ?? 100);

  if (options?.q?.trim()) {
    query = query.or(
      `title.ilike.%${options.q}%,isbn.ilike.%${options.q}%,description.ilike.%${options.q}%`
    );
  }

  const { data, error } = await query;
  if (error || !data) {
    console.warn("[books.listBooks]", error?.message);
    return mockFallbackBooks();
  }

  let books = (data as Record<string, unknown>[]).map(mapDbBook);

  if (options?.categorySlug) {
    const { data: cat } = await supabase
      .from("categories")
      .select("id")
      .eq("slug", options.categorySlug)
      .maybeSingle();
    if (cat?.id) {
      books = books.filter((b) => b.categoryIds.includes(String(cat.id)));
    }
  }

  if (options?.collectionSlug) {
    const { data: col } = await supabase
      .from("collections")
      .select("id, collection_books(book_id)")
      .eq("slug", options.collectionSlug)
      .maybeSingle();
    const ids = new Set(
      ((col as { collection_books?: { book_id: string }[] } | null)?.collection_books ?? []).map(
        (c) => c.book_id
      )
    );
    if (ids.size) books = books.filter((b) => ids.has(b.id));
  }

  return books;
}

export async function getBookBySlug(slug: string): Promise<Book | null> {
  if (!isSupabaseConfigured()) return mockFallbackBook(slug);

  const supabase = browserDb();
  if (!supabase) return mockFallbackBook(slug);

  const { data, error } = await supabase
    .from("books")
    .select(bookSelect)
    .eq("slug", slug)
    .maybeSingle();

  if (error || !data) {
    return mockFallbackBook(slug);
  }
  return mapDbBook(data as Record<string, unknown>);
}

export async function getBookById(id: string): Promise<Book | null> {
  if (!isSupabaseConfigured()) return mockFallbackBook(id);

  const supabase = browserDb();
  if (!supabase) return mockFallbackBook(id);

  const { data, error } = await supabase
    .from("books")
    .select(bookSelect)
    .eq("id", id)
    .maybeSingle();

  if (error || !data) return mockFallbackBook(id);
  return mapDbBook(data as Record<string, unknown>);
}

export async function searchBooks(q: string): Promise<Book[]> {
  return listBooks({ q, limit: 24 });
}

export async function getInventoryForBook(bookId: string) {
  if (!isSupabaseConfigured()) {
    const book = mockFallbackBook(bookId);
    return (
      book?.formats.map((f) => ({
        format: f.format,
        price: f.price,
        inStock: f.inStock,
      })) ?? []
    );
  }

  const supabase = browserDb();
  if (!supabase) return [];

  const { data } = await supabase
    .from("book_inventory")
    .select("id, format, price_cents, quantity_on_hand, quantity_reserved, is_active")
    .eq("book_id", bookId)
    .eq("is_active", true);

  return ((data ?? []) as Record<string, unknown>[]).map((row) => ({
    id: String(row.id),
    format: row.format as string,
    price: Math.round(Number(row.price_cents) / 100),
    inStock: Math.max(Number(row.quantity_on_hand) - Number(row.quantity_reserved), 0),
  }));
}
