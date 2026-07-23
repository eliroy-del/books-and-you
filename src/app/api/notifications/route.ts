import { NextResponse } from "next/server";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import {
  listNotifications,
  markNotificationRead,
} from "@/lib/services/notifications";

export async function GET() {
  if (!isSupabaseConfigured()) {
    return NextResponse.json({
      demo: true,
      notifications: [
        {
          id: "n1",
          title: "Welcome to Books & You",
          body: "Configure Resend + payment keys to enable live notifications.",
          type: "general",
          is_read: false,
          created_at: new Date().toISOString(),
        },
      ],
    });
  }

  const supabase = await tryCreateClient();
  if (!supabase) {
    return NextResponse.json({ error: "Supabase unavailable" }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const notifications = await listNotifications(supabase, user.id);
  return NextResponse.json({ notifications });
}

export async function PATCH(request: Request) {
  const body = await request.json();
  const id = body.id as string;
  if (!id) {
    return NextResponse.json({ error: "id required" }, { status: 400 });
  }

  if (!isSupabaseConfigured()) {
    return NextResponse.json({ ok: true, demo: true });
  }

  const supabase = await tryCreateClient();
  if (!supabase) {
    return NextResponse.json({ error: "Supabase unavailable" }, { status: 500 });
  }

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  await markNotificationRead(supabase, user.id, id);
  return NextResponse.json({ ok: true });
}
