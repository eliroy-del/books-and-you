import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/admin";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { nextTrackingStatus } from "@/lib/services/shipping";
import { db } from "@/lib/supabase/typed";
import {
  renderShippingUpdateEmail,
  sendEmail,
} from "@/lib/services/email";
import { notifyUser } from "@/lib/services/notifications";
import { sendSms } from "@/lib/services/sms";

/**
 * Advance shipping timeline for an order (staff / demo tooling).
 * Body: { orderId, status? }
 */
export async function POST(request: Request) {
  if (!isSupabaseConfigured()) {
    return NextResponse.json({
      ok: true,
      demo: true,
      status: "shipped",
      note: "Demo shipping advance",
    });
  }

  const body = await request.json();
  const orderId = body.orderId as string;
  if (!orderId) {
    return NextResponse.json({ ok: false, error: "orderId required" }, { status: 400 });
  }

  let supabase = await tryCreateClient();
  const {
    data: { user },
  } = (await supabase?.auth.getUser()) ?? { data: { user: null } };

  // Allow service role for internal jobs when no user session
  if (!user) {
    try {
      supabase = createServiceClient();
    } catch {
      return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
    }
  }

  if (!supabase) {
    return NextResponse.json({ ok: false, error: "Supabase unavailable" }, { status: 500 });
  }

  const client = db(supabase);
  const { data: shipping } = await client
    .from("shipping")
    .select("id, status, tracking_number, order_id")
    .eq("order_id", orderId)
    .maybeSingle();

  if (!shipping) {
    return NextResponse.json({ ok: false, error: "Shipping record not found" }, { status: 404 });
  }

  const next =
    (body.status as string) || nextTrackingStatus(String(shipping.status)) || shipping.status;

  await client
    .from("shipping")
    .update({
      status: next,
      shipped_at: next === "shipped" ? new Date().toISOString() : undefined,
      delivered_at: next === "delivered" ? new Date().toISOString() : undefined,
    })
    .eq("id", shipping.id);

  await client.from("tracking_events").insert({
    shipping_id: shipping.id,
    status: next,
    note: body.note || `Status updated to ${next}`,
  });

  const orderStatus =
    next === "delivered"
      ? "delivered"
      : next === "shipped" || next === "out_for_delivery"
        ? "shipped"
        : next === "packed"
          ? "packed"
          : "ordered";

  await client.from("orders").update({ status: orderStatus }).eq("id", orderId);

  const { data: order } = await client
    .from("orders")
    .select("order_number, user_id")
    .eq("id", orderId)
    .maybeSingle();

  if (order) {
    const { data: profile } = await client
      .from("profiles")
      .select("full_name, email, phone")
      .eq("id", order.user_id)
      .maybeSingle();

    const emailContent = renderShippingUpdateEmail({
      customerName: profile?.full_name || "Reader",
      orderNumber: order.order_number,
      status: next,
      trackingNumber: shipping.tracking_number ?? undefined,
    });

    if (profile?.email) {
      await sendEmail({
        to: profile.email,
        subject: emailContent.subject,
        html: emailContent.html,
        text: emailContent.text,
      });
    }

    await notifyUser(supabase, {
      userId: order.user_id,
      email: profile?.email ?? undefined,
      title: `Order ${next.replace(/_/g, " ")}`,
      body: `${order.order_number}${shipping.tracking_number ? ` · ${shipping.tracking_number}` : ""}`,
      type: "shipping_update",
      link: "/orders",
      channels: ["in_app", "email"],
      emailSubject: emailContent.subject,
      emailHtml: emailContent.html,
    });

    if (profile?.phone) {
      await sendSms({
        to: profile.phone,
        body: `Books & You: ${order.order_number} is now ${next}.`,
      });
    }
  }

  return NextResponse.json({ ok: true, status: next });
}
