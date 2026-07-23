import {
  books,
  formatMoney,
  sampleOrders,
  authors,
  categories,
  currentUser,
  publishers,
  reviews,
} from "@/data/mock";
import type { AppSupabaseClient } from "@/lib/supabase/typed";
import { db } from "@/lib/supabase/typed";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import {
  ALL_PERMISSIONS,
  ROLE_PERMISSIONS,
  STAFF_ROLES,
  roleLabel,
  type RoleKey,
} from "@/lib/admin/permissions";

export type AdminOrderRow = {
  id: string;
  number: string;
  status: string;
  totalLabel: string;
  itemCount: number;
  placedAt: string;
  customer?: string;
};

export async function listAdminOrders(
  supabase?: AppSupabaseClient | null
): Promise<AdminOrderRow[]> {
  if (!supabase || !isSupabaseConfigured()) {
    return sampleOrders.map((o) => ({
      id: o.id,
      number: o.number,
      status: o.status,
      totalLabel: formatMoney(o.total),
      itemCount: o.items.length,
      placedAt: o.placedAt,
      customer: currentUser.name,
    }));
  }

  const { data, error } = await db(supabase)
    .from("orders")
    .select(
      "id, order_number, status, total_cents, created_at, profiles(full_name, email), order_items(id)"
    )
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) throw new Error(error.message);

  return ((data || []) as any[]).map((o) => ({
    id: o.id,
    number: o.order_number,
    status: o.status,
    totalLabel: formatMoney((o.total_cents || 0) / 100),
    itemCount: o.order_items?.length ?? 0,
    placedAt: o.created_at,
    customer:
      (Array.isArray(o.profiles) ? o.profiles[0]?.full_name : o.profiles?.full_name) ||
      (Array.isArray(o.profiles) ? o.profiles[0]?.email : o.profiles?.email) ||
      "Customer",
  }));
}

export async function updateAdminOrderStatus(
  supabase: AppSupabaseClient | null | undefined,
  input: { id: string; status: string }
): Promise<{ ok: true } | { ok: false; error: string }> {
  if (!supabase || !isSupabaseConfigured()) {
    const order = sampleOrders.find((o) => o.id === input.id);
    if (!order) return { ok: false, error: "Order not found" };
    order.status = input.status as typeof order.status;
    return { ok: true };
  }

  const { error } = await db(supabase)
    .from("orders")
    .update({ status: input.status, updated_at: new Date().toISOString() })
    .eq("id", input.id);

  if (error) return { ok: false, error: error.message };
  return { ok: true };
}

export function listAdminBooks() {
  return books.map((b) => ({
    id: b.id,
    title: b.title,
    slug: b.slug,
    authors: b.authorName,
    formats: b.formats.map((f) => f.format).join(", "),
    priceLabel: formatMoney(b.formats[0]?.price ?? 0),
    rating: b.rating,
    featured: Boolean(b.featured || b.bestseller),
  }));
}

export function listAdminAuthors() {
  return authors.map((a) => ({
    id: a.id,
    name: a.name,
    slug: a.slug,
    bookCount: a.bookCount,
    nationality: a.nationality,
  }));
}

export function listAdminCategories() {
  return categories.map((c) => ({
    id: c.id,
    name: c.name,
    slug: c.slug,
    bookCount: c.bookCount,
  }));
}

export function listAdminCustomers() {
  return Array.from({ length: 12 }, (_, i) => ({
    id: `cust-${i + 1}`,
    name: i === 0 ? currentUser.name : `Reader ${String(i + 1).padStart(2, "0")}`,
    email: i === 0 ? currentUser.email : `reader${String(i + 1).padStart(2, "0")}@booksandyou.test`,
    orders: 1 + ((i * 3) % 7),
    spentLabel: formatMoney(70 + i * 45),
    status: i % 9 === 0 ? "suspended" : "active",
  }));
}

