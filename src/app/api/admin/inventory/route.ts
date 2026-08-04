import { NextResponse } from "next/server";
import { requireAdmin, writeAuditLog } from "@/lib/admin/guard";
import { tryCreateClient } from "@/lib/supabase/server";
import { adjustInventory, listInventory } from "@/lib/services/admin-inventory";
import { getFieldErrors, inventoryAdjustSchema, searchQuerySchema } from "@/lib/validation";
import { sanitize } from "@/lib/sanitize";

export async function GET(request: Request) {
  const auth = await requireAdmin("inventory.read");
  if ("error" in auth) return auth.error;

  const { searchParams } = new URL(request.url);
  const qRaw = searchParams.get("q") || undefined;
  const qParsed = qRaw ? searchQuerySchema.safeParse({ q: qRaw }) : null;
  if (qParsed && !qParsed.success) {
    return NextResponse.json(
      { ok: false, error: "Invalid search", errors: getFieldErrors(qParsed.error) },
      { status: 400 }
    );
  }

  const supabase = await tryCreateClient();
  const rows = await listInventory(supabase, {
    lowOnly: searchParams.get("low") === "1",
    q: qParsed?.success ? sanitize(qParsed.data.q) : undefined,
  });

  return NextResponse.json({ ok: true, rows });
}

export async function PATCH(request: Request) {
  const auth = await requireAdmin("inventory.write");
  if ("error" in auth) return auth.error;

  const body = await request.json();
  const parsed = inventoryAdjustSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { ok: false, error: "Validation failed", errors: getFieldErrors(parsed.error) },
      { status: 400 }
    );
  }

  const reason = sanitize(parsed.data.reason || "manual_admin_adjust");

  const supabase = await tryCreateClient();
  const result = await adjustInventory(supabase, {
    id: parsed.data.id,
    delta: parsed.data.delta,
    reason,
  });

  if (!result.ok) {
    return NextResponse.json(result, { status: 400 });
  }

  await writeAuditLog({
    actorId: auth.session.userId,
    action: "inventory.adjust",
    entityType: "book_inventory",
    entityId: parsed.data.id,
    metadata: { delta: parsed.data.delta, reason, quantity: result.row.quantity },
  });

  return NextResponse.json({ ok: true, row: result.row });
}
