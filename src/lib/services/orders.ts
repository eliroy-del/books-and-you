import type { SupabaseClient } from "@supabase/supabase-js";
import type { Order } from "@/types";
import { mapOrder, mockFallbackOrders, formatMoney } from "@/lib/services/mappers";
import { db } from "@/lib/supabase/typed";
import { quoteShipping, generateTrackingNumber } from "@/lib/services/shipping";
import {
  initializePayment,
  type PaymentProviderId,
} from "@/lib/providers";
import { siteUrl } from "@/lib/providers/types";
import {
  renderOrderConfirmationEmail,
  sendEmail,
} from "@/lib/services/email";
import { notifyUser } from "@/lib/services/notifications";
import { qualifyReferralForOrder } from "@/lib/services/referrals";
import { sendSms } from "@/lib/services/sms";

export async function listOrdersWithClient(
  supabase: SupabaseClient,
  userId: string
): Promise<Order[]> {
  const client = db(supabase);
  const { data, error } = await client
    .from("orders")
    .select(
      `
      *,
      order_items ( book_id, title, format, quantity, unit_price_cents ),
      shipping ( tracking_number, tracking_events ( status, note, occurred_at ) )
    `
    )
    .eq("user_id", userId)
    .order("placed_at", { ascending: false });

  if (error || !data) {
    console.warn("[orders]", error?.message);
    return mockFallbackOrders();
  }

  return (data as Record<string, unknown>[]).map(mapOrder);
}

export async function listOrders(userId: string): Promise<Order[]> {
  if (userId === "demo-user-local") return mockFallbackOrders();
  return mockFallbackOrders();
}

export type CheckoutLine = {
  bookId: string;
  format: "hardcover" | "paperback" | "ebook" | "audiobook";
  quantity: number;
  unitPrice: number;
  title: string;
};

export type PlaceOrderInput = {
  /** Null/undefined for guest checkout. */
  userId?: string | null;
  email?: string;
  customerName?: string;
  phone?: string;
  lines: CheckoutLine[];
  provider: PaymentProviderId;
  shippingAddress: Record<string, unknown>;
  couponCode?: string;
  discountCedis?: number;
  /** When true, skip redirect payment and mark paid immediately (demo / wallet). */
  autoCapture?: boolean;
};

export type PlaceOrderResult = {
  ok: boolean;
  orderId?: string;
  orderNumber?: string;
  paymentReference?: string;
  authorizationUrl?: string;
  clientSecret?: string;
  amountCents?: number;
  shippingCents?: number;
  demo?: boolean;
  error?: string;
};

