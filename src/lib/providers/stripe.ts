import type {
  InitializePaymentInput,
  InitializePaymentResult,
  PaymentProvider,
  RefundPaymentInput,
  RefundPaymentResult,
  VerifyPaymentResult,
} from "@/lib/providers/types";
import { isPaymentConfigured, siteUrl } from "@/lib/providers/types";

const STRIPE_BASE = "https://api.stripe.com/v1";

async function stripeFetch(path: string, body?: URLSearchParams) {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) throw new Error("STRIPE_SECRET_KEY is not set");

  const res = await fetch(`${STRIPE_BASE}${path}`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body,
  });
  const json = await res.json();
  return { res, json };
}

async function stripeGet(path: string) {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) throw new Error("STRIPE_SECRET_KEY is not set");

  const res = await fetch(`${STRIPE_BASE}${path}`, {
    headers: { Authorization: `Bearer ${key}` },
  });
  const json = await res.json();
  return { res, json };
}

export const stripeProvider: PaymentProvider = {
  id: "stripe",

  async initialize(input: InitializePaymentInput): Promise<InitializePaymentResult> {
    if (!isPaymentConfigured("stripe")) {
      return {
        ok: true,
        provider: "stripe",
        reference: input.reference,
        authorizationUrl: siteUrl(`/checkout?mock_pay=stripe&ref=${input.reference}`),
        clientSecret: `demo_secret_${input.reference}`,
        demo: true,
      };
    }

    try {
      const params = new URLSearchParams();
      params.set("mode", "payment");
      params.set("success_url", input.callbackUrl ?? siteUrl("/checkout?paid=1&session_id={CHECKOUT_SESSION_ID}"));
      params.set("cancel_url", siteUrl("/checkout?cancelled=1"));
      params.set("customer_email", input.email);
      params.set("client_reference_id", input.reference);
      params.set("line_items[0][price_data][currency]", input.currency.toLowerCase());
      params.set("line_items[0][price_data][product_data][name]", "Books & You order");
      params.set("line_items[0][price_data][unit_amount]", String(input.amountCents));
      params.set("line_items[0][quantity]", "1");
      params.set("metadata[reference]", input.reference);

      const { res, json } = await stripeFetch("/checkout/sessions", params);

      if (!res.ok) {
        return {
          ok: false,
          provider: "stripe",
          reference: input.reference,
          error: json.error?.message || "Stripe initialize failed",
          raw: json,
        };
      }

      return {
        ok: true,
        provider: "stripe",
        reference: input.reference,
        authorizationUrl: json.url,
        accessCode: json.id,
        raw: json,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "stripe",
        reference: input.reference,
        error: error instanceof Error ? error.message : "Stripe error",
      };
    }
  },

  async verify(reference: string): Promise<VerifyPaymentResult> {
    if (!isPaymentConfigured("stripe")) {
      return {
        ok: true,
        provider: "stripe",
        reference,
        status: "succeeded",
        demo: true,
      };
    }

    try {
      // reference may be Checkout Session id or our order reference in metadata
      const sessionPath = reference.startsWith("cs_")
        ? `/checkout/sessions/${reference}`
        : null;

      if (sessionPath) {
        const { res, json } = await stripeGet(sessionPath);
        if (!res.ok) {
          return {
            ok: false,
            provider: "stripe",
            reference,
            status: "failed",
            error: json.error?.message || "Stripe verify failed",
          };
        }

        const status =
          json.payment_status === "paid"
            ? "succeeded"
            : json.status === "expired"
              ? "abandoned"
              : "pending";

        return {
          ok: status === "succeeded",
          provider: "stripe",
          reference,
          status,
          amountCents: json.amount_total ?? undefined,
          currency: json.currency?.toUpperCase(),
          providerReference: json.payment_intent ?? json.id,
          raw: json,
        };
      }

      // Fallback: treat unknown refs as pending without session id
      return {
        ok: false,
        provider: "stripe",
        reference,
        status: "pending",
        error: "Provide a Stripe Checkout Session id (cs_...) to verify",
      };
    } catch (error) {
      return {
        ok: false,
        provider: "stripe",
        reference,
        status: "failed",
        error: error instanceof Error ? error.message : "Stripe verify error",
      };
    }
  },

  async refund(input: RefundPaymentInput): Promise<RefundPaymentResult> {
    if (!isPaymentConfigured("stripe")) {
      return { ok: true, refundId: `demo_stripe_refund_${Date.now()}`, demo: true };
    }

    try {
      const params = new URLSearchParams();
      params.set("payment_intent", input.providerReference);
      if (input.amountCents) params.set("amount", String(input.amountCents));
      if (input.reason) params.set("reason", "requested_by_customer");

      const { res, json } = await stripeFetch("/refunds", params);
      if (!res.ok) {
        return { ok: false, error: json.error?.message || "Refund failed" };
      }

      return { ok: true, refundId: json.id };
    } catch (error) {
      return {
        ok: false,
        error: error instanceof Error ? error.message : "Stripe refund error",
      };
    }
  },
};
