import type { Metadata } from "next";
import Link from "next/link";
import {
  BookOpen,
  CircleHelp,
  Mail,
  MessageCircle,
  MessageSquare,
  Phone,
  Ticket,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { JsonLd } from "@/components/structured-data";
import { siteConfig } from "@/data/mock";
import { siteName, siteUrl } from "@/lib/seo";
import { buildBreadcrumbs, buildFAQSchema } from "@/lib/structured-data";

export const metadata: Metadata = {
  title: "Support",
  description:
    "Help with delivery, eBooks, refunds, and orders at Books & You. FAQs and ways to reach our Accra team.",
  alternates: { canonical: "/support" },
  openGraph: {
    title: `Support · ${siteName}`,
    description: "FAQs and contact options for Books & You customers.",
    url: `${siteUrl}/support`,
    type: "website",
  },
};

const faqs = [
  {
    q: "How long does delivery take in Accra?",
    a: "Most Accra orders arrive in 1–2 business days. Same-day options appear at checkout when available.",
  },
  {
    q: "Can I read eBooks immediately?",
    a: "Yes. Digital purchases appear in your Library as soon as payment confirms.",
  },
  {
    q: "How do refunds work?",
    a: "Physical books in resaleable condition can be returned within 14 days. Ebooks are refundable within 48 hours if unread.",
  },
  {
    q: "Do you ship internationally?",
    a: "Yes, international shipping rates are calculated at checkout. Ghana remains our primary focus.",
  },
];

export default function SupportPage() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <JsonLd
        data={[
          buildFAQSchema(
            faqs.map((f) => ({ question: f.q, answer: f.a }))
          ),
          buildBreadcrumbs([
            { name: "Home", path: "/" },
            { name: "Support" },
          ]),
        ]}
      />
      <div className="max-w-2xl">
        <p className="text-primary text-sm font-semibold tracking-widest uppercase">Help center</p>
        <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight sm:text-4xl">
          Support
        </h1>
        <p className="text-muted-foreground mt-3">
          Knowledge base, tickets, live chat, WhatsApp, and email. We&apos;re here.
        </p>
      </div>

      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {[
          { icon: MessageSquare, label: "Live chat", body: "Avg. reply under 2 min" },
          { icon: Phone, label: "WhatsApp", body: siteConfig.whatsapp },
          { icon: Mail, label: "Email", body: siteConfig.supportEmail },
          { icon: CircleHelp, label: "System status", body: "All systems operational" },
        ].map((item) => (
          <div
            key={item.label}
            className="rounded-2xl border border-border/70 bg-card p-5 shadow-soft"
          >
            <item.icon className="text-primary size-5" />
            <p className="font-heading mt-3 font-semibold">{item.label}</p>
            <p className="text-muted-foreground mt-1 text-sm">{item.body}</p>
          </div>
        ))}
      </div>

      <div className="mt-12 grid gap-10 lg:grid-cols-12">
        <section className="lg:col-span-7">
          <h2 className="font-heading text-xl font-semibold">FAQ</h2>
          <div className="mt-5 space-y-3">
            {faqs.map((faq) => (
              <details
                key={faq.q}
                className="group rounded-2xl border border-border/70 bg-card p-5 shadow-soft"
              >
                <summary className="font-medium cursor-pointer list-none flex items-center justify-between gap-3">
                  {faq.q}
                  <CircleHelp className="text-muted-foreground size-4 shrink-0" />
                </summary>
                <p className="text-muted-foreground mt-3 text-sm leading-relaxed">{faq.a}</p>
              </details>
            ))}
          </div>

          <div className="mt-8 rounded-2xl border border-border/70 bg-secondary/40 p-5">
            <div className="flex items-center gap-2">
              <BookOpen className="text-primary size-4" />
              <h3 className="font-heading font-semibold">Knowledge base</h3>
            </div>
            <ul className="text-muted-foreground mt-3 space-y-2 text-sm">
              <li>
                <Link href="/orders" className="hover:text-primary">
                  Tracking your shipment
                </Link>
              </li>
              <li>
                <Link href="/library" className="hover:text-primary">
                  Using your digital library
                </Link>
              </li>
              <li>
                <Link href="/blog" className="hover:text-primary">
                  Reading tips on the blog
                </Link>
              </li>
            </ul>
          </div>
        </section>

        <section className="lg:col-span-5">
          <div className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <div className="flex items-center gap-2">
              <Ticket className="text-primary size-4" />
              <h2 className="font-heading text-lg font-semibold">Open a ticket</h2>
            </div>
            <form className="mt-5 space-y-4" action="#">
              <Input placeholder="Subject" required />
              <Input type="email" placeholder="Email" defaultValue="ama.darko@email.com" />
              <Textarea placeholder="How can we help?" rows={5} required />
              <Button type="submit" className="w-full">
                <MessageCircle className="size-4" />
                Submit ticket
              </Button>
            </form>
            <p className="text-muted-foreground mt-3 text-xs">
              Tickets sync to the support desk in Phase 4. This form is UI-only for Phase 1.
            </p>
          </div>
        </section>
      </div>
    </div>
  );
}
