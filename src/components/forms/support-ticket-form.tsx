"use client";

import { useState } from "react";
import { toast } from "sonner";
import { MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
  getFieldErrors,
  getFirstError,
  supportTicketSchema,
  type SupportTicketData,
} from "@/lib/validation";
import { sanitize, sanitizeEmail } from "@/lib/sanitize";
import { analytics } from "@/lib/analytics";
import { cn } from "@/lib/utils";
import { useAuth } from "@/components/providers/auth-provider";

export function SupportTicketForm() {
  const { user, profile } = useAuth();
  const [formData, setFormData] = useState({
    subject: "",
    email: profile?.email || user?.email || "",
    name: profile?.full_name || "",
    message: "",
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  function validateField(field: keyof SupportTicketData, value: unknown) {
    const fieldSchema = supportTicketSchema.shape[field];
    const result = fieldSchema.safeParse(value);
    setErrors((prev) => {
      const next = { ...prev };
      if (!result.success) {
        next[field] = result.error.issues[0]?.message || "Invalid";
      } else {
        delete next[field];
      }
      return next;
    });
  }

  function handleChange(
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    validateField(name as keyof SupportTicketData, value);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsSubmitting(true);

    const result = supportTicketSchema.safeParse(formData);
    if (!result.success) {
      setErrors(getFieldErrors(result.error));
      setIsSubmitting(false);
      toast.error(getFirstError(result.error));
      return;
    }

    const payload = {
      subject: sanitize(result.data.subject),
      email: sanitizeEmail(result.data.email),
      name: sanitize(result.data.name || "") || "Reader",
      message: sanitize(result.data.message),
    };

    try {
      const response = await fetch("/api/support", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const data = (await response.json()) as {
        success?: boolean;
        error?: string;
        errors?: Record<string, string>;
        ticketNumber?: string;
      };

      if (!response.ok) {
        if (data.errors) setErrors(data.errors);
        analytics.trackFormSubmission("support_ticket", false);
        toast.error(data.error || "Failed to submit ticket");
        return;
      }

      setFormData({
        subject: "",
        email: profile?.email || user?.email || "",
        name: profile?.full_name || "",
        message: "",
      });
      setErrors({});
      analytics.trackFormSubmission("support_ticket", true);
      toast.success(
        data.ticketNumber
          ? `Ticket ${data.ticketNumber} submitted`
          : "Ticket submitted",
        { description: "We'll get back to you soon." }
      );
    } catch {
      analytics.trackFormSubmission("support_ticket", false);
      toast.error("Failed to submit ticket. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <form className="mt-5 space-y-4" onSubmit={handleSubmit} noValidate>
      <div>
        <Input
          name="subject"
          placeholder="Subject"
          value={formData.subject}
          onChange={handleChange}
          className={cn(errors.subject && "border-destructive")}
          aria-invalid={Boolean(errors.subject)}
          autoComplete="off"
        />
        {errors.subject ? (
          <p className="text-destructive mt-1 text-xs">{errors.subject}</p>
        ) : null}
      </div>
      <div>
        <Input
          name="email"
          type="email"
          placeholder="Email"
          value={formData.email}
          onChange={handleChange}
          className={cn(errors.email && "border-destructive")}
          aria-invalid={Boolean(errors.email)}
          autoComplete="email"
        />
        {errors.email ? (
          <p className="text-destructive mt-1 text-xs">{errors.email}</p>
        ) : null}
      </div>
      <div>
        <Textarea
          name="message"
          placeholder="How can we help?"
          rows={5}
          value={formData.message}
          onChange={handleChange}
          className={cn(errors.message && "border-destructive")}
          aria-invalid={Boolean(errors.message)}
        />
        {errors.message ? (
          <p className="text-destructive mt-1 text-xs">{errors.message}</p>
        ) : null}
      </div>
      <Button type="submit" className="w-full" disabled={isSubmitting}>
        <MessageCircle className="size-4" />
        {isSubmitting ? "Submitting…" : "Submit ticket"}
      </Button>
    </form>
  );
}
