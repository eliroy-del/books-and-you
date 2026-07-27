"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { SmartSearch } from "@/components/search/smart-search";

export function HeaderSearch() {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    setOpen(false);
  }, [pathname]);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger
        render={
          <Button variant="ghost" size="icon" className="size-11" aria-label="Search books" />
        }
      >
        <Search className="size-5" />
      </DialogTrigger>
      <DialogContent
        showCloseButton={false}
        className="top-[16%] translate-y-0 gap-0 overflow-visible p-4 sm:max-w-xl"
      >
        <DialogHeader className="sr-only">
          <DialogTitle>Search books</DialogTitle>
        </DialogHeader>
        {open ? <SmartSearch autoFocus /> : null}
      </DialogContent>
    </Dialog>
  );
}
