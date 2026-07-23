import { NextResponse } from "next/server";
import { requireSuperAdmin, writeAuditLog } from "@/lib/admin/guard";
import {
  buildExportManifest,
  getApiMonitoring,
  getBackupStatus,
  getFraudSignals,
  getPaymentProviderHealth,
  getPlatformHealth,
  getRbacOverview,
  getShippingProviders,
  getSystemLogs,
  listAuditCenter,
  listFeatureFlags,
  listNotificationTemplates,
  listSiteSettings,
  listWebhookLogs,
  setFeatureFlag,
  updateSiteSetting,
} from "@/lib/superadmin/platform";

export async function GET(request: Request) {
  const auth = await requireSuperAdmin();
  if ("error" in auth) return auth.error;

  const { searchParams } = new URL(request.url);
  const section = searchParams.get("section") || "overview";

  switch (section) {
    case "overview":
      return NextResponse.json({
        ok: true,
        health: getPlatformHealth(),
        session: { email: auth.session.email, role: auth.session.roleKey },
      });
    case "flags":
      return NextResponse.json({ ok: true, flags: await listFeatureFlags() });
    case "settings":
      return NextResponse.json({ ok: true, settings: await listSiteSettings() });
    case "templates":
      return NextResponse.json({
        ok: true,
        templates: await listNotificationTemplates(),
      });
    case "payments":
      return NextResponse.json({ ok: true, providers: getPaymentProviderHealth() });
    case "shipping":
      return NextResponse.json({ ok: true, providers: getShippingProviders() });
    case "monitoring":
      return NextResponse.json({ ok: true, monitoring: getApiMonitoring() });
    case "fraud":
      return NextResponse.json({ ok: true, signals: getFraudSignals() });
    case "database":
      return NextResponse.json({
        ok: true,
        health: getPlatformHealth(),
        backups: getBackupStatus(),
      });
    case "exports":
      return NextResponse.json({ ok: true, manifest: buildExportManifest() });
    case "backups":
      return NextResponse.json({ ok: true, backups: getBackupStatus() });
    case "audit":
      return NextResponse.json({ ok: true, entries: await listAuditCenter() });
    case "logs":
      return NextResponse.json({ ok: true, logs: getSystemLogs() });
    case "webhooks":
      return NextResponse.json({ ok: true, webhooks: await listWebhookLogs() });
    case "rbac":
      return NextResponse.json({ ok: true, rbac: getRbacOverview() });
    case "permissions":
      return NextResponse.json({
        ok: true,
        rbac: getRbacOverview(),
        focus: "permissions",
      });
    default:
      return NextResponse.json({ ok: false, error: "Unknown section" }, { status: 400 });
  }
}

export async function PATCH(request: Request) {
  const auth = await requireSuperAdmin();
  if ("error" in auth) return auth.error;

  const body = (await request.json()) as {
    action?: string;
    key?: string;
    enabled?: boolean;
    value?: Record<string, unknown>;
  };

  if (body.action === "toggle_flag" && body.key && typeof body.enabled === "boolean") {
    const flag = await setFeatureFlag(body.key, body.enabled);
    if (!flag) {
      return NextResponse.json({ ok: false, error: "Flag not found" }, { status: 404 });
    }
    await writeAuditLog({
      actorId: auth.session.userId,
      action: "feature_flag.toggle",
      entityType: "feature_flags",
      metadata: { key: body.key, enabled: body.enabled },
    });
    return NextResponse.json({ ok: true, flag });
  }

  if (body.action === "update_setting" && body.key && body.value) {
    const setting = await updateSiteSetting(body.key, body.value);
    if (!setting) {
      return NextResponse.json({ ok: false, error: "Setting not found" }, { status: 404 });
    }
    await writeAuditLog({
      actorId: auth.session.userId,
      action: "site_settings.update",
      entityType: "site_settings",
      metadata: { key: body.key },
    });
    return NextResponse.json({ ok: true, setting });
  }

  return NextResponse.json({ ok: false, error: "Unsupported action" }, { status: 400 });
}
