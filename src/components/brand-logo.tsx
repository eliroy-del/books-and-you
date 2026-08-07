import Image from "next/image";
import Link from "next/link";
import { cn } from "@/lib/utils";

type BrandLogoProps = {
  /** Pass `null` to render without a link */
  href?: string | null;
  showWordmark?: boolean;
  size?: "sm" | "md" | "lg";
  className?: string;
  wordmarkClassName?: string;
  /** Inverse for dark backgrounds (footer) */
  tone?: "default" | "inverse";
  priority?: boolean;
};

/** Horizontal lockup heights; width follows the logo aspect ratio. */
const sizes = {
  sm: { height: "h-9 sm:h-10", pxH: 40, pxW: 164 },
  md: { height: "h-12", pxH: 48, pxW: 197 },
  lg: { height: "h-16", pxH: 64, pxW: 263 },
};

export function BrandLogo({
  href = "/",
  showWordmark = false,
  size = "sm",
  className,
  wordmarkClassName,
  tone = "default",
  priority = false,
}: BrandLogoProps) {
  const dim = sizes[size];
  const logoSrc = tone === "inverse" ? "/brand/logo-white.png" : "/brand/logo.png";

  const mark = (
    <span
      className={cn(
        "relative inline-flex shrink-0 items-center overflow-hidden rounded-md",
        dim.height,
        className
      )}
    >
      <Image
        src={logoSrc}
        alt="Books & You"
        width={dim.pxW}
        height={dim.pxH}
        className={cn("h-full w-auto object-contain object-left", dim.height)}
        priority={priority}
      />
    </span>
  );

  const content = (
    <>
      {mark}
      {showWordmark ? (
        <span
          className={cn(
            "font-heading text-lg font-bold tracking-tight",
            tone === "inverse" && "text-white",
            wordmarkClassName
          )}
        >
          Books{" "}
          <span className={tone === "inverse" ? "text-gold" : "text-primary"}>
            &
          </span>{" "}
          You
        </span>
      ) : null}
    </>
  );

  if (href === null) {
    return <span className="inline-flex items-center gap-2.5">{content}</span>;
  }

  return (
    <Link href={href ?? "/"} className="group inline-flex items-center gap-2.5">
      {content}
    </Link>
  );
}
