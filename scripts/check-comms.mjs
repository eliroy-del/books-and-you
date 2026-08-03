/**
 * Live connectivity checks for Moolre SMS, Resend email, and callbacks.
 * Usage: node --env-file=.env.local scripts/check-comms.mjs
 * Never prints secret values.
 */
import { Resend } from "resend";

const results = [];

function report(name, ok, detail) {
  results.push({ name, ok, detail });
  console.log(`${ok ? "PASS" : "FAIL"}  ${name}: ${detail}`);
}

function required(name) {
  const v = process.env[name];
  return Boolean(v && String(v).trim());
}

const base = (process.env.MOOLRE_BASE_URL || "https://api.moolre.com").replace(/\/$/, "");
const site = (process.env.NEXT_PUBLIC_SITE_URL || "https://booksandyou.shop").replace(/\/$/, "");

async function checkSmsAccount() {
  if (!required("MOOLRE_SMS_API_KEY")) {
    report("sms.config", false, "MOOLRE_SMS_API_KEY missing");
    return;
  }
  if (!required("MOOLRE_SMS_SENDER_ID")) {
    report("sms.config", false, "MOOLRE_SMS_SENDER_ID missing");
    return;
  }

  const headers = {
    "Content-Type": "application/json",
    "X-API-VASKEY": process.env.MOOLRE_SMS_API_KEY,
  };

  // Account balance / status
  const statusRes = await fetch(`${base}/open/sms/status`, {
    method: "POST",
    headers,
    body: JSON.stringify({ type: 2 }),
  });
  const statusJson = await statusRes.json();
  if (statusRes.ok && Number(statusJson.status) === 1) {
    report(
      "sms.account",
      true,
      `auth ok · balance=${statusJson.data?.balance ?? "n/a"} · code=${statusJson.code}`
    );
  } else {
    report(
      "sms.account",
      false,
      `auth/status failed · http=${statusRes.status} · code=${statusJson.code || "?"} · msg=${statusJson.message || "?"}`
    );
    return;
  }

  // Sender ID list
  const listRes = await fetch(`${base}/open/sms/status`, {
    method: "POST",
    headers,
    body: JSON.stringify({ type: 7 }),
  });
  const listJson = await listRes.json();
  const sender = process.env.MOOLRE_SMS_SENDER_ID;
  const rows = Array.isArray(listJson.data) ? listJson.data : [];
  const match = rows.find(
    (r) => String(r.senderid || "").toLowerCase() === String(sender).toLowerCase()
  );
  if (Number(listJson.status) === 1 && match) {
    const approved = String(match.approval || "").toLowerCase() === "approved";
    report(
      "sms.sender",
      approved,
      `found "${match.senderid}" · approval=${match.approval}`
    );
  } else if (Number(listJson.status) === 1) {
    report(
      "sms.sender",
      false,
      `sender "${sender}" not in account list (${rows.length} ids: ${rows
        .map((r) => r.senderid)
        .join(", ") || "none"})`
    );
  } else {
    report(
      "sms.sender",
      false,
      `list failed · code=${listJson.code || "?"} · msg=${listJson.message || "?"}`
    );
  }
}

async function checkEmail() {
  if (!required("RESEND_API_KEY")) {
    report("email.config", false, "RESEND_API_KEY missing");
    return;
  }
  const from = process.env.RESEND_FROM_EMAIL || "Books & You <onboarding@resend.dev>";
  const to =
    process.env.ADMIN_EMAIL ||
    (from.match(/<([^>]+)>/)?.[1] ?? from);

  if (!process.env.ADMIN_EMAIL) {
    report("email.admin", false, "ADMIN_EMAIL missing — using from-address as probe recipient");
  } else {
    report("email.admin", true, "ADMIN_EMAIL set");
  }

  const resend = new Resend(process.env.RESEND_API_KEY);
  const { data, error } = await resend.emails.send({
    from,
    to,
    subject: "[Books & You] Connectivity probe",
    html: "<p>This is an automated connectivity check from the Books &amp; You server.</p>",
    text: "This is an automated connectivity check from the Books & You server.",
    tags: [{ name: "type", value: "connectivity_probe" }],
  });

  if (error) {
    report("email.send", false, error.message);
  } else {
    report("email.send", true, `accepted by Resend · id=${data?.id || "?"}`);
  }
}

async function checkCallbacks() {
  // Local route existence is verified by import/build; probe production URLs
  for (const path of ["/api/webhooks/moolre", "/api/webhooks/paystack"]) {
    try {
      const res = await fetch(`${site}${path}`, { method: "GET" });
      // paystack may not have GET — 405/404 still informative
      if (path.includes("moolre")) {
        if (res.status === 200) {
          const json = await res.json();
          report(
            "callback.moolre.live",
            Boolean(json.ok),
            `GET ${res.status} · secretConfigured=${json.secretConfigured} · paymentCreds=${json.paymentCredsConfigured}`
          );
        } else {
          report("callback.moolre.live", false, `GET ${res.status} (route missing or not deployed)`);
        }
      } else {
        report(
          "callback.paystack.live",
          res.status !== 404,
          `GET ${res.status}`
        );
      }
    } catch (e) {
      report(`callback.${path}`, false, e.message);
    }
  }

  // Local secret gate simulation for moolre handler logic
  report(
    "callback.moolre.secret",
    required("MOOLRE_CALLBACK_SECRET"),
    required("MOOLRE_CALLBACK_SECRET")
      ? "MOOLRE_CALLBACK_SECRET set (handler will require it)"
      : "MOOLRE_CALLBACK_SECRET missing (handler accepts unsigned callbacks)"
  );

  report(
    "callback.moolre.verify_creds",
    required("MOOLRE_API_USER") &&
      required("MOOLRE_ACCOUNT_NUMBER") &&
      required("MOOLRE_API_PUBKEY"),
    required("MOOLRE_API_KEY")
      ? "user/account/pubkey present (private key also set)"
      : required("MOOLRE_API_USER") && required("MOOLRE_ACCOUNT_NUMBER") && required("MOOLRE_API_PUBKEY")
        ? "user/account/pubkey present — private MOOLRE_API_KEY still missing (needed for initiate payment, not status)"
        : "incomplete Moolre payment credentials for status re-verify"
  );
}

async function main() {
  console.log("Books & You — comms connectivity check\n");
  await checkSmsAccount();
  await checkEmail();
  await checkCallbacks();
  const failed = results.filter((r) => !r.ok);
  console.log(`\n${results.length - failed.length}/${results.length} checks passed`);
  process.exit(failed.length ? 1 : 0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
