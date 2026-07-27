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

const sizes = {
  sm: { box: "size-9", px: 36 },
  md: { box: "size-12", px: 48 },
  lg: { box: "size-16", px: 64 },
};

export function BrandLogo({
  href = "/",
  showWordmark = true,
  size = "sm",
  className,
  wordmarkClassName,
  tone = "default",
  priority = false,
}: BrandLogoProps) {
  const dim = sizes[size];

  const mark = (
    <span
      className={cn(
        "relative inline-flex shrink-0 overflow-hidden rounded-xl bg-black shadow-soft ring-1 ring-black/20",
        dim.box,
        className
      )}
    >
      <Image
        src="/brand/logo.png"
        alt="Books & You"
        width={dim.px}
        height={dim.px}
        className="object-contain p-0.5"
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
          <span className={tone === "inverse" ? "text-teal-400" : "text-primary"}>
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
