import { NextResponse } from "next/server";
import { quoteShipping } from "@/lib/services/shipping";

export async function POST(request: Request) {
  const body = await request.json().catch(() => ({}));
  const rate = quoteShipping({
    city: body.city,
    region: body.region,
    country: body.country || "Ghana",
    subtotalCents: Number(body.subtotalCents || 0),
    weightKg: body.weightKg ? Number(body.weightKg) : undefined,
  });

  return NextResponse.json({
    ok: true,
    rate,
    amount: rate.amountCents / 100,
    freeThresholdCents: Number(process.env.SHIPPING_FREE_THRESHOLD_CENTS || 30000),
  });
}
