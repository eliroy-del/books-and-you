"use client";

import type { ReactNode } from "react";
import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { AdminPageHeader, AdminPanel, AdminTable } from "@/components/admin/admin-ui";

const RESOURCE_META: Record<
  string,
  {
    title: string;
    description: string;
    headers: string[];
    mapRow: (row: Record<string, unknown>) => ReactNode[];
  }
> = {
  books: {
    title: "Books",
    description: "Catalog titles and formats.",
    headers: ["Title", "Author", "Formats", "Price", "Rating"],
    mapRow: (r) => [
      String(r.title),
      String(r.authors),
      String(r.formats),
      String(r.priceLabel),
      String(r.rating),
    ],
  },
  authors: {
    title: "Authors",
    description: "Author roster and book counts.",
    headers: ["Name", "Nationality", "Books"],
    mapRow: (r) => [String(r.name), String(r.nationality), String(r.bookCount)],
  },
  publishers: {
    title: "Publishers",
    description: "Publisher partners.",
    headers: ["Name", "Country", "Books"],
    mapRow: (r) => [String(r.name), String(r.country), String(r.bookCount)],
  },
  categories: {
    title: "Categories",
    description: "Browse taxonomy.",
    headers: ["Name", "Slug", "Books"],
    mapRow: (r) => [String(r.name), String(r.slug), String(r.bookCount)],
  },
  customers: {
    title: "Customers",
    description: "Reader accounts overview.",
    headers: ["Name", "Email", "Orders", "Spent", "Status"],
    mapRow: (r) => [
      String(r.name),
      String(r.email),
      String(r.orders),
      String(r.spentLabel),
      <Badge key="s" variant="secondary">
        {String(r.status)}
      </Badge>,
    ],
  },
  coupons: {
    title: "Coupons",
    description: "Discount codes and usage.",
    headers: ["Code", "Type", "Value", "Uses", "Active"],
    mapRow: (r) => [
      String(r.code),
      String(r.type),
      String(r.value),
      String(r.uses),
      String(r.active ? "Yes" : "No"),
    ],
  },
  gifts: {
    title: "Gift cards",
    description: "Store credit instruments.",
    headers: ["Code", "Balance", "Status"],
    mapRow: (r) => [String(r.code), String(r.balanceLabel), String(r.status)],
  },
  reviews: {
    title: "Reviews",
    description: "Moderation queue.",
    headers: ["Book", "Reviewer", "Rating", "Excerpt"],
    mapRow: (r) => [
      String(r.book),
      String(r.author),
      String(r.rating),
      String(r.body),
    ],
  },
  support: {
    title: "Support",
    description: "Open tickets and priorities.",
    headers: ["Ticket", "Subject", "Customer", "Priority", "Status"],
    mapRow: (r) => [
      String(r.number),
      String(r.subject),
      String(r.customer),
      String(r.priority),
      String(r.status),
    ],
  },
  returns: {
    title: "Returns",
    description: "Return and refund requests.",
    headers: ["Order", "Reason", "Amount", "Status"],
    mapRow: (r) => [
      String(r.order),
      String(r.reason),
      String(r.amountLabel),
      String(r.status),
    ],
  },
  promotions: {
    title: "Promotions",
    description: "Campaign overlays.",
    headers: ["Name", "Offer", "Active"],
    mapRow: (r) => [String(r.name), String(r.discount), String(r.active ? "Yes" : "No")],
  },
  audit: {
    title: "Audit logs",
    description: "Immutable staff action trail.",
    headers: ["Action", "Actor", "Entity", "Detail", "When"],
    mapRow: (r) => [
      String(r.action),
      String(r.actor),
      String(r.entity),
      String(r.detail),
      String(r.at).replace("T", " ").slice(0, 16),
    ],
  },
};

function resourceFromPath(pathname: string) {
  const part = pathname.split("/").pop() || "books";
  return part;
}

export default function AdminCatalogResourcePage() {
  const pathname = usePathname();
  const resource = resourceFromPath(pathname);
  const meta = RESOURCE_META[resource] || RESOURCE_META.books;
  const [rows, setRows] = useState<Record<string, unknown>[]>([]);
  const [error, setError] = useState("");

  useEffect(() => {
    void fetch(`/api/admin/catalog?resource=${resource}`)
      .then((r) => r.json())
      .then((json) => {
        if (json.ok) {
          setRows(json.rows);
          setError("");
        } else {
          setError(json.error || "Forbidden");
          setRows([]);
        }
      });
  }, [resource]);

  return (
    <div>
      <AdminPageHeader title={meta.title} description={meta.description} />
      <AdminPanel>
        {error ? (
          <p className="text-destructive text-sm">{error}</p>
        ) : (
          <AdminTable headers={meta.headers}>
            {rows.map((row, idx) => (
              <tr key={String(row.id || idx)}>
                {meta.mapRow(row).map((cell, i) => (
                  <td key={i} className="py-3">
                    {cell}
                  </td>
                ))}
              </tr>
            ))}
          </AdminTable>
        )}
      </AdminPanel>
    </div>
  );
}
