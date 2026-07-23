import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import {
  listAdminAuthors,
  listAdminBooks,
  listAdminCategories,
  listAdminCoupons,
  listAdminCustomers,
  listAdminGiftCards,
  listAdminPromotions,
  listAdminPublishers,
  listAdminReturns,
  listAdminReviews,
  listAdminTickets,
  listAdminAuditLogs,
} from "@/lib/services/admin-catalog";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const resource = searchParams.get("resource") || "books";

  const permissionMap: Record<string, Parameters<typeof requireAdmin>[0]> = {
    books: "catalog.read",
    authors: ["catalog.read", "authors.write"],
    publishers: ["catalog.read", "publishers.write"],
    categories: "catalog.read",
    customers: "customers.read",
    coupons: "marketing.read",
    gifts: ["marketing.read", "finance.read"],
    reviews: "reviews.moderate",
    support: "support.read",
    returns: ["orders.read", "orders.write"],
    promotions: "marketing.read",
    audit: "audit.read",
  };

  const auth = await requireAdmin(permissionMap[resource] || "catalog.read");
  if ("error" in auth) return auth.error;

  const data: Record<string, unknown> = {
    books: listAdminBooks,
    authors: listAdminAuthors,
    publishers: listAdminPublishers,
    categories: listAdminCategories,
    customers: listAdminCustomers,
    coupons: listAdminCoupons,
    gifts: listAdminGiftCards,
    reviews: listAdminReviews,
    support: listAdminTickets,
    returns: listAdminReturns,
    promotions: listAdminPromotions,
    audit: listAdminAuditLogs,
  };

  const loader = data[resource];
  if (!loader || typeof loader !== "function") {
    return NextResponse.json({ ok: false, error: "Unknown resource" }, { status: 400 });
  }

  return NextResponse.json({ ok: true, resource, rows: loader() });
}
