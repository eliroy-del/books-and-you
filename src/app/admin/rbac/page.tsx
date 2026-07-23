"use client";

import { useEffect, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { AdminPageHeader, AdminPanel, AdminTable } from "@/components/admin/admin-ui";

type Matrix = {
  roles: Array<{
    key: string;
    label: string;
    permissions: string[];
    permissionCount: number;
  }>;
  permissions: Array<{ key: string; module: string; action: string }>;
};

export default function AdminRbacPage() {
  const [matrix, setMatrix] = useState<Matrix | null>(null);
  const [sessionRole, setSessionRole] = useState("");
  const [modules, setModules] = useState<string[]>([]);

  useEffect(() => {
    void fetch("/api/admin/rbac")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) {
          setMatrix(json.matrix);
          setSessionRole(json.session.role);
          setModules(json.session.modules);
        }
      });
  }, []);

  return (
    <div>
      <AdminPageHeader
        title="RBAC"
        description="Role–permission matrix. Assignments are enforced on admin APIs."
        action={<Badge variant="secondary">Acting as {sessionRole || "…"}</Badge>}
      />

      <AdminPanel title="Your visible modules" className="mb-6">
        <div className="flex flex-wrap gap-2">
          {modules.map((m) => (
            <Badge key={m} variant="outline">
              {m}
            </Badge>
          ))}
        </div>
      </AdminPanel>

      <AdminPanel title="Roles">
        <AdminTable headers={["Role", "Permissions", "Keys"]}>
          {(matrix?.roles || []).map((role) => (
            <tr key={role.key}>
              <td className="py-3 font-medium">{role.label}</td>
              <td className="py-3">{role.permissionCount}</td>
              <td className="py-3">
                <div className="flex max-w-xl flex-wrap gap-1">
                  {role.permissions.slice(0, 8).map((p) => (
                    <Badge key={p} variant="secondary" className="text-[10px]">
                      {p}
                    </Badge>
                  ))}
                  {role.permissions.length > 8 ? (
                    <Badge variant="outline" className="text-[10px]">
                      +{role.permissions.length - 8}
                    </Badge>
                  ) : null}
                </div>
              </td>
            </tr>
          ))}
        </AdminTable>
      </AdminPanel>

      <AdminPanel title="Permission catalog" className="mt-6">
        <AdminTable headers={["Key", "Module", "Action"]}>
          {(matrix?.permissions || []).map((p) => (
            <tr key={p.key}>
              <td className="py-2 font-mono text-xs">{p.key}</td>
              <td className="py-2 capitalize">{p.module}</td>
              <td className="py-2 capitalize">{p.action}</td>
            </tr>
          ))}
        </AdminTable>
      </AdminPanel>
    </div>
  );
}
