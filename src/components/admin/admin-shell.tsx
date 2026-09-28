"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useCallback, useEffect, useMemo, useState, type ReactNode } from "react";
import {
  BarChart3,
  BookOpen,
  CirclePlus,
  Boxes,
  Building2,
  FileText,
  Gift,
  LayoutDashboard,
  LogOut,
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
import { useAuth } from "@/components/providers/auth-provider";
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
  "add-product": CirclePlus,
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
  const router = useRouter();
  const { signOut } = useAuth();
  const [session, setSession] = useState<AdminSessionPayload | null>(null);
  const [loading, setLoading] = useState(true);
  const [signingOut, setSigningOut] = useState(false);
  const [demoRole, setDemoRole] = useState<RoleKey>("super_admin");

  const handleSignOut = useCallback(async () => {
    setSigningOut(true);
    try {
      await signOut();
      router.replace("/auth?next=/admin");
      router.refresh();
    } finally {
      setSigningOut(false);
    }
  }, [router, signOut]);

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
    <div className="min-h-[calc(100vh-6rem)] bg-secondary/40">
      <div className="mx-auto grid max-w-site gap-4 px-4 py-5 lg:grid-cols-[210px_1fr] sm:px-6 lg:px-8">
        <aside className="h-fit rounded-2xl border border-border/70 bg-card p-3 shadow-soft">
          <div className="px-1.5">
            <p className="font-heading text-xs font-bold">Admin</p>
            <p className="text-muted-foreground text-[11px]">
              {session?.demo ? "Demo RBAC" : "Staff console"}
            </p>
          </div>

          {session && (
            <div className="mt-2 rounded-xl border border-primary/15 bg-primary/5 px-2.5 py-1.5">
              <Badge variant="secondary" className="mb-0.5 text-[10px]">
                {roleLabel(session.role)}
              </Badge>
              <p className="text-muted-foreground truncate text-[10px]">
                {session.email || "staff"}
              </p>
            </div>
          )}

          {session?.demo && (
            <div className="mt-2 px-0.5">
              <p className="text-muted-foreground mb-1 text-[10px] uppercase tracking-wide">
                Impersonate role
              </p>
              <select
                className="border-border bg-background w-full rounded-lg border px-2 py-1 text-[11px]"
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

          <nav className="mt-3 max-h-[60vh] space-y-0.5 overflow-y-auto pr-1">
            {loading
              ? Array.from({ length: 8 }).map((_, i) => (
                  <div key={i} className="bg-muted/60 mb-1 h-7 animate-pulse rounded-lg" />
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
                        "flex items-center gap-2 rounded-lg px-2.5 py-1.5 text-xs font-medium transition",
                        active
                          ? "bg-primary text-primary-foreground"
                          : "hover:bg-muted text-foreground"
                      )}
                    >
                      <Icon className="size-3.5 shrink-0" />
                      {m.label}
                    </Link>
                  );
                })}
          </nav>

          <div className="mt-3 space-y-0.5 border-t border-border/60 pt-2">
            <Button asChild variant="ghost" size="sm" className="h-8 w-full justify-start text-xs">
              <Link href="/superadmin">
                <Settings2 className="mr-1.5 size-3.5" />
                Super Admin
              </Link>
            </Button>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="text-muted-foreground hover:text-foreground h-8 w-full justify-start text-xs"
              disabled={signingOut}
              onClick={() => void handleSignOut()}
            >
              <LogOut className="mr-1.5 size-3.5" />
              {signingOut ? "Signing out…" : "Sign out"}
            </Button>
          </div>
        </aside>

        <div className="min-w-0">{children}</div>
      </div>
    </div>
  );
}
