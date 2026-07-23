# Deployment (Vercel)

## 1. Prerequisites

- Supabase project with migrations + seed applied (`supabase/README.md`)
- Resend domain verified (optional for email)
- Paystack / Flutterwave / Stripe keys (optional; demo auto-captures without secrets)

## 2. Environment

Copy `.env.example` → Vercel project env (Production + Preview):

Required for production:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_SITE_URL` (e.g. `https://booksandyou.com`)

Recommended:

- `RESEND_API_KEY`, `RESEND_FROM_EMAIL`
- Payment secrets + public keys
- `STRIPE_WEBHOOK_SECRET`, `FLUTTERWAVE_SECRET_HASH`

## 3. Deploy

```bash
npm i -g vercel
vercel link
vercel env pull
vercel --prod
```

Or connect the GitHub repo in the Vercel dashboard (framework: Next.js). `vercel.json` sets region + baseline headers.

## 4. Webhooks

Point providers to:

```
https://<domain>/api/webhooks/paystack
https://<domain>/api/webhooks/flutterwave
https://<domain>/api/webhooks/stripe
```

## 5. Post-deploy smoke

1. `/` loads
2. `/auth` sign-in with seeded staff user
3. `/admin` + `/superadmin` accessible for `super_admin`
4. Checkout creates order (demo or live provider)
5. Webhook verify path returns 200 on test event
