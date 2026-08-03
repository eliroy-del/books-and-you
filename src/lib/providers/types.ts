import { siteUrl as resolvedSiteUrl } from "@/lib/seo";

export type PaymentProviderId = "moolre";

export type PaymentCurrency = "GHS" | "USD" | "NGN" | "EUR" | "GBP";

export type InitializePaymentInput = {
  amountCents: number;
  currency: PaymentCurrency;
  email: string;
  reference: string;
  metadata?: Record<string, unknown>;
  callbackUrl?: string;
  customerName?: string;
};

export type InitializePaymentResult = {
  ok: boolean;
  provider: PaymentProviderId;
  reference: string;
  authorizationUrl?: string;
  accessCode?: string;
  clientSecret?: string;
  demo?: boolean;
  error?: string;
  raw?: unknown;
};

export type VerifyPaymentResult = {
  ok: boolean;
  provider: PaymentProviderId;
  reference: string;
  status: "succeeded" | "failed" | "pending" | "abandoned";
  amountCents?: number;
  currency?: string;
  providerReference?: string;
  demo?: boolean;
  error?: string;
  raw?: unknown;
};

export type RefundPaymentInput = {
  providerReference: string;
  amountCents?: number;
  reason?: string;
};

export type RefundPaymentResult = {
  ok: boolean;
  refundId?: string;
  demo?: boolean;
  error?: string;
};

export interface PaymentProvider {
  id: PaymentProviderId;
  initialize(input: InitializePaymentInput): Promise<InitializePaymentResult>;
  verify(reference: string): Promise<VerifyPaymentResult>;
  refund(input: RefundPaymentInput): Promise<RefundPaymentResult>;
}

export function isPaymentConfigured(provider: PaymentProviderId) {
  switch (provider) {
    case "moolre":
      return Boolean(
        process.env.MOOLRE_API_USER &&
          process.env.MOOLRE_API_PUBKEY &&
          process.env.MOOLRE_ACCOUNT_NUMBER
      );
    default:
      return false;
  }
}

export function siteUrl(path = "") {
  const base = resolvedSiteUrl;
  return `${base.replace(/\/$/, "")}${path.startsWith("/") ? path : `/${path}`}`;
}
