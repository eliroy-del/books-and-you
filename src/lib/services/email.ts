import { Resend } from "resend";

export type EmailPayload = {
  to: string | string[];
  subject: string;
  html: string;
  text?: string;
  tags?: { name: string; value: string }[];
};

export type EmailResult = {
  ok: boolean;
  id?: string;
  demo?: boolean;
  error?: string;
};

function getResend() {
  const key = process.env.RESEND_API_KEY;
  if (!key) return null;
  return new Resend(key);
}

export function isEmailConfigured() {
  return Boolean(process.env.RESEND_API_KEY);
}

export async function sendEmail(payload: EmailPayload): Promise<EmailResult> {
  const from =
    process.env.RESEND_FROM_EMAIL ||
    `${process.env.NEXT_PUBLIC_APP_NAME || "Books & You"} <onboarding@resend.dev>`;

  const resend = getResend();
  if (!resend) {
    console.info("[email:demo]", payload.subject, "→", payload.to);
    return { ok: true, id: `demo_email_${Date.now()}`, demo: true };
  }

  try {
    const { data, error } = await resend.emails.send({
      from,
      to: payload.to,
      subject: payload.subject,
      html: payload.html,
      text: payload.text,
      tags: payload.tags,
    });

    if (error) {
      return { ok: false, error: error.message };
    }

    return { ok: true, id: data?.id };
  } catch (error) {
    return {
      ok: false,
      error: error instanceof Error ? error.message : "Email send failed",
    };
  }
}

export function renderOrderConfirmationEmail(input: {
  customerName: string;
  orderNumber: string;
  totalLabel: string;
  trackingUrl: string;
}) {
  return {
    subject: `Order ${input.orderNumber} confirmed · Books & You`,
    html: `
      <div style="font-family:Inter,system-ui,sans-serif;max-width:560px;margin:0 auto;padding:24px;color:#0f172a">
        <h1 style="font-size:22px;margin:0 0 12px">Thanks, ${input.customerName}!</h1>
        <p style="margin:0 0 16px;color:#475569">Your order <strong>${input.orderNumber}</strong> is confirmed.</p>
        <p style="margin:0 0 16px">Total paid: <strong>${input.totalLabel}</strong></p>
        <a href="${input.trackingUrl}" style="display:inline-block;background:#001F3E;color:#fff;text-decoration:none;padding:12px 18px;border-radius:10px">Track order</a>
        <p style="margin:24px 0 0;font-size:12px;color:#94a3b8">Books & You · Discover your next favorite book.</p>
      </div>
    `,
    text: `Thanks ${input.customerName}! Order ${input.orderNumber} confirmed. Total ${input.totalLabel}. Track: ${input.trackingUrl}`,
  };
}

export function renderShippingUpdateEmail(input: {
  customerName: string;
  orderNumber: string;
  status: string;
  trackingNumber?: string;
}) {
  return {
    subject: `Order ${input.orderNumber} is ${input.status}`,
    html: `
      <div style="font-family:Inter,system-ui,sans-serif;max-width:560px;margin:0 auto;padding:24px;color:#0f172a">
        <h1 style="font-size:22px;margin:0 0 12px">Shipping update</h1>
        <p style="margin:0 0 16px;color:#475569">Hi ${input.customerName}, your order <strong>${input.orderNumber}</strong> is now <strong>${input.status}</strong>.</p>
        ${input.trackingNumber ? `<p>Tracking: <strong>${input.trackingNumber}</strong></p>` : ""}
      </div>
    `,
    text: `Order ${input.orderNumber} is now ${input.status}.${input.trackingNumber ? ` Tracking ${input.trackingNumber}` : ""}`,
  };
}

export function renderReferralRewardEmail(input: {
  customerName: string;
  amountLabel: string;
  code: string;
}) {
  return {
    subject: "You earned store credit · Books & You",
    html: `
      <div style="font-family:Inter,system-ui,sans-serif;max-width:560px;margin:0 auto;padding:24px;color:#0f172a">
        <h1 style="font-size:22px;margin:0 0 12px">Referral reward unlocked</h1>
        <p style="margin:0 0 16px;color:#475569">Hi ${input.customerName}, ${input.amountLabel} was added to your wallet for sharing <strong>${input.code}</strong>.</p>
      </div>
    `,
    text: `Hi ${input.customerName}, ${input.amountLabel} credit added for referral code ${input.code}.`,
  };
}
