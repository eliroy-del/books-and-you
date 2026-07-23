import { describe, expect, it } from "vitest";
import {
  canAccessModule,
  hasAnyPermission,
  permissionsForRole,
  visibleModules,
} from "@/lib/admin/permissions";
import { quoteShipping, resolveShippingZone } from "@/lib/services/shipping";
import { rateLimit } from "@/lib/security/rate-limit";

describe("RBAC", () => {
  it("grants inventory manager inventory modules", () => {
    const perms = permissionsForRole("inventory_manager");
    expect(perms).toContain("inventory.write");
    expect(hasAnyPermission(perms, ["inventory.read"])).toBe(true);
    expect(hasAnyPermission(perms, ["finance.write"])).toBe(false);
  });

  it("filters visible modules by permission", () => {
    const perms = permissionsForRole("support_agent");
    const modules = visibleModules(perms).map((m) => m.id);
    expect(modules).toContain("support");
    expect(modules).not.toContain("inventory");
  });

  it("allows dashboard for any staff permission set", () => {
    const dashboard = visibleModules(permissionsForRole("finance")).find(
      (m) => m.id === "dashboard"
    );
    expect(dashboard).toBeTruthy();
    expect(canAccessModule(["orders.read"], { id: "orders", label: "Orders", href: "/admin/orders", anyOf: ["orders.read"] })).toBe(true);
  });
});

describe("shipping", () => {
  it("resolves Accra zone", () => {
    expect(resolveShippingZone({ city: "Accra", country: "Ghana" })).toBe("accra");
  });

  it("quotes free shipping above threshold", () => {
    const quote = quoteShipping({
      city: "Accra",
      country: "Ghana",
      subtotalCents: 50000,
    });
    expect(quote.free).toBe(true);
    expect(quote.amountCents).toBe(0);
  });

  it("quotes international outside Ghana", () => {
    const quote = quoteShipping({
      city: "London",
      country: "UK",
      subtotalCents: 10000,
    });
    expect(quote.zone).toBe("international");
    expect(quote.amountCents).toBeGreaterThan(0);
  });
});

describe("rate limit", () => {
  it("blocks after limit", () => {
    const key = `test-${Date.now()}`;
    for (let i = 0; i < 3; i++) {
      expect(rateLimit(key, { limit: 3, windowMs: 60_000 }).ok).toBe(true);
    }
    expect(rateLimit(key, { limit: 3, windowMs: 60_000 }).ok).toBe(false);
  });
});
