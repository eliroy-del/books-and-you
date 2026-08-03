/**
 * Super Admin platform services — demo store + Supabase-backed when linked.
 */

import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { db } from "@/lib/supabase/typed";
import { ALL_PERMISSIONS, ROLE_PERMISSIONS, STAFF_ROLES, roleLabel } from "@/lib/admin/permissions";
import { listPaymentProviders } from "@/lib/providers";

export type FeatureFlag = {
  key: string;
  enabled: boolean;
  description: string;
};

export type SiteSetting = {
  key: string;
  value: Record<string, unknown>;
  description: string;
};

export type NotificationTemplate = {
  id: string;
  key: string;
  channel: "email" | "sms" | "push";
  subject: string | null;
  body: string;
  is_active: boolean;
};

export type WebhookLog = {
  id: string;
  provider: string;
  event_type: string;
  status: string;
  error: string | null;
  created_at: string;
};

export type AuditEntry = {
  id: string;
  action: string;
  actor: string;
  resource_type: string | null;
  created_at: string;
  metadata: Record<string, unknown>;
};

export type PlatformHealth = {
  uptime: string;
  database: "healthy" | "degraded" | "demo";
  rlsCoverage: number;
  lastBackupAt: string;
  failedWebhooks24h: number;
  apiP95Ms: number;
  fraudSignalsOpen: number;
  storageBuckets: number;
};

const demoFlags: FeatureFlag[] = [
  { key: "ai_recommendations", enabled: true, description: "Personalized recommendations" },
  { key: "preorders", enabled: true, description: "Allow preorder checkout" },
  { key: "referrals", enabled: true, description: "Referral rewards program" },
  { key: "subscriptions", enabled: true, description: "Subscription box plans" },
  { key: "gift_cards", enabled: true, description: "Gift card purchases" },
  { key: "live_inventory", enabled: true, description: "Realtime stock updates" },
  { key: "marketplace_authors", enabled: false, description: "Author self-serve listings" },
  { key: "fraud_rules", enabled: true, description: "Checkout fraud heuristics" },
  { key: "sms_notifications", enabled: false, description: "Transactional SMS" },
  { key: "dark_promo_banner", enabled: true, description: "Homepage promo strip" },
  { key: "bulk_institutional", enabled: false, description: "B2B bulk checkout" },
  { key: "ebook_drm", enabled: true, description: "Signed ebook download links" },
];

const demoSettings: SiteSetting[] = [
  {
    key: "brand",
    value: { name: "Books & You", primary: "#0F766E", accent: "#D4A017" },
    description: "Brand tokens",
  },
  {
    key: "shipping",
    value: {
      free_delivery_threshold_cents: 30000,
      currency: "GHS",
      default_shipping_cents: 2500,
    },
    description: "Shipping rules",
  },
  {
    key: "payments",
    value: { providers: ["moolre"] },
    description: "Enabled payment providers",
  },
  {
    key: "locale",
    value: {
      default_country: "GH",
      timezone: "Africa/Accra",
      support_email: process.env.ADMIN_EMAIL || "hello@booksandyou.shop",
    },
    description: "Locale & support",
  },
];

const demoTemplates: NotificationTemplate[] = [
  {
    id: "nt-1",
    key: "order_confirmation",
    channel: "email",
    subject: "Your Books & You order {{order_number}}",
    body: "Thanks for your order. Total: {{total}}.",
    is_active: true,
  },
  {
    id: "nt-2",
    key: "order_shipped",
    channel: "email",
    subject: "Your order is on the way",
    body: "Tracking: {{tracking_number}}",
    is_active: true,
  },
  {
    id: "nt-3",
    key: "welcome_sms",
    channel: "sms",
    subject: null,
    body: "Welcome to Books & You! Code {{referral_code}} earns credit.",
    is_active: true,
  },
  {
    id: "nt-4",
    key: "low_stock_alert",
    channel: "email",
    subject: "Low stock: {{title}}",
    body: "Only {{quantity}} units remain for {{format}}.",
    is_active: true,
  },
];

const demoWebhooks: WebhookLog[] = [
  {
    id: "wh-1",
    provider: "moolre",
    event_type: "P01",
    status: "processed",
    error: null,
    created_at: "2026-07-23T14:02:11Z",
  },
  {
    id: "wh-2",
    provider: "moolre",
    event_type: "sms.delivered",
    status: "processed",
    error: null,
    created_at: "2026-07-23T12:41:03Z",
  },
];

