import Link from "next/link";
import { AtSign, Globe2, Share2 } from "lucide-react";
import { BrandLogo } from "@/components/brand-logo";
import { categories, siteConfig } from "@/data/mock";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function SiteFooter() {
  return (
    <footer className="border-t border-border/60 bg-[#0B1220] text-slate-200">
      <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 lg:px-8">
        <div className="grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-4">
            <BrandLogo href="/" size="md" showWordmark={false} />
            <p className="mt-4 max-w-sm text-sm leading-relaxed text-slate-400">
              A premium bookstore for curious minds—discover, purchase, and build a library
              you&apos;ll love.
            </p>
            <div className="mt-6 flex gap-3">
              {[Share2, Globe2, AtSign].map((Icon, i) => (
                <a
                  key={i}
                  href="#"
                  className="flex size-9 items-center justify-center rounded-full border border-white/10 text-slate-300 transition hover:border-teal-500/50 hover:text-teal-300"
                  aria-label="Social link"
                >
                  <Icon className="size-4" />
                </a>
              ))}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-8 sm:grid-cols-3 lg:col-span-5">
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Categories</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                {categories.slice(0, 6).map((c) => (
                  <li key={c.id}>
                    <Link href={`/categories?c=${c.slug}`} className="hover:text-teal-300">
                      {c.name}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Help</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                <li>
                  <Link href="/support" className="hover:text-teal-300">
                    Support Center
                  </Link>
                </li>
                <li>
                  <Link href="/orders" className="hover:text-teal-300">
                    Track Orders
                  </Link>
                </li>
                <li>
                  <Link href="/blog" className="hover:text-teal-300">
                    Blog
                  </Link>
                </li>
                <li>
                  <a href={`mailto:${siteConfig.supportEmail}`} className="hover:text-teal-300">
                    Email Us
                  </a>
                </li>
              </ul>
            </div>
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Company</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                <li>
                  <Link href="/contact" className="hover:text-teal-300">
                    Contact Us
                  </Link>
                </li>
                <li>
                  <Link href="/auth" className="hover:text-teal-300">
                    Sign In
                  </Link>
                </li>
                <li>
                  <Link href="/dashboard" className="hover:text-teal-300">
                    Dashboard
                  </Link>
                </li>
                <li>
                  <span className="cursor-default">Privacy</span>
                </li>
                <li>
                  <span className="cursor-default">Terms</span>
                </li>
              </ul>
            </div>
          </div>

          <div className="lg:col-span-3">
            <h3 className="font-heading text-sm font-semibold text-white">Newsletter</h3>
            <p className="mt-3 text-sm text-slate-400">
              New releases, discounts, and author events—once a week.
            </p>
            <form className="mt-4 flex gap-2" action="#">
              <Input
                type="email"
                required
                placeholder="you@email.com"
                className="border-white/10 bg-white/5 text-white placeholder:text-slate-500"
              />
              <Button type="submit" className="shrink-0 bg-teal-600 hover:bg-teal-500">
                Join
              </Button>
            </form>
          </div>
        </div>

        <div className="mt-14 flex flex-col gap-3 border-t border-white/10 pt-8 text-xs text-slate-500 sm:flex-row sm:items-center sm:justify-between">
          <p>© {new Date().getFullYear()} {siteConfig.name}. All rights reserved.</p>
          <p>Made for readers in Ghana — shipping worldwide.</p>
        </div>
      </div>
    </footer>
  );
}
