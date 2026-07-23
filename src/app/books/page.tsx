import { Suspense } from "react";
import BooksClient from "./books-client";
import { Skeleton } from "@/components/ui/skeleton";

export const metadata = {
  title: "Books",
};

export default function Page() {
  return (
    <Suspense
      fallback={
        <div className="mx-auto max-w-7xl space-y-6 px-4 py-10">
          <Skeleton className="h-10 w-64" />
          <Skeleton className="h-12 w-full max-w-xl" />
          <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
            {Array.from({ length: 8 }).map((_, i) => (
              <Skeleton key={i} className="aspect-[2/3] w-full rounded-lg" />
            ))}
          </div>
        </div>
      }
    >
      <BooksClient />
    </Suspense>
  );
}
