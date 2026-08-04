import { writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";
import { createRequire } from "node:module";

// Load TS module via tsx register when executed with: npx tsx scripts/generate-catalog-taxonomy-sql.mjs
const { flattenCatalogNav, featuredCollectionDefs, accentForSlug } = await import(
  "../src/data/catalog-nav.ts"
);

const rows = flattenCatalogNav();
const esc = (s) => String(s).replace(/'/g, "''");

const lines = [];
lines.push("-- School & stationery catalog taxonomy");
lines.push(
  "ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS parent_id uuid REFERENCES public.categories(id) ON DELETE CASCADE;"
);
lines.push(
  "CREATE INDEX IF NOT EXISTS categories_parent_id_idx ON public.categories(parent_id);"
);
lines.push(
  "ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS depth integer NOT NULL DEFAULT 0;"
);
lines.push("");
lines.push("-- Clear old taxonomy links and rows (preserve books)");
lines.push("DELETE FROM public.book_categories;");
lines.push("DELETE FROM public.collection_books;");
lines.push("DELETE FROM public.collections;");
lines.push("DELETE FROM public.categories;");
lines.push("");
lines.push("CREATE TEMP TABLE nodes (");
lines.push("  slug text,");
lines.push("  name text,");
lines.push("  description text,");
lines.push("  accent text,");
lines.push("  sort_order integer,");
lines.push("  parent_slug text,");
lines.push("  depth integer");
lines.push(");");
lines.push("");
lines.push(
  "INSERT INTO nodes (slug, name, description, accent, sort_order, parent_slug, depth) VALUES"
);

const values = rows.map((r, i) => {
  const desc = r.description ?? r.name;
  return `  ('${esc(r.slug)}', '${esc(r.name)}', '${esc(desc)}', '${esc(accentForSlug(r.slug))}', ${i}, ${
    r.parentSlug ? `'${esc(r.parentSlug)}'` : "NULL"
  }, ${r.depth})`;
});
lines.push(`${values.join(",\n")};`);
lines.push("");
lines.push(
  "INSERT INTO public.categories (slug, name, description, accent, sort_order, depth, is_featured)"
);
lines.push("SELECT slug, name, description, accent, sort_order, depth, depth = 0");
lines.push("FROM nodes;");
lines.push("");
lines.push("UPDATE public.categories c");
lines.push("SET parent_id = p.id");
lines.push("FROM nodes n");
lines.push("JOIN public.categories p ON p.slug = n.parent_slug");
lines.push("WHERE c.slug = n.slug AND n.parent_slug IS NOT NULL;");
lines.push("");
lines.push(
  "INSERT INTO public.collections (slug, title, description, is_featured, sort_order) VALUES"
);
lines.push(
  featuredCollectionDefs
    .map(
      (c, i) =>
        `  ('${esc(c.slug)}', '${esc(c.title)}', '${esc(c.description)}', true, ${i})`
    )
    .join(",\n")
);
lines.push(";");
lines.push("");
lines.push("-- Soft-assign existing books into nearest new categories");
lines.push("INSERT INTO public.book_categories (book_id, category_id)");
lines.push("SELECT b.id, c.id");
lines.push("FROM public.books b");
lines.push("CROSS JOIN LATERAL (");
lines.push("  SELECT id FROM public.categories");
lines.push("  WHERE slug = CASE");
lines.push(
  "    WHEN b.title ILIKE '%math%' OR b.title ILIKE '%algebra%' THEN 'primary-mathematics'"
);
lines.push("    WHEN b.title ILIKE '%science%' THEN 'primary-science'");
lines.push(
  "    WHEN b.title ILIKE '%english%' OR b.title ILIKE '%grammar%' THEN 'primary-english-language'"
);
lines.push(
  "    WHEN lower(array_to_string(b.genres, ' ')) LIKE '%child%' THEN 'nursery-storybooks'"
);
lines.push(
  "    WHEN lower(array_to_string(b.genres, ' ')) LIKE '%academic%' OR lower(array_to_string(b.genres, ' ')) LIKE '%education%' THEN 'primary-workbooks'"
);
lines.push("    ELSE 'nursery-storybooks'");
lines.push("  END");
lines.push("  LIMIT 1");
lines.push(") c");
lines.push("WHERE c.id IS NOT NULL");
lines.push("ON CONFLICT DO NOTHING;");
lines.push("");
lines.push(
  "-- Fallback: any uncategorized book → nursery storybooks"
);
lines.push("INSERT INTO public.book_categories (book_id, category_id)");
lines.push("SELECT b.id, c.id FROM public.books b");
lines.push("JOIN public.categories c ON c.slug = 'nursery-storybooks'");
lines.push(
  "WHERE NOT EXISTS (SELECT 1 FROM public.book_categories bc WHERE bc.book_id = b.id)"
);
lines.push("ON CONFLICT DO NOTHING;");
lines.push("");
lines.push("-- Seed featured collections with sample books");
lines.push(
  "INSERT INTO public.collection_books (collection_id, book_id, sort_order)"
);
lines.push(
  "SELECT col.id, b.id, (row_number() OVER (PARTITION BY col.id ORDER BY b.created_at DESC) - 1)::int"
);
lines.push("FROM public.collections col");
lines.push("CROSS JOIN LATERAL (");
lines.push("  SELECT id, created_at FROM public.books ORDER BY created_at DESC LIMIT 12");
lines.push(") b");
lines.push("ON CONFLICT DO NOTHING;");

const out = "supabase/migrations/20260804004500_school_catalog_taxonomy.sql";
writeFileSync(out, `${lines.join("\n")}\n`);
console.log(`wrote ${out} (${rows.length} categories, ${featuredCollectionDefs.length} collections)`);

// silence unused
void pathToFileURL;
void createRequire;
