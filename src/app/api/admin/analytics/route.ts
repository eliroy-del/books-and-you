import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import { getAnalyticsSnapshot, buildReports } from "@/lib/services/admin-analytics";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const type = searchParams.get("type") || "analytics";

  if (type === "reports") {
    const auth = await requireAdmin(["finance.read", "orders.read"]);
    if ("error" in auth) return auth.error;
    return NextResponse.json({ ok: true, reports: buildReports() });
  }

  const auth = await requireAdmin(["finance.read", "orders.read", "inventory.read"]);
  if ("error" in auth) return auth.error;
  return NextResponse.json({ ok: true, analytics: getAnalyticsSnapshot() });
}
