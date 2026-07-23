"use client";

import { useEffect } from "react";
import { useAuth } from "@/components/providers/auth-provider";
import { useWishlistStore } from "@/stores/commerce";

/** Sync local wishlist with Supabase when the user is authenticated. */
export function WishlistSync() {
  const { user, configured, loading } = useAuth();
  const setBookIds = useWishlistStore((s) => s.setBookIds);

  useEffect(() => {
    if (loading || !user || !configured) return;

    let cancelled = false;
    (async () => {
      const res = await fetch("/api/wishlist");
      if (!res.ok || cancelled) return;
      const data = (await res.json()) as { bookIds?: string[] };
      if (data.bookIds) setBookIds(data.bookIds);
    })();

    return () => {
      cancelled = true;
    };
  }, [user, configured, loading, setBookIds]);

  return null;
}
