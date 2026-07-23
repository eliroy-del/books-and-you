# Supabase — Phase 2

Schema, RLS, storage buckets, realtime publication, and seed data for **Books & You**.

## Hosted project (current)

Migrations + catalog seed were applied via Supabase MCP. Demo auth users:

```bash
npm run seed:users
```

## Apply locally

```bash
# Install CLI: https://supabase.com/docs/guides/cli
supabase start
supabase db reset   # runs migrations + seed.sql
```

Or against a hosted project:

```bash
supabase link --project-ref <your-ref>
supabase db push
# then run seed in SQL editor, or:
psql "$DATABASE_URL" -f supabase/seed.sql
npm run seed:users
```

Regenerate seed:

```bash
npm run seed:generate
```

## Demo accounts (after seed)

| Email | Password | Role |
|-------|----------|------|
| `reader01@booksandyou.test` | `Password123!` | Customer (Ama Darko) |
| `superadmin@booksandyou.test` | `Password123!` | super_admin |
| `inventory@booksandyou.test` | `Password123!` | inventory_manager |
| `sales@booksandyou.test` | `Password123!` | sales_manager |
| `support@booksandyou.test` | `Password123!` | support_agent |
| `finance@booksandyou.test` | `Password123!` | finance |

Customers: `reader01` … `reader50@booksandyou.test`

## Migrations

| File | Purpose |
|------|---------|
| `20260723160001_schema_core.sql` | Auth/RBAC, catalog, library |
| `20260723160002_schema_commerce.sql` | Orders, payments, subs, support, system |
| `20260723160003_functions.sql` | `is_superadmin()`, `has_permission()`, triggers |
| `20260723160004_rls.sql` | Row Level Security |
| `20260723160005_storage.sql` | Buckets + storage policies |
| `20260723160006_realtime.sql` | Live inventory / orders / notifications |

## Storage buckets

`book-covers` · `ebooks` · `author-images` · `publisher-logos` · `receipts` · `user-uploads` · `avatars` · `marketing-assets`

## Helpers

```sql
select public.is_superadmin();
select public.has_permission('orders.read');
```

## App env

Copy `.env.example` → `.env.local` and fill Supabase URL + anon/service keys after `supabase start` (see `supabase status`).
