import type { Metadata } from "next";
import { SuperAdminShell } from "@/components/superadmin/shell";

export const metadata: Metadata = {
  title: "Super Admin",
};

export default function SuperAdminLayout({ children }: { children: React.ReactNode }) {
  return <SuperAdminShell>{children}</SuperAdminShell>;
}
