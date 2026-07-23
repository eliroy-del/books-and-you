export type SmsPayload = {
  to: string;
  body: string;
};

export type SmsResult = {
  ok: boolean;
  id?: string;
  demo?: boolean;
  provider?: "console" | "twilio" | "hubtel";
  error?: string;
};

/**
 * SMS abstraction — Phase 4.
 * Swap provider via SMS_PROVIDER=console|twilio|hubtel without changing callers.
 */
export async function sendSms(payload: SmsPayload): Promise<SmsResult> {
  const provider = (process.env.SMS_PROVIDER || "console") as
    | "console"
    | "twilio"
    | "hubtel";

  if (provider === "console" || !process.env.TWILIO_ACCOUNT_SID) {
    console.info("[sms:demo]", payload.to, payload.body);
    return { ok: true, id: `demo_sms_${Date.now()}`, demo: true, provider: "console" };
  }

  if (provider === "twilio") {
    const sid = process.env.TWILIO_ACCOUNT_SID!;
    const token = process.env.TWILIO_AUTH_TOKEN!;
    const from = process.env.TWILIO_FROM_NUMBER!;
    const auth = Buffer.from(`${sid}:${token}`).toString("base64");

    try {
      const body = new URLSearchParams({
        To: payload.to,
        From: from,
        Body: payload.body,
      });
      const res = await fetch(
        `https://api.twilio.com/2010-04-01/Accounts/${sid}/Messages.json`,
        {
          method: "POST",
          headers: {
            Authorization: `Basic ${auth}`,
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body,
        }
      );
      const json = await res.json();
      if (!res.ok) {
        return { ok: false, provider, error: json.message || "Twilio SMS failed" };
      }
      return { ok: true, id: json.sid, provider };
    } catch (error) {
      return {
        ok: false,
        provider,
        error: error instanceof Error ? error.message : "SMS failed",
      };
    }
  }

  // Hubtel stub
  console.info("[sms:hubtel:stub]", payload.to, payload.body);
  return { ok: true, id: `hubtel_stub_${Date.now()}`, demo: true, provider: "hubtel" };
}
