import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function NotFound() {
  return (
    <div className="mx-auto flex max-w-lg flex-col items-center px-4 py-24 text-center">
      <p className="text-primary text-sm font-semibold tracking-widest uppercase">404</p>
      <h1 className="font-heading mt-2 text-3xl font-bold">Page not found</h1>
      <p className="text-muted-foreground mt-3 text-sm">
        That shelf is empty. Try searching the catalog instead.
      </p>
      <Button className="mt-8" asChild>
        <Link href="/books">Browse books</Link>
      </Button>
    </div>
  );
}
