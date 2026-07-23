"use client";

import { useEffect, useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { SaCard, SaHeader } from "@/components/superadmin/ui";
import type { SiteSetting } from "@/lib/superadmin/platform";

export default function SuperAdminSettingsPage() {
  const [settings, setSettings] = useState<SiteSetting[]>([]);

  useEffect(() => {
    void fetch("/api/superadmin?section=settings")
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) setSettings(json.settings);
      });
  }, []);

  async function save(setting: SiteSetting) {
    const res = await fetch("/api/superadmin", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        action: "update_setting",
        key: setting.key,
        value: setting.value,
      }),
    });
    const json = await res.json();
    if (!json.ok) {
      toast.error(json.error || "Save failed");
      return;
    }
    toast.success(`Saved ${setting.key}`);
  }

  return (
    <div>
      <SaHeader
        title="Site configuration"
        description="Brand, shipping thresholds, payment enablement, and locale."
      />
      <div className="space-y-4">
        {settings.map((setting) => (
          <SaCard key={setting.key} title={setting.key}>
            <p className="mb-3 text-sm text-slate-400">{setting.description}</p>
            <textarea
              className="min-h-28 w-full rounded-xl border border-white/10 bg-[#0B1220] p-3 font-mono text-xs text-slate-200"
              value={JSON.stringify(setting.value, null, 2)}
              onChange={(e) => {
                try {
                  const value = JSON.parse(e.target.value) as Record<string, unknown>;
                  setSettings((prev) =>
                    prev.map((s) => (s.key === setting.key ? { ...s, value } : s))
                  );
                } catch {
                  // allow invalid JSON while typing
                }
              }}
            />
            <Button
              size="sm"
              className="mt-3 bg-teal-600 hover:bg-teal-500"
              onClick={() => void save(setting)}
            >
              Save
            </Button>
          </SaCard>
        ))}
      </div>
    </div>
  );
}
