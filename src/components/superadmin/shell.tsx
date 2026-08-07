"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import {
  Activity,
  Database,
  Download,
  Flag,
  HardDrive,
  KeyRound,
  ScrollText,
  Server,
  Shield,
  ShieldAlert,
  Truck,
  Webhook,
  FileText,
  LayoutDashboard,
} from "lucide-react";
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

  return (
    <div className="min-h-[calc(100vh-8rem)] bg-[#0B1220] text-slate-100">
      <div className="mx-auto grid max-w-7xl gap-6 px-4 py-8 lg:grid-cols-[230px_1fr] sm:px-6 lg:px-8">
        <aside className="h-fit rounded-3xl border border-white/10 bg-white/5 p-4 backdrop-blur">
          <div className="px-2">
            <Badge className="border-0 bg-primary/20 text-gold">super_admin</Badge>
            <p className="font-heading mt-2 text-sm font-bold text-white">Control plane</p>
            <p className="text-xs text-slate-400">Platform configuration</p>
          </div>
          <nav className="mt-4 max-h-[65vh] space-y-0.5 overflow-y-auto pr-1">
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
                    "flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition",
                    active
                      ? "bg-primary text-primary-foreground"
                      : "text-slate-300 hover:bg-white/10 hover:text-white"
                  )}
                >
                  <item.icon className="size-4 shrink-0" />
                  {item.label}
                </Link>
              );
            })}
          </nav>
          <div className="mt-4 border-t border-white/10 pt-3">
            <Button
              asChild
              variant="ghost"
              size="sm"
              className="w-full justify-start text-slate-300 hover:bg-white/10 hover:text-white"
            >
              <Link href="/admin">← Admin ops</Link>
            </Button>
          </div>
        </aside>
        <div className="min-w-0">{children}</div>
      </div>
    </div>
  );
}
