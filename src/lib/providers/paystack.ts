import type {
  InitializePaymentInput,
  InitializePaymentResult,
  PaymentProvider,
  RefundPaymentInput,
  RefundPaymentResult,
  VerifyPaymentResult,
} from "@/lib/providers/types";
import { isPaymentConfigured, siteUrl } from "@/lib/providers/types";

const PAYSTACK_BASE = "https://api.paystack.co";

async function paystackFetch(path: string, init?: RequestInit) {
  const key = process.env.PAYSTACK_SECRET_KEY;
  if (!key) throw new Error("PAYSTACK_SECRET_KEY is not set");

  const res = await fetch(`${PAYSTACK_BASE}${path}`, {
    ...init,
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
  });

  const json = await res.json();
  return { res, json };
}

export const paystackProvider: PaymentProvider = {
  id: "paystack",

  async initialize(input: InitializePaymentInput): Promise<InitializePaymentResult> {
    if (!isPaymentConfigured("paystack")) {
      return {
        ok: true,
        provider: "paystack",
        reference: input.reference,
        authorizationUrl: siteUrl(`/checkout?mock_pay=paystack&ref=${input.reference}`),
        demo: true,
      };
    }

    try {
      const { res, json } = await paystackFetch("/transaction/initialize", {
        method: "POST",
        body: JSON.stringify({
          email: input.email,
          amount: input.amountCents,
          currency: input.currency,
          reference: input.reference,
          callback_url: input.callbackUrl ?? siteUrl("/checkout?paid=1"),
          metadata: input.metadata ?? {},
        }),
      });

      if (!res.ok || !json.status) {
        return {
          ok: false,
          provider: "paystack",
          reference: input.reference,
          error: json.message || "Paystack initialize failed",
          raw: json,
        };
      }

      return {
        ok: true,
        provider: "paystack",
        reference: input.reference,
        authorizationUrl: json.data.authorization_url,
        accessCode: json.data.access_code,
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "paystack",
        reference: input.reference,
        error: error instanceof Error ? error.message : "Paystack error",
      };
    }
  },

  async verify(reference: string): Promise<VerifyPaymentResult> {
    if (!isPaymentConfigured("paystack")) {
      return {
        ok: true,
        provider: "paystack",
        reference,
        status: "succeeded",
        demo: true,
      };
    }

    try {
      const { res, json } = await paystackFetch(
        `/transaction/verify/${encodeURIComponent(reference)}`
      );

      if (!res.ok || !json.status) {
        return {
          ok: false,
          provider: "paystack",
          reference,
          status: "failed",
          error: json.message || "Verification failed",
          raw: json,
        };
      }

      const status =
        json.data.status === "success"
          ? "succeeded"
          : json.data.status === "abandoned"
            ? "abandoned"
            : json.data.status === "failed"
              ? "failed"
              : "pending";

      return {
        ok: status === "succeeded",
        provider: "paystack",
        reference,
        status,
        amountCents: json.data.amount,
        currency: json.data.currency,
        providerReference: String(json.data.id),
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "paystack",
        reference,
        status: "failed",
        error: error instanceof Error ? error.message : "Paystack verify error",
      };
    }
  },

  async refund(input: RefundPaymentInput): Promise<RefundPaymentResult> {
    if (!isPaymentConfigured("paystack")) {
      return { ok: true, refundId: `demo_refund_${Date.now()}`, demo: true };
    }

    try {
      const { res, json } = await paystackFetch("/refund", {
        method: "POST",
        body: JSON.stringify({
          transaction: input.providerReference,
          amount: input.amountCents,
          merchant_note: input.reason,
        }),
      });

      if (!res.ok || !json.status) {
        return { ok: false, error: json.message || "Refund failed", };
      }

      return { ok: true, refundId: String(json.data?.id ?? json.data?.transaction?.id) };
    } catch (error) {
      return {
        ok: false,
        error: error instanceof Error ? error.message : "Paystack refund error",
      };
    }
  },
};
