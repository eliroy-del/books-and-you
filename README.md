# Books & You

Premium bookstore platform — Next.js, TypeScript, Tailwind, shadcn/ui, Framer Motion, Supabase.

## Phase status

| Phase | Status |
|-------|--------|
| **1** Premium UI + mock data | Complete |
| **2** Supabase schema, RLS, storage, seed | Complete |
| **3** Auth, realtime, orders, wishlist, library, checkout | Complete |
| **4** Payments, shipping, email, notifications, referral | Complete |
| **5** Admin dashboard, inventory, analytics, reports, RBAC | Complete |
| **6** Super Admin, performance, testing, deployment, security, docs | Complete |

## Run

```bash
npm install
cp .env.example .env.local
npm run dev
```

```bash
npm run test
npm run build
```

## Consoles

| Surface | Path |
|---------|------|
| Storefront | `/` |
| Staff admin | `/admin` |
| Super Admin | `/superadmin` |

Demo staff (after seed): `superadmin@booksandyou.test` / `Password123!`

## Phase 6 highlights

- **Super Admin** — flags, site config, payments/shipping health, templates, monitoring, fraud, DB/backups, exports, audit, system logs
- **Performance** — security headers, compression, `optimizePackageImports`, route `loading.tsx`
- **Testing** — Vitest suite for RBAC, shipping, rate limits
- **Deployment** — `vercel.json` + [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- **Security** — [docs/SECURITY.md](docs/SECURITY.md) + checkout rate limiting
- **Docs** — Architecture, Testing, Security, Deployment under `docs/`

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Deployment](docs/DEPLOYMENT.md)
- [Security](docs/SECURITY.md)
- [Testing](docs/TESTING.md)
- [SEO](docs/SEO.md)
- [Moolre payments](docs/MOOLRE.md)
- [Supabase](supabase/README.md)
