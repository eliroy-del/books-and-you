"use client";

import { useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { newsletterSchema } from "@/lib/validation";
import { sanitizeEmail } from "@/lib/sanitize";
import { analytics } from "@/lib/analytics";
import { cn } from "@/lib/utils";

type Props = {
  className?: string;
  inputClassName?: string;
  buttonClassName?: string;
  buttonLabel?: string;
};

export function NewsletterForm({
  className,
  inputClassName,
  buttonClassName,
  buttonLabel = "Join",
}: Props) {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsSubmitting(true);
    setError("");

    const result = newsletterSchema.safeParse({ email });
    if (!result.success) {
      const message = result.error.issues[0]?.message || "Invalid email";
      setError(message);
      toast.error(message);
      setIsSubmitting(false);
      return;
    }

    try {
      const response = await fetch("/api/newsletter", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: sanitizeEmail(result.data.email) }),
      });
      const data = (await response.json()) as { success?: boolean; error?: string };
      if (!response.ok) {
        setError(data.error || "Subscription failed");
        analytics.trackFormSubmission("newsletter", false);
        toast.error(data.error || "Subscription failed");
        return;
      }
      setEmail("");
      analytics.trackFormSubmission("newsletter", true);
      toast.success("You're on the list");
    } catch {
      analytics.trackFormSubmission("newsletter", false);
      toast.error("Subscription failed. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <form className={cn("flex gap-2", className)} onSubmit={handleSubmit} noValidate>
      <div className="min-w-0 flex-1">
        <Input
          type="email"
          required
          value={email}
          onChange={(e) => {
            setEmail(e.target.value);
            if (error) setError("");
          }}
          placeholder="you@email.com"
          className={cn(error && "border-destructive", inputClassName)}
          autoComplete="email"
          aria-invalid={Boolean(error)}
        />
        {error ? <p className="text-destructive mt-1 text-xs">{error}</p> : null}
      </div>
      <Button type="submit" className={cn("shrink-0", buttonClassName)} disabled={isSubmitting}>
        {isSubmitting ? "…" : buttonLabel}
      </Button>
    </form>
  );
}
