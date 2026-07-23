import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import {
  getWishlistBookIdsWithClient,
  toggleWishlistItemWithClient,
} from "@/lib/services/wishlist";
import { isSupabaseConfigured } from "@/lib/supabase/env";

export async function GET() {
  if (!isSupabaseConfigured()) {
    return NextResponse.json({ bookIds: [], demo: true });
  }

  const supabase = await tryCreateClient();
  if (!supabase) {
    return NextResponse.json({ bookIds: [] }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ bookIds: [] }, { status: 401 });
  }

  const bookIds = await getWishlistBookIdsWithClient(supabase, user.id);
  return NextResponse.json({ bookIds });
}

export async function POST(request: Request) {
  const { bookId } = (await request.json()) as { bookId?: string };
  if (!bookId) {
    return NextResponse.json({ error: "bookId required" }, { status: 400 });
  }

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ wished: true, demo: true });
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

  const result = await toggleWishlistItemWithClient(supabase, user.id, bookId);
  return NextResponse.json(result, { status: result.error ? 400 : 200 });
}
