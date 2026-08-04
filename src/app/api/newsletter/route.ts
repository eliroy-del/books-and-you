import { z } from "zod";
import { newsletterSchema, getFieldErrors } from "@/lib/validation";
import { sanitizeEmail } from "@/lib/sanitize";
import { corsPreflight, jsonWithCors } from "@/lib/security/cors";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";

export async function OPTIONS(request: Request) {
  return corsPreflight(request);
}

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`newsletter:${ip}`, { limit: 10, windowMs: 60_000 });
    if (!limited.ok) {
      return jsonWithCors(
        request,
        { success: false, error: "Too many attempts. Please try again shortly." },
        { status: 429 }
      );
    }

    const body = await request.json();
    const validationResult = newsletterSchema.safeParse(body);

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

    const email = sanitizeEmail(validationResult.data.email);
    console.info("[newsletter:subscribe]", email);

    return jsonWithCors(request, {
      success: true,
      message: "Subscribed successfully",
    });
  } catch (error) {
    console.error("Newsletter API error:", error);
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
      { success: false, error: "Failed to subscribe. Please try again." },
      { status: 500 }
    );
  }
}
