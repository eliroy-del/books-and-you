/**
 * Recommendations service (Phase 3 stub; expands in later AI wiring).
 */
import { listBooks } from "@/lib/services/books";
import type { Book } from "@/types";

export async function getRecommendations(input?: {
  favoriteGenres?: string[];
  wishlistIds?: string[];
  recentIds?: string[];
  limit?: number;
}): Promise<Book[]> {
  const books = await listBooks({ limit: 40 });
  const genres = new Set(input?.favoriteGenres ?? []);
  const wish = new Set(input?.wishlistIds ?? []);
  const recent = new Set(input?.recentIds ?? []);

  const scored = books
    .map((b) => {
      let score = 0;
      if (b.staffPick) score += 2;
      if (b.bestseller) score += 2;
      if (b.genres.some((g) => genres.has(g))) score += 3;
      if (wish.has(b.id)) score += 1;
      if (recent.has(b.id)) score += 1;
      return { b, score };
    })
    .sort((a, c) => c.score - a.score)
    .map((x) => x.b);

  const unique = scored.filter(
    (b, i, arr) => arr.findIndex((x) => x.id === b.id) === i
  );

  return unique.slice(0, input?.limit ?? 8);
}
