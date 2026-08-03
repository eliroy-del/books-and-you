import { paystackProvider } from "@/lib/providers/paystack";
import type {
  InitializePaymentInput,
  PaymentProvider,
  PaymentProviderId,
  VerifyPaymentResult,
} from "@/lib/providers/types";
import { isPaymentConfigured } from "@/lib/providers/types";

const providers: Record<PaymentProviderId, PaymentProvider> = {
  paystack: paystackProvider,
};

export function getPaymentProvider(id: PaymentProviderId): PaymentProvider {
  return providers[id];
}

export function listPaymentProviders() {
  return (Object.keys(providers) as PaymentProviderId[]).map((id) => ({
    id,
    configured: isPaymentConfigured(id),
    label: "Paystack",
  }));
}

export async function initializePayment(
  provider: PaymentProviderId,
  input: InitializePaymentInput
) {
  return getPaymentProvider(provider).initialize(input);
}

export async function verifyPayment(
  provider: PaymentProviderId,
  reference: string
): Promise<VerifyPaymentResult> {
  return getPaymentProvider(provider).verify(reference);
}

export async function refundPayment(
  provider: PaymentProviderId,
  input: Parameters<PaymentProvider["refund"]>[0]
) {
  return getPaymentProvider(provider).refund(input);
}

export * from "@/lib/providers/types";
export { paystackProvider };
