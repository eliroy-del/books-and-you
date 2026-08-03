export type SmsPayload = {
  to: string;
  body: string;
  ref?: string;
};

export type SmsResult = {
  ok: boolean;
  id?: string;
  demo?: boolean;
  provider?: "console" | "moolre";
  error?: string;
};

function moolreBaseUrl() {
  return (process.env.MOOLRE_BASE_URL || "https://api.moolre.com").replace(/\/$/, "");
}

/** Normalize Ghana numbers toward E.164-style digits Moolre accepts. */
export function normalizeSmsRecipient(phone: string) {
  const digits = phone.replace(/[^\d+]/g, "");
  if (digits.startsWith("+")) return digits.slice(1);
  if (digits.startsWith("0") && digits.length === 10) return `233${digits.slice(1)}`;
  return digits;
}

export function isMoolreSmsConfigured() {
  return Boolean(process.env.MOOLRE_SMS_API_KEY && process.env.MOOLRE_SMS_SENDER_ID);
}

/**
 * SMS via Moolre (X-API-VASKEY). Falls back to console demo when keys are missing.
 * Docs: https://docs.moolre.com/ai/send-sms.html
 */
export async function sendSms(payload: SmsPayload): Promise<SmsResult> {
  if (!isMoolreSmsConfigured()) {
    console.info("[sms:demo]", payload.to, payload.body);
    return {
      ok: true,
      id: `demo_sms_${Date.now()}`,
      demo: true,
      provider: "console",
    };
  }

  const vasKey = process.env.MOOLRE_SMS_API_KEY!;
  const senderId = process.env.MOOLRE_SMS_SENDER_ID!;
  const recipient = normalizeSmsRecipient(payload.to);
  const ref = payload.ref || `sms_${Date.now()}`;

  try {
    const res = await fetch(`${moolreBaseUrl()}/open/sms/send`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-API-VASKEY": vasKey,
      },
      body: JSON.stringify({
        type: 1,
        senderid: senderId.slice(0, 11),
        messages: [
          {
            recipient,
            message: payload.body,
            ref,
          },
        ],
      }),
    });

    const json = (await res.json()) as {
      status?: number | string;
      code?: string;
      message?: string | string[];
      data?: unknown;
    };

    if (!res.ok || Number(json.status) !== 1) {
      const message = Array.isArray(json.message)
        ? json.message.join(", ")
        : json.message || json.code || "Moolre SMS failed";
      return { ok: false, provider: "moolre", error: message };
    }

    return { ok: true, id: ref, provider: "moolre" };
  } catch (error) {
    return {
      ok: false,
      provider: "moolre",
      error: error instanceof Error ? error.message : "SMS failed",
    };
  }
}
