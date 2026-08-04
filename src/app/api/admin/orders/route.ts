import { NextResponse } from "next/server";
import { requireAdmin, writeAuditLog } from "@/lib/admin/guard";
import { tryCreateClient } from "@/lib/supabase/server";
import {
  listAdminOrders,
  updateAdminOrderStatus,
} from "@/lib/services/admin-catalog";
import { adminOrderStatusSchema, getFieldErrors } from "@/lib/validation";

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

  const body = await request.json();
  const parsed = adminOrderStatusSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { ok: false, error: "Validation failed", errors: getFieldErrors(parsed.error) },
      { status: 400 }
    );
  }

  const supabase = await tryCreateClient();
  const result = await updateAdminOrderStatus(supabase, {
    id: parsed.data.id,
    status: parsed.data.status,
  });

  if (!result.ok) {
    return NextResponse.json(result, { status: 400 });
  }

  await writeAuditLog({
    actorId: auth.session.userId,
    action: "order.status",
    entityType: "orders",
    entityId: parsed.data.id,
    metadata: { status: parsed.data.status },
  });

  return NextResponse.json({ ok: true });
}
