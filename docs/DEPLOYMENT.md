# Deployment (Vercel)

## 1. Prerequisites

- Supabase project with migrations + seed applied (`supabase/README.md`)
- Resend domain verified (optional for email)
- Moolre payment + SMS keys (optional; demo auto-captures without payment secrets)

## 2. Environment

Copy `.env.example` → Vercel project env (Production + Preview):

Required for production:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_SITE_URL` (production: `https://booksandyou.shop`)

Recommended:

- `RESEND_API_KEY`, `RESEND_FROM_EMAIL`
- `ADMIN_EMAIL`
- `MOOLRE_API_USER`, `MOOLRE_API_PUBKEY`, `MOOLRE_ACCOUNT_NUMBER`, `MOOLRE_CALLBACK_SECRET`
- `MOOLRE_SMS_API_KEY`, `MOOLRE_SMS_SENDER_ID`
- `MOOLRE_API_KEY` (private key — needed for MoMo push / transfers, not hosted checkout links)

## 3. Deploy

```bash
npm i -g vercel
vercel link
vercel env pull
vercel --prod
```

Or connect the GitHub repo in the Vercel dashboard (framework: Next.js). `vercel.json` sets region + baseline headers.

## 4. Webhooks / callbacks

Point Moolre wallet callback URL to:

```
https://booksandyou.shop/api/webhooks/moolre?secret=<MOOLRE_CALLBACK_SECRET>
```

The handler rejects unsigned callbacks when `MOOLRE_CALLBACK_SECRET` is set, then re-verifies the payment via Moolre’s status API before fulfilling an order.

Connectivity probe:

```bash
node --env-file=.env.local scripts/check-comms.mjs
```

## 5. Post-deploy smoke

1. `/` loads
2. `/auth` sign-in with seeded staff user
3. `/admin` + `/superadmin` accessible for `super_admin`
4. Checkout creates a Moolre payment link and redirects to POS
5. `GET /api/webhooks/moolre` returns `{ ok: true }`
6. SMS with Moolre keys set delivers to a Ghana number
7. Set `ADMIN_EMAIL` so contact/support and email probes use your inbox
