# Architecture

Books & You is a Next.js App Router bookstore with Supabase-backed auth/data, multi-provider payments, and permissioned admin consoles.

## Stack

| Layer | Choice |
|-------|--------|
| UI | Next.js 16, React 19, Tailwind 4, shadcn/ui, Framer Motion |
| State | Zustand (cart/wishlist), Supabase Auth session |
| Data | Supabase Postgres + RLS + Realtime + Storage |
| Payments | Paystack · Flutterwave · Stripe (`src/lib/providers`) |
| Email / SMS | Resend + SMS provider abstraction |
| Hosting | Vercel |

## Route map

- **Storefront** — `/`, `/books`, `/book/[slug]`, `/cart`, `/checkout`, `/dashboard`, …
- **Admin ops** — `/admin/*` (RBAC-gated modules)
- **Super Admin** — `/superadmin/*` (platform control plane)
- **APIs** — `/api/checkout`, `/api/admin/*`, `/api/superadmin`, webhooks

## Security model

1. **Customers** — RLS limits rows to `auth.uid()`.
2. **Staff** — `has_permission(key)` / `is_staff()` for admin modules.
3. **Super Admin** — `is_superadmin()` for platform settings, flags, webhooks.

## Key folders

```
src/app/                 # App Router pages + API routes
src/components/          # UI, admin, superadmin shells
src/lib/admin/           # RBAC permissions + API guards
src/lib/providers/       # Payment adapters
src/lib/services/        # Domain services
src/lib/superadmin/      # Control-plane services
src/lib/security/        # Rate limiting helpers
supabase/migrations/     # Schema, RLS, storage
```

## Demo vs production

When Supabase / payment / Resend keys are missing, services fall back to in-memory or console demo modes so the UI stays usable locally.
