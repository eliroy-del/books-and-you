"use client";

import { useCallback, useEffect, useState } from "react";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { SaCard, SaHeader } from "@/components/superadmin/ui";
import type { FeatureFlag } from "@/lib/superadmin/platform";

export default function SuperAdminFlagsPage() {
  const [flags, setFlags] = useState<FeatureFlag[]>([]);

  const load = useCallback(async () => {
    const res = await fetch("/api/superadmin?section=flags");
    const json = await res.json();
    if (json.ok) setFlags(json.flags);
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  async function toggle(flag: FeatureFlag) {
    const res = await fetch("/api/superadmin", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        action: "toggle_flag",
        key: flag.key,
        enabled: !flag.enabled,
      }),
    });
    const json = await res.json();
    if (!json.ok) {
      toast.error(json.error || "Update failed");
      return;
    }
    toast.success(`${flag.key} → ${json.flag.enabled ? "on" : "off"}`);
    void load();
  }

  return (
    <div>
      <SaHeader
        title="Feature flags"
        description="Toggle product capabilities without redeploying."
      />
      <SaCard>
        <div className="space-y-3">
          {flags.map((flag) => (
            <div
              key={flag.key}
              className="flex flex-wrap items-center justify-between gap-3 border-b border-white/10 py-3 last:border-0"
            >
              <div>
                <p className="font-medium text-white">{flag.key}</p>
                <p className="text-sm text-slate-400">{flag.description}</p>
              </div>
              <div className="flex items-center gap-2">
                <Badge
                  className={
                    flag.enabled
                      ? "border-0 bg-primary/20 text-gold"
                      : "border-0 bg-slate-500/20 text-slate-300"
                  }
                >
                  {flag.enabled ? "enabled" : "disabled"}
                </Badge>
                <Button
                  size="sm"
                  className="bg-primary hover:bg-primary/90"
                  onClick={() => void toggle(flag)}
                >
                  Toggle
                </Button>
              </div>
            </div>
          ))}
        </div>
      </SaCard>
    </div>
  );
}
