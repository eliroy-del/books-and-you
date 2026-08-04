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

/** Letters (incl. accented / Unicode), spaces, hyphens, apostrophes, dots. */
const personName = z
  .string()
  .trim()
  .min(2, "Name must be at least 2 characters")
  .max(100, "Name must be less than 100 characters")
  .regex(
    /^[\p{L}\s\-'.]+$/u,
    "Name can only contain letters, spaces, hyphens, apostrophes and dots"
  );

const emailField = z
  .string()
  .trim()
  .email("Please enter a valid email address")
  .max(254, "Email must be less than 254 characters")
  .transform((v) => v.toLowerCase());

const passwordField = z
  .string()
  .min(6, "Password must be at least 6 characters")
  .max(128, "Password must be less than 128 characters");

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

export const signInSchema = z.object({
  email: emailField,
  password: passwordField,
});

export type SignInData = z.infer<typeof signInSchema>;

export const signUpSchema = z.object({
  fullName: personName,
  email: emailField,
  password: passwordField,
});

export type SignUpData = z.infer<typeof signUpSchema>;

/** @deprecated Prefer signInSchema / signUpSchema */
export const authCredentialsSchema = z.object({
  email: emailField,
  password: passwordField,
  fullName: personName.optional(),
});

export type AuthCredentialsData = z.infer<typeof authCredentialsSchema>;

export const GHANA_REGIONS = [
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

export type GhanaRegion = (typeof GHANA_REGIONS)[number];

const ghanaPhoneRequired = z
  .string()
  .trim()
  .min(9, "A valid phone number is required")
  .max(20, "Phone number must be less than 20 characters")
  .refine(validateGhanaPhone, {
    message: "Please enter a valid Ghana phone number (e.g. 0247140856 or +233247140856)",
  });

const optionalEmail = z.union([
  z.literal(""),
  emailField,
]);

const streetAddress = z
  .string()
  .trim()
  .min(2, "Street address is required")
  .max(200, "Street address must be less than 200 characters");

const cityTown = z
  .string()
  .trim()
  .min(2, "City / town is required")
  .max(100, "City / town must be less than 100 characters")
  .regex(
    /^[a-zA-Z0-9\s\-'.]+$/,
    "City can only contain letters, numbers, spaces, hyphens, apostrophes and dots"
  );

const ghanaRegion = z.enum(GHANA_REGIONS, {
  message: "Please select a valid Ghana region",
});

/** Customer-facing "Your details" fields on checkout (guest or create-account). */
export const checkoutDetailsSchema = z.object({
  fullName: personName,
  phone: ghanaPhoneRequired,
  email: optionalEmail,
  password: z
    .string()
    .max(128, "Password must be less than 128 characters")
    .optional()
    .or(z.literal("")),
  line1: streetAddress,
  city: cityTown,
  region: ghanaRegion,
});

export type CheckoutDetailsData = z.infer<typeof checkoutDetailsSchema>;

export function checkoutDetailsSchemaForMode(
  mode: "guest" | "account",
  hasUser: boolean
) {
  return checkoutDetailsSchema.superRefine((data, ctx) => {
    if (mode === "account" && !hasUser) {
      if (!data.email?.trim()) {
        ctx.addIssue({
          code: "custom",
          path: ["email"],
          message: "Email is required to create an account",
        });
      }
      if (!data.password || data.password.length < 6) {
        ctx.addIssue({
          code: "custom",
          path: ["password"],
          message: "Password must be at least 6 characters",
        });
      }
    }
  });
}

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
  phone: ghanaPhoneRequired,
  email: optionalEmail,
  shippingAddress: z.object({
    fullName: personName.optional(),
    line1: streetAddress,
    city: cityTown,
    region: ghanaRegion.default("Greater Accra"),
    country: z.string().trim().max(80).default("Ghana"),
    phone: z.string().trim().max(20).optional(),
    email: optionalEmail,
  }),
  lines: z.array(checkoutLineSchema).min(1, "Cart is empty").max(50),
  couponCode: z.string().trim().max(40).optional(),
  discountCedis: z.number().min(0).max(100000).optional(),
  autoCapture: z.boolean().optional(),
});

export type CheckoutData = z.infer<typeof checkoutSchema>;

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
