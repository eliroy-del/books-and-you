import type {
  InitializePaymentInput,
  InitializePaymentResult,
  PaymentProvider,
  RefundPaymentInput,
  RefundPaymentResult,
  VerifyPaymentResult,
} from "@/lib/providers/types";
import { isPaymentConfigured, siteUrl } from "@/lib/providers/types";

const FLW_BASE = "https://api.flutterwave.com/v3";

async function flwFetch(path: string, init?: RequestInit) {
  const key = process.env.FLUTTERWAVE_SECRET_KEY;
  if (!key) throw new Error("FLUTTERWAVE_SECRET_KEY is not set");

  const res = await fetch(`${FLW_BASE}${path}`, {
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

export const flutterwaveProvider: PaymentProvider = {
  id: "flutterwave",

  async initialize(input: InitializePaymentInput): Promise<InitializePaymentResult> {
    if (!isPaymentConfigured("flutterwave")) {
      return {
        ok: true,
        provider: "flutterwave",
        reference: input.reference,
        authorizationUrl: siteUrl(`/checkout?mock_pay=flutterwave&ref=${input.reference}`),
        demo: true,
      };
    }

    try {
      const { res, json } = await flwFetch("/payments", {
        method: "POST",
        body: JSON.stringify({
          tx_ref: input.reference,
          amount: input.amountCents / 100,
          currency: input.currency,
          redirect_url: input.callbackUrl ?? siteUrl("/checkout?paid=1"),
          customer: {
            email: input.email,
            name: input.customerName || input.email,
          },
          meta: input.metadata ?? {},
          customizations: {
            title: process.env.NEXT_PUBLIC_APP_NAME || "Books & You",
            description: "Bookstore order payment",
          },
        }),
      });

      if (!res.ok || json.status !== "success") {
        return {
          ok: false,
          provider: "flutterwave",
          reference: input.reference,
          error: json.message || "Flutterwave initialize failed",
          raw: json,
        };
      }

      return {
        ok: true,
        provider: "flutterwave",
        reference: input.reference,
        authorizationUrl: json.data.link,
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "flutterwave",
        reference: input.reference,
        error: error instanceof Error ? error.message : "Flutterwave error",
      };
    }
  },

  async verify(reference: string): Promise<VerifyPaymentResult> {
    if (!isPaymentConfigured("flutterwave")) {
      return {
        ok: true,
        provider: "flutterwave",
        reference,
        status: "succeeded",
        demo: true,
      };
    }

    try {
      const { res, json } = await flwFetch(
        `/transactions/verify_by_reference?tx_ref=${encodeURIComponent(reference)}`
      );

      if (!res.ok || json.status !== "success") {
        return {
          ok: false,
          provider: "flutterwave",
          reference,
          status: "failed",
          error: json.message || "Verification failed",
          raw: json,
        };
      }

      const flwStatus = String(json.data?.status || "").toLowerCase();
      const status =
        flwStatus === "successful"
          ? "succeeded"
          : flwStatus === "failed"
            ? "failed"
            : "pending";

      return {
        ok: status === "succeeded",
        provider: "flutterwave",
        reference,
        status,
        amountCents: Math.round(Number(json.data?.amount ?? 0) * 100),
        currency: json.data?.currency,
        providerReference: String(json.data?.id ?? ""),
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "flutterwave",
        reference,
        status: "failed",
        error: error instanceof Error ? error.message : "Flutterwave verify error",
      };
    }
  },

  async refund(input: RefundPaymentInput): Promise<RefundPaymentResult> {
    if (!isPaymentConfigured("flutterwave")) {
      return { ok: true, refundId: `demo_flw_refund_${Date.now()}`, demo: true };
    }

    try {
      const { res, json } = await flwFetch(`/transactions/${input.providerReference}/refund`, {
        method: "POST",
        body: JSON.stringify({
          amount: input.amountCents ? input.amountCents / 100 : undefined,
          comments: input.reason,
        }),
      });

      if (!res.ok || json.status !== "success") {
        return { ok: false, error: json.message || "Refund failed" };
      }

      return { ok: true, refundId: String(json.data?.id ?? "") };
    } catch (error) {
      return {
        ok: false,
        error: error instanceof Error ? error.message : "Flutterwave refund error",
      };
    }
  },
};
