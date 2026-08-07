import type { Book, BookFormat, LibraryBook, Order, OrderStatus } from "@/types";
import {
  books as mockBooks,
  formatMoney,
  getBookById as mockGetBookById,
  libraryBooks as mockLibrary,
  sampleOrders,
  searchBooks as mockSearch,
} from "@/data/mock";

export { formatMoney };

/** Map DB row + joins into the UI Book shape used by Phase 1 components. */
export function mapDbBook(row: Record<string, unknown>): Book {
  const authors = (row.book_authors as { authors?: { id: string; name: string; slug: string } | null }[]) ?? [];
  const primary = authors.find((a) => a.authors)?.authors;
  const publisher = row.publishers as { id?: string; name?: string } | null;
  const inventory =
    (row.book_inventory as {
      format: BookFormat;
      price_cents: number;
      compare_at_cents: number | null;
      quantity_on_hand: number;
      quantity_reserved: number;
    }[]) ?? [];
  const categories =
    (row.book_categories as { category_id: string }[]) ?? [];
  const tags = (row.book_tags as { tag: string }[]) ?? [];
  const gallery =
    (row.book_images as { url: string; alt_text?: string | null; sort_order?: number; is_primary?: boolean }[]) ??
    [];
  const sortedGallery = [...gallery].sort(
    (a, b) => Number(a.sort_order ?? 0) - Number(b.sort_order ?? 0)
  );
  const images = sortedGallery.map((img) => ({
    url: String(img.url),
    alt: img.alt_text ? String(img.alt_text) : undefined,
  }));
  const primaryGallery = sortedGallery.find((img) => img.is_primary)?.url;

  return {
    id: String(row.id),
    slug: String(row.slug),
    title: String(row.title),
    subtitle: (row.subtitle as string) || undefined,
    authorId: primary?.id ?? "",
    authorName: primary?.name ?? "Unknown author",
    authorSlug: primary?.slug,
    publisherId: publisher?.id ?? "",
    publisherName: publisher?.name ?? "Unknown publisher",
    categoryIds: categories.map((c) => c.category_id),
    genres: (row.genres as string[]) ?? [],
    description: String(row.description ?? ""),
    synopsis: String(row.synopsis ?? ""),
    isbn: String(row.isbn ?? ""),
    pages: Number(row.pages ?? 0),
    language: String(row.language ?? "English"),
    publishedAt: String(row.published_at ?? ""),
    coverUrl: (row.cover_url as string) || primaryGallery || undefined,
    images: images.length ? images : undefined,
    coverGradient: String(row.cover_gradient ?? "from-[#001F3E] to-[#0D2136]"),
    coverAccent: String(row.cover_accent ?? "#EFC076"),
    formats: inventory.map((inv) => ({
      format: inv.format,
      price: Math.round(inv.price_cents / 100),
      compareAt: inv.compare_at_cents
        ? Math.round(inv.compare_at_cents / 100)
        : undefined,
      inStock: Math.max(inv.quantity_on_hand - inv.quantity_reserved, 0),
    })),
    rating: Number(row.rating_avg ?? 0),
    reviewCount: Number(row.review_count ?? 0),
    tags: tags.map((t) => t.tag),
    featured: Boolean(row.is_featured),
    bestseller: Boolean(row.is_bestseller),
    newArrival: Boolean(row.is_new_arrival),
    staffPick: Boolean(row.is_staff_pick),
    awardWinner: Boolean(row.is_award_winner),
    preorder: Boolean(row.is_preorder),
    releaseDate: (row.release_date as string) || undefined,
    tableOfContents: (row.table_of_contents as string[]) ?? [],
  };
}

export const bookSelect = `
  *,
  publishers ( id, name, slug ),
  book_authors ( is_primary, authors ( id, name, slug ) ),
  book_categories ( category_id ),
  book_tags ( tag ),
  book_images ( url, alt_text, sort_order, is_primary ),
  book_inventory ( format, price_cents, compare_at_cents, quantity_on_hand, quantity_reserved, is_active )
`;

export function centsToCedis(cents: number) {
  return Math.round(cents / 100);
}

export function cedisToCents(amount: number) {
  return Math.round(amount * 100);
}

export function mapOrder(row: Record<string, unknown>): Order {
  const items =
    (row.order_items as {
      book_id: string;
      title: string;
      format: BookFormat;
      quantity: number;
      unit_price_cents: number;
    }[]) ?? [];
  const shipping = row.shipping as
    | { tracking_number?: string; tracking_events?: { status: string; occurred_at: string; note?: string }[] }
    | null
    | undefined;
  const events = shipping?.tracking_events ?? [];

  return {
    id: String(row.id),
    number: String(row.order_number),
    status: String(row.status) as OrderStatus,
    placedAt: String(row.placed_at ?? row.created_at),
    total: centsToCedis(Number(row.total_cents ?? 0)),
    currency: String(row.currency ?? "GHS"),
    items: items.map((i) => ({
      bookId: i.book_id,
      title: i.title,
      format: i.format,
      quantity: i.quantity,
      price: centsToCedis(i.unit_price_cents),
    })),
    shippingAddress:
      typeof row.shipping_address === "object" && row.shipping_address
        ? [
            (row.shipping_address as { line1?: string }).line1,
            (row.shipping_address as { city?: string }).city,
          ]
            .filter(Boolean)
            .join(", ")
        : "-",
    trackingNumber: shipping?.tracking_number,
    timeline: events.map((e) => ({
      status: e.status,
      at: e.occurred_at,
      note: e.note,
    })),
  };
}

export function mockFallbackBooks() {
  return mockBooks;
}

export function mockFallbackBook(idOrSlug: string) {
  return (
    mockGetBookById(idOrSlug) ||
    mockBooks.find((b) => b.slug === idOrSlug) ||
    null
  );
}

export function mockFallbackSearch(q: string) {
  return mockSearch(q);
}

export function mockFallbackOrders() {
  return sampleOrders;
}

export function mockFallbackLibrary(): LibraryBook[] {
  return mockLibrary;
}
