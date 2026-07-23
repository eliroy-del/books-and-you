import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import { tryCreateClient } from "@/lib/supabase/server";
import { getDashboardOverview } from "@/lib/services/admin-analytics";

export async function GET() {
  const auth = await requireAdmin();
  if ("error" in auth) return auth.error;

  const supabase = await tryCreateClient();
  const overview = await getDashboardOverview(supabase);
  return NextResponse.json({
    ok: true,
    overview,
    session: {
      role: auth.session.roleKey,
      permissions: auth.session.permissions,
      demo: auth.session.demo,
      email: auth.session.email,
    },
  });
}
