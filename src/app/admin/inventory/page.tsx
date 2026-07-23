import { Suspense } from "react";
import AdminInventoryPage from "./inventory-client";

export default function Page() {
  return (
    <Suspense fallback={<p className="text-muted-foreground text-sm">Loading inventory…</p>}>
      <AdminInventoryPage />
    </Suspense>
  );
}
