# Testing

## Scripts

```bash
npm run test      # vitest unit suite
npm run lint      # eslint
npm run build     # production typecheck + compile
```

## Coverage (Phase 6)

- RBAC permission matrix + module visibility
- Shipping zone resolution + free-threshold quotes
- In-memory rate limiter

## Recommended next tests

- Playwright: checkout happy path, admin inventory adjust, feature flag toggle
- Contract tests for webhook signature verification with fixtures
- RLS policy tests via `supabase test db` / pgTAP
