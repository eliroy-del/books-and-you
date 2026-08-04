import Link from "next/link";
import { Facebook, Instagram, Phone } from "lucide-react";
import { siteConfig } from "@/data/mock";

const phoneDisplay = "0247140856";
const phoneHref = "tel:0247140856";

export function AnnouncementBar() {
  return (
    <div className="bg-primary text-primary-foreground relative overflow-hidden">
      <div className="absolute inset-0 opacity-20 editorial-grid" />
      <div className="relative mx-auto flex h-10 max-w-7xl items-center justify-between gap-4 px-4 text-xs font-medium tracking-wide sm:px-6 sm:text-sm lg:px-8">
        <a
          href={phoneHref}
          className="inline-flex items-center gap-2 transition hover:opacity-90"
          aria-label={`Call ${phoneDisplay}`}
        >
          <Phone className="size-3.5 shrink-0" aria-hidden />
          <span>{phoneDisplay}</span>
        </a>

        <div className="flex items-center gap-3">
          <Link
            href={siteConfig.social.facebook}
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Facebook"
            className="inline-flex size-7 items-center justify-center rounded-full transition hover:bg-white/10"
          >
            <Facebook className="size-3.5" />
          </Link>
          <Link
            href={siteConfig.social.instagram}
            target="_blank"
            rel="noopener noreferrer"
            aria-label="Instagram"
            className="inline-flex size-7 items-center justify-center rounded-full transition hover:bg-white/10"
          >
            <Instagram className="size-3.5" />
          </Link>
        </div>
      </div>
    </div>
  );
}
