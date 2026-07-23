"use client";

import { useEffect, useState } from "react";
import { Radio } from "lucide-react";
import { subscribeInventory, getLiveInventory } from "@/lib/services/inventory";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import type { BookFormat } from "@/types";

type Props = {
  bookId: string;
  onStock?: (format: BookFormat, available: number) => void;
};

export function LiveInventoryBadge({ bookId, onStock }: Props) {
  const [live, setLive] = useState(false);
  const [available, setAvailable] = useState<number | null>(null);

  useEffect(() => {
    if (!isSupabaseConfigured()) return;

    let mounted = true;
    (async () => {
      const rows = await getLiveInventory(bookId);
      if (!mounted) return;
      const total = rows.reduce((s, r) => s + r.available, 0);
      setAvailable(total);
      setLive(true);
      rows.forEach((r) => onStock?.(r.format as BookFormat, r.available));
    })();

    const unsub = subscribeInventory(bookId, (rows) => {
      const total = rows.reduce((s, r) => s + r.available, 0);
      setAvailable(total);
      setLive(true);
      rows.forEach((r) => onStock?.(r.format as BookFormat, r.available));
    });

    return () => {
      mounted = false;
      unsub();
    };
  }, [bookId, onStock]);

  if (!live || available == null) return null;

  return (
    <span className="text-success inline-flex items-center gap-1.5 text-xs font-medium">
      <Radio className="size-3 animate-pulse" />
      Live stock · {available} available
    </span>
  );
}
