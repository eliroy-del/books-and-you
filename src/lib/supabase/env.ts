export function isSupabaseConfigured() {
  return Boolean(
    process.env.NEXT_PUBLIC_SUPABASE_URL &&
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY &&
      !process.env.NEXT_PUBLIC_SUPABASE_URL.includes("your-project")
  );
}

/** Demo / fake login is opt-in for local testing only. Off in production. */
export function isDemoAuthAllowed() {
  if (process.env.NODE_ENV === "production") return false;
  return (
    process.env.ALLOW_DEMO_AUTH === "true" ||
    process.env.NEXT_PUBLIC_ALLOW_DEMO_AUTH === "true"
  );
}

export function getSupabaseEnv() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) {
    return null;
  }
  return { url, anonKey };
}
