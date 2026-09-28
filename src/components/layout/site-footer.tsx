import Link from "next/link";
import { BrandLogo } from "@/components/brand-logo";
import { CookieSettingsButton } from "@/components/CookieConsentBanner";
import { siteConfig } from "@/data/mock";
import { catalogNav, departmentHref, featuredCollectionDefs } from "@/data/catalog-nav";
import { NewsletterForm } from "@/components/forms/newsletter-form";

export function SiteFooter() {
  return (
    <footer className="border-t border-border/60 bg-[#001f3e] text-slate-200">
      <div className="mx-auto max-w-site px-4 py-10 sm:px-6 lg:px-8">
        <div className="grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-4">
            <BrandLogo href="/" size="sm" showWordmark={false} tone="inverse" />
            <p className="mt-4 max-w-sm text-sm leading-relaxed text-slate-400">
              Ghana&apos;s school bookstore for textbooks, stationery, and classroom essentials from
              Nursery through SHS.
            </p>
            <div className="mt-6 flex gap-3">
              <a
                href={siteConfig.social.facebook}
                target="_blank"
                rel="noopener noreferrer"
                aria-label="Facebook"
                className="flex size-9 items-center justify-center rounded-full border border-white/10 text-slate-300 transition hover:border-gold/60 hover:text-gold"
              >
                <svg viewBox="0 0 24 24" fill="currentColor" className="size-4" aria-hidden>
                  <path d="M14 13.5h2.5l1-4H14v-2c0-1.03 0-2 2-2h1.5V2.14C17.17 2.09 16.02 2 14.79 2 12.06 2 10 3.72 10 7.05V9.5H7.5v4H10V22h4v-8.5z" />
                </svg>
              </a>
              <a
                href={siteConfig.social.instagram}
                target="_blank"
                rel="noopener noreferrer"
                aria-label="Instagram"
                className="flex size-9 items-center justify-center rounded-full border border-white/10 text-slate-300 transition hover:border-gold/60 hover:text-gold"
              >
                <svg viewBox="0 0 24 24" fill="currentColor" className="size-4" aria-hidden>
                  <path d="M7.5 2h9A5.5 5.5 0 0 1 22 7.5v9a5.5 5.5 0 0 1-5.5 5.5h-9A5.5 5.5 0 0 1 2 16.5v-9A5.5 5.5 0 0 1 7.5 2zm0 2A3.5 3.5 0 0 0 4 7.5v9A3.5 3.5 0 0 0 7.5 20h9a3.5 3.5 0 0 0 3.5-3.5v-9A3.5 3.5 0 0 0 16.5 4h-9zm9.25 1.75a1 1 0 1 1 0 2 1 1 0 0 1 0-2zM12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6z" />
                </svg>
              </a>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-8 sm:grid-cols-3 lg:col-span-5">
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Shop</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                {catalogNav.slice(0, 6).map((d) => (
                  <li key={d.slug}>
                    <Link href={departmentHref(d.slug)} className="hover:text-gold">
                      {d.name}
                    </Link>
                  </li>
                ))}
                <li>
                  <Link href={`/books?collection=${featuredCollectionDefs[3]?.slug}`} className="hover:text-gold">
                    Back to School
                  </Link>
                </li>
              </ul>
            </div>
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Help</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                <li>
                  <Link href="/support" className="hover:text-gold">
                    Support Center
                  </Link>
                </li>
                <li>
                  <Link href="/orders" className="hover:text-gold">
                    Track Orders
                  </Link>
                </li>
                <li>
                  <Link href="/blog" className="hover:text-gold">
                    Blog
                  </Link>
                </li>
                <li>
                  <a href={`mailto:${siteConfig.supportEmail}`} className="hover:text-gold">
                    Email Us
                  </a>
                </li>
              </ul>
            </div>
            <div>
              <h3 className="font-heading text-sm font-semibold text-white">Company</h3>
              <ul className="mt-4 space-y-2.5 text-sm text-slate-400">
                <li>
                  <Link href="/contact" className="hover:text-gold">
                    Contact Us
                  </Link>
                </li>
                <li>
                  <span className="cursor-default">Privacy</span>
                </li>
                <li>
                  <span className="cursor-default">Terms</span>
                </li>
                <li>
                  <CookieSettingsButton className="hover:text-gold" />
                </li>
              </ul>
            </div>
          </div>

          <div className="lg:col-span-3">
            <h3 className="font-heading text-sm font-semibold text-white">Newsletter</h3>
            <p className="mt-3 text-sm text-slate-400">
              New releases, discounts, and author events, once a week.
            </p>
            <NewsletterForm
              className="mt-4"
              inputClassName="border-white/10 bg-white/5 text-white placeholder:text-slate-500"
              buttonClassName="bg-gold text-gold-foreground hover:bg-[#e8b86d]"
            />
          </div>
        </div>

        <div className="mt-14 flex flex-col gap-3 border-t border-white/10 pt-8 text-xs text-slate-500 sm:flex-row sm:items-center sm:justify-between">
          <p>© {new Date().getFullYear()} {siteConfig.name}. All rights reserved.</p>
          <p>
            Powered By{" "}
            <a
              href="https://www.solveek.com"
              target="_blank"
              rel="noopener noreferrer"
              className="text-slate-400 transition hover:text-gold"
            >
              Solveek
            </a>
          </p>
        </div>
      </div>
    </footer>
  );
}
