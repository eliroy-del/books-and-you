import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { listOrdersWithClient } from "@/lib/services/orders";
import { getLibraryItemsWithClient } from "@/lib/services/library";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { mockFallbackLibrary, mockFallbackOrders } from "@/lib/services/mappers";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const type = searchParams.get("type") ?? "orders";

  if (!isSupabaseConfigured()) {
    if (type === "library") {
      return NextResponse.json({ items: mockFallbackLibrary(), demo: true });
    }
    return NextResponse.json({ orders: mockFallbackOrders(), demo: true });
  }

  const supabase = await tryCreateClient();
  if (!supabase) {
    return NextResponse.json({ error: "Supabase unavailable" }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (type === "library") {
    const items = await getLibraryItemsWithClient(supabase, user.id);
    return NextResponse.json({ items });
  }

  const orders = await listOrdersWithClient(supabase, user.id);
  return NextResponse.json({ orders });
}
