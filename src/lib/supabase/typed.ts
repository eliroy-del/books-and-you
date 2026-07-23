import type { SupabaseClient } from "@supabase/supabase-js";
import { tryCreateClient } from "@/lib/supabase/client";

/** Untyped client for flexible table access until full generated types are linked. */
export type AppSupabaseClient = SupabaseClient;

export function db(client: AppSupabaseClient) {
  return client as SupabaseClient<any>;
}

export function browserDb() {
  const client = tryCreateClient();
  return client ? db(client) : null;
}
