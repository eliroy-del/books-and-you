# Moolre Payments — Setup & API Key Guide

Moolre is the payment provider for Books & You (mobile money + cards, GHS settlement).
This guide covers **how to obtain your API keys**, **which environment variables to set**,
and **how the API works** so the integration can be wired up and tested.

- Live base URL: `https://api.moolre.com`
- Sandbox base URL: `https://sandbox.moolre.com`
- Official docs: <https://docs.moolre.com>
- Support: `hello@moolre.com`

---

## 1. Get your API keys

Moolre authenticates with **API keys sent as request headers** — not a bearer token.
You need four values before you can take a single payment.

### Steps in the Moolre dashboard

1. Create a Moolre business account at <https://moolre.com> and complete KYC/business verification.
   Payments cannot go live until verification is approved.
2. On signup a **business wallet** is created automatically. Open it and copy the
   **Account Number** (a 12-digit number such as `100000157291`). Every API call includes it.
3. Go to the **API / Developer** section of the dashboard and generate your keys. You will get:
   - a **Private API Key** — used for money-moving endpoints (collections, transfers)
   - a **Public API Key** — used for payment links and status lookups
4. Note your **Moolre username** — this is the `X-API-USER` value, not your email.
5. Set your **Callback (webhook) URL** on the wallet/API settings to:
   `https://booksandyou.shop/api/webhooks/moolre`
6. Repeat in the **sandbox** dashboard for test credentials.

### The four values you need

| Dashboard value | Header it maps to | Used for |
| --- | --- | --- |
| Username | `X-API-USER` | Every request |
| Private API Key | `X-API-KEY` | Initiating payments, transfers |
| Public API Key | `X-API-PUBKEY` | Payment links, payment status |
| Account Number | `accountnumber` body field | Every request |

---

## 2. Environment variables

Add these to `.env.local` for development and to your **Vercel project settings** for production.

```env
# Moolre — https://docs.moolre.com
MOOLRE_API_USER=
MOOLRE_API_KEY=
MOOLRE_API_PUBKEY=
MOOLRE_ACCOUNT_NUMBER=
MOOLRE_BASE_URL=https://api.moolre.com
MOOLRE_CURRENCY=GHS

# SMS — separate VAS key + approved Sender ID (max 11 chars)
MOOLRE_VAS_KEY=
MOOLRE_SMS_SENDER_ID=BooksNYou
```

For sandbox testing, point the base URL at sandbox instead:

```env
MOOLRE_BASE_URL=https://sandbox.moolre.com
```

SMS still requires `X-API-VASKEY` even in sandbox.

### Two things to be careful about

**The "Public API Key" is not browser-safe.** Despite the name, it is a server-side
credential used to create payment links and read transaction status. Do **not** prefix it
with `NEXT_PUBLIC_` and never ship it to the client — anyone holding it could enumerate your
transactions. All four Moolre payment values stay server-only, unlike the Paystack
publishable key already in `.env.example`.

**Moolre amounts are in major units.** Moolre expects `"amount": "50"` to mean GHS 50.00.
This codebase passes money around in minor units (`amountCents`), matching Paystack.
Any payment adapter must divide by 100 on the way out and multiply by 100 on the way back,
or every charge will be 100× too small.

---

## 3. Response envelope

Every Moolre endpoint returns the same shape, so check `status` before trusting `data`:

```json
{
  "status": 1,
  "code": "POS09",
  "message": "POS payment link successfully generated.",
  "data": { },
  "go": null
}
```

| Field | Meaning |
| --- | --- |
| `status` | `1` = success, `0` = failure |
| `code` | Stable machine-readable result code (see §7) |
| `message` | Human-readable description |
| `data` | The payload — an object, array, or bare string depending on endpoint |
| `go` | Navigation hint, usually `null` |

Note that a failed request can still return HTTP 200 with `"status": 0`, and `status` is
sometimes a string (`"0"`) rather than a number. Compare loosely: `Number(json.status) === 1`.

---

## 4. Endpoints for checkout

