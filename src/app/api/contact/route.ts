import { z } from "zod";
import { contactFormSchema, getFieldErrors } from "@/lib/validation";
import { sanitize, sanitizeEmail, sanitizePhone } from "@/lib/sanitize";
import { corsPreflight, jsonWithCors } from "@/lib/security/cors";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";
import { sendEmail } from "@/lib/services/email";

export async function OPTIONS(request: Request) {
  return corsPreflight(request);
}

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`contact:${ip}`, { limit: 8, windowMs: 60_000 });
    if (!limited.ok) {
      return jsonWithCors(
        request,
        { success: false, error: "Too many messages. Please try again shortly." },
        { status: 429 }
      );
    }

    const body = await request.json();
    const validationResult = contactFormSchema.safeParse(body);

    if (!validationResult.success) {
      return jsonWithCors(
        request,
        {
          success: false,
          error: "Validation failed",
          errors: getFieldErrors(validationResult.error),
        },
        { status: 400 }
      );
    }

    const formData = {
      name: sanitize(validationResult.data.name),
      email: sanitizeEmail(validationResult.data.email),
      phone: sanitizePhone(validationResult.data.phone || ""),
      message: sanitize(validationResult.data.message),
    };

    const to = process.env.ADMIN_EMAIL || process.env.RESEND_FROM_EMAIL || "";
    if (to) {
      await sendEmail({
        to,
        subject: `Contact form: ${formData.name}`,
        text: `From: ${formData.name} <${formData.email}>\nPhone: ${formData.phone || "-"}\n\n${formData.message}`,
        html: `<p><strong>From:</strong> ${formData.name} &lt;${formData.email}&gt;</p>
          <p><strong>Phone:</strong> ${formData.phone || "-"}</p>
          <p>${formData.message.replace(/\n/g, "<br/>")}</p>`,
        tags: [{ name: "type", value: "contact" }],
      });
    } else {
      console.info("[contact]", formData);
    }

    return jsonWithCors(request, {
      success: true,
      message: "Message submitted successfully",
    });
  } catch (error) {
    console.error("Contact API error:", error);
    if (error instanceof z.ZodError) {
      return jsonWithCors(
        request,
        {
          success: false,
          error: "Validation failed",
          errors: getFieldErrors(error),
        },
        { status: 400 }
      );
    }
    return jsonWithCors(
      request,
      { success: false, error: "Failed to submit message. Please try again." },
      { status: 500 }
    );
  }
}
