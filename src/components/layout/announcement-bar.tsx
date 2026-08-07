import Link from "next/link";
import { Phone } from "lucide-react";
import { siteConfig } from "@/data/mock";

const phoneDisplay = "0247140856";
const phoneHref = "tel:0247140856";

function FacebookIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className={className} aria-hidden>
      <path d="M14 13.5h2.5l1-4H14v-2c0-1.03 0-2 2-2h1.5V2.14C17.17 2.09 16.02 2 14.79 2 12.06 2 10 3.72 10 7.05V9.5H7.5v4H10V22h4v-8.5z" />
    </svg>
  );
}

function InstagramIcon({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" fill="currentColor" className={className} aria-hidden>
      <path d="M7.5 2h9A5.5 5.5 0 0 1 22 7.5v9a5.5 5.5 0 0 1-5.5 5.5h-9A5.5 5.5 0 0 1 2 16.5v-9A5.5 5.5 0 0 1 7.5 2zm0 2A3.5 3.5 0 0 0 4 7.5v9A3.5 3.5 0 0 0 7.5 20h9a3.5 3.5 0 0 0 3.5-3.5v-9A3.5 3.5 0 0 0 16.5 4h-9zm9.25 1.75a1 1 0 1 1 0 2 1 1 0 0 1 0-2zM12 7a5 5 0 1 1 0 10 5 5 0 0 1 0-10zm0 2a3 3 0 1 0 0 6 3 3 0 0 0 0-6z" />
    </svg>
  );
}

export function AnnouncementBar() {
  return (
    <div className="bg-primary text-primary-foreground relative overflow-hidden">
      <div className="absolute inset-0 opacity-20 editorial-grid" />
      <div className="relative mx-auto flex h-10 max-w-7xl items-center justify-start gap-4 px-4 text-xs font-medium tracking-wide sm:px-6 sm:text-sm lg:px-8">
        <a
          href={phoneHref}
          className="inline-flex items-center gap-2 transition hover:opacity-90"
          aria-label={`Call ${phoneDisplay}`}
        >
          <Phone className="size-3.5 shrink-0" aria-hidden />
          <span>{phoneDisplay}</span>
        </a>

        <div className="ml-auto flex items-center gap-1">
          <Link
            href={siteConfig.social.facebook}
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Facebook"
            className="inline-flex size-8 items-center justify-center rounded-full transition hover:bg-white/10"
          >
            <FacebookIcon className="size-3.5" />
          </Link>
          <Link
            href={siteConfig.social.instagram}
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Instagram"
            className="inline-flex size-8 items-center justify-center rounded-full transition hover:bg-white/10"
          >
            <InstagramIcon className="size-3.5" />
          </Link>
        </div>
      </div>
    </div>
  );
}
