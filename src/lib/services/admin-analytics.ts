import { books, formatMoney, sampleOrders, categories, authors } from "@/data/mock";
import type { AppSupabaseClient } from "@/lib/supabase/typed";
import { db } from "@/lib/supabase/typed";
import { isSupabaseConfigured } from "@/lib/supabase/env";

export type DashboardOverview = {
  catalogTitles: number;
  openOrders: number;
  revenueCents: number;
  revenueLabel: string;
  lowStockAlerts: number;
  customers: number;
  ticketsOpen: number;
  recentOrders: Array<{
    id: string;
    number: string;
    status: string;
    totalLabel: string;
    itemCount: number;
    placedAt: string;
  }>;
  lowStockItems: Array<{
    bookId: string;
    title: string;
    format: string;
    quantity: number;
    reserved: number;
  }>;
};

function mockOverview(): DashboardOverview {
  const revenue = sampleOrders.reduce((s, o) => s + o.total, 0);
  const low = books.flatMap((b) =>
    b.formats
      .filter((f) => f.format !== "ebook" && f.inStock > 0 && f.inStock < 15)
      .map((f) => ({
        bookId: b.id,
        title: b.title,
        format: f.format,
        quantity: f.inStock,
        reserved: 0,
      }))
  );

  return {
    catalogTitles: books.length,
    openOrders: sampleOrders.filter((o) => o.status !== "completed").length,
    revenueCents: Math.round(revenue * 100),
    revenueLabel: formatMoney(revenue),
    lowStockAlerts: low.length,
    customers: 50,
    ticketsOpen: 3,
    recentOrders: sampleOrders.map((o) => ({
      id: o.id,
      number: o.number,
      status: o.status,
      totalLabel: formatMoney(o.total),
      itemCount: o.items.length,
      placedAt: o.placedAt,
    })),
    lowStockItems: low.slice(0, 8),
  };
}

export async function getDashboardOverview(
  supabase?: AppSupabaseClient | null
): Promise<DashboardOverview> {
  if (!supabase || !isSupabaseConfigured()) return mockOverview();

  const client = db(supabase);

  const [
    { count: catalogTitles },
    { data: paidOrders },
    { count: customers },
    { count: ticketsOpen },
    { data: recent },
    { data: inventory },
  ] = await Promise.all([
    client.from("books").select("*", { count: "exact", head: true }),
    client
      .from("orders")
      .select("id, total_cents, status")
      .in("status", ["paid", "processing", "shipped", "delivered", "completed"]),
    client
      .from("profiles")
      .select("*", { count: "exact", head: true })
      .not("role_id", "is", null),
    client
      .from("tickets")
      .select("*", { count: "exact", head: true })
      .in("status", ["open", "pending"]),
    client
      .from("orders")
      .select("id, order_number, status, total_cents, created_at, order_items(id)")
      .order("created_at", { ascending: false })
      .limit(8),
    client
      .from("book_inventory")
      .select("id, book_id, format, quantity, reserved, books(title)")
      .lt("quantity", 15)
      .gt("quantity", 0)
      .limit(12),
  ]);

  const revenueCents = (paidOrders || []).reduce(
    (s: number, o: { total_cents?: number }) => s + (o.total_cents || 0),
    0
  );
  const openOrders = (paidOrders || []).filter((o: { status?: string }) =>
    ["paid", "processing", "shipped"].includes(o.status || "")
  ).length;

  return {
    catalogTitles: catalogTitles ?? books.length,
    openOrders,
    revenueCents,
    revenueLabel: formatMoney(revenueCents / 100),
    lowStockAlerts: inventory?.length ?? 0,
    customers: customers ?? 50,
    ticketsOpen: ticketsOpen ?? 0,
    recentOrders: ((recent || []) as any[]).map((o) => ({
      id: o.id,
      number: o.order_number,
      status: o.status,
      totalLabel: formatMoney((o.total_cents || 0) / 100),
      itemCount: o.order_items?.length ?? 0,
      placedAt: o.created_at,
    })),
    lowStockItems: ((inventory || []) as any[]).map((row) => ({
      bookId: row.book_id,
      title: Array.isArray(row.books)
        ? row.books[0]?.title || "Untitled"
        : row.books?.title || "Untitled",
      format: row.format,
      quantity: row.quantity,
      reserved: row.reserved,
    })),
  };
}

