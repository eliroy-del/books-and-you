import { NextResponse } from "next/server";
import { getAdminSession } from "@/lib/admin/guard";
import { visibleModules } from "@/lib/admin/permissions";

export async function GET() {
  const session = await getAdminSession();
  if (!session) {
    return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
  }

  return NextResponse.json({
    ok: true,
    session: {
      role: session.roleKey,
      email: session.email,
      permissions: session.permissions,
      demo: session.demo,
      isSuperAdmin: session.isSuperAdmin,
      modules: visibleModules(session.permissions),
    },
  });
}
