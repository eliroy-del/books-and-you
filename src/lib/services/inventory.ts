import { browserDb } from "@/lib/supabase/typed";
import { isSupabaseConfigured } from "@/lib/supabase/env";

export type InventorySnapshot = {
  id: string;
  bookId: string;
  format: string;
  quantityOnHand: number;
  quantityReserved: number;
  available: number;
  priceCents: number;
};

export async function getLiveInventory(bookId: string): Promise<InventorySnapshot[]> {
  if (!isSupabaseConfigured()) return [];

  const supabase = browserDb();
  if (!supabase) return [];

  const { data } = await supabase
    .from("book_inventory")
    .select("id, book_id, format, quantity_on_hand, quantity_reserved, price_cents, is_active")
    .eq("book_id", bookId)
    .eq("is_active", true);

  return ((data ?? []) as Record<string, unknown>[]).map((row) => ({
    id: String(row.id),
    bookId: String(row.book_id),
    format: String(row.format),
    quantityOnHand: Number(row.quantity_on_hand),
    quantityReserved: Number(row.quantity_reserved),
    available: Math.max(
      Number(row.quantity_on_hand) - Number(row.quantity_reserved),
      0
    ),
    priceCents: Number(row.price_cents),
  }));
}

export function subscribeInventory(
  bookId: string,
  onChange: (rows: InventorySnapshot[]) => void
) {
  if (!isSupabaseConfigured()) return () => undefined;

  const supabase = browserDb();
  if (!supabase) return () => undefined;

  const channel = supabase
    .channel(`inventory:${bookId}`)
    .on(
      "postgres_changes",
      {
        event: "*",
        schema: "public",
        table: "book_inventory",
        filter: `book_id=eq.${bookId}`,
      },
      async () => {
        onChange(await getLiveInventory(bookId));
      }
    )
    .subscribe();

  return () => {
    void supabase.removeChannel(channel);
  };
}

export function subscribeOrderStatus(
  orderId: string,
  onChange: (status: string) => void
) {
  if (!isSupabaseConfigured()) return () => undefined;

  const supabase = browserDb();
  if (!supabase) return () => undefined;

  const channel = supabase
    .channel(`order:${orderId}`)
    .on(
      "postgres_changes",
      {
        event: "UPDATE",
        schema: "public",
        table: "orders",
        filter: `id=eq.${orderId}`,
      },
      (payload: { new: Record<string, unknown> }) => {
        const status = payload.new?.status;
        if (typeof status === "string") onChange(status);
      }
    )
    .subscribe();

  return () => {
    void supabase.removeChannel(channel);
  };
}
