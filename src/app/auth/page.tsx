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

function AuthForm() {
  const router = useRouter();
  const params = useSearchParams();
  const next = params.get("next") || "/";
  const { signIn, signUp, configured } = useAuth();
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");

  async function submit(mode: "signin" | "signup") {
    if (!email.trim() || !password) {
      toast.error("Enter your email and password");
      return;
    }
    setLoading(true);
    const result =
      mode === "signin"
        ? await signIn(email.trim(), password)
        : await signUp(email.trim(), password, fullName.trim() || email.split("@")[0] || "Reader");
    setLoading(false);

    if (result.error) {
      toast.error(result.error);
      return;
    }

    toast.success(mode === "signin" ? "Welcome back" : "Account created");
    router.push(next);
    router.refresh();
  }

  return (
    <div className="relative flex min-h-[calc(100vh-8rem)] items-center justify-center px-4 py-16">
      <div className="pointer-events-none absolute inset-0 gradient-mesh opacity-80" />
      <div className="glass-strong relative w-full max-w-md rounded-3xl p-8">
        <div className="mb-6 flex flex-col items-center text-center">
          <BrandLogo href={null} size="lg" showWordmark={false} priority />
          <h1 className="sr-only">Books & You</h1>
          <p className="text-muted-foreground mt-4 text-sm">Sign in to sync your library</p>
          {!configured ? (
            <p className="text-destructive mt-3 text-xs">
              Live authentication is not configured on this environment.
            </p>
          ) : null}
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
                placeholder="you@email.com"
                autoComplete="email"
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
                placeholder="Your password"
                autoComplete="current-password"
              />
            </div>
            <Button className="w-full" disabled={loading || !configured} onClick={() => submit("signin")}>
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
                autoComplete="name"
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
                autoComplete="email"
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
                autoComplete="new-password"
              />
            </div>
            <Button className="w-full" disabled={loading || !configured} onClick={() => submit("signup")}>
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