function calcTotals(
  lines: CheckoutLine[],
  shippingAddress: Record<string, unknown>,
  discountCedis = 0
) {
  const subtotalCents = lines.reduce(
    (s, l) => s + Math.round(l.unitPrice * 100) * l.quantity,
    0
  );
  const discountCents = Math.round(discountCedis * 100);
  const rate = quoteShipping({
    city: String(shippingAddress.city || ""),
    region: String(shippingAddress.region || ""),
    country: String(shippingAddress.country || "Ghana"),
    subtotalCents,
  });
  const shippingCents = rate.amountCents;
  const totalCents = Math.max(0, subtotalCents + shippingCents - discountCents);
  return { subtotalCents, discountCents, shippingCents, totalCents, rate };
}

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export async function placeOrderWithClient(
  supabase: SupabaseClient,
  input: PlaceOrderInput
): Promise<PlaceOrderResult> {
  const client = db(supabase);

  if (!input.lines.length) {
    return { ok: false, error: "Your cart is empty" };
  }

  const invalid = input.lines.filter((l) => !UUID_RE.test(l.bookId));
  if (invalid.length) {
    return {
      ok: false,
      error:
        "Your cart has outdated items. Clear the cart and add books again from the catalog.",
    };
  }

  const bookIds = [...new Set(input.lines.map((l) => l.bookId))];
  const { data: catalogBooks, error: catalogError } = await client
    .from("books")
    .select("id")
    .in("id", bookIds);

  if (catalogError) {
    return { ok: false, error: catalogError.message };
  }

  const found = new Set((catalogBooks ?? []).map((b) => String(b.id)));
  const missing = bookIds.filter((id) => !found.has(id));
  if (missing.length) {
    return {
      ok: false,
      error:
        "One or more books are no longer available. Remove them from your cart and try again.",
    };
  }

  const guestName =
    input.customerName?.trim() ||
    String(input.shippingAddress.fullName || "").trim() ||
    null;
  const guestPhone =
    input.phone?.trim() || String(input.shippingAddress.phone || "").trim() || null;
  const guestEmail = input.email?.trim() || null;
  const isGuest = !input.userId;

  if (isGuest && (!guestName || !guestPhone)) {
    return {
      ok: false,
      error: "Full name and phone number are required for guest checkout.",
    };
  }

  const location =
    String(input.shippingAddress.line1 || "").trim() ||
    String(input.shippingAddress.city || "").trim();
  if (isGuest && !location) {
    return {
      ok: false,
      error: "Delivery location is required for guest checkout.",
    };
  }

  const { subtotalCents, discountCents, shippingCents, totalCents, rate } = calcTotals(
    input.lines,
    input.shippingAddress,
    input.discountCedis
  );

  const { data: order, error: orderError } = await client
    .from("orders")
    .insert({
      user_id: input.userId || null,
      is_guest: isGuest,
      guest_name: guestName,
      guest_phone: guestPhone,
      guest_email: guestEmail,
      status: "pending",
      currency: "GHS",
      subtotal_cents: subtotalCents,
      shipping_cents: shippingCents,
      discount_cents: discountCents,
      total_cents: totalCents,
      coupon_code: input.couponCode ?? null,
      shipping_address: {
        ...input.shippingAddress,
        fullName: guestName,
        phone: guestPhone,
        email: guestEmail,
        shipping_zone: rate.zone,
        carrier: rate.carrier,
        eta_days_min: rate.etaDaysMin,
        eta_days_max: rate.etaDaysMax,
      },
      placed_at: new Date().toISOString(),
    })
    .select("id, order_number")
    .single();

  if (orderError || !order) {
    return { ok: false, error: orderError?.message ?? "Failed to create order" };
  }

  const orderItems = input.lines.map((l) => ({
    order_id: order.id,
    book_id: l.bookId,
    title: l.title,
    format: l.format,
    quantity: l.quantity,
    unit_price_cents: Math.round(l.unitPrice * 100),
    total_cents: Math.round(l.unitPrice * 100) * l.quantity,
  }));

  const { error: itemsError } = await client.from("order_items").insert(orderItems);
  if (itemsError) {
    await client.from("orders").update({ status: "cancelled" }).eq("id", order.id);
    return { ok: false, error: itemsError.message };
  }

  const paymentReference = `${order.order_number}-${Date.now().toString(36)}`;

  const { data: tx, error: txError } = await client
    .from("transactions")
    .insert({
      order_id: order.id,
      user_id: input.userId || null,
      provider: input.provider,
      provider_reference: paymentReference,
      amount_cents: totalCents,
      currency: "GHS",
      status: "pending",
      metadata: {
        order_number: order.order_number,
        guest: isGuest,
        guest_phone: guestPhone,
      },
    })
    .select("id")
    .single();

  if (txError || !tx) {
    await client.from("orders").update({ status: "cancelled" }).eq("id", order.id);
    return { ok: false, error: txError?.message ?? "Failed to create transaction" };
  }

  await client.from("payments").insert({
    transaction_id: tx.id,
    order_id: order.id,
    amount_cents: totalCents,
    currency: "GHS",
    status: "pending",
  });

  if (input.autoCapture) {
    const fulfilled = await fulfillPaidOrder(supabase, {
      orderId: order.id,
      paymentReference,
      providerReference: `DEMO_${paymentReference}`,
    });
    return {
      ok: fulfilled.ok,
      orderId: String(order.id),
      orderNumber: String(order.order_number),
      paymentReference,
      amountCents: totalCents,
      shippingCents,
      demo: true,
      error: fulfilled.error,
    };
  }

  const payment = await initializePayment(input.provider, {
    amountCents: totalCents,
    currency: "GHS",
    email: input.email || "customer@booksandyou.test",
    reference: paymentReference,
    customerName: input.customerName,
    callbackUrl: siteUrl(`/checkout?paid=1&ref=${encodeURIComponent(paymentReference)}&provider=${input.provider}`),
    metadata: {
      order_id: order.id,
      order_number: order.order_number,
      user_id: input.userId || null,
      guest: isGuest,
    },
  });

  if (!payment.ok) {
    await client.from("transactions").update({ status: "failed" }).eq("id", tx.id);
    await client.from("payments").update({ status: "failed" }).eq("transaction_id", tx.id);
    await client.from("orders").update({ status: "cancelled" }).eq("id", order.id);
    return { ok: false, error: payment.error || "Payment initialization failed" };
  }

  // Demo providers still need fulfillment after mock redirect — caller may auto-verify
  if (payment.demo) {
    await fulfillPaidOrder(supabase, {
      orderId: order.id,
      paymentReference,
      providerReference: `DEMO_${paymentReference}`,
    });
  }

  return {
    ok: true,
    orderId: String(order.id),
    orderNumber: String(order.order_number),
    paymentReference,
    authorizationUrl: payment.authorizationUrl,
    clientSecret: payment.clientSecret,
    amountCents: totalCents,
    shippingCents,
    demo: payment.demo,
  };
}

