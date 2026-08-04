import type { Metadata } from "next";
import Link from "next/link";
import {
  Clock,
  Mail,
  MapPin,
  MessageCircle,
  Navigation,
  Phone,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { ContactForm } from "@/components/forms/contact-form";
import { JsonLd } from "@/components/structured-data";
import { siteConfig } from "@/data/mock";
import { siteName, siteUrl } from "@/lib/seo";
import { bookstoreSchema, buildBreadcrumbs } from "@/lib/structured-data";

export const metadata: Metadata = {
  title: "Contact Us",
  description:
    "Visit Books & You in Greater Accra. Open Monday–Saturday, 6:00 AM–5:00 PM. Find our shop on the map, call, email, or send a message.",
  alternates: { canonical: "/contact" },
  openGraph: {
    title: `Contact Us · ${siteName}`,
    description: "Shop hours, location map, phone, and email for Books & You.",
    url: `${siteUrl}/contact`,
    type: "website",
  },
};

export default function ContactPage() {
  const { address, hours, maps, supportEmail, supportPhone, whatsapp } = siteConfig;

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <JsonLd
        data={[
          bookstoreSchema(),
          buildBreadcrumbs([
            { name: "Home", path: "/" },
            { name: "Contact Us" },
          ]),
        ]}
      />

      <div className="mx-auto max-w-2xl text-center">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">
          Get in touch
        </p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          Contact Us
        </h1>
        <p className="text-muted-foreground mt-3">
          Visit the shop, call us, or send a message. We&apos;re here for readers,
          parents, and schools across Ghana.
        </p>
      </div>

      <div className="mt-12 grid gap-6 lg:grid-cols-12">
        <div className="grid gap-4 sm:grid-cols-2 lg:col-span-5 lg:grid-cols-1">
          <div className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft">
            <div className="flex items-start gap-3">
              <span className="bg-primary/10 text-primary flex size-10 shrink-0 items-center justify-center rounded-2xl">
                <Clock className="size-5" />
              </span>
              <div>
                <h2 className="font-heading text-lg font-semibold">Opening hours</h2>
                <p className="text-muted-foreground mt-2 text-sm">
                  {hours.weekdays}
                </p>
                <p className="mt-1 text-base font-medium">
                  {hours.open} – {hours.close}
                </p>
                <p className="text-muted-foreground mt-2 text-sm">
                  Sunday: {hours.sunday}
                </p>
              </div>
            </div>
          </div>

          <div className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft">
            <div className="flex items-start gap-3">
              <span className="bg-primary/10 text-primary flex size-10 shrink-0 items-center justify-center rounded-2xl">
                <MapPin className="size-5" />
              </span>
              <div>
                <h2 className="font-heading text-lg font-semibold">Our location</h2>
                <p className="mt-2 text-sm font-medium">{address.line1}</p>
                <p className="text-muted-foreground mt-1 text-sm">{address.line2}</p>
                <p className="text-muted-foreground text-sm">{address.city}</p>
                <Button variant="outline" size="sm" className="mt-4 rounded-xl" asChild>
                  <a href={maps.placeUrl} target="_blank" rel="noopener noreferrer">
                    <Navigation className="size-3.5" />
                    Open in Google Maps
                  </a>
                </Button>
              </div>
            </div>
          </div>

          <div className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft sm:col-span-2 lg:col-span-1">
            <h2 className="font-heading text-lg font-semibold">Reach us directly</h2>
            <ul className="mt-4 space-y-3 text-sm">
              <li>
                <a
                  href={`tel:${supportPhone.replace(/\s/g, "")}`}
                  className="hover:text-primary flex items-center gap-3"
                >
                  <Phone className="text-primary size-4 shrink-0" />
                  {supportPhone}
                </a>
              </li>
              <li>
                <a
                  href={`https://wa.me/${whatsapp.replace(/\D/g, "")}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-primary flex items-center gap-3"
                >
                  <MessageCircle className="text-primary size-4 shrink-0" />
                  WhatsApp {whatsapp}
                </a>
              </li>
              <li>
                <a
                  href={`mailto:${supportEmail}`}
                  className="hover:text-primary flex items-center gap-3"
                >
                  <Mail className="text-primary size-4 shrink-0" />
                  {supportEmail}
                </a>
              </li>
            </ul>
            <p className="text-muted-foreground mt-4 text-xs">
              Need order help? Visit our{" "}
              <Link href="/support" className="text-primary font-medium hover:underline">
                Support Center
              </Link>
              .
            </p>
          </div>
        </div>

        <div className="rounded-3xl border border-border/70 bg-card p-5 shadow-soft lg:col-span-7 sm:p-6">
          <h2 className="font-heading text-lg font-semibold">Send a message</h2>
          <p className="text-muted-foreground mt-1 text-sm">
            Tell us how we can help. We typically reply within one business day.
          </p>
          <ContactForm />
        </div>
      </div>

      <section className="mt-10 overflow-hidden rounded-3xl border border-border/70 bg-card shadow-soft">
        <div className="flex flex-col gap-2 border-b border-border/60 px-5 py-4 sm:flex-row sm:items-center sm:justify-between sm:px-6">
          <div>
            <h2 className="font-heading text-lg font-semibold">Find us on the map</h2>
            <p className="text-muted-foreground text-sm">
              Pin drop at {maps.lat.toFixed(6)}, {maps.lng.toFixed(6)}
            </p>
          </div>
          <Button variant="outline" size="sm" className="rounded-xl" asChild>
            <a href={maps.placeUrl} target="_blank" rel="noopener noreferrer">
              <MapPin className="size-3.5" />
              Get directions
            </a>
          </Button>
        </div>
        <div className="relative aspect-[16/10] w-full bg-muted sm:aspect-[21/9]">
          <iframe
            title="Books & You shop location on Google Maps"
            src={maps.embedUrl}
            className="absolute inset-0 h-full w-full border-0"
            loading="lazy"
            referrerPolicy="no-referrer-when-downgrade"
            allowFullScreen
          />
        </div>
      </section>
    </div>
  );
}
