# Security review

## Controls implemented

| Area | Control |
|------|---------|
| Auth | Supabase Auth + middleware session refresh |
| Authorization | RLS + `has_permission` / `is_superadmin` + API `requireAdmin` / `requireSuperAdmin` |
| Headers | HSTS, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy |
| Secrets | Service role / payment secrets server-only (never `NEXT_PUBLIC_`) |
| Webhooks | Provider signature / secret hash verification when configured |
| Abuse | Checkout rate limit (per IP, in-memory) |
| Audit | `audit_logs` writes on inventory, order, flag, and settings mutations |
| Storage | Bucket policies for covers, ebooks, receipts, avatars |

## Threat notes

1. **Demo mode** — Without Supabase, admin APIs default to a demo superadmin session. Never ship production without env vars.
2. **Rate limit** — In-memory limiter is per-instance; use Redis/Upstash for multi-region.
3. **Webhook secrets** — Set `MOOLRE_CALLBACK_SECRET` on the Moolre callback URL. SMS uses server-only `MOOLRE_SMS_API_KEY`.
4. **Service role** — `SUPABASE_SERVICE_ROLE_KEY` bypasses RLS; only use in webhook/fulfillment server routes.
5. **XSS / HTML email** — Prefer text/structured templates; sanitize any user-generated review content before admin display.

## Pre-launch checklist

- [ ] Rotate all demo passwords after seed
- [ ] Confirm RLS enabled on every public table
- [ ] Restrict CORS / allowed origins if adding mobile clients
- [ ] Enable Supabase leaked-password protection
- [ ] Review Vercel env: no service keys in client bundle
- [ ] Turn on provider webhook IP allowlists where available
