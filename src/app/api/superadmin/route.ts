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
import { getFieldErrors, superAdminPatchSchema } from "@/lib/validation";

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

  const body = await request.json();
  const parsed = superAdminPatchSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { ok: false, error: "Validation failed", errors: getFieldErrors(parsed.error) },
      { status: 400 }
    );
  }

  if (parsed.data.action === "toggle_flag") {
    const flag = await setFeatureFlag(parsed.data.key, parsed.data.enabled);
    if (!flag) {
      return NextResponse.json({ ok: false, error: "Flag not found" }, { status: 404 });
    }
    await writeAuditLog({
      actorId: auth.session.userId,
      action: "feature_flag.toggle",
      entityType: "feature_flags",
      metadata: { key: parsed.data.key, enabled: parsed.data.enabled },
    });
    return NextResponse.json({ ok: true, flag });
  }

  const setting = await updateSiteSetting(parsed.data.key, parsed.data.value);
  if (!setting) {
    return NextResponse.json({ ok: false, error: "Setting not found" }, { status: 404 });
  }
  await writeAuditLog({
    actorId: auth.session.userId,
    action: "site_settings.update",
    entityType: "site_settings",
    metadata: { key: parsed.data.key },
  });
  return NextResponse.json({ ok: true, setting });
}
