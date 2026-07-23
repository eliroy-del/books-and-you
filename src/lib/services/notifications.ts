import type { SupabaseClient } from "@supabase/supabase-js";
import { db } from "@/lib/supabase/typed";
import { sendEmail } from "@/lib/services/email";
import { sendSms } from "@/lib/services/sms";

export type NotificationChannel = "in_app" | "email" | "sms" | "push";

export type NotifyInput = {
  userId?: string;
  email?: string;
  phone?: string;
  title: string;
  body: string;
  type?: string;
  link?: string;
  channels?: NotificationChannel[];
  emailHtml?: string;
  emailSubject?: string;
};

export async function createInAppNotification(
  supabase: SupabaseClient,
  input: {
    userId: string;
    title: string;
    body: string;
    type?: string;
    link?: string;
  }
) {
  const client = db(supabase);
  const { data, error } = await client
    .from("notifications")
    .insert({
      user_id: input.userId,
      title: input.title,
      body: input.body,
      type: input.type ?? "general",
      link: input.link ?? null,
    })
    .select("id")
    .single();

  if (error) {
    console.warn("[notifications]", error.message);
    return null;
  }
  return data?.id as string | undefined;
}

export async function notifyUser(
  supabase: SupabaseClient | null,
  input: NotifyInput
) {
  const channels = input.channels ?? ["in_app", "email"];
  const results: Record<string, unknown> = {};

  if (channels.includes("in_app") && supabase && input.userId) {
    results.inApp = await createInAppNotification(supabase, {
      userId: input.userId,
      title: input.title,
      body: input.body,
      type: input.type,
      link: input.link,
    });
  }

  if (channels.includes("email") && input.email) {
    results.email = await sendEmail({
      to: input.email,
      subject: input.emailSubject ?? input.title,
      html:
        input.emailHtml ??
        `<p>${input.body}</p>${input.link ? `<p><a href="${input.link}">Open</a></p>` : ""}`,
      text: input.body,
      tags: input.type ? [{ name: "type", value: input.type }] : undefined,
    });
  }

  if (channels.includes("sms") && input.phone) {
    results.sms = await sendSms({
      to: input.phone,
      body: `${input.title}: ${input.body}`.slice(0, 160),
    });
  }

  // Push reserved for Phase 5/6
  if (channels.includes("push")) {
    results.push = { ok: true, demo: true };
  }

  return results;
}

export async function listNotifications(
  supabase: SupabaseClient,
  userId: string,
  limit = 20
) {
  const client = db(supabase);
  const { data, error } = await client
    .from("notifications")
    .select("*")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    console.warn("[notifications:list]", error.message);
    return [];
  }
  return data ?? [];
}

export async function markNotificationRead(
  supabase: SupabaseClient,
  userId: string,
  notificationId: string
) {
  const client = db(supabase);
  await client
    .from("notifications")
    .update({ is_read: true })
    .eq("id", notificationId)
    .eq("user_id", userId);
}
