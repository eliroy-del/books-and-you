"use client";

import { useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { contactFormSchema, type ContactFormData } from "@/lib/validation";
import { sanitize, sanitizeEmail, sanitizePhone } from "@/lib/sanitize";
import { analytics } from "@/lib/analytics";
import { cn } from "@/lib/utils";

export function ContactForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    message: "",
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  function validateField(field: keyof ContactFormData, value: unknown) {
    const fieldSchema = contactFormSchema.shape[field];
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
    validateField(name as keyof ContactFormData, value);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setIsSubmitting(true);

    const result = contactFormSchema.safeParse(formData);
    if (!result.success) {
      const fieldErrors: Record<string, string> = {};
      for (const issue of result.error.issues) {
        const path = issue.path.join(".");
        if (!fieldErrors[path]) fieldErrors[path] = issue.message;
      }
      setErrors(fieldErrors);
      setIsSubmitting(false);
      toast.error(Object.values(fieldErrors)[0] || "Please fix the form");
      return;
    }

    const payload = {
      name: sanitize(result.data.name),
      email: sanitizeEmail(result.data.email),
      phone: sanitizePhone(result.data.phone || ""),
      message: sanitize(result.data.message),
    };

    try {
      const response = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const data = (await response.json()) as {
        success?: boolean;
        error?: string;
        errors?: Record<string, string>;
      };

      if (!response.ok) {
        if (data.errors) setErrors(data.errors);
        analytics.trackFormSubmission("contact_form", false);
        toast.error(data.error || "Failed to send message");
        return;
      }

      setFormData({ name: "", email: "", phone: "", message: "" });
      setErrors({});
      analytics.trackFormSubmission("contact_form", true);
      toast.success("Message sent", {
        description: "We typically reply within one business day.",
      });
    } catch {
      analytics.trackFormSubmission("contact_form", false);
      toast.error("Failed to send message. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <form className="mt-5 grid gap-4" onSubmit={handleSubmit} noValidate>
      <div className="grid gap-4 sm:grid-cols-2">
        <div>
          <label htmlFor="name" className="mb-1.5 block text-sm font-medium">
            Full name
          </label>
          <Input
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            placeholder="Your name"
            className={cn(errors.name && "border-destructive")}
            autoComplete="name"
          />
          {errors.name ? (
            <p className="text-destructive mt-1 text-xs">{errors.name}</p>
          ) : null}
        </div>
        <div>
          <label htmlFor="email" className="mb-1.5 block text-sm font-medium">
            Email
          </label>
          <Input
            id="email"
            name="email"
            type="email"
            value={formData.email}
            onChange={handleChange}
            placeholder="you@email.com"
            className={cn(errors.email && "border-destructive")}
            autoComplete="email"
          />
          {errors.email ? (
            <p className="text-destructive mt-1 text-xs">{errors.email}</p>
          ) : null}
        </div>
      </div>
      <div>
        <label htmlFor="phone" className="mb-1.5 block text-sm font-medium">
          Phone (optional)
        </label>
        <Input
          id="phone"
          name="phone"
          type="tel"
          value={formData.phone}
          onChange={handleChange}
          placeholder="0247140856"
          className={cn(errors.phone && "border-destructive")}
          autoComplete="tel"
        />
        {errors.phone ? (
          <p className="text-destructive mt-1 text-xs">{errors.phone}</p>
        ) : null}
      </div>
      <div>
        <label htmlFor="message" className="mb-1.5 block text-sm font-medium">
          Message
        </label>
        <Textarea
          id="message"
          name="message"
          rows={5}
          value={formData.message}
          onChange={handleChange}
          placeholder="How can we help?"
          className={cn(errors.message && "border-destructive")}
        />
        {errors.message ? (
          <p className="text-destructive mt-1 text-xs">{errors.message}</p>
        ) : null}
      </div>
      <Button
        type="submit"
        className="h-11 rounded-xl sm:w-fit"
        disabled={isSubmitting}
      >
        {isSubmitting ? "Sending…" : "Send message"}
      </Button>
    </form>
  );
}
