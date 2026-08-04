import { NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured, getSupabaseEnv } from "@/lib/supabase/env";
import { db } from "@/lib/supabase/typed";
import { bookSelect, mapDbBook } from "@/lib/services/mappers";
import {
  authors as mockAuthors,
  books as mockBooks,
  categories as mockCategories,
  collections as mockCollections,
  getBookBySlug as mockGetBookBySlug,
  getBooksByAuthor as mockGetBooksByAuthor,
  publishers as mockPublishers,
} from "@/data/mock";
import {
  collectDescendantSlugs,
  featuredCollectionDefs,
  findCatalogNode,
  flattenCatalogNav,
  accentForSlug,
} from "@/data/catalog-nav";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const resource = searchParams.get("resource") || "books";
  const slug = searchParams.get("slug") || undefined;
  const q = searchParams.get("q") || undefined;
  const category = searchParams.get("category") || undefined;
  const collection = searchParams.get("collection") || undefined;
  const authorSlug = searchParams.get("author") || undefined;
  const limit = Number(searchParams.get("limit") || 100);

  if (!isSupabaseConfigured()) {
    return NextResponse.json(mockPayload(resource, { slug, q, category, collection, authorSlug, limit }));
  }

  const supabase = (await tryCreateClient()) ?? createAnonFallback();
  if (!supabase) {
    return NextResponse.json(mockPayload(resource, { slug, q, category, collection, authorSlug, limit }));
  }

  const client = db(supabase);

  try {
    if (resource === "books") {
      if (slug) {
        const { data, error } = await client
          .from("books")
          .select(bookSelect)
          .eq("slug", slug)
          .maybeSingle();
        if (error) throw error;
        return NextResponse.json({
          ok: true,
          book: data ? mapDbBook(data as Record<string, unknown>) : null,
          source: "supabase",
        });
      }

      let query = client.from("books").select(bookSelect).limit(limit);
      if (q?.trim()) {
        query = query.or(
          `title.ilike.%${q}%,isbn.ilike.%${q}%,description.ilike.%${q}%`
        );
      }
      const { data, error } = await query;
      if (error) throw error;

      let books = ((data || []) as Record<string, unknown>[]).map(mapDbBook);

      if (category) {
        const node = findCatalogNode(category);
        const slugs = node ? collectDescendantSlugs(node) : [category];
        const { data: cats } = await client
          .from("categories")
          .select("id")
          .in("slug", slugs);
        const catIds = new Set((cats || []).map((c: { id: string }) => String(c.id)));
        if (catIds.size) {
          books = books.filter((b) => b.categoryIds.some((id) => catIds.has(id)));
        }
      }

      if (collection) {
        const { data: col } = await client
          .from("collections")
          .select("id, collection_books(book_id)")
          .eq("slug", collection)
          .maybeSingle();
        const ids = new Set(
          ((col as { collection_books?: { book_id: string }[] } | null)?.collection_books || []).map(
            (c) => c.book_id
          )
        );
        if (ids.size) books = books.filter((b) => ids.has(b.id));
      }

      if (authorSlug) {
        const { data: author } = await client
          .from("authors")
          .select("id")
          .eq("slug", authorSlug)
          .maybeSingle();
        if (author?.id) {
          const { data: links } = await client
            .from("book_authors")
            .select("book_id")
            .eq("author_id", author.id);
          const ids = new Set((links || []).map((l: { book_id: string }) => l.book_id));
          books = books.filter((b) => ids.has(b.id));
        }
      }

      return NextResponse.json({ ok: true, books, source: "supabase" });
    }

    if (resource === "categories") {
      const { data, error } = await client
        .from("categories")
        .select("id, slug, name, description, accent, sort_order, parent_id, depth")
        .order("sort_order");
      if (error) throw error;

      const { data: counts } = await client.from("book_categories").select("category_id");
      const countMap = new Map<string, number>();
      for (const row of counts || []) {
        const id = (row as { category_id: string }).category_id;
        countMap.set(id, (countMap.get(id) || 0) + 1);
      }

      return NextResponse.json({
        ok: true,
        categories: (data || []).map((c: Record<string, unknown>) => ({
          id: String(c.id),
          slug: String(c.slug),
          name: String(c.name),
          description: String(c.description || ""),
          accent: String(c.accent || "from-teal-700 to-emerald-500"),
          parentId: c.parent_id ? String(c.parent_id) : null,
          depth: Number(c.depth ?? 0),
          bookCount: countMap.get(String(c.id)) || 0,
        })),
        source: "supabase",
      });
    }

    if (resource === "authors") {
      if (slug) {
        const { data, error } = await client
          .from("authors")
          .select("*")
          .eq("slug", slug)
          .maybeSingle();
        if (error) throw error;
        if (!data) return NextResponse.json({ ok: true, author: null, books: [], source: "supabase" });

        const { data: links } = await client
          .from("book_authors")
          .select("book_id")
          .eq("author_id", data.id);
        const ids = (links || []).map((l: { book_id: string }) => l.book_id);
        const { data: bookRows } = ids.length
          ? await client.from("books").select(bookSelect).in("id", ids)
          : { data: [] };

        return NextResponse.json({
          ok: true,
          author: mapAuthor(data as Record<string, unknown>, ids.length),
          books: ((bookRows || []) as Record<string, unknown>[]).map(mapDbBook),
          source: "supabase",
        });
      }

      const { data, error } = await client.from("authors").select("*").order("name").limit(limit);
      if (error) throw error;
      const { data: links } = await client.from("book_authors").select("author_id");
      const countMap = new Map<string, number>();
      for (const row of links || []) {
        const id = (row as { author_id: string }).author_id;
        countMap.set(id, (countMap.get(id) || 0) + 1);
      }

      return NextResponse.json({
        ok: true,
        authors: (data || []).map((a: Record<string, unknown>) =>
          mapAuthor(a, countMap.get(String(a.id)) || 0)
        ),
        source: "supabase",
      });
    }

    if (resource === "collections") {
      const { data, error } = await client
        .from("collections")
        .select("id, slug, title, description, collection_books(book_id)")
        .order("sort_order");
      if (error) throw error;
      return NextResponse.json({
        ok: true,
        collections: (data || []).map((c: Record<string, unknown>) => ({
          id: String(c.id),
          slug: String(c.slug),
          title: String(c.title),
          description: String(c.description || ""),
          bookIds: ((c.collection_books as { book_id: string }[]) || []).map((b) => b.book_id),
        })),
        source: "supabase",
      });
    }

    if (resource === "publishers") {
      const { data, error } = await client.from("publishers").select("*").order("name");
      if (error) throw error;
      return NextResponse.json({ ok: true, publishers: data || [], source: "supabase" });
    }

    if (resource === "book-by-id") {
      const id = searchParams.get("id");
      if (!id) return NextResponse.json({ ok: false, error: "id required" }, { status: 400 });
      const { data, error } = await client
        .from("books")
        .select(bookSelect)
        .eq("id", id)
        .maybeSingle();
      if (error) throw error;
      return NextResponse.json({
        ok: true,
        book: data ? mapDbBook(data as Record<string, unknown>) : null,
        source: "supabase",
      });
    }

    return NextResponse.json({ ok: false, error: "Unknown resource" }, { status: 400 });
  } catch (error) {
    console.warn("[api/catalog]", error);
    return NextResponse.json(
      {
        ...mockPayload(resource, { slug, q, category, collection, authorSlug, limit }),
        warning: error instanceof Error ? error.message : "Catalog query failed",
      },
      { status: 200 }
    );
  }
}

