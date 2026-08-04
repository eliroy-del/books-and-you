import { z } from "zod";

/** Ghana mobile / landline style numbers: 024…, +233…, or 233… */
export function validateGhanaPhone(phone: string): boolean {
  const digits = phone.replace(/\D/g, "");
  if (digits.startsWith("233")) {
    return digits.length === 12 && /^233[2-5]\d{8}$/.test(digits);
  }
  if (digits.startsWith("0")) {
    return digits.length === 10 && /^0[2-5]\d{8}$/.test(digits);
  }
  if (digits.length === 9) {
    return /^[2-5]\d{8}$/.test(digits);
  }
  return false;
}

const personName = z
  .string()
  .trim()
  .min(2, "Name must be at least 2 characters")
  .max(100, "Name must be less than 100 characters")
  .regex(
    /^[a-zA-Z\s\-'.]+$/,
    "Name can only contain letters, spaces, hyphens, apostrophes and dots"
  );

const emailField = z
  .string()
  .trim()
  .email("Please enter a valid email address")
  .max(254, "Email must be less than 254 characters")
  .transform((v) => v.toLowerCase());

export const contactFormSchema = z.object({
  name: personName,
  email: emailField,
  phone: z
    .string()
    .trim()
    .max(20, "Phone number must be less than 20 characters")
    .refine((val) => !val || validateGhanaPhone(val), {
      message: "Please enter a valid Ghana phone number (e.g. 0247140856 or +233247140856)",
    })
    .optional()
    .or(z.literal("")),
  message: z
    .string()
    .trim()
    .min(10, "Message must be at least 10 characters")
    .max(2000, "Message must be less than 2000 characters"),
});

export type ContactFormData = z.infer<typeof contactFormSchema>;

export const newsletterSchema = z.object({
  email: emailField,
});

export type NewsletterData = z.infer<typeof newsletterSchema>;

export const authCredentialsSchema = z.object({
  email: emailField,
  password: z
    .string()
    .min(6, "Password must be at least 6 characters")
    .max(128, "Password must be less than 128 characters"),
  fullName: personName.optional(),
});

export type AuthCredentialsData = z.infer<typeof authCredentialsSchema>;

const GHANA_REGIONS = [
  "Greater Accra",
  "Ashanti",
  "Western",
  "Central",
  "Eastern",
  "Volta",
  "Northern",
  "Upper East",
  "Upper West",
  "Bono",
  "Bono East",
  "Ahafo",
  "Western North",
  "Oti",
  "North East",
  "Savannah",
] as const;

export const checkoutLineSchema = z.object({
  bookId: z.string().uuid("Invalid book id"),
  format: z.enum(["hardcover", "paperback", "ebook", "audiobook"]),
  quantity: z.number().int().min(1).max(99),
  unitPrice: z.number().positive().max(100000),
  title: z.string().trim().min(1).max(300),
});

export const checkoutSchema = z.object({
  provider: z.enum(["moolre"]).default("moolre"),
  paymentMethod: z.enum(["momo", "card"]).optional(),
  customerName: personName,
  phone: z
    .string()
    .trim()
    .min(9, "A valid phone number is required")
    .max(20)
    .refine(validateGhanaPhone, {
      message: "Please enter a valid Ghana phone number",
    }),
  email: z
    .string()
    .trim()
    .email("Email looks invalid")
    .max(254)
    .transform((v) => v.toLowerCase())
    .optional()
    .or(z.literal("")),
  shippingAddress: z.object({
    fullName: personName.optional(),
    line1: z.string().trim().min(2, "Street address is required").max(200),
    city: z.string().trim().min(2, "City / town is required").max(100),
    region: z.string().trim().min(2).max(100).default("Greater Accra"),
    country: z.string().trim().max(80).default("Ghana"),
    phone: z.string().trim().max(20).optional(),
    email: z.string().trim().email().max(254).optional().or(z.literal("")),
  }),
  lines: z.array(checkoutLineSchema).min(1, "Cart is empty").max(50),
  couponCode: z.string().trim().max(40).optional(),
  discountCedis: z.number().min(0).max(100000).optional(),
  autoCapture: z.boolean().optional(),
});

export type CheckoutData = z.infer<typeof checkoutSchema>;

export { GHANA_REGIONS };

export function getFirstError(error: z.ZodError): string {
  return error.issues[0]?.message || "Validation failed";
}

export function getFieldErrors(error: z.ZodError): Record<string, string> {
  const errors: Record<string, string> = {};
  for (const issue of error.issues) {
    const path = issue.path.join(".");
    if (!errors[path]) errors[path] = issue.message;
  }
  return errors;
}
