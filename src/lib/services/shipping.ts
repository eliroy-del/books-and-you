export type ShippingZone = "accra" | "greater_accra" | "nationwide" | "international";

export type ShippingRateInput = {
  city?: string;
  region?: string;
  country?: string;
  subtotalCents: number;
  weightKg?: number;
};

export type ShippingRate = {
  zone: ShippingZone;
  carrier: string;
  amountCents: number;
  etaDaysMin: number;
  etaDaysMax: number;
  free: boolean;
};

const FREE_THRESHOLD_CENTS = Number(
  process.env.SHIPPING_FREE_THRESHOLD_CENTS || 30000
);

export function resolveShippingZone(input: {
  city?: string;
  region?: string;
  country?: string;
}): ShippingZone {
  const country = (input.country || "Ghana").toLowerCase();
  if (country !== "ghana") return "international";

  const city = (input.city || "").toLowerCase();
  const region = (input.region || "").toLowerCase();

  if (city.includes("accra") || city.includes("tema") || city.includes("madina")) {
    return "accra";
  }
  if (region.includes("greater accra") || region.includes("accra")) {
    return "greater_accra";
  }
  return "nationwide";
}

export function quoteShipping(input: ShippingRateInput): ShippingRate {
  const zone = resolveShippingZone(input);
  const freeEligible = input.subtotalCents >= FREE_THRESHOLD_CENTS;

  const table: Record<ShippingZone, Omit<ShippingRate, "free" | "amountCents"> & { amountCents: number }> = {
    accra: {
      zone: "accra",
      carrier: "Books & You Express",
      amountCents: freeEligible ? 0 : 1500,
      etaDaysMin: 0,
      etaDaysMax: 1,
    },
    greater_accra: {
      zone: "greater_accra",
      carrier: "Books & You Logistics",
      amountCents: freeEligible ? 0 : 2500,
      etaDaysMin: 1,
      etaDaysMax: 2,
    },
    nationwide: {
      zone: "nationwide",
      carrier: "Books & You Nationwide",
      amountCents: freeEligible ? 0 : 3500,
      etaDaysMin: 2,
      etaDaysMax: 5,
    },
    international: {
      zone: "international",
      carrier: "Books & You Global",
      amountCents: 8500 + Math.round((input.weightKg || 1) * 1200),
      etaDaysMin: 7,
      etaDaysMax: 21,
    },
  };

  const rate = table[zone];
  return {
    ...rate,
    free: rate.amountCents === 0,
  };
}

export type TrackingStatus =
  | "pending"
  | "ordered"
  | "packed"
  | "shipped"
  | "out_for_delivery"
  | "delivered"
  | "failed";

export const TRACKING_FLOW: TrackingStatus[] = [
  "ordered",
  "packed",
  "shipped",
  "out_for_delivery",
  "delivered",
];

export function nextTrackingStatus(current: string): TrackingStatus | null {
  const idx = TRACKING_FLOW.indexOf(current as TrackingStatus);
  if (idx < 0 || idx >= TRACKING_FLOW.length - 1) return null;
  return TRACKING_FLOW[idx + 1]!;
}

export function generateTrackingNumber() {
  return `GH-BY-${Date.now().toString().slice(-8)}`;
}
