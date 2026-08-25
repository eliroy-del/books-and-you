"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useCallback, useState, type ReactNode } from "react";
import {
  Activity,
  Database,
  Download,
  Flag,
  HardDrive,
  KeyRound,
  LogOut,
  ScrollText,
  Server,
  Shield,
  ShieldAlert,
  Truck,
  Webhook,
  FileText,
  LayoutDashboard,
} from "lucide-react";
import { useAuth } from "@/components/providers/auth-provider";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const NAV = [
  { href: "/superadmin", label: "Overview", icon: LayoutDashboard },
  { href: "/superadmin/rbac", label: "RBAC", icon: Shield },
  { href: "/superadmin/permissions", label: "Permissions", icon: KeyRound },
  { href: "/superadmin/flags", label: "Feature flags", icon: Flag },
  { href: "/superadmin/settings", label: "Site config", icon: Server },
  { href: "/superadmin/payments", label: "Payments", icon: Activity },
  { href: "/superadmin/shipping", label: "Shipping", icon: Truck },
  { href: "/superadmin/templates", label: "Templates", icon: FileText },
  { href: "/superadmin/monitoring", label: "API monitoring", icon: Webhook },
  { href: "/superadmin/fraud", label: "Fraud", icon: ShieldAlert },
  { href: "/superadmin/database", label: "Database", icon: Database },
  { href: "/superadmin/exports", label: "Exports", icon: Download },
  { href: "/superadmin/backups", label: "Backups", icon: HardDrive },
  { href: "/superadmin/audit", label: "Audit center", icon: ScrollText },
  { href: "/superadmin/logs", label: "System logs", icon: FileText },
];

export function SuperAdminShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const { signOut } = useAuth();
  const [signingOut, setSigningOut] = useState(false);

  const handleSignOut = useCallback(async () => {
    setSigningOut(true);
    try {
      await signOut();
      router.replace("/auth?next=/superadmin");
      router.refresh();
    } finally {
      setSigningOut(false);
    }
  }, [router, signOut]);

  return (
    <div className="min-h-[calc(100vh-6rem)] bg-[#0B1220] text-slate-100">
      <div className="mx-auto grid max-w-site gap-4 px-4 py-5 lg:grid-cols-[200px_1fr] sm:px-6 lg:px-8">
        <aside className="h-fit rounded-2xl border border-white/10 bg-white/5 p-3 backdrop-blur">
          <div className="px-1.5">
            <Badge className="border-0 bg-primary/20 text-[10px] text-gold">super_admin</Badge>
            <p className="font-heading mt-1.5 text-xs font-bold text-white">Control plane</p>
            <p className="text-[11px] text-slate-400">Platform configuration</p>
          </div>
          <nav className="mt-3 max-h-[65vh] space-y-0.5 overflow-y-auto pr-1">
            {NAV.map((item) => {
              const active =
                item.href === "/superadmin"
                  ? pathname === "/superadmin"
                  : pathname === item.href || pathname.startsWith(`${item.href}/`);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    "flex items-center gap-2 rounded-lg px-2.5 py-1.5 text-xs font-medium transition",
                    active
                      ? "bg-primary text-primary-foreground"
                      : "text-slate-300 hover:bg-white/10 hover:text-white"
                  )}
                >
                  <item.icon className="size-3.5 shrink-0" />
                  {item.label}
                </Link>
              );
            })}
          </nav>
          <div className="mt-3 space-y-0.5 border-t border-white/10 pt-2">
            <Button
              asChild
              variant="ghost"
              size="sm"
              className="h-8 w-full justify-start text-xs text-slate-300 hover:bg-white/10 hover:text-white"
            >
              <Link href="/admin">← Admin ops</Link>
            </Button>
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="h-8 w-full justify-start text-xs text-slate-300 hover:bg-white/10 hover:text-white"
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
