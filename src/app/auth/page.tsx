"use client";

import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Suspense, useState } from "react";
import { toast } from "sonner";
import { BrandLogo } from "@/components/brand-logo";
import { useAuth } from "@/components/providers/auth-provider";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { isSupabaseConfigured } from "@/lib/supabase/env";

function AuthForm() {
  const router = useRouter();
  const params = useSearchParams();
  const next = params.get("next") || "/dashboard";
  const { signIn, signUp, configured } = useAuth();
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState(
    configured ? "reader01@booksandyou.test" : "ama.darko@email.com"
  );
  const [password, setPassword] = useState("Password123!");
  const [fullName, setFullName] = useState("");

  async function submit(mode: "signin" | "signup") {
    setLoading(true);
    const result =
      mode === "signin"
        ? await signIn(email, password)
        : await signUp(email, password, fullName || email.split("@")[0] || "Reader");
    setLoading(false);

    if (result.error) {
      toast.error(result.error);
      return;
    }

    toast.success(mode === "signin" ? "Welcome back" : "Account created", {
      description: configured
        ? "Synced with Supabase"
        : "Demo mode — configure Supabase for real auth",
    });
    router.push(next);
    router.refresh();
  }

  return (
    <div className="relative flex min-h-[calc(100vh-8rem)] items-center justify-center px-4 py-16">
      <div className="pointer-events-none absolute inset-0 gradient-mesh opacity-80" />
      <div className="glass-strong relative w-full max-w-md rounded-3xl p-8">
        <div className="mb-6 flex flex-col items-center text-center">
          <BrandLogo size="lg" href={null} />
          <p className="text-muted-foreground mt-4 text-sm">Sign in to sync your library</p>
          {!isSupabaseConfigured() && (
            <p className="bg-accent text-accent-foreground mt-3 rounded-full px-3 py-1 text-[11px] font-medium">
              Demo auth · add Supabase keys for production
            </p>
          )}
        </div>

        <Tabs defaultValue="signin">
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="signin">Sign in</TabsTrigger>
            <TabsTrigger value="signup">Create account</TabsTrigger>
          </TabsList>
          <TabsContent value="signin" className="mt-6 space-y-4">
            <div>
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                className="mt-1.5"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div>
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                className="mt-1.5"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <Button className="w-full" disabled={loading} onClick={() => submit("signin")}>
              {loading ? "Signing in…" : "Sign in"}
            </Button>
          </TabsContent>
          <TabsContent value="signup" className="mt-6 space-y-4">
            <div>
              <Label htmlFor="name">Full name</Label>
              <Input
                id="name"
                className="mt-1.5"
                placeholder="Your name"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
              />
            </div>
            <div>
              <Label htmlFor="email2">Email</Label>
              <Input
                id="email2"
                type="email"
                className="mt-1.5"
                placeholder="you@email.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div>
              <Label htmlFor="password2">Password</Label>
              <Input
                id="password2"
                type="password"
                className="mt-1.5"
                placeholder="Create a password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>
            <Button className="w-full" disabled={loading} onClick={() => submit("signup")}>
              {loading ? "Creating…" : "Create account"}
            </Button>
          </TabsContent>
        </Tabs>

        <p className="text-muted-foreground mt-6 text-center text-xs">
          By continuing you agree to our Terms and Privacy Policy.
        </p>
        <Button variant="link" className="mt-2 w-full" asChild>
          <Link href="/">Back to store</Link>
        </Button>
      </div>
    </div>
  );
}

export default function AuthPage() {
  return (
    <Suspense fallback={<div className="py-24 text-center text-sm">Loading…</div>}>
      <AuthForm />
    </Suspense>
  );
}