function createAnonFallback() {
  const env = getSupabaseEnv();
  if (!env) return null;
  return createSupabaseClient(env.url, env.anonKey);
}

function mapAuthor(a: Record<string, unknown>, bookCount: number) {
  return {
    id: String(a.id),
    slug: String(a.slug),
    name: String(a.name),
    bio: String(a.bio || ""),
    nationality: String(a.nationality || ""),
    bookCount,
    followers: Number(a.followers_count || 0),
    avatarColor: String(a.avatar_color || "from-teal-700 to-emerald-500"),
  };
}

function mockPayload(
  resource: string,
  opts: {
    slug?: string;
    q?: string;
    category?: string;
    collection?: string;
    authorSlug?: string;
    limit: number;
  }
) {
  if (resource === "books") {
    if (opts.slug) {
      return { ok: true, book: mockGetBookBySlug(opts.slug) ?? null, source: "mock" };
    }
    let list = [...mockBooks];
    if (opts.authorSlug) {
      const author = mockAuthors.find((a) => a.slug === opts.authorSlug);
      if (author) list = mockGetBooksByAuthor(author.id);
    }
    return { ok: true, books: list.slice(0, opts.limit), source: "mock" };
  }
  if (resource === "categories") {
    const cats = flattenCatalogNav().map((c, i) => ({
      id: `nav-${c.slug}`,
      slug: c.slug,
      name: c.name,
      description: c.description || "",
      accent: accentForSlug(c.slug),
      parentId: c.parentSlug ? `nav-${c.parentSlug}` : null,
      depth: c.depth,
      bookCount: 0,
      sortOrder: i,
    }));
    return { ok: true, categories: cats.length ? cats : mockCategories, source: "mock" };
  }
  if (resource === "authors") {
    if (opts.slug) {
      const author = mockAuthors.find((a) => a.slug === opts.slug) ?? null;
      const books = author ? mockGetBooksByAuthor(author.id) : [];
      return { ok: true, author, books, source: "mock" };
    }
    return { ok: true, authors: mockAuthors, source: "mock" };
  }
  if (resource === "collections") {
    const cols = featuredCollectionDefs.map((c, i) => ({
      id: `col-${c.slug}`,
      slug: c.slug,
      title: c.title,
      description: c.description,
      bookIds: mockCollections[i % mockCollections.length]?.bookIds ?? [],
    }));
    return { ok: true, collections: cols, source: "mock" };
  }
  if (resource === "publishers") return { ok: true, publishers: mockPublishers, source: "mock" };
  return { ok: false, error: "Unknown resource", source: "mock" };
}
