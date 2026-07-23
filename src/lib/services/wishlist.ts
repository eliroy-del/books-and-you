import type { SupabaseClient } from "@supabase/supabase-js";
import { db } from "@/lib/supabase/typed";

export async function getWishlistBookIdsWithClient(
  supabase: SupabaseClient,
  userId: string
): Promise<string[]> {
  const client = db(supabase);
  const { data: wishlist } = await client
    .from("wishlists")
    .select("id")
    .eq("user_id", userId)
    .eq("is_default", true)
    .maybeSingle();

  if (!wishlist?.id) return [];

  const { data: items } = await client
    .from("wishlist_items")
    .select("book_id")
    .eq("wishlist_id", wishlist.id);

  return ((items ?? []) as { book_id: string }[]).map((i) => String(i.book_id));
}

export async function toggleWishlistItemWithClient(
  supabase: SupabaseClient,
  userId: string,
  bookId: string
): Promise<{ wished: boolean; error?: string }> {
  const client = db(supabase);
  let { data: wishlist } = await client
    .from("wishlists")
    .select("id")
    .eq("user_id", userId)
    .eq("is_default", true)
    .maybeSingle();

  if (!wishlist?.id) {
    const { data: created, error } = await client
      .from("wishlists")
      .insert({ user_id: userId, name: "Default", is_default: true })
      .select("id")
      .single();
    if (error || !created) return { wished: false, error: error?.message };
    wishlist = created;
  }

  const { data: existing } = await client
    .from("wishlist_items")
    .select("id")
    .eq("wishlist_id", wishlist.id)
    .eq("book_id", bookId)
    .maybeSingle();

  if (existing?.id) {
    const { error } = await client.from("wishlist_items").delete().eq("id", existing.id);
    return error ? { wished: true, error: error.message } : { wished: false };
  }

  const { error } = await client.from("wishlist_items").insert({
    wishlist_id: wishlist.id,
    book_id: bookId,
  });

  return error ? { wished: false, error: error.message } : { wished: true };
}

export async function trackReadingHistoryWithClient(
  supabase: SupabaseClient,
  userId: string,
  bookId: string
) {
  const client = db(supabase);
  await client.from("reading_history").insert({
    user_id: userId,
    book_id: bookId,
    source: "web",
  });
}
