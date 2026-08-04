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
import {
  getFieldErrors,
  getFirstError,
  signInSchema,
  signUpSchema,
  type SignInData,
  type SignUpData,
} from "@/lib/validation";
import { sanitize, sanitizeEmail } from "@/lib/sanitize";
import { cn } from "@/lib/utils";

function AuthForm() {
  const router = useRouter();
  const params = useSearchParams();
  const next = params.get("next") || "/";
  const { signIn, signUp, configured } = useAuth();
  const [loading, setLoading] = useState(false);
  const [mode, setMode] = useState<"signin" | "signup">("signin");
  const [signInData, setSignInData] = useState<SignInData>({
    email: "",
    password: "",
  });
  const [signUpData, setSignUpData] = useState<SignUpData>({
    fullName: "",
    email: "",
    password: "",
  });
  const [errors, setErrors] = useState<Record<string, string>>({});

  function clearFieldError(field: string) {
    setErrors((prev) => {
      if (!prev[field]) return prev;
      const nextErrors = { ...prev };
      delete nextErrors[field];
      return nextErrors;
    });
  }

  function validateSignInField(field: keyof SignInData, value: string) {
    const result = signInSchema.shape[field].safeParse(value);
    setErrors((prev) => {
      const nextErrors = { ...prev };
      if (!result.success) {
        nextErrors[field] = result.error.issues[0]?.message || "Invalid";
      } else {
        delete nextErrors[field];
      }
      return nextErrors;
    });
  }

  function validateSignUpField(field: keyof SignUpData, value: string) {
    const result = signUpSchema.shape[field].safeParse(value);
    setErrors((prev) => {
      const nextErrors = { ...prev };
      if (!result.success) {
        nextErrors[field] = result.error.issues[0]?.message || "Invalid";
      } else {
        delete nextErrors[field];
      }
      return nextErrors;
    });
  }

  async function handleSignIn(e: React.FormEvent) {
    e.preventDefault();
    const parsed = signInSchema.safeParse(signInData);
    if (!parsed.success) {
      setErrors(getFieldErrors(parsed.error));
      toast.error(getFirstError(parsed.error));
      return;
    }

    setLoading(true);
    setErrors({});
    const cleanEmail = sanitizeEmail(parsed.data.email);
    const result = await signIn(cleanEmail, parsed.data.password);
    setLoading(false);

    if (result.error) {
      toast.error(result.error);
      return;
    }

    toast.success("Welcome back");
    router.push(next);
    router.refresh();
  }

  async function handleSignUp(e: React.FormEvent) {
    e.preventDefault();
    const parsed = signUpSchema.safeParse(signUpData);
    if (!parsed.success) {
      setErrors(getFieldErrors(parsed.error));
      toast.error(getFirstError(parsed.error));
      return;
    }

    setLoading(true);
    setErrors({});
    const cleanEmail = sanitizeEmail(parsed.data.email);
    const cleanName = sanitize(parsed.data.fullName);
    if (cleanName.length < 2) {
      setErrors({ fullName: "Name must be at least 2 characters" });
      setLoading(false);
      toast.error("Please enter a valid full name");
      return;
    }

    const result = await signUp(cleanEmail, parsed.data.password, cleanName);
    setLoading(false);

    if (result.error) {
      toast.error(result.error);
      return;
    }

    toast.success("Account created");
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

        <Tabs
          value={mode}
          onValueChange={(value) => {
            setMode(value as "signin" | "signup");
            setErrors({});
          }}
        >
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="signin">Sign in</TabsTrigger>
            <TabsTrigger value="signup">Create account</TabsTrigger>
          </TabsList>

          <TabsContent value="signin" className="mt-6">
            <form className="space-y-4" onSubmit={handleSignIn} noValidate>
              <div>
                <Label htmlFor="signin-email">Email</Label>
                <Input
                  id="signin-email"
                  name="email"
                  type="email"
                  className={cn("mt-1.5", errors.email && "border-destructive")}
                  value={signInData.email}
                  onChange={(e) => {
                    const value = e.target.value;
                    setSignInData((prev) => ({ ...prev, email: value }));
                    validateSignInField("email", value);
                  }}
                  onBlur={(e) => validateSignInField("email", e.target.value)}
                  placeholder="you@email.com"
                  autoComplete="email"
                  inputMode="email"
                  aria-invalid={Boolean(errors.email)}
                  aria-describedby={errors.email ? "signin-email-error" : undefined}
                />
                {errors.email ? (
                  <p id="signin-email-error" className="text-destructive mt-1 text-xs">
                    {errors.email}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="signin-password">Password</Label>
                <Input
                  id="signin-password"
                  name="password"
                  type="password"
                  className={cn("mt-1.5", errors.password && "border-destructive")}
                  value={signInData.password}
                  onChange={(e) => {
                    const value = e.target.value;
                    setSignInData((prev) => ({ ...prev, password: value }));
                    clearFieldError("password");
                  }}
                  onBlur={(e) => validateSignInField("password", e.target.value)}
                  placeholder="Your password"
                  autoComplete="current-password"
                  aria-invalid={Boolean(errors.password)}
                  aria-describedby={errors.password ? "signin-password-error" : undefined}
                />
                {errors.password ? (
                  <p id="signin-password-error" className="text-destructive mt-1 text-xs">
                    {errors.password}
                  </p>
                ) : null}
              </div>
              <Button className="w-full" type="submit" disabled={loading || !configured}>
                {loading ? "Signing in…" : "Sign in"}
              </Button>
            </form>
          </TabsContent>

          <TabsContent value="signup" className="mt-6">
            <form className="space-y-4" onSubmit={handleSignUp} noValidate>
              <div>
                <Label htmlFor="signup-fullName">Full name</Label>
                <Input
                  id="signup-fullName"
                  name="fullName"
                  className={cn("mt-1.5", errors.fullName && "border-destructive")}
                  placeholder="Your name"
                  value={signUpData.fullName}
                  onChange={(e) => {
                    const value = e.target.value;
                    setSignUpData((prev) => ({ ...prev, fullName: value }));
                    validateSignUpField("fullName", value);
                  }}
                  onBlur={(e) => validateSignUpField("fullName", e.target.value)}
                  autoComplete="name"
                  aria-invalid={Boolean(errors.fullName)}
                  aria-describedby={errors.fullName ? "signup-fullName-error" : undefined}
                />
                {errors.fullName ? (
                  <p id="signup-fullName-error" className="text-destructive mt-1 text-xs">
                    {errors.fullName}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="signup-email">Email</Label>
                <Input
                  id="signup-email"
                  name="email"
                  type="email"
                  className={cn("mt-1.5", errors.email && "border-destructive")}
                  placeholder="you@email.com"
                  value={signUpData.email}
                  onChange={(e) => {
                    const value = e.target.value;
                    setSignUpData((prev) => ({ ...prev, email: value }));
                    validateSignUpField("email", value);
                  }}
                  onBlur={(e) => validateSignUpField("email", e.target.value)}
                  autoComplete="email"
                  inputMode="email"
                  aria-invalid={Boolean(errors.email)}
                  aria-describedby={errors.email ? "signup-email-error" : undefined}
                />
                {errors.email ? (
                  <p id="signup-email-error" className="text-destructive mt-1 text-xs">
                    {errors.email}
                  </p>
                ) : null}
              </div>
              <div>
                <Label htmlFor="signup-password">Password</Label>
                <Input
                  id="signup-password"
                  name="password"
                  type="password"
                  className={cn("mt-1.5", errors.password && "border-destructive")}
                  placeholder="Create a password"
                  value={signUpData.password}
                  onChange={(e) => {
                    const value = e.target.value;
                    setSignUpData((prev) => ({ ...prev, password: value }));
                    clearFieldError("password");
                  }}
                  onBlur={(e) => validateSignUpField("password", e.target.value)}
                  autoComplete="new-password"
                  aria-invalid={Boolean(errors.password)}
                  aria-describedby={errors.password ? "signup-password-error" : undefined}
                />
                {errors.password ? (
                  <p id="signup-password-error" className="text-destructive mt-1 text-xs">
                    {errors.password}
                  </p>
                ) : (
                  <p className="text-muted-foreground mt-1 text-xs">
                    At least 6 characters.
                  </p>
                )}
              </div>
              <Button className="w-full" type="submit" disabled={loading || !configured}>
                {loading ? "Creating…" : "Create account"}
              </Button>
            </form>
          </TabsContent>
        </Tabs>

        <p className="text-muted-foreground mt-6 text-center text-xs">
          By continuing you agree to our{" "}
          <Link href="/support" className="underline underline-offset-2 hover:text-foreground">
            Terms
          </Link>{" "}
          and{" "}
          <Link href="/support" className="underline underline-offset-2 hover:text-foreground">
            Privacy Policy
          </Link>
          .
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
