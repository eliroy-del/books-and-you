import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import { getRbacMatrix } from "@/lib/services/admin-catalog";
import { visibleModules } from "@/lib/admin/permissions";

export async function GET() {
  const auth = await requireAdmin(["settings.write", "audit.read"]);
  if ("error" in auth) return auth.error;

  const matrix = getRbacMatrix();
  return NextResponse.json({
    ok: true,
    matrix,
    session: {
      role: auth.session.roleKey,
      permissions: auth.session.permissions,
      modules: visibleModules(auth.session.permissions).map((m) => m.id),
    },
  });
}
