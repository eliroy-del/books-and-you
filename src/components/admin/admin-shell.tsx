"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useCallback, useEffect, useMemo, useState, type ReactNode } from "react";
import {
  BarChart3,
  BookOpen,
  Boxes,
  Building2,
  FileText,
  Gift,
  LayoutDashboard,
  MessageSquare,
  Package,
  Percent,
  RotateCcw,
  ScrollText,
  Settings2,
  Shield,
  ShoppingBag,
  Sparkles,
  Tags,
  Users,
} from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  ADMIN_MODULES,
  STAFF_ROLES,
  roleLabel,
  type AdminModuleId,
  type RoleKey,
} from "@/lib/admin/permissions";
import { cn } from "@/lib/utils";

const ICONS: Record<AdminModuleId, typeof LayoutDashboard> = {
  dashboard: LayoutDashboard,
  inventory: Boxes,
  books: BookOpen,
  authors: Users,
  publishers: Building2,
  categories: Tags,
  orders: Package,
  customers: ShoppingBag,
  coupons: Percent,
  gifts: Gift,
  reviews: Sparkles,
  support: MessageSquare,
  returns: RotateCcw,
  reports: FileText,
  analytics: BarChart3,
  promotions: Percent,
  audit: ScrollText,
  rbac: Shield,
};

type AdminSessionPayload = {
  role: RoleKey;
  email: string | null;
  permissions: string[];
  demo: boolean;
  isSuperAdmin: boolean;
  modules: typeof ADMIN_MODULES;
};

const DEMO_ROLE_KEY = "bay-demo-role";

export function AdminShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const [session, setSession] = useState<AdminSessionPayload | null>(null);
  const [loading, setLoading] = useState(true);
  const [demoRole, setDemoRole] = useState<RoleKey>("super_admin");

  const load = useCallback(async (role?: RoleKey) => {
    setLoading(true);
    const headers: HeadersInit = {};
    if (role) {
      headers["x-demo-role"] = role;
      document.cookie = `${DEMO_ROLE_KEY}=${role}; path=/; max-age=86400; SameSite=Lax`;
    }
    const res = await fetch("/api/admin/me", { headers, cache: "no-store" });
    const json = await res.json();
    if (json.ok) {
      setSession(json.session);
      setDemoRole(json.session.role);
    } else {
      setSession(null);
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    const saved =
      (typeof document !== "undefined" &&
        document.cookie
          .split("; ")
          .find((c) => c.startsWith(`${DEMO_ROLE_KEY}=`))
          ?.split("=")[1]) ||
      undefined;
    void load(saved as RoleKey | undefined);
  }, [load]);

  const modules = useMemo(() => {
    if (session?.modules?.length) return session.modules;
    return ADMIN_MODULES;
  }, [session]);

  return (
    <div className="min-h-[calc(100vh-8rem)] bg-secondary/40">
      <div className="mx-auto grid max-w-7xl gap-6 px-4 py-8 lg:grid-cols-[250px_1fr] sm:px-6 lg:px-8">
        <aside className="h-fit rounded-3xl border border-border/70 bg-card p-4 shadow-soft">
          <div className="px-2">
            <p className="font-heading text-sm font-bold">Admin</p>
            <p className="text-muted-foreground text-xs">
              {session?.demo ? "Demo RBAC" : "Staff console"}
            </p>
          </div>

          {session && (
            <div className="mt-3 rounded-2xl border border-primary/15 bg-primary/5 px-3 py-2">
              <Badge variant="secondary" className="mb-1">
                {roleLabel(session.role)}
              </Badge>
              <p className="text-muted-foreground truncate text-[11px]">
                {session.email || "staff"}
              </p>
            </div>
          )}

          {session?.demo && (
            <div className="mt-3 px-1">
              <p className="text-muted-foreground mb-1 text-[11px] uppercase tracking-wide">
                Impersonate role
              </p>
              <select
                className="border-border bg-background w-full rounded-xl border px-2 py-1.5 text-xs"
                value={demoRole}
                onChange={(e) => {
                  const role = e.target.value as RoleKey;
                  setDemoRole(role);
                  void load(role);
                }}
              >
                {STAFF_ROLES.map((r) => (
                  <option key={r} value={r}>
                    {roleLabel(r)}
                  </option>
                ))}
              </select>
            </div>
          )}

          <nav className="mt-4 max-h-[60vh] space-y-0.5 overflow-y-auto pr-1">
            {loading
              ? Array.from({ length: 8 }).map((_, i) => (
                  <div key={i} className="bg-muted/60 mb-1 h-8 animate-pulse rounded-xl" />
                ))
              : modules.map((m) => {
                  const Icon = ICONS[m.id as AdminModuleId] || LayoutDashboard;
                  const active =
                    m.href === "/admin"
                      ? pathname === "/admin"
                      : pathname === m.href || pathname.startsWith(`${m.href}/`);
                  return (
                    <Link
                      key={m.id}
                      href={m.href}
                      className={cn(
                        "flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition",
                        active
                          ? "bg-primary text-primary-foreground"
                          : "hover:bg-muted text-foreground"
                      )}
                    >
                      <Icon className="size-4 shrink-0" />
                      {m.label}
                    </Link>
                  );
                })}
          </nav>

          <div className="mt-4 border-t border-border/60 pt-3">
            <Button asChild variant="ghost" size="sm" className="w-full justify-start">
              <Link href="/superadmin">
                <Settings2 className="mr-2 size-4" />
                Super Admin
              </Link>
            </Button>
          </div>
        </aside>

        <div className="min-w-0">{children}</div>
      </div>
    </div>
  );
}
