import { NextResponse } from "next/server";
import { requireAdmin, writeAuditLog } from "@/lib/admin/guard";
import { tryCreateClient } from "@/lib/supabase/server";
import {
  listAdminOrders,
  updateAdminOrderStatus,
} from "@/lib/services/admin-catalog";

export async function GET() {
  const auth = await requireAdmin("orders.read");
  if ("error" in auth) return auth.error;

  const supabase = await tryCreateClient();
  const orders = await listAdminOrders(supabase);
  return NextResponse.json({ ok: true, orders });
}

export async function PATCH(request: Request) {
  const auth = await requireAdmin("orders.write");
  if ("error" in auth) return auth.error;

  const body = (await request.json()) as { id?: string; status?: string };
  if (!body.id || !body.status) {
    return NextResponse.json({ ok: false, error: "id and status required" }, { status: 400 });
  }

  const supabase = await tryCreateClient();
  const result = await updateAdminOrderStatus(supabase, {
    id: body.id,
    status: body.status,
  });

  if (!result.ok) {
    return NextResponse.json(result, { status: 400 });
  }

  await writeAuditLog({
    actorId: auth.session.userId,
    action: "order.status",
    entityType: "orders",
    entityId: body.id,
    metadata: { status: body.status },
  });

  return NextResponse.json({ ok: true });
}