const demoAudits: AuditEntry[] = [
  {
    id: "au-1",
    action: "feature_flag.toggle",
    actor: "Super Admin",
    resource_type: "feature_flags",
    created_at: "2026-07-23T15:10:00Z",
    metadata: { key: "sms_notifications", enabled: false },
  },
  {
    id: "au-2",
    action: "site_settings.update",
    actor: "Super Admin",
    resource_type: "site_settings",
    created_at: "2026-07-23T11:02:00Z",
    metadata: { key: "shipping" },
  },
  {
    id: "au-3",
    action: "inventory.adjust",
    actor: "Ivy Manager",
    resource_type: "book_inventory",
    created_at: "2026-07-23T10:12:00Z",
    metadata: { delta: 12 },
  },
];

export async function listFeatureFlags(): Promise<FeatureFlag[]> {
  if (!isSupabaseConfigured()) return [...demoFlags];
  const supabase = await tryCreateClient();
  if (!supabase) return [...demoFlags];
  const { data } = await db(supabase)
    .from("feature_flags")
    .select("key, enabled, description")
    .order("key");
  return (data as FeatureFlag[])?.length ? (data as FeatureFlag[]) : [...demoFlags];
}

export async function setFeatureFlag(
  key: string,
  enabled: boolean
): Promise<FeatureFlag | null> {
  if (!isSupabaseConfigured()) {
    const flag = demoFlags.find((f) => f.key === key);
    if (!flag) return null;
    flag.enabled = enabled;
    return { ...flag };
  }
  const supabase = await tryCreateClient();
  if (!supabase) return null;
  const { data } = await db(supabase)
    .from("feature_flags")
    .upsert({ key, enabled, updated_at: new Date().toISOString() })
    .select("key, enabled, description")
    .single();
  return (data as FeatureFlag) ?? null;
}

export async function listSiteSettings(): Promise<SiteSetting[]> {
  if (!isSupabaseConfigured()) return [...demoSettings];
  const supabase = await tryCreateClient();
  if (!supabase) return [...demoSettings];
  const { data } = await db(supabase).from("site_settings").select("key, value, description");
  return (data as SiteSetting[])?.length ? (data as SiteSetting[]) : [...demoSettings];
}

export async function updateSiteSetting(
  key: string,
  value: Record<string, unknown>
): Promise<SiteSetting | null> {
  if (!isSupabaseConfigured()) {
    const row = demoSettings.find((s) => s.key === key);
    if (!row) return null;
    row.value = value;
    return { ...row };
  }
  const supabase = await tryCreateClient();
  if (!supabase) return null;
  const { data } = await db(supabase)
    .from("site_settings")
    .upsert({ key, value, updated_at: new Date().toISOString() })
    .select("key, value, description")
    .single();
  return (data as SiteSetting) ?? null;
}

export async function listNotificationTemplates(): Promise<NotificationTemplate[]> {
  if (!isSupabaseConfigured()) return [...demoTemplates];
  const supabase = await tryCreateClient();
  if (!supabase) return [...demoTemplates];
  const { data } = await db(supabase)
    .from("notification_templates")
    .select("id, key, channel, subject, body, is_active")
    .order("key");
  return (data as NotificationTemplate[])?.length
    ? (data as NotificationTemplate[])
    : [...demoTemplates];
}

export async function listWebhookLogs(): Promise<WebhookLog[]> {
  if (!isSupabaseConfigured()) return [...demoWebhooks];
  const supabase = await tryCreateClient();
  if (!supabase) return [...demoWebhooks];
  const { data } = await db(supabase)
    .from("webhook_logs")
    .select("id, provider, event_type, status, error, created_at")
    .order("created_at", { ascending: false })
    .limit(40);
  return (data as WebhookLog[])?.length ? (data as WebhookLog[]) : [...demoWebhooks];
}

export async function listAuditCenter(): Promise<AuditEntry[]> {
  if (!isSupabaseConfigured()) return [...demoAudits];
  const supabase = await tryCreateClient();
  if (!supabase) return [...demoAudits];
  const { data } = await db(supabase)
    .from("audit_logs")
    .select("id, action, actor_id, resource_type, created_at, metadata, profiles(full_name)")
    .order("created_at", { ascending: false })
    .limit(50);
  if (!data?.length) return [...demoAudits];
  return (data as any[]).map((row) => ({
    id: row.id,
    action: row.action,
    actor:
      (Array.isArray(row.profiles) ? row.profiles[0]?.full_name : row.profiles?.full_name) ||
      row.actor_id ||
      "system",
    resource_type: row.resource_type,
    created_at: row.created_at,
    metadata: row.metadata || {},
  }));
}

