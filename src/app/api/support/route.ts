import { z } from "zod";
import { getFieldErrors, supportTicketSchema } from "@/lib/validation";
import { sanitize, sanitizeEmail } from "@/lib/sanitize";
import { corsPreflight, jsonWithCors } from "@/lib/security/cors";
import { clientIpFromHeaders, rateLimit } from "@/lib/security/rate-limit";
import { sendEmail } from "@/lib/services/email";
import { tryCreateClient } from "@/lib/supabase/server";
import { isSupabaseConfigured } from "@/lib/supabase/env";
import { db } from "@/lib/supabase/typed";

export async function OPTIONS(request: Request) {
  return corsPreflight(request);
}

export async function POST(request: Request) {
  try {
    const ip = clientIpFromHeaders(request.headers);
    const limited = rateLimit(`support:${ip}`, { limit: 8, windowMs: 60_000 });
    if (!limited.ok) {
      return jsonWithCors(
        request,
        { success: false, error: "Too many tickets. Please try again shortly." },
        { status: 429 }
      );
    }

    const body = await request.json();
    const validationResult = supportTicketSchema.safeParse(body);

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
      subject: sanitize(validationResult.data.subject),
      email: sanitizeEmail(validationResult.data.email),
      name: sanitize(validationResult.data.name || "") || "Reader",
      message: sanitize(validationResult.data.message),
    };

    let ticketNumber: string | undefined;

    if (isSupabaseConfigured()) {
      const sessionClient = await tryCreateClient();
      const {
        data: { user },
      } = (await sessionClient?.auth.getUser()) ?? { data: { user: null } };

      if (user && sessionClient) {
        const client = db(sessionClient);
        const { data: ticket, error } = await client
          .from("tickets")
          .insert({
            user_id: user.id,
            subject: formData.subject,
            status: "open",
            priority: "medium",
          })
          .select("id, ticket_number")
          .single();

        if (!error && ticket?.id) {
          ticketNumber = ticket.ticket_number;
          await client.from("ticket_messages").insert({
            ticket_id: ticket.id,
            sender_id: user.id,
            body: formData.message,
            is_staff: false,
          });
        }
      }
    }

    const to = process.env.ADMIN_EMAIL || process.env.RESEND_FROM_EMAIL || "";
    if (to) {
      await sendEmail({
        to,
        subject: `Support ticket: ${formData.subject}`,
        text: `From: ${formData.name} <${formData.email}>\nTicket: ${ticketNumber || "email-only"}\n\n${formData.message}`,
        html: `<p><strong>From:</strong> ${formData.name} &lt;${formData.email}&gt;</p>
          <p><strong>Subject:</strong> ${formData.subject}</p>
          <p><strong>Ticket:</strong> ${ticketNumber || "email-only"}</p>
          <p>${formData.message.replace(/\n/g, "<br/>")}</p>`,
        tags: [{ name: "type", value: "support_ticket" }],
      });
    } else {
      console.info("[support]", formData, { ticketNumber });
    }

    return jsonWithCors(request, {
      success: true,
      message: "Ticket submitted successfully",
      ticketNumber,
    });
  } catch (error) {
    console.error("Support API error:", error);
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
      { success: false, error: "Failed to submit ticket. Please try again." },
      { status: 500 }
    );
  }
}
