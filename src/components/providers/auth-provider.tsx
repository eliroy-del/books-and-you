"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import type { User } from "@supabase/supabase-js";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { tryCreateClient } from "@/lib/supabase/client";
import { db } from "@/lib/supabase/typed";
import {
  DEMO_STAFF_BY_EMAIL,
  permissionsForRole,
  type RoleKey,
} from "@/lib/admin/permissions";

export type Profile = {
  id: string;
  email: string | null;
  full_name: string | null;
  avatar_url: string | null;
  referral_code: string | null;
  reading_goal: number;
  reading_streak: number;
  favorite_genres: string[];
  role_key?: RoleKey | null;
};

type AuthContextValue = {
  user: User | null;
  profile: Profile | null;
  loading: boolean;
  configured: boolean;
  demoMode: boolean;
  roleKey: RoleKey | null;
  permissions: string[];
  isStaff: boolean;
  signIn: (email: string, password: string) => Promise<{ error?: string }>;
  signUp: (
    email: string,
    password: string,
    fullName: string
  ) => Promise<{ error?: string }>;
  signOut: () => Promise<void>;
  refreshProfile: () => Promise<void>;
};

const AuthContext = createContext<AuthContextValue | null>(null);

const DEMO_KEY = "books-and-you-demo-auth";

type DemoSession = {
  id: string;
  email: string;
  full_name: string;
};

function readDemo(): DemoSession | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = localStorage.getItem(DEMO_KEY);
    return raw ? (JSON.parse(raw) as DemoSession) : null;
  } catch {
    return null;
  }
}

function writeDemo(session: DemoSession | null) {
  if (typeof window === "undefined") return;
  if (!session) localStorage.removeItem(DEMO_KEY);
  else localStorage.setItem(DEMO_KEY, JSON.stringify(session));
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const configured = isSupabaseConfigured();
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [demoMode, setDemoMode] = useState(!configured);

  const loadProfile = useCallback(async (uid: string) => {
    const supabase = tryCreateClient();
    if (!supabase) return null;
    const { data } = await db(supabase)
      .from("profiles")
      .select(
        "id, email, full_name, avatar_url, referral_code, reading_goal, reading_streak, favorite_genres"
      )
      .eq("id", uid)
      .maybeSingle();
    return (data as Profile | null) ?? null;
  }, []);

  const refreshProfile = useCallback(async () => {
    if (user?.id && configured) {
      const p = await loadProfile(user.id);
      setProfile(p);
    }
  }, [user?.id, configured, loadProfile]);

  useEffect(() => {
    let mounted = true;

    async function init() {
      if (!configured) {
        const demo = readDemo();
        if (demo && mounted) {
          setDemoMode(true);
          setUser({ id: demo.id, email: demo.email } as User);
          setProfile({
            id: demo.id,
            email: demo.email,
            full_name: demo.full_name,
            avatar_url: null,
            referral_code: "DEMO-READS",
            reading_goal: 24,
            reading_streak: 3,
            favorite_genres: ["Literary Fiction", "Business"],
            role_key: DEMO_STAFF_BY_EMAIL[demo.email.toLowerCase()] || null,
          });
        }
        if (mounted) setLoading(false);
        return;
      }

      const supabase = tryCreateClient();
      if (!supabase) {
        if (mounted) setLoading(false);
        return;
      }

      const {
        data: { session },
      } = await supabase.auth.getSession();

      if (session?.user && mounted) {
        setUser(session.user);
        setProfile(await loadProfile(session.user.id));
      }

      const {
        data: { subscription },
      } = supabase.auth.onAuthStateChange(async (_event, next) => {
        if (!mounted) return;
        setUser(next?.user ?? null);
        if (next?.user) {
          setProfile(await loadProfile(next.user.id));
        } else {
          setProfile(null);
        }
      });

      if (mounted) setLoading(false);
      return () => subscription.unsubscribe();
    }

    const cleanup = init();
    return () => {
      mounted = false;
      void cleanup.then((unsub) => unsub?.());
    };
  }, [configured, loadProfile]);

  const signIn = useCallback(
    async (email: string, password: string) => {
      if (!configured) {
        const demo: DemoSession = {
          id: "demo-user-local",
          email,
          full_name: email.split("@")[0] || "Reader",
        };
        const staffRole = DEMO_STAFF_BY_EMAIL[email.toLowerCase()] || null;
        writeDemo(demo);
        setDemoMode(true);
        setUser({ id: demo.id, email: demo.email } as User);
        setProfile({
          id: demo.id,
          email: demo.email,
          full_name: demo.full_name,
          avatar_url: null,
          referral_code: "DEMO-READS",
          reading_goal: 24,
          reading_streak: 3,
          favorite_genres: ["Literary Fiction", "Business"],
          role_key: staffRole,
        });
        return {};
      }

      const supabase = tryCreateClient();
      if (!supabase) return { error: "Supabase is not configured." };
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      return error ? { error: error.message } : {};
    },
    [configured]
  );

  const signUp = useCallback(
    async (email: string, password: string, fullName: string) => {
      if (!configured) {
        return signIn(email, password);
      }
      const supabase = tryCreateClient();
      if (!supabase) return { error: "Supabase is not configured." };
      const { error } = await supabase.auth.signUp({
        email,
        password,
        options: { data: { full_name: fullName } },
      });
      return error ? { error: error.message } : {};
    },
    [configured, signIn]
  );

  const signOut = useCallback(async () => {
    if (!configured) {
      writeDemo(null);
      setUser(null);
      setProfile(null);
      return;
    }
    const supabase = tryCreateClient();
    await supabase?.auth.signOut();
    setUser(null);
    setProfile(null);
  }, [configured]);

  const roleKey = useMemo<RoleKey | null>(() => {
    if (profile?.role_key) return profile.role_key;
    if (profile?.email && DEMO_STAFF_BY_EMAIL[profile.email.toLowerCase()]) {
      return DEMO_STAFF_BY_EMAIL[profile.email.toLowerCase()];
    }
    return null;
  }, [profile]);

  const permissions = useMemo(
    () => (roleKey ? permissionsForRole(roleKey) : []),
    [roleKey]
  );

  const value = useMemo(
    () => ({
      user,
      profile,
      loading,
      configured,
      demoMode: demoMode || !configured,
      roleKey,
      permissions,
      isStaff: Boolean(roleKey && roleKey !== "customer"),
      signIn,
      signUp,
      signOut,
      refreshProfile,
    }),
    [
      user,
      profile,
      loading,
      configured,
      demoMode,
      roleKey,
      permissions,
      signIn,
      signUp,
      signOut,
      refreshProfile,
    ]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
