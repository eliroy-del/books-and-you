"use client";

import Link from "next/link";
import { Heart, ShoppingBag, Star } from "lucide-react";
import { motion } from "framer-motion";
import { BookCover } from "@/components/books/book-cover";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { formatMoney, lowestPrice } from "@/data/mock";
import { useCartStore, useWishlistStore } from "@/stores/commerce";
import type { Book } from "@/types";
import { cn } from "@/lib/utils";

interface BookCardProps {
  book: Book;
  index?: number;
  className?: string;
}

export function BookCard({ book, index = 0, className }: BookCardProps) {
  const addItem = useCartStore((s) => s.addItem);
  const toggleRemote = useWishlistStore((s) => s.toggleRemote);
  const wished = useWishlistStore((s) => s.bookIds.includes(book.id));
  const defaultFormat = book.formats.find((f) => f.inStock > 0)?.format ?? book.formats[0]!.format;

  return (
    <motion.article
      initial={{ opacity: 0, y: 16 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-40px" }}
      transition={{ duration: 0.4, delay: Math.min(index * 0.05, 0.3) }}
      className={cn("group flex flex-col", className)}
    >
      <div className="relative">
        <Link href={`/book/${book.slug}`} className="block">
          <BookCover
            book={book}
            size="md"
            className="w-full transition-transform duration-500 group-hover:-translate-y-1 group-hover:shadow-glow"
          />
        </Link>
        <div className="absolute top-2 left-2 flex flex-col gap-1">
          {book.bestseller && (
            <Badge className="bg-gold text-gold-foreground border-0 text-[10px]">
              Bestseller
            </Badge>
          )}
          {book.newArrival && (
            <Badge className="bg-primary text-primary-foreground border-0 text-[10px]">
              New
            </Badge>
          )}
          {book.preorder && (
            <Badge variant="secondary" className="text-[10px]">
              Pre-order
            </Badge>
          )}
        </div>
        <Button
          size="icon"
          variant="secondary"
          className={cn(
            "absolute top-2 right-2 size-8 rounded-full opacity-0 shadow-soft transition-opacity group-hover:opacity-100",
            wished && "opacity-100 text-destructive"
          )}
          aria-label={wished ? "Remove from wishlist" : "Add to wishlist"}
          onClick={() => void toggleRemote(book.id)}
        >
          <Heart className={cn("size-3.5", wished && "fill-current")} />
        </Button>
      </div>

      <div className="mt-3 flex flex-1 flex-col gap-1.5">
        <Link href={`/book/${book.slug}`} className="space-y-0.5">
          <h3 className="font-heading text-sm leading-snug font-semibold transition-colors group-hover:text-primary">
            {book.title}
          </h3>
          <p className="text-muted-foreground text-xs">{book.authorName}</p>
        </Link>
        <div className="text-muted-foreground flex items-center gap-1 text-xs">
          <Star className="size-3 fill-gold text-gold" />
          <span className="text-foreground font-medium">{book.rating.toFixed(1)}</span>
          <span>({book.reviewCount})</span>
        </div>
        <div className="mt-auto flex items-center justify-between pt-2">
          <p className="font-heading text-sm font-semibold">
            {formatMoney(lowestPrice(book))}
          </p>
          <Button
            size="icon"
            variant="outline"
            className="size-8 rounded-full"
            aria-label={`Add ${book.title} to cart`}
            onClick={() => addItem(book.id, defaultFormat)}
          >
            <ShoppingBag className="size-3.5" />
          </Button>
        </div>
      </div>
    </motion.article>
  );
}
