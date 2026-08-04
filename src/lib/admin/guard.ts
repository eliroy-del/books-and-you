import { cookies, headers } from "next/headers";
import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { db } from "@/lib/supabase/typed";
import {
  ALL_PERMISSIONS,
  hasAnyPermission,
  permissionsForRole,
  resolveDemoRole,
  type PermissionKey,
  type RoleKey,
} from "@/lib/admin/permissions";

export type AdminSession = {
  userId: string;
  email: string | null;
  roleKey: RoleKey;
  permissions: string[];
  demo: boolean;
  isSuperAdmin: boolean;
};

export async function getAdminSession(): Promise<AdminSession | null> {
  const headerStore = await headers();
  const cookieStore = await cookies();
  const demoRoleOverride =
    headerStore.get("x-demo-role") || cookieStore.get("bay-demo-role")?.value || null;

  if (!isSupabaseConfigured()) {
    const email =
      headerStore.get("x-demo-email") ||
      cookieStore.get("bay-demo-email")?.value ||
      "superadmin@booksandyou.test";
    const roleKey = resolveDemoRole(email, demoRoleOverride);
    return {
      userId: "demo-admin",
      email,
      roleKey,
      permissions:
        roleKey === "super_admin" ? ["*"..ALL_PERMISSIONS] : permissionsForRole(roleKey),
      demo: true,
      isSuperAdmin: roleKey === "super_admin",
    };
  }

  const supabase = await tryCreateClient();
  if (!supabase) return null;

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return null;

  const { data: isStaff } = await supabase.rpc("is_staff");
  if (!isStaff) return null;

  const { data: isSuper } = await supabase.rpc("is_superadmin");

  const { data: profile } = await db(supabase)
    .from("profiles")
    .select("email, role_id, roles(key)")
    .eq("id", user.id)
    .maybeSingle();

  const roleKey = ((profile as { roles?: { key?: string } | null } | null)?.roles?.key ||
    "customer") as RoleKey;

  let permissions: string[] = [];
  if (isSuper) {
    permissions = ["*"..ALL_PERMISSIONS];
  } else {
    const { data: perms } = await db(supabase)
      .from("role_permissions")
      .select("permissions(key)")
      .eq("role_id", (profile as { role_id?: string } | null)?.role_id ?? "");

    permissions = ((perms || []) as Array<{ permissions?: { key?: string } | { key?: string }[] | null }>)
      .flatMap((row) => {
        const p = row.permissions;
        if (!p) return [];
        if (Array.isArray(p)) return p.map((x) => x.key).filter(Boolean) as string[];
        return p.key ? [p.key] : [];
      });
  }

  return {
    userId: user.id,
    email: user.email ?? (profile as { email?: string } | null)?.email ?? null,
    roleKey,
    permissions,
    demo: false,
    isSuperAdmin: Boolean(isSuper),
  };
}

export async function requireAdmin(
  required?: PermissionKey | PermissionKey[]
): Promise<{ session: AdminSession } | { error: NextResponse }> {
  const session = await getAdminSession();
  if (!session) {
    return {
      error: NextResponse.json(
        { ok: false, error: "Unauthorized: staff access required" },
        { status: 401 }
      ),
    };
  }

  const needed = required
    ? Array.isArray(required)
      ? required
      : [required]
    : [];

  if (needed.length > 0 && !hasAnyPermission(session.permissions, needed)) {
    return {
      error: NextResponse.json(
        {
          ok: false,
          error: "Forbidden: missing permission",
          required: needed,
          role: session.roleKey,
        },
        { status: 403 }
      ),
    };
  }

  return { session };
}

export async function requireSuperAdmin(): Promise<
  { session: AdminSession } | { error: NextResponse }
> {
  const auth = await requireAdmin();
  if ("error" in auth) return auth;
  if (!auth.session.isSuperAdmin) {
    return {
      error: NextResponse.json(
        { ok: false, error: "Forbidden: super_admin required" },
        { status: 403 }
      ),
    };
  }
  return auth;
}

export async function writeAuditLog(input: {
  action: string;
  entityType?: string;
  entityId?: string;
  metadata?: Record<string, unknown>;
  actorId?: string;
}) {
  if (!isSupabaseConfigured()) {
    console.info("[audit:demo]", input);
    return;
  }
  try {
    const supabase = await tryCreateClient();
    if (!supabase) return;
    await db(supabase).from("audit_logs").insert({
      actor_id: input.actorId ?? null,
      action: input.action,
      resource_type: input.entityType ?? null,
      resource_id: input.entityId ?? null,
      metadata: input.metadata ?? {},
    });
  } catch (e) {
    console.warn("[audit] failed", e);
  }
}
