import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { slugify, type CoverDraft } from "@/lib/catalog/identify-cover";

function adminClient(): SupabaseClient {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) throw new Error("Supabase service role is not configured.");
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
}

async function uniqueSlug(supabase: SupabaseClient, base: string) {
  let slug = base || "product";
  for (let n = 2; n < 20; n++) {
    const { data } = await supabase.from("books").select("id").eq("slug", slug).maybeSingle();
    if (!data) return slug;
    slug = `${base}-${n}`;
  }
  return `${base}-${Date.now()}`;
}

export async function publishProduct(input: {
  draft: CoverDraft;
  priceCedis: number;
  bytes: Buffer;
  mime: string;
}) {
  const supabase = adminClient();
  const title = input.draft.title.trim();
  if (!title) throw new Error("Title is required.");
  if (!Number.isFinite(input.priceCedis) || input.priceCedis <= 0) {
    throw new Error("Enter a price in cedis.");
  }

  const slug = await uniqueSlug(supabase, slugify(title));
  const ext = input.mime === "image/png" ? "png" : input.mime === "image/webp" ? "webp" : "jpg";
  const path = `${slug}/front.${ext}`;

  const upload = await supabase.storage.from("product-covers").upload(path, input.bytes, {
    contentType: input.mime,
    upsert: true,
  });
  if (upload.error) throw new Error(upload.error.message);
  const coverUrl = supabase.storage.from("product-covers").getPublicUrl(path).data.publicUrl;

  let publisherId: string | null = null;
  const publisherName = input.draft.publisher.trim();
  if (publisherName) {
    const publisherSlug = slugify(publisherName);
    const { data: publisher, error } = await supabase
      .from("publishers")
      .upsert(
        { slug: publisherSlug, name: publisherName, country: "Ghana" },
        { onConflict: "slug" }
      )
      .select("id")
      .single();
    if (error) throw new Error(error.message);
    publisherId = publisher.id;
  }

  const { data: book, error: bookError } = await supabase
    .from("books")
    .insert({
      slug,
      title,
      subtitle: input.draft.subtitle || null,
      description: input.draft.description || title,
      synopsis: input.draft.description || title,
      language: input.draft.language || "English",
      publisher_id: publisherId,
      cover_url: coverUrl,
      cover_gradient: "from-[#001F3E] via-[#1E3A5F] to-[#EFC076]",
      cover_accent: "#001F3E",
      genres: input.draft.categorySlugs.slice(0, 4),
      is_featured: true,
      is_new_arrival: true,
      metadata: { source: "admin-upload" },
    })
    .select("id, slug")
    .single();
  if (bookError || !book) throw new Error(bookError?.message || "Could not save the product.");

  for (const [index, name] of input.draft.authors.entries()) {
    const authorSlug = slugify(name);
    if (!authorSlug) continue;
    const { data: author, error } = await supabase
      .from("authors")
      .upsert(
        { slug: authorSlug, name, nationality: "Ghanaian", is_verified: false },
        { onConflict: "slug" }
      )
      .select("id")
      .single();
    if (error || !author) continue;
    await supabase.from("book_authors").upsert(
      {
        book_id: book.id,
        author_id: author.id,
        is_primary: index === 0,
        sort_order: index,
      },
      { onConflict: "book_id,author_id" }
    );
  }

  if (input.draft.categorySlugs.length) {
    const { data: cats } = await supabase
      .from("categories")
      .select("id, slug")
      .in("slug", input.draft.categorySlugs);
    if (cats?.length) {
      await supabase.from("book_categories").upsert(
        cats.map((c) => ({ book_id: book.id, category_id: c.id })),
        { onConflict: "book_id,category_id" }
      );
    }
  }

  const { error: inventoryError } = await supabase.from("book_inventory").upsert(
    {
      book_id: book.id,
      format: "paperback",
      sku: `UP-${slug}`.slice(0, 48),
      price_cents: Math.round(input.priceCedis * 100),
      currency: "GHS",
      quantity_on_hand: 100,
      quantity_reserved: 0,
      low_stock_threshold: 10,
      is_active: true,
    },
    { onConflict: "book_id,format" }
  );
  if (inventoryError) throw new Error(inventoryError.message);

  await supabase.from("book_images").insert({
    book_id: book.id,
    url: coverUrl,
    alt_text: `${title} front cover`,
    sort_order: 0,
    is_primary: true,
  });

  const { data: collection } = await supabase
    .from("collections")
    .select("id")
    .eq("slug", "new-arrivals")
    .maybeSingle();
  if (collection?.id) {
    await supabase
      .from("collection_books")
      .upsert(
        { collection_id: collection.id, book_id: book.id, sort_order: 0 },
        { onConflict: "collection_id,book_id" }
      );
  }

  return { slug: book.slug as string, coverUrl };
}
