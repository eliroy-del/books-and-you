# Deployment (Vercel)

## 1. Prerequisites

- Supabase project with migrations + seed applied (`supabase/README.md`)
- Resend domain verified (optional for email)
- Paystack keys (optional; demo auto-captures without secrets)
- Moolre VAS key + approved Sender ID for SMS (optional; console demo without secrets)

## 2. Environment

Copy `.env.example` → Vercel project env (Production + Preview):

Required for production:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`
- `NEXT_PUBLIC_SITE_URL` (production: `https://booksandyou.shop`)

Recommended:

- `RESEND_API_KEY`, `RESEND_FROM_EMAIL`
- `PAYSTACK_SECRET_KEY`, `PAYSTACK_PUBLIC_KEY`, `NEXT_PUBLIC_PAYSTACK_PUBLIC_KEY`
- `MOOLRE_SMS_API_KEY`, `MOOLRE_SMS_SENDER_ID` (SMS)
- `ADMIN_EMAIL` (contact / support inbox)
- Moolre payment keys if/when the payment adapter is enabled (see `docs/MOOLRE.md`)

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
https://booksandyou.shop/api/webhooks/paystack
```

## 5. Post-deploy smoke

1. `/` loads
2. `/auth` sign-in with seeded staff user
3. `/admin` + `/superadmin` accessible for `super_admin`
4. Checkout creates order (demo or live Paystack)
5. Paystack webhook verify path returns 200 on test event
6. SMS with Moolre keys set delivers to a Ghana number