export function listAdminCoupons() {
  return [
    {
      code: "WELCOME10",
      type: "percent",
      value: "10%",
      uses: 84,
      active: true,
    },
    {
      code: "ACCRA25",
      type: "fixed",
      value: formatMoney(25),
      uses: 31,
      active: true,
    },
    {
      code: "SUMMER50",
      type: "percent",
      value: "50%",
      uses: 12,
      active: false,
    },
  ];
}

export function listAdminGiftCards() {
  return [
    { code: "GIFT-8842", balanceLabel: formatMoney(200), status: "active" },
    { code: "GIFT-1102", balanceLabel: formatMoney(50), status: "redeemed" },
    { code: "GIFT-5521", balanceLabel: formatMoney(100), status: "active" },
  ];
}

export function listAdminReviews() {
  return reviews.slice(0, 10).map((r) => {
    const book = books.find((b) => b.id === r.bookId);
    return {
      id: r.id,
      book: book?.title || "Unknown",
      author: r.userName,
      rating: r.rating,
      body: r.body.slice(0, 120),
      published: true,
    };
  });
}

export function listAdminTickets() {
  return [
    {
      id: "t1",
      number: "TK-1042",
      subject: "Damaged hardcover on delivery",
      status: "open",
      priority: "high",
      customer: currentUser.name,
    },
    {
      id: "t2",
      number: "TK-1038",
      subject: "Ebook download link expired",
      status: "pending",
      priority: "medium",
      customer: "Reader 07",
    },
    {
      id: "t3",
      number: "TK-1021",
      subject: "Refund for cancelled preorder",
      status: "resolved",
      priority: "low",
      customer: "Reader 12",
    },
  ];
}

export function listAdminReturns() {
  return [
    {
      id: "ret-1",
      order: "BY-10482",
      reason: "Wrong edition shipped",
      status: "requested",
      amountLabel: formatMoney(110),
    },
    {
      id: "ret-2",
      order: "BY-10391",
      reason: "Print defect",
      status: "approved",
      amountLabel: formatMoney(145),
    },
  ];
}

export function listAdminPromotions() {
  return [
    { id: "promo-1", name: "Independence Week", discount: "15% sitewide", active: true },
    { id: "promo-2", name: "Kids Shelf Boost", discount: "Buy 2 get 1", active: true },
    { id: "promo-3", name: "Flash Fiction Friday", discount: "GH₵20 off", active: false },
  ];
}

export function listAdminAuditLogs() {
  return [
    {
      id: "a1",
      action: "inventory.adjust",
      actor: "Ivy Manager",
      entity: "book_inventory",
      at: "2026-07-23T10:12:00Z",
      detail: "+12 paperback units",
    },
    {
      id: "a2",
      action: "order.status",
      actor: "Sam Sales",
      entity: "orders",
      at: "2026-07-23T09:40:00Z",
      detail: "BY-10482 → shipped",
    },
    {
      id: "a3",
      action: "coupon.create",
      actor: "Super Admin",
      entity: "coupons",
      at: "2026-07-22T16:05:00Z",
      detail: "ACCRA25",
    },
    {
      id: "a4",
      action: "review.moderate",
      actor: "Marketing",
      entity: "book_reviews",
      at: "2026-07-22T14:20:00Z",
      detail: "Published review on Changes",
    },
  ];
}

export function getRbacMatrix() {
  return {
    roles: STAFF_ROLES.map((key) => ({
      key,
      label: roleLabel(key),
      permissions: ROLE_PERMISSIONS[key as RoleKey],
      permissionCount: ROLE_PERMISSIONS[key as RoleKey].length,
    })),
    permissions: ALL_PERMISSIONS.map((key) => ({
      key,
      module: key.split(".")[0],
      action: key.split(".")[1],
    })),
  };
}

export function listAdminPublishers() {
  return publishers.map((p) => ({
    id: p.id,
    name: p.name,
    slug: p.slug,
    country: p.country,
    bookCount: books.filter((b) => b.publisherId === p.id).length,
  }));
}
