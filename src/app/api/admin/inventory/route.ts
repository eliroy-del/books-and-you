import { NextResponse } from "next/server";
import { requireAdmin, writeAuditLog } from "@/lib/admin/guard";
import { tryCreateClient } from "@/lib/supabase/server";
import { adjustInventory, listInventory } from "@/lib/services/admin-inventory";

export async function GET(request: Request) {
  const auth = await requireAdmin("inventory.read");
  if ("error" in auth) return auth.error;

  const { searchParams } = new URL(request.url);
  const supabase = await tryCreateClient();
  const rows = await listInventory(supabase, {
    lowOnly: searchParams.get("low") === "1",
    q: searchParams.get("q") || undefined,
  });

  return NextResponse.json({ ok: true, rows });
}

export async function PATCH(request: Request) {
  const auth = await requireAdmin("inventory.write");
  if ("error" in auth) return auth.error;

  const body = (await request.json()) as {
    id?: string;
    delta?: number;
    reason?: string;
  };

  if (!body.id || typeof body.delta !== "number") {
    return NextResponse.json({ ok: false, error: "id and delta required" }, { status: 400 });
  }

  const supabase = await tryCreateClient();
  const result = await adjustInventory(supabase, {
    id: body.id,
    delta: body.delta,
    reason: body.reason,
  });

  if (!result.ok) {
    return NextResponse.json(result, { status: 400 });
  }

  await writeAuditLog({
    actorId: auth.session.userId,
    action: "inventory.adjust",
    entityType: "book_inventory",
    entityId: body.id,
    metadata: { delta: body.delta, reason: body.reason, quantity: result.row.quantity },
  });

  return NextResponse.json({ ok: true, row: result.row });
}
