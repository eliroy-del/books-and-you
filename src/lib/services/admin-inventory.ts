import { books } from "@/data/mock";
import type { AppSupabaseClient } from "@/lib/supabase/typed";
import { db } from "@/lib/supabase/typed";
import { isSupabaseConfigured } from "@/lib/supabase/env";

export type InventoryRow = {
  id: string;
  bookId: string;
  title: string;
  format: string;
  quantity: number;
  reserved: number;
  available: number;
  lowStock: boolean;
  sku?: string;
};

const inventoryStore = new Map<string, InventoryRow>();

function seedMockInventory(): InventoryRow[] {
  if (inventoryStore.size > 0) return [...inventoryStore.values()];

  for (const book of books) {
    for (const format of book.formats) {
      if (format.format === "ebook") continue;
      const id = `${book.id}:${format.format}`;
      const row: InventoryRow = {
        id,
        bookId: book.id,
        title: book.title,
        format: format.format,
        quantity: format.inStock,
        reserved: Math.min(2, Math.floor(format.inStock / 10)),
        available: Math.max(0, format.inStock - Math.min(2, Math.floor(format.inStock / 10))),
        lowStock: format.inStock > 0 && format.inStock < 15,
        sku: `${book.slug?.slice(0, 8) || book.id}-${format.format}`.toUpperCase(),
      };
      inventoryStore.set(id, row);
    }
  }
  return [...inventoryStore.values()];
}

export async function listInventory(
  supabase?: AppSupabaseClient | null,
  opts?: { lowOnly?: boolean; q?: string }
): Promise<InventoryRow[]> {
  if (!supabase || !isSupabaseConfigured()) {
    let rows = seedMockInventory();
    if (opts?.lowOnly) rows = rows.filter((r) => r.lowStock || r.quantity === 0);
    if (opts?.q) {
      const q = opts.q.toLowerCase();
      rows = rows.filter(
        (r) =>
          r.title.toLowerCase().includes(q) ||
          r.format.toLowerCase().includes(q) ||
          (r.sku || "").toLowerCase().includes(q)
      );
    }
    return rows.sort((a, b) => a.quantity - b.quantity);
  }

  const client = db(supabase);
  let query = client
    .from("book_inventory")
    .select("id, book_id, format, quantity, reserved, sku, books(title)")
    .order("quantity", { ascending: true })
    .limit(200);

  if (opts?.lowOnly) query = query.lt("quantity", 15);

  const { data, error } = await query;
  if (error) throw new Error(error.message);

  let rows: InventoryRow[] = ((data || []) as any[]).map((row) => {
    const available = Math.max(0, (row.quantity || 0) - (row.reserved || 0));
    const title = Array.isArray(row.books)
      ? row.books[0]?.title || "Untitled"
      : row.books?.title || "Untitled";
    return {
      id: row.id,
      bookId: row.book_id,
      title,
      format: row.format,
      quantity: row.quantity,
      reserved: row.reserved,
      available,
      lowStock: row.quantity > 0 && row.quantity < 15,
      sku: row.sku || undefined,
    };
  });

  if (opts?.q) {
    const q = opts.q.toLowerCase();
    rows = rows.filter(
      (r) =>
        r.title.toLowerCase().includes(q) ||
        r.format.toLowerCase().includes(q) ||
        (r.sku || "").toLowerCase().includes(q)
    );
  }

  return rows;
}

export async function adjustInventory(
  supabase: AppSupabaseClient | null | undefined,
  input: { id: string; delta: number; reason?: string }
): Promise<{ ok: true; row: InventoryRow } | { ok: false; error: string }> {
  if (!supabase || !isSupabaseConfigured()) {
    seedMockInventory();
    const row = inventoryStore.get(input.id);
    if (!row) return { ok: false, error: "Inventory row not found" };
    const nextQty = Math.max(0, row.quantity + input.delta);
    const updated: InventoryRow = {
      ...row,
      quantity: nextQty,
      available: Math.max(0, nextQty - row.reserved),
      lowStock: nextQty > 0 && nextQty < 15,
    };
    inventoryStore.set(input.id, updated);
    return { ok: true, row: updated };
  }

  const client = db(supabase);
  const { data: current, error: fetchErr } = await client
    .from("book_inventory")
    .select("id, book_id, format, quantity, reserved, sku, books(title)")
    .eq("id", input.id)
    .maybeSingle();

  if (fetchErr || !current) {
    return { ok: false, error: fetchErr?.message || "Inventory row not found" };
  }

  const nextQty = Math.max(0, (current.quantity as number) + input.delta);
  const { data: updated, error } = await client
    .from("book_inventory")
    .update({ quantity: nextQty, updated_at: new Date().toISOString() })
    .eq("id", input.id)
    .select("id, book_id, format, quantity, reserved, sku, books(title)")
    .single();

  if (error || !updated) return { ok: false, error: error?.message || "Update failed" };

  const available = Math.max(0, updated.quantity - updated.reserved);
  const title = Array.isArray(updated.books)
    ? updated.books[0]?.title || "Untitled"
    : (updated.books as { title?: string } | null)?.title || "Untitled";
  return {
    ok: true,
    row: {
      id: updated.id,
      bookId: updated.book_id,
      title,
      format: updated.format,
      quantity: updated.quantity,
      reserved: updated.reserved,
      available,
      lowStock: updated.quantity > 0 && updated.quantity < 15,
      sku: updated.sku || undefined,
    },
  };
}
