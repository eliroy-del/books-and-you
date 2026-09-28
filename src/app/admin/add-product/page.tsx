"use client";

import Link from "next/link";
import { useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AdminPageHeader, AdminPanel } from "@/components/admin/admin-ui";
import type { CoverDraft } from "@/lib/catalog/identify-cover";

const emptyDraft: CoverDraft = {
  title: "",
  subtitle: "",
  description: "",
  authors: [],
  publisher: "",
  categorySlugs: [],
  language: "English",
};

export default function AddProductPage() {
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState("");
  const [price, setPrice] = useState("");
  const [draft, setDraft] = useState<CoverDraft>(emptyDraft);
  const [identifying, setIdentifying] = useState(false);
  const [publishing, setPublishing] = useState(false);
  const [publishedSlug, setPublishedSlug] = useState("");

  function onFile(next: File | null) {
    setFile(next);
    setPublishedSlug("");
    setPreview(next ? URL.createObjectURL(next) : "");
  }

  async function identify() {
    if (!file) {
      toast.error("Choose a product image first.");
      return;
    }
    setIdentifying(true);
    try {
      const body = new FormData();
      body.set("image", file);
      const res = await fetch("/api/admin/products/identify", { method: "POST", body });
      const json = await res.json();
      if (!json.ok) throw new Error(json.error || "Identification failed");
      setDraft(json.draft as CoverDraft);
      toast.success("Details filled from the cover. Review them before publishing.");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Identification failed");
    } finally {
      setIdentifying(false);
    }
  }

  async function publish(event: React.FormEvent) {
    event.preventDefault();
    if (!file) {
      toast.error("Choose a product image first.");
      return;
    }
    setPublishing(true);
    try {
      const body = new FormData();
      body.set("image", file);
      body.set("title", draft.title);
      body.set("subtitle", draft.subtitle);
      body.set("description", draft.description);
      body.set("authors", draft.authors.join("\n"));
      body.set("publisher", draft.publisher);
      body.set("categorySlugs", draft.categorySlugs.join(","));
      body.set("language", draft.language);
      body.set("price", price);
      const res = await fetch("/api/admin/products", { method: "POST", body });
      const json = await res.json();
      if (!json.ok) throw new Error(json.error || "Publish failed");
      setPublishedSlug(json.slug);
      toast.success("Product is live on the store.");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Publish failed");
    } finally {
      setPublishing(false);
    }
  }

  return (
    <div>
      <AdminPageHeader
        title="Add product"
        description="Upload a cover, set the price, and let AI read the title, authors, and categories."
        action={
          <Button variant="outline" asChild>
            <Link href="/admin/books">Back to books</Link>
          </Button>
        }
      />
      <form onSubmit={publish} className="grid gap-6 lg:grid-cols-[280px_1fr]">
        <AdminPanel>
          <Label htmlFor="cover">Product image</Label>
          <Input
            id="cover"
            type="file"
            accept="image/jpeg,image/png,image/webp"
            className="mt-2"
            onChange={(event) => onFile(event.target.files?.[0] || null)}
          />
          {preview ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={preview} alt="Selected cover" className="mt-4 w-full rounded-lg border" />
          ) : null}
          <Button
            type="button"
            variant="secondary"
            className="mt-4 w-full"
            disabled={!file || identifying}
            onClick={identify}
          >
            {identifying ? "Reading cover…" : "Identify with AI"}
          </Button>
        </AdminPanel>

        <AdminPanel>
          <div className="grid gap-4">
            <div>
              <Label htmlFor="price">Price (GH₵)</Label>
              <Input
                id="price"
                inputMode="decimal"
                value={price}
                onChange={(event) => setPrice(event.target.value)}
                placeholder="70"
                className="mt-2"
                required
              />
            </div>
            <div>
              <Label htmlFor="title">Title</Label>
              <Input
                id="title"
                value={draft.title}
                onChange={(event) => setDraft({ ...draft, title: event.target.value })}
                className="mt-2"
                required
              />
            </div>
            <div>
              <Label htmlFor="subtitle">Subtitle</Label>
              <Input
                id="subtitle"
                value={draft.subtitle}
                onChange={(event) => setDraft({ ...draft, subtitle: event.target.value })}
                className="mt-2"
              />
            </div>
            <div>
              <Label htmlFor="authors">Authors (one per line)</Label>
              <textarea
                id="authors"
                value={draft.authors.join("\n")}
                onChange={(event) =>
                  setDraft({
                    ...draft,
                    authors: event.target.value.split("\n"),
                  })
                }
                className="border-input mt-2 min-h-20 w-full rounded-lg border bg-transparent px-3 py-2 text-sm"
              />
            </div>
            <div>
              <Label htmlFor="publisher">Publisher</Label>
              <Input
                id="publisher"
                value={draft.publisher}
                onChange={(event) => setDraft({ ...draft, publisher: event.target.value })}
                className="mt-2"
              />
            </div>
            <div>
              <Label htmlFor="categories">Category slugs (comma separated)</Label>
              <Input
                id="categories"
                value={draft.categorySlugs.join(", ")}
                onChange={(event) =>
                  setDraft({
                    ...draft,
                    categorySlugs: event.target.value
                      .split(",")
                      .map((slug) => slug.trim())
                      .filter(Boolean),
                  })
                }
                className="mt-2"
                placeholder="primary-school, primary-english-language, level-primary-5"
              />
            </div>
            <div>
              <Label htmlFor="description">Description</Label>
              <textarea
                id="description"
                value={draft.description}
                onChange={(event) => setDraft({ ...draft, description: event.target.value })}
                className="border-input mt-2 min-h-28 w-full rounded-lg border bg-transparent px-3 py-2 text-sm"
              />
            </div>
            <Button type="submit" disabled={publishing}>
              {publishing ? "Publishing…" : "Publish product"}
            </Button>
            {publishedSlug ? (
              <Link className="text-primary text-sm underline" href={`/book/${publishedSlug}`}>
                View live product
              </Link>
            ) : null}
          </div>
        </AdminPanel>
      </form>
    </div>
  );
}
