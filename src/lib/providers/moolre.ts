import type {
  InitializePaymentInput,
  InitializePaymentResult,
  PaymentProvider,
  RefundPaymentInput,
  RefundPaymentResult,
  VerifyPaymentResult,
} from "@/lib/providers/types";
import { isPaymentConfigured, siteUrl } from "@/lib/providers/types";

function moolreBaseUrl() {
  return (process.env.MOOLRE_BASE_URL || "https://api.moolre.com").replace(/\/$/, "");
}

function centsToMajor(amountCents: number) {
  // Moolre expects major units as a string, e.g. "50" for GHS 50
  return (amountCents / 100).toFixed(2).replace(/\.00$/, "");
}

function majorToCents(amount: string | number | undefined) {
  if (amount == null || amount === "") return undefined;
  const n = typeof amount === "number" ? amount : Number(amount);
  if (!Number.isFinite(n)) return undefined;
  return Math.round(n * 100);
}

function messageOf(json: { message?: string | string[]; code?: string }, fallback: string) {
  if (Array.isArray(json.message)) return json.message.join(", ");
  return json.message || json.code || fallback;
}

function callbackUrlWithSecret() {
  const secret = process.env.MOOLRE_CALLBACK_SECRET;
  const path = secret
    ? `/api/webhooks/moolre?secret=${encodeURIComponent(secret)}`
    : "/api/webhooks/moolre";
  return siteUrl(path);
}

export const moolreProvider: PaymentProvider = {
  id: "moolre",

  async initialize(input: InitializePaymentInput): Promise<InitializePaymentResult> {
    if (!isPaymentConfigured("moolre")) {
      return {
        ok: true,
        provider: "moolre",
        reference: input.reference,
        authorizationUrl: siteUrl(`/checkout?mock_pay=moolre&ref=${input.reference}`),
        demo: true,
      };
    }

    const user = process.env.MOOLRE_API_USER!;
    const pubKey = process.env.MOOLRE_API_PUBKEY!;
    const account = process.env.MOOLRE_ACCOUNT_NUMBER!;
    const businessEmail =
      process.env.ADMIN_EMAIL ||
      process.env.RESEND_FROM_EMAIL?.match(/<([^>]+)>/)?.[1] ||
      input.email;

    try {
      const res = await fetch(`${moolreBaseUrl()}/embed/link`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-API-USER": user,
          "X-API-PUBKEY": pubKey,
        },
        body: JSON.stringify({
          type: 1,
          amount: centsToMajor(input.amountCents),
          email: businessEmail,
          externalref: input.reference,
          callback: callbackUrlWithSecret(),
          redirect: input.callbackUrl ?? siteUrl("/checkout?paid=1"),
          reusable: "0",
          expiration_time: 60,
          currency: input.currency || process.env.MOOLRE_CURRENCY || "GHS",
          accountnumber: account,
          metadata: {
            ...(input.metadata ?? {}),
            customer_email: input.email,
            customer_name: input.customerName,
          },
        }),
      });

      const json = (await res.json()) as {
        status?: number | string;
        code?: string;
        message?: string | string[];
        data?: { authorization_url?: string; reference?: string };
      };

      if (!res.ok || Number(json.status) !== 1 || !json.data?.authorization_url) {
        return {
          ok: false,
          provider: "moolre",
          reference: input.reference,
          error: messageOf(json, "Moolre payment link failed"),
          raw: json,
        };
      }

      return {
        ok: true,
        provider: "moolre",
        reference: input.reference,
        authorizationUrl: json.data.authorization_url,
        accessCode: json.data.reference,
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "moolre",
        reference: input.reference,
        error: error instanceof Error ? error.message : "Moolre error",
      };
    }
  },

  async verify(reference: string): Promise<VerifyPaymentResult> {
    if (!isPaymentConfigured("moolre")) {
      return {
        ok: true,
        provider: "moolre",
        reference,
        status: "succeeded",
        demo: true,
      };
    }

    const user = process.env.MOOLRE_API_USER!;
    const pubKey = process.env.MOOLRE_API_PUBKEY!;
    const account = process.env.MOOLRE_ACCOUNT_NUMBER!;

    try {
      const res = await fetch(`${moolreBaseUrl()}/open/transact/status`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-API-USER": user,
          "X-API-PUBKEY": pubKey,
        },
        body: JSON.stringify({
          type: 1,
          idtype: "1",
          id: reference,
          accountnumber: account,
        }),
      });

      const json = (await res.json()) as {
        status?: number | string;
        code?: string;
        message?: string | string[];
        data?: {
          txstatus?: number | string;
          transactionid?: string | number;
          amount?: string | number;
          value?: string | number;
        };
      };

      if (!res.ok || Number(json.status) !== 1) {
        return {
          ok: false,
          provider: "moolre",
          reference,
          status: "failed",
          error: messageOf(json, "Moolre verification failed"),
          raw: json,
        };
      }

      const txstatus = Number(json.data?.txstatus);
      const status =
        txstatus === 1 ? "succeeded" : txstatus === 0 ? "failed" : "pending";

      return {
        ok: status === "succeeded",
        provider: "moolre",
        reference,
        status,
        amountCents: majorToCents(json.data?.amount ?? json.data?.value),
        currency: process.env.MOOLRE_CURRENCY || "GHS",
        providerReference:
          json.data?.transactionid != null ? String(json.data.transactionid) : undefined,
        raw: json.data,
      };
    } catch (error) {
      return {
        ok: false,
        provider: "moolre",
        reference,
        status: "failed",
        error: error instanceof Error ? error.message : "Moolre verify error",
      };
    }
  },

  async refund(_input: RefundPaymentInput): Promise<RefundPaymentResult> {
    if (!isPaymentConfigured("moolre")) {
      return { ok: true, refundId: `demo_moolre_refund_${Date.now()}`, demo: true };
    }
    // Moolre collections do not expose a simple refund API in the public docs.
    // Handle refunds from the Moolre dashboard / disbursement flow for now.
    return {
      ok: false,
      error: "Moolre refunds must be processed from the Moolre dashboard",
    };
  },
};
