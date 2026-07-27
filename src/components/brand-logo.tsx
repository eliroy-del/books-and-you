import Image from "next/image";
import Link from "next/link";
import { cn } from "@/lib/utils";

type BrandLogoProps = {
  className?: string;
  href?: string | null;
  /** Visual size of the full wordmark */
  size?: "sm" | "md" | "lg";
  priority?: boolean;
};

const heights = {
  sm: 28,
  md: 36,
  lg: 48,
} as const;

export function BrandLogo({
  className,
  href = "/",
  size = "md",
  priority = false,
}: BrandLogoProps) {
  const height = heights[size];
  const width = Math.round(height * (520 / 140));

  const mark = (
    <Image
      src="/brand/logo.png"
      alt="Books & You"
      width={width}
      height={height}
      priority={priority}
      className={cn("h-auto w-auto object-contain", className)}
      style={{ height, width: "auto" }}
    />
  );

  if (href === null) return mark;

  return (
    <Link href={href} className="inline-flex shrink-0 items-center" aria-label="Books & You home">
      {mark}
    </Link>
  );
}
