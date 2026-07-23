import type { SupabaseClient } from "@supabase/supabase-js";
import type { LibraryBook } from "@/types";
import { mockFallbackLibrary } from "@/lib/services/mappers";
import { db } from "@/lib/supabase/typed";

export async function getLibraryItemsWithClient(
  supabase: SupabaseClient,
  userId: string
): Promise<LibraryBook[]> {
  const client = db(supabase);
  const { data, error } = await client
    .from("library_items")
    .select(
      "book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count"
    )
    .eq("user_id", userId)
    .order("last_opened_at", { ascending: false });

  if (error || !data) {
    console.warn("[library]", error?.message);
    return mockFallbackLibrary();
  }

  return (data as Record<string, unknown>[]).map((row) => ({
    bookId: String(row.book_id),
    format: row.format as "ebook" | "audiobook",
    progress: Number(row.progress_percent ?? 0),
    lastOpenedAt: String(row.last_opened_at ?? new Date().toISOString()),
    bookmarks: Number(row.bookmarks_count ?? 0),
    highlights: Number(row.highlights_count ?? 0),
  }));
}

export async function getLibraryItems(userId: string): Promise<LibraryBook[]> {
  if (userId === "demo-user-local") return mockFallbackLibrary();
  return mockFallbackLibrary();
}
