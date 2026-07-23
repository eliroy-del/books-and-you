import { createBrowserClient } from "@supabase/ssr";
import type { Database } from "@/types/database";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";

export function createClient() {
  const env = getSupabaseEnv();
  if (!env) {
    throw new Error(
      "Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY. Copy .env.example to .env.local."
    );
  }
  return createBrowserClient<Database>(env.url, env.anonKey);
}

export function tryCreateClient() {
  if (!isSupabaseConfigured()) return null;
  return createClient();
}
