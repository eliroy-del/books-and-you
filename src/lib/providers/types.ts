import { siteUrl as resolvedSiteUrl } from "@/lib/seo";

export type PaymentProviderId = "paystack" | "flutterwave" | "stripe";

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
    case "paystack":
      return Boolean(process.env.PAYSTACK_SECRET_KEY);
    case "flutterwave":
      return Boolean(process.env.FLUTTERWAVE_SECRET_KEY);
    case "stripe":
      return Boolean(process.env.STRIPE_SECRET_KEY);
    default:
      return false;
  }
}

export function siteUrl(path = "") {
  const base = resolvedSiteUrl;
  return `${base.replace(/\/$/, "")}${path.startsWith("/") ? path : `/${path}`}`;
}
