import Image from "next/image";
import { cn } from "@/lib/utils";
import type { Book } from "@/types";

interface BookCoverProps {
  book: Pick<Book, "title" | "authorName" | "coverGradient" | "coverAccent"> & {
    coverUrl?: string | null;
  };
  className?: string;
  size?: "sm" | "md" | "lg" | "xl";
}

const sizeClasses = {
  sm: "aspect-[2/3] w-20 text-[9px]",
  md: "aspect-[2/3] w-36 text-xs",
  lg: "aspect-[2/3] w-48 text-sm",
  xl: "aspect-[2/3] w-full max-w-sm text-base",
};

export function BookCover({ book, className, size = "md" }: BookCoverProps) {
  if (book.coverUrl) {
    return (
      <div
        className={cn(
          "relative overflow-hidden rounded-lg bg-muted shadow-elevated",
          sizeClasses[size],
          className
        )}
      >
        <Image
          src={book.coverUrl}
          alt={`${book.title} cover`}
          fill
          sizes={
            size === "xl"
              ? "(max-width: 768px) 90vw, 420px"
              : size === "lg"
                ? "192px"
                : size === "md"
                  ? "144px"
                  : "80px"
          }
          className="object-cover object-center"
        />
      </div>
    );
  }

  return (
    <div
      className={cn(
        "relative overflow-hidden rounded-lg shadow-elevated",
        sizeClasses[size],
        className
      )}
      aria-hidden={false}
    >
      <div
        className={cn(
          "absolute inset-0 bg-gradient-to-br",
          book.coverGradient
        )}
      />
      <div className="absolute inset-0 opacity-30 mix-blend-overlay editorial-grid" />
      <div
        className="absolute top-0 right-0 h-full w-2.5 opacity-40"
        style={{ background: book.coverAccent }}
      />
      <div className="absolute inset-0 flex flex-col justify-between p-4 text-white">
        <div className="space-y-1">
          <p
            className="font-heading font-semibold leading-snug text-balance"
            style={{ color: book.coverAccent }}
          >
            {book.title}
          </p>
          <p className="text-[0.7em] tracking-wide text-white/75">{book.authorName}</p>
        </div>
        <div className="flex items-center justify-between">
          <span
            className="h-1 w-8 rounded-full"
            style={{ background: book.coverAccent }}
          />
          <span className="font-heading text-[0.65em] tracking-[0.2em] text-white/50 uppercase">
            B&Y
          </span>
        </div>
      </div>
    </div>
  );
}