export function getPlatformHealth(): PlatformHealth {
  return {
    uptime: "99.98%",
    database: isSupabaseConfigured() ? "healthy" : "demo",
    rlsCoverage: 100,
    lastBackupAt: new Date(Date.now() - 6 * 3600_000).toISOString(),
    failedWebhooks24h: demoWebhooks.filter((w) => w.status === "failed").length,
    apiP95Ms: 186,
    fraudSignalsOpen: 1,
    storageBuckets: 8,
  };
}

export function getPaymentProviderHealth() {
  return listPaymentProviders().map((p) => {
    const configured =
      Boolean(
        process.env.MOOLRE_API_USER &&
          process.env.MOOLRE_API_PUBKEY &&
          process.env.MOOLRE_ACCOUNT_NUMBER
      ) || p.configured;
    return {
      id: p.id,
      label: p.label,
      configured,
      mode: configured ? "live_keys" : "demo_autocapture",
      webhookPath: `/api/webhooks/${p.id}`,
      status: configured ? "ready" : "demo",
    };
  });
}

export function getShippingProviders() {
  return [
    {
      id: "booksandyou_courier",
      name: "Books & You Courier",
      zones: ["accra", "greater_accra", "nationwide"],
      status: "active",
    },
    {
      id: "dhl",
      name: "DHL Express",
      zones: ["international"],
      status: "active",
    },
    {
      id: "gps",
      name: "Ghana Post",
      zones: ["nationwide"],
      status: "standby",
    },
  ];
}

export function getFraudSignals() {
  return [
    {
      id: "fr-1",
      severity: "medium",
      signal: "Velocity: 4 checkouts / 10m from same IP",
      orderRef: "BY-10499",
      status: "open",
      at: "2026-07-23T15:40:00Z",
    },
    {
      id: "fr-2",
      severity: "low",
      signal: "Billing country ≠ shipping country",
      orderRef: "BY-10471",
      status: "reviewed",
      at: "2026-07-22T09:18:00Z",
    },
  ];
}

export function getApiMonitoring() {
  return {
    endpoints: [
      { path: "/api/checkout", p50: 120, p95: 280, errorRate: 0.2 },
      { path: "/api/payments/verify", p50: 90, p95: 210, errorRate: 0.1 },
      { path: "/api/admin/inventory", p50: 45, p95: 110, errorRate: 0 },
      { path: "/api/webhooks/moolre", p50: 30, p95: 80, errorRate: 0.4 },
      { path: "/api/wishlist", p50: 35, p95: 95, errorRate: 0 },
    ],
    webhooks: demoWebhooks,
  };
}

export function getRbacOverview() {
  return {
    roles: STAFF_ROLES.map((key) => ({
      key,
      label: roleLabel(key),
      permissions: ROLE_PERMISSIONS[key],
    })),
    permissionCount: ALL_PERMISSIONS.length,
  };
}

export function getSystemLogs() {
  return [
    { level: "info", message: "Checkout completed BY-10482", at: "2026-07-23T15:01:12Z" },
    { level: "info", message: "Moolre SMS sender ID approved", at: "2026-07-22T18:20:44Z" },
    { level: "info", message: "Inventory adjust +10 paperback", at: "2026-07-23T10:12:00Z" },
    { level: "info", message: "Feature flag sms_notifications=false", at: "2026-07-23T15:10:00Z" },
    { level: "error", message: "Resend skipped — RESEND_API_KEY missing (demo)", at: "2026-07-23T09:00:01Z" },
  ];
}

export function buildExportManifest() {
  return {
    generatedAt: new Date().toISOString(),
    datasets: [
      { name: "orders", format: "csv", rows: 148 },
      { name: "customers", format: "csv", rows: 50 },
      { name: "inventory", format: "csv", rows: 186 },
      { name: "audit_logs", format: "json", rows: 420 },
      { name: "feature_flags", format: "json", rows: demoFlags.length },
    ],
  };
}

export function getBackupStatus() {
  return {
    lastSuccessful: new Date(Date.now() - 6 * 3600_000).toISOString(),
    schedule: "Daily 02:00 GMT",
    retentionDays: 30,
    targets: ["Supabase PITR", "Storage bucket snapshots"],
    nextRun: new Date(Date.now() + 10 * 3600_000).toISOString(),
  };
}