### Recommended: hosted payment link

This is the right choice for the Books & You checkout — Moolre hosts the payment page and
handles mobile money, cards, and the OTP flow, so you never touch card data.

```
POST {MOOLRE_BASE_URL}/embed/link
X-API-USER: <MOOLRE_API_USER>
X-API-PUBKEY: <MOOLRE_API_PUBKEY>
Content-Type: application/json
```

| Body field | Required | Notes |
| --- | --- | --- |
| `type` | Yes | Always `1` |
| `amount` | Yes | Major units, e.g. `"150"` for GHS 150 |
| `email` | Yes | Business email |
| `externalref` | Yes | Your unique order reference — must never repeat |
| `currency` | Yes | `GHS` |
| `accountnumber` | Yes | Your wallet account number |
| `reusable` | Yes | `"0"` for one-off checkout, `"1"` for repeat use |
| `callback` | No | Webhook URL for this payment |
| `redirect` | No | Where to send the customer after paying |
| `expiration_time` | No | Link expiry in minutes (minimum 1) |
| `metadata` | No | Echoed back to you in the callback |

Success returns the URL to redirect the customer to:

```json
{
  "status": 1,
  "code": "POS09",
  "data": {
    "authorization_url": "https://pos.moolre.com/RZWs1yB6amGjNoiEQvlHPS5uqgp3Jc",
    "reference": "uuid-1234as2"
  }
}
```

### Alternative: direct mobile money push

Sends a USSD approval prompt straight to the customer's phone. Requires the **private** key
and means you handle the OTP round-trip yourself.

```
POST {MOOLRE_BASE_URL}/open/transact/payment
X-API-USER: <MOOLRE_API_USER>
X-API-KEY: <MOOLRE_API_KEY>
```

| Body field | Required | Notes |
| --- | --- | --- |
| `type` | Yes | Always `1` |
| `channel` | Yes | `13` = MTN, `6` = Telecel, `7` = AT |
| `currency` | Yes | `GHS` |
| `payer` | Yes | Customer phone number |
| `amount` | Yes | Major units |
| `externalref` | Yes | Unique reference |
| `accountnumber` | Yes | Your wallet account number |
| `otpcode` | No | Supplied on the retry after code `TP14` |

If the response is code `TP14`, the customer was sent an SMS verification code — collect it
and repeat the request with `otpcode` filled in. Code `TR099` means the prompt was delivered
and you should now poll for status.

### Verify a payment

```
POST {MOOLRE_BASE_URL}/open/transact/status
X-API-USER: <MOOLRE_API_USER>
X-API-PUBKEY: <MOOLRE_API_PUBKEY>

{ "type": 1, "idtype": "1", "id": "<externalref>", "accountnumber": "<account>" }
```

`idtype` is `1` to look up by your own `externalref`, or `2` by Moolre's transaction ID.

```json
{
  "status": 1,
  "code": "SS01",
  "message": "Transaction Successful",
  "data": {
    "txstatus": 1,
    "amount": "1",
    "transactionid": "31772290",
    "externalref": "1231231-128",
    "ts": "2023-11-21 03:57:25"
  }
}
```

Treat `data.txstatus === 1` as paid. Anything else is pending or failed — never fulfil on
`status: 1` alone, since that only means the *lookup* succeeded.

### Bank list (for payouts/refunds)

```
GET {MOOLRE_BASE_URL}/open/transact/data?country=gha&data=banks
```

---

## 5. Webhooks

Moolre POSTs to your callback URL whenever a payment completes or changes state:

```json
{
  "status": 1,
  "code": "P01",
  "message": "Transaction Successful",
  "data": { }
}
```

**Moolre does not document a webhook signature.** There is no shared secret or HMAC header
to validate, which means an attacker who finds your endpoint could POST a fake "payment
successful" body and get free books. So the webhook handler must:

