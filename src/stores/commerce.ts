import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { BookFormat, CartItem } from "@/types";

interface CartState {
  items: CartItem[];
  addItem: (bookId: string, format: BookFormat, quantity?: number) => void;
  removeItem: (bookId: string, format: BookFormat) => void;
  updateQuantity: (bookId: string, format: BookFormat, quantity: number) => void;
  clear: () => void;
  itemCount: () => number;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [
        { bookId: "bk-2", format: "paperback", quantity: 1 },
        { bookId: "bk-8", format: "paperback", quantity: 1 },
      ],
      addItem: (bookId, format, quantity = 1) => {
        set((state) => {
          const existing = state.items.find(
            (i) => i.bookId === bookId && i.format === format
          );
          if (existing) {
            return {
              items: state.items.map((i) =>
                i.bookId === bookId && i.format === format
                  ? { ...i, quantity: i.quantity + quantity }
                  : i
              ),
            };
          }
          return { items: [...state.items, { bookId, format, quantity }] };
        });
      },
      removeItem: (bookId, format) => {
        set((state) => ({
          items: state.items.filter(
            (i) => !(i.bookId === bookId && i.format === format)
          ),
        }));
      },
      updateQuantity: (bookId, format, quantity) => {
        if (quantity <= 0) {
          get().removeItem(bookId, format);
          return;
        }
        set((state) => ({
          items: state.items.map((i) =>
            i.bookId === bookId && i.format === format ? { ...i, quantity } : i
          ),
        }));
      },
      clear: () => set({ items: [] }),
      itemCount: () => get().items.reduce((sum, i) => sum + i.quantity, 0),
    }),
    { name: "books-and-you-cart" }
  )
);

interface WishlistState {
  bookIds: string[];
  setBookIds: (ids: string[]) => void;
  toggle: (bookId: string) => void;
  toggleRemote: (bookId: string) => Promise<void>;
  has: (bookId: string) => boolean;
}

export const useWishlistStore = create<WishlistState>()(
  persist(
    (set, get) => ({
      bookIds: ["bk-1", "bk-6", "bk-16", "bk-19"],
      setBookIds: (ids) => set({ bookIds: ids }),
      toggle: (bookId) => {
        set((state) => ({
          bookIds: state.bookIds.includes(bookId)
            ? state.bookIds.filter((id) => id !== bookId)
            : [...state.bookIds, bookId],
        }));
      },
      toggleRemote: async (bookId) => {
        const previous = get().bookIds;
        const optimistic = previous.includes(bookId)
          ? previous.filter((id) => id !== bookId)
          : [...previous, bookId];
        set({ bookIds: optimistic });

        try {
          const res = await fetch("/api/wishlist", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ bookId }),
          });
          if (res.status === 401) {
            // Keep optimistic local toggle when signed out / demo
            return;
          }
          const data = (await res.json()) as { wished?: boolean; error?: string };
          if (!res.ok && data.error) {
            set({ bookIds: previous });
          } else if (typeof data.wished === "boolean") {
            set({
              bookIds: data.wished
                ? Array.from(new Set([...optimistic, bookId]))
                : optimistic.filter((id) => id !== bookId),
            });
          }
        } catch {
          set({ bookIds: previous });
        }
      },
      has: (bookId) => get().bookIds.includes(bookId),
    }),
    { name: "books-and-you-wishlist" }
  )
);

interface RecentlyViewedState {
  bookIds: string[];
  add: (bookId: string) => void;
}

export const useRecentlyViewedStore = create<RecentlyViewedState>()(
  persist(
    (set, get) => ({
      bookIds: ["bk-10", "bk-4", "bk-3"],
      add: (bookId) => {
        const next = [bookId, ...get().bookIds.filter((id) => id !== bookId)].slice(
          0,
          12
        );
        set({ bookIds: next });
      },
    }),
    { name: "books-and-you-recent" }
  )
);
