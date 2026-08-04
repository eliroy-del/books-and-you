/** Admin RBAC: permission keys, modules, demo role matrix */

export type RoleKey =
  | "super_admin"
  | "inventory_manager"
  | "sales_manager"
  | "support_agent"
  | "finance"
  | "marketing_manager"
  | "publisher_manager"
  | "customer";

export type PermissionKey =
  | "catalog.read"
  | "catalog.write"
  | "authors.write"
  | "publishers.write"
  | "inventory.read"
  | "inventory.write"
  | "orders.read"
  | "orders.write"
  | "customers.read"
  | "customers.write"
  | "finance.read"
  | "finance.write"
  | "marketing.read"
  | "marketing.write"
  | "support.read"
  | "support.write"
  | "reviews.moderate"
  | "subscriptions.read"
  | "subscriptions.write"
  | "settings.write"
  | "audit.read";

export const ALL_PERMISSIONS: PermissionKey[] = [
  "catalog.read",
  "catalog.write",
  "authors.write",
  "publishers.write",
  "inventory.read",
  "inventory.write",
  "orders.read",
  "orders.write",
  "customers.read",
  "customers.write",
  "finance.read",
  "finance.write",
  "marketing.read",
  "marketing.write",
  "support.read",
  "support.write",
  "reviews.moderate",
  "subscriptions.read",
  "subscriptions.write",
  "settings.write",
  "audit.read",
];

/** Mirrors supabase/seed role_permissions */
export const ROLE_PERMISSIONS: Record<RoleKey, PermissionKey[]> = {
  super_admin: [..ALL_PERMISSIONS],
  inventory_manager: [
    "catalog.read",
    "catalog.write",
    "inventory.read",
    "inventory.write",
    "orders.read",
  ],
  sales_manager: [
    "catalog.read",
    "orders.read",
    "orders.write",
    "customers.read",
    "marketing.read",
  ],
  support_agent: [
    "support.read",
    "support.write",
    "orders.read",
    "customers.read",
  ],
  finance: [
    "finance.read",
    "finance.write",
    "orders.read",
    "subscriptions.read",
  ],
  marketing_manager: [
    "marketing.read",
    "marketing.write",
    "catalog.read",
    "reviews.moderate",
  ],
  publisher_manager: [
    "catalog.read",
    "catalog.write",
    "authors.write",
    "publishers.write",
    "inventory.read",
  ],
  customer: [],
};

export type AdminModuleId =
  | "dashboard"
  | "inventory"
  | "books"
  | "authors"
  | "publishers"
  | "categories"
  | "orders"
  | "customers"
  | "coupons"
  | "gifts"
  | "reviews"
  | "support"
  | "returns"
  | "reports"
  | "analytics"
  | "promotions"
  | "audit"
  | "rbac";

export type AdminModule = {
  id: AdminModuleId;
  label: string;
  href: string;
  /** Any of these permissions grants access; empty = any staff */
  anyOf: PermissionKey[];
};

export const ADMIN_MODULES: AdminModule[] = [
  { id: "dashboard", label: "Dashboard", href: "/admin", anyOf: [] },
  {
    id: "inventory",
    label: "Inventory",
    href: "/admin/inventory",
    anyOf: ["inventory.read"],
  },
  { id: "books", label: "Books", href: "/admin/books", anyOf: ["catalog.read"] },
  {
    id: "authors",
    label: "Authors",
    href: "/admin/authors",
    anyOf: ["catalog.read", "authors.write"],
  },
  {
    id: "publishers",
    label: "Publishers",
    href: "/admin/publishers",
    anyOf: ["catalog.read", "publishers.write"],
  },
  {
    id: "categories",
    label: "Categories",
    href: "/admin/categories",
    anyOf: ["catalog.read"],
  },
  { id: "orders", label: "Orders", href: "/admin/orders", anyOf: ["orders.read"] },
  {
    id: "customers",
    label: "Customers",
    href: "/admin/customers",
    anyOf: ["customers.read"],
  },
  {
    id: "coupons",
    label: "Coupons",
    href: "/admin/coupons",
    anyOf: ["marketing.read"],
  },
  {
    id: "gifts",
    label: "Gift cards",
    href: "/admin/gifts",
    anyOf: ["marketing.read", "finance.read"],
  },
  {
    id: "reviews",
    label: "Reviews",
    href: "/admin/reviews",
    anyOf: ["reviews.moderate"],
  },
  {
    id: "support",
    label: "Support",
    href: "/admin/support",
    anyOf: ["support.read"],
  },
  {
    id: "returns",
    label: "Returns",
    href: "/admin/returns",
    anyOf: ["orders.read", "orders.write"],
  },
  {
    id: "reports",
    label: "Reports",
    href: "/admin/reports",
    anyOf: ["finance.read", "orders.read"],
  },
  {
    id: "analytics",
    label: "Analytics",
    href: "/admin/analytics",
    anyOf: ["finance.read", "orders.read", "inventory.read"],
  },
  {
    id: "promotions",
    label: "Promotions",
    href: "/admin/promotions",
    anyOf: ["marketing.read"],
  },
  { id: "audit", label: "Audit logs", href: "/admin/audit", anyOf: ["audit.read"] },
  {
    id: "rbac",
    label: "RBAC",
    href: "/admin/rbac",
    anyOf: ["settings.write", "audit.read"],
  },
];

export const STAFF_ROLES: RoleKey[] = [
  "super_admin",
  "inventory_manager",
  "sales_manager",
  "support_agent",
  "finance",
  "marketing_manager",
  "publisher_manager",
];

export const DEMO_STAFF_BY_EMAIL: Record<string, RoleKey> = {
  "superadmin@booksandyou.test": "super_admin",
  "inventory@booksandyou.test": "inventory_manager",
  "sales@booksandyou.test": "sales_manager",
  "support@booksandyou.test": "support_agent",
  "finance@booksandyou.test": "finance",
  "marketing@booksandyou.test": "marketing_manager",
  "publisher@booksandyou.test": "publisher_manager",
};

export function permissionsForRole(role: RoleKey): PermissionKey[] {
  return ROLE_PERMISSIONS[role] ?? [];
}

export function hasAnyPermission(
  granted: string[],
  required: PermissionKey[]
): boolean {
  if (required.length === 0) return true;
  if (granted.includes("*")) return true;
  return required.some((p) => granted.includes(p));
}

export function canAccessModule(
  granted: string[],
  module: AdminModule
): boolean {
  return hasAnyPermission(granted, module.anyOf);
}

export function visibleModules(granted: string[]): AdminModule[] {
  return ADMIN_MODULES.filter((m) => canAccessModule(granted, m));
}

export function roleLabel(role: RoleKey): string {
  return role
    .split("_")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}

export function resolveDemoRole(email?: string | null, override?: string | null): RoleKey {
  if (override && STAFF_ROLES.includes(override as RoleKey)) {
    return override as RoleKey;
  }
  if (email && DEMO_STAFF_BY_EMAIL[email.toLowerCase()]) {
    return DEMO_STAFF_BY_EMAIL[email.toLowerCase()];
  }
  // Default demo admin access so /admin works without login
  return "super_admin";
}