export async function fulfillPaidOrder(
  supabase: SupabaseClient,
  input: {
    orderId: string;
    paymentReference: string;
    providerReference?: string;
  }
): Promise<{ ok: boolean; error?: string }> {
  const client = db(supabase);

  const { data: order } = await client
    .from("orders")
    .select(
      "id, order_number, user_id, status, total_cents, shipping_address, currency, guest_name, guest_email, guest_phone, is_guest"
    )
    .eq("id", input.orderId)
    .maybeSingle();

  if (!order) return { ok: false, error: "Order not found" };
  if (order.status !== "pending" && order.status !== "ordered") {
    return { ok: true }; // already fulfilled
  }

  await client
    .from("orders")
    .update({ status: "ordered", placed_at: new Date().toISOString() })
    .eq("id", order.id);

  const { data: tx } = await client
    .from("transactions")
    .select("id, provider")
    .eq("order_id", order.id)
    .eq("provider_reference", input.paymentReference)
    .maybeSingle();

  if (tx?.id) {
    await client
      .from("transactions")
      .update({
        status: "succeeded",
        metadata: {
          provider_reference: input.providerReference ?? input.paymentReference,
        },
      })
      .eq("id", tx.id);

    await client
      .from("payments")
      .update({
        status: "succeeded",
        paid_at: new Date().toISOString(),
      })
      .eq("transaction_id", tx.id);
  }

  const trackingNumber = generateTrackingNumber();
  const address = (order.shipping_address || {}) as Record<string, unknown>;
  const carrier = String(address.carrier || "Books & You Logistics");

  const { data: existingShip } = await client
    .from("shipping")
    .select("id")
    .eq("order_id", order.id)
    .maybeSingle();

  let shippingId = existingShip?.id as string | undefined;
  if (!shippingId) {
    const { data: shipping } = await client
      .from("shipping")
      .insert({
        order_id: order.id,
        carrier,
        tracking_number: trackingNumber,
        status: "ordered",
      })
      .select("id")
      .single();
    shippingId = shipping?.id;
  }

  if (shippingId) {
    await client.from("tracking_events").insert({
      shipping_id: shippingId,
      status: "ordered",
      note: "Payment confirmed",
    });
  }

  const { data: items } = await client
    .from("order_items")
    .select("book_id, format, quantity")
    .eq("order_id", order.id);

  for (const line of items ?? []) {
    if ((line.format === "ebook" || line.format === "audiobook") && order.user_id) {
      await client.from("library_items").upsert(
        {
          user_id: order.user_id,
          book_id: line.book_id,
          format: line.format,
          progress_percent: 0,
          last_opened_at: new Date().toISOString(),
        },
        { onConflict: "user_id,book_id,format" }
      );
    } else if (line.format !== "ebook" && line.format !== "audiobook") {
      const { data: inv } = await client
        .from("book_inventory")
        .select("id, quantity_on_hand")
        .eq("book_id", line.book_id)
        .eq("format", line.format)
        .maybeSingle();
      if (inv?.id != null) {
        await client
          .from("book_inventory")
          .update({
            quantity_on_hand: Math.max(
              0,
              Number(inv.quantity_on_hand) - Number(line.quantity)
            ),
          })
          .eq("id", inv.id);
      }
    }
  }

  const { data: profile } = order.user_id
    ? await client
        .from("profiles")
        .select("full_name, email, phone")
        .eq("id", order.user_id)
        .maybeSingle()
    : { data: null };

  const totalLabel = formatMoney(Number(order.total_cents) / 100);
  const trackingUrl = siteUrl("/orders");
  const customerName =
    profile?.full_name ||
    order.guest_name ||
    String(address.fullName || "") ||
    "Customer";
  const notifyEmail =
    profile?.email || order.guest_email || String(address.email || "") || undefined;
  const notifyPhone =
    profile?.phone || order.guest_phone || String(address.phone || "") || undefined;

  const emailContent = renderOrderConfirmationEmail({
    customerName,
    orderNumber: order.order_number,
    totalLabel,
    trackingUrl,
  });

  if (notifyEmail) {
    await sendEmail({
      to: notifyEmail,
      subject: emailContent.subject,
      html: emailContent.html,
      text: emailContent.text,
      tags: [{ name: "type", value: "order_confirmation" }],
    });
  }

  if (order.user_id) {
    await notifyUser(supabase, {
      userId: order.user_id,
      email: notifyEmail,
      phone: notifyPhone,
      title: "Order confirmed",
      body: `${order.order_number} · ${totalLabel}`,
      type: "order_confirmation",
      link: "/orders",
      channels: ["in_app", "email"],
      emailSubject: emailContent.subject,
      emailHtml: emailContent.html,
    });

    await qualifyReferralForOrder(supabase, {
      userId: order.user_id,
      orderId: order.id,
      orderNumber: order.order_number,
    });
  }

  if (notifyPhone) {
    await sendSms({
      to: notifyPhone,
      body: `Books & You: Order ${order.order_number} confirmed. Total ${totalLabel}. We'll contact you about delivery.`,
    });
  }

  await client.from("webhook_logs").insert({
    provider: "internal",
    event_type: "order.fulfilled",
    payload: {
      order_id: order.id,
      payment_reference: input.paymentReference,
    },
    status: "processed",
  });

  return { ok: true };
}

export async function placeOrder(input: PlaceOrderInput): Promise<PlaceOrderResult> {
  if (input.userId === "demo-user-local") {
    const { totalCents, shippingCents } = calcTotals(
      input.lines,
      input.shippingAddress,
      input.discountCedis
    );
    return {
      ok: true,
      demo: true,
      orderId: `demo-${Date.now()}`,
      orderNumber: `BY-DEMO-${String(Date.now()).slice(-6)}`,
      paymentReference: `demo-ref-${Date.now()}`,
      amountCents: totalCents,
      shippingCents,
    };
  }
  return {
    ok: false,
    error: "Use placeOrderWithClient from an authenticated server context.",
  };
}