1. Read only the `externalref` from the payload — trust nothing else in the body.
2. Call the Payment Status endpoint to confirm the transaction independently.
3. Confirm the returned amount matches what the order actually costs.
4. Mark the order paid only then, and make it idempotent so a repeated callback is a no-op.
5. Return `2xx` quickly, before doing slow work.

The existing checkout rate limiter (`src/lib/security/rate-limit.ts`) should also cover this
route to blunt callback flooding.

---

## 6. Testing in sandbox

Point `MOOLRE_BASE_URL` at `https://sandbox.moolre.com`. In sandbox, `X-API-KEY` and
`X-API-PUBKEY` are **not required** — only `X-API-USER` — so a working sandbox call does not
prove your live keys are correct. Always re-test once after switching to live.

Quick connectivity check:

```bash
curl -s -X POST https://sandbox.moolre.com/embed/link \
  -H "X-API-USER: $MOOLRE_API_USER" \
  -H "Content-Type: application/json" \
  -d '{
    "type": 1,
    "amount": "5",
    "email": "hello@booksandyou.shop",
    "externalref": "test-'"$(date +%s)"'",
    "currency": "GHS",
    "reusable": "0",
    "accountnumber": "'"$MOOLRE_ACCOUNT_NUMBER"'"
  }'
```

A Postman collection with every endpoint is downloadable from <https://docs.moolre.com>.

---

## 7. Result codes

| Code | Meaning | What to do |
| --- | --- | --- |
| `POS09` | Payment link generated | Redirect to `data.authorization_url` |
| `TR099` | Payment prompt sent | Poll status |
| `TP14` | OTP verification required | Re-send request with `otpcode` |
| `TP13` | `externalref` missing or already used | Generate a fresh reference |
| `INP02` | Transaction already exists | Treat as duplicate, look up status |
| `SS01` | Status lookup succeeded | Check `data.txstatus` |
| `P01` | Webhook: transaction successful | Verify independently, then fulfil |

Because `externalref` must be globally unique, derive it from the order ID plus a suffix
(e.g. `order_1234-1`) so a customer retrying a failed payment does not collide with `TP13`.

---

## 8. Go-live checklist

- [ ] Business KYC approved in the Moolre dashboard
- [ ] Live keys generated and set in Vercel (not just `.env.local`)
- [ ] `MOOLRE_BASE_URL` switched to `https://api.moolre.com`
- [ ] Callback URL set to `https://booksandyou.shop/api/webhooks/moolre`
- [ ] Webhook handler re-verifies via the status endpoint and checks the amount
- [ ] One real low-value payment tested end to end (GHS 1)
- [ ] Refund/payout path confirmed with the bank list endpoint
- [ ] Settlement account and frequency configured on the wallet

---

## 9. SMS (live in codebase)

SMS is implemented in `src/lib/services/sms.ts` against:

```
POST {MOOLRE_BASE_URL}/open/sms/send
X-API-VASKEY: <MOOLRE_VAS_KEY>
```

Body:

```json
{
  "type": 1,
  "senderid": "BooksNYou",
  "messages": [
    { "recipient": "233201234567", "message": "Your order is confirmed.", "ref": "sms_123" }
  ]
}
```

### Get your SMS keys

1. In the Moolre dashboard, open the **SMS / VAS** product and copy the **VAS Key**.
2. Register a **Sender ID** (max 11 characters, e.g. `BooksNYou`) and wait for approval.
   Unapproved IDs return code `ASMS07`.
3. Put both into `.env.local` / Vercel:

```env
MOOLRE_VAS_KEY=...
MOOLRE_SMS_SENDER_ID=BooksNYou
```

Without those two values, `sendSms()` logs to the console in demo mode so local checkout
and shipping notifications still work.

Callers (`notifyUser`, shipping advance, etc.) do not need to know about Moolre — they keep
calling `sendSms({ to, body })`.

## 10. Payment adapter status

Flutterwave and Stripe have been removed. Checkout currently uses **Paystack** only.
A Moolre payment adapter is still optional; the payment keys above are ready for when you
want `/embed/link` wired into `src/lib/providers/`. Until then, payments do not go through
Moolre.