export type AnalyticsSnapshot = {
  revenueByDay: Array<{ day: string; amountCents: number; label: string }>;
  ordersByStatus: Array<{ status: string; count: number }>;
  topCategories: Array<{ name: string; share: number }>;
  topAuthors: Array<{ name: string; sales: number }>;
  conversionFunnel: Array<{ stage: string; value: number }>;
  kpis: {
    aovLabel: string;
    repeatRate: number;
    digitalShare: number;
    fulfillmentHours: number;
  };
};

export function getAnalyticsSnapshot(): AnalyticsSnapshot {
  const days = Array.from({ length: 14 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (13 - i));
    const amount = 80000 + ((i * 13791) % 120000) + i * 4200;
    return {
      day: d.toISOString().slice(0, 10),
      amountCents: amount,
      label: formatMoney(amount / 100),
    };
  });

  return {
    revenueByDay: days,
    ordersByStatus: [
      { status: "paid", count: 18 },
      { status: "processing", count: 7 },
      { status: "shipped", count: 12 },
      { status: "delivered", count: 41 },
      { status: "completed", count: 96 },
      { status: "cancelled", count: 4 },
    ],
    topCategories: categories.slice(0, 6).map((c, i) => ({
      name: c.name,
      share: Math.max(8, 28 - i * 3),
    })),
    topAuthors: authors.slice(0, 5).map((a, i) => ({
      name: a.name,
      sales: 120 - i * 17,
    })),
    conversionFunnel: [
      { stage: "Visits", value: 12400 },
      { stage: "Product views", value: 5800 },
      { stage: "Add to cart", value: 1420 },
      { stage: "Checkout", value: 610 },
      { stage: "Paid", value: 480 },
    ],
    kpis: {
      aovLabel: formatMoney(186),
      repeatRate: 34,
      digitalShare: 22,
      fulfillmentHours: 18,
    },
  };
}

export type ReportBundle = {
  generatedAt: string;
  salesSummary: {
    period: string;
    orders: number;
    revenueLabel: string;
    refundsLabel: string;
    netLabel: string;
  };
  inventorySummary: {
    skus: number;
    lowStock: number;
    outOfStock: number;
    reserved: number;
  };
  customerSummary: {
    active: number;
    newThisMonth: number;
    subscribers: number;
    referralCreditsLabel: string;
  };
  csvPreview: string;
};

export function buildReports(): ReportBundle {
  const revenue = sampleOrders.reduce((s, o) => s + o.total, 0);
  const low = books.filter((b) =>
    b.formats.some((f) => f.format !== "ebook" && f.inStock > 0 && f.inStock < 15)
  ).length;
  const out = books.filter((b) =>
    b.formats.every((f) => f.format === "ebook" || f.inStock === 0)
  ).length;

  const csvPreview = [
    "metric,value",
    `orders,${sampleOrders.length}`,
    `revenue_ghs,${revenue.toFixed(2)}`,
    `low_stock,${low}`,
    `catalog,${books.length}`,
  ].join("\n");

  return {
    generatedAt: new Date().toISOString(),
    salesSummary: {
      period: "Last 30 days (demo)",
      orders: sampleOrders.length + 142,
      revenueLabel: formatMoney(revenue + 18420),
      refundsLabel: formatMoney(240),
      netLabel: formatMoney(revenue + 18180),
    },
    inventorySummary: {
      skus: books.reduce((s, b) => s + b.formats.length, 0),
      lowStock: low,
      outOfStock: out,
      reserved: 27,
    },
    customerSummary: {
      active: 50,
      newThisMonth: 11,
      subscribers: 18,
      referralCreditsLabel: formatMoney(1250),
    },
    csvPreview,
  };
}
