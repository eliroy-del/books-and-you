import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { getSupabaseEnv, isSupabaseConfigured } from "@/lib/supabase/env";

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request });

  if (!isSupabaseConfigured()) {
    return supabaseResponse;
  }

  const env = getSupabaseEnv()!;

  const supabase = createServerClient(env.url, env.anonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => {
          request.cookies.set(name, value);
        });
        supabaseResponse = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) => {
          supabaseResponse.cookies.set(name, value, options);
        });
      },
    },
  });

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const path = request.nextUrl.pathname;
  // Checkout stays public so Buy now / cart can go straight there; guest vs account is chosen on the page.
  const protectedPaths = ["/dashboard", "/orders", "/library", "/wishlist"];
  const staffPaths = ["/admin", "/superadmin"];
  const isProtected = protectedPaths.some(
    (p) => path === p || path.startsWith(`${p}/`)
  );
  const isStaffPath = staffPaths.some(
    (p) => path === p || path.startsWith(`${p}/`)
  );

  if ((isProtected || isStaffPath) && !user) {
    const url = request.nextUrl.clone();
    url.pathname = "/auth";
    url.searchParams.set("next", path);
    return NextResponse.redirect(url);
  }

  // Soft staff gate — full permission checks happen in admin APIs / pages
  if (isStaffPath && user) {
    const { data: isStaff } = await supabase.rpc("is_staff");
    if (!isStaff) {
      const url = request.nextUrl.clone();
      url.pathname = "/dashboard";
      return NextResponse.redirect(url);
    }
  }

  if (path === "/auth" && user) {
    const url = request.nextUrl.clone();
    url.pathname = "/dashboard";
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}
