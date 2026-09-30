"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { Star, X } from "lucide-react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AdminPageHeader, AdminPanel } from "@/components/admin/admin-ui";
import {
  assertImage,
  MAX_PRODUCT_IMAGES,
  type CoverDraft,
} from "@/lib/catalog/identify-cover";

const emptyDraft: CoverDraft = {
  title: "",
  subtitle: "",
  description: "",
  authors: [],
  publisher: "",
  categorySlugs: [],
  language: "English",
};

type SelectedImage = {
  id: string;
  file: File;
  preview: string;
};

export default function AddProductPage() {
  const [images, setImages] = useState<SelectedImage[]>([]);
  const [price, setPrice] = useState("");
  const [draft, setDraft] = useState<CoverDraft>(emptyDraft);
  const [categoriesText, setCategoriesText] = useState("");
  const [identifying, setIdentifying] = useState(false);
  const [publishing, setPublishing] = useState(false);
  const [publishedSlug, setPublishedSlug] = useState("");
  const imagesRef = useRef<SelectedImage[]>([]);
  const cover = images[0] ?? null;
  imagesRef.current = images;

  useEffect(() => {
    return () => {
      imagesRef.current.forEach((image) => URL.revokeObjectURL(image.preview));
    };
  }, []);

  function addFiles(list: FileList | null) {
    if (!list?.length) return;
    setPublishedSlug("");
    const incoming: SelectedImage[] = [];
    for (const file of Array.from(list)) {
      try {
        assertImage(file);
        incoming.push({
          id: `${file.name}-${file.size}-${file.lastModified}-${Math.random()}`,
          file,
          preview: URL.createObjectURL(file),
        });
      } catch (error) {
        toast.error(error instanceof Error ? error.message : "Invalid image");
      }
    }
    if (!incoming.length) return;
    setImages((current) => {
      const room = MAX_PRODUCT_IMAGES - current.length;
      if (room <= 0) {
        incoming.forEach((image) => URL.revokeObjectURL(image.preview));
        toast.error(`You can add up to ${MAX_PRODUCT_IMAGES} images.`);
        return current;
      }
      const kept = incoming.slice(0, room);
      incoming.slice(room).forEach((image) => URL.revokeObjectURL(image.preview));
      if (incoming.length > room) {
        toast.error(`You can add up to ${MAX_PRODUCT_IMAGES} images.`);
      }
      return [...current, ...kept];
    });
  }

  function removeImage(id: string) {
    setImages((current) => {
      const next = current.filter((image) => image.id !== id);
      current
        .filter((image) => image.id === id)
        .forEach((image) => URL.revokeObjectURL(image.preview));
      return next;
    });
  }

  function makeCover(id: string) {
    setImages((current) => {
      const index = current.findIndex((image) => image.id === id);
      if (index <= 0) return current;
      const next = [...current];
      const [picked] = next.splice(index, 1);
      if (!picked) return current;
      return [picked, ...next];
    });
  }

  async function identify() {
    if (!cover) {
      toast.error("Choose a cover image first.");
      return;
    }
    setIdentifying(true);
    try {
      const body = new FormData();
      body.set("image", cover.file);
      const res = await fetch("/api/admin/products/identify", { method: "POST", body });
      const json = await res.json();
      if (!json.ok) throw new Error(json.error || "Identification failed");
      const next = json.draft as CoverDraft;
      setDraft(next);
      setCategoriesText(next.categorySlugs.join(", "));
      toast.success("Details filled from the cover. Review them before publishing.");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Identification failed");
    } finally {
      setIdentifying(false);
    }
  }

  async function publish(event: React.FormEvent) {
    event.preventDefault();
    if (!images.length) {
      toast.error("Choose at least one product image.");
      return;
    }
    setPublishing(true);
    try {
      const body = new FormData();
      for (const image of images) body.append("images", image.file);
      body.set("title", draft.title);
      body.set("subtitle", draft.subtitle);
      body.set("description", draft.description);
      body.set("authors", draft.authors.join("\n"));
      body.set("publisher", draft.publisher);
      body.set("categorySlugs", categoriesText);
      body.set("language", draft.language);
      body.set("price", price);
      const res = await fetch("/api/admin/products", { method: "POST", body });
      const json = await res.json();
      if (!json.ok) throw new Error(json.error || "Publish failed");
      setPublishedSlug(json.slug);
      toast.success(
        json.imageCount > 1
          ? `Product is live with ${json.imageCount} images.`
          : "Product is live on the store."
      );
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
        description="Upload a cover and extra photos, set the price, and let AI read the title, authors, and categories."
        action={
          <Button variant="outline" asChild>
            <Link href="/admin/books">Back to books</Link>
          </Button>
        }
      />
      <form onSubmit={publish} className="grid gap-6 lg:grid-cols-[320px_1fr]">
        <AdminPanel>
          <Label htmlFor="cover">Product images</Label>
          <p className="text-muted-foreground mt-1 text-xs">
            First image is the cover. Add more angles, the back, or close-ups. Up to{" "}
            {MAX_PRODUCT_IMAGES}.
          </p>
          <Input
            id="cover"
            type="file"
            accept="image/jpeg,image/png,image/webp"
            multiple
            className="mt-2"
            onChange={(event) => {
              addFiles(event.target.files);
              event.target.value = "";
            }}
          />
          {images.length ? (
            <ul className="mt-4 grid grid-cols-2 gap-2">
              {images.map((image, index) => (
                <li key={image.id} className="relative overflow-hidden rounded-lg border bg-muted">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={image.preview}
                    alt={index === 0 ? "Cover image" : `Product image ${index + 1}`}
                    className="aspect-[2/3] w-full object-cover"
                  />
                  {index === 0 ? (
                    <span className="absolute top-2 left-2 rounded-full bg-primary px-2 py-0.5 text-[10px] font-medium tracking-wide text-primary-foreground uppercase">
                      Cover
                    </span>
                  ) : (
                    <button
                      type="button"
                      onClick={() => makeCover(image.id)}
                      className="absolute top-2 left-2 inline-flex items-center gap-1 rounded-full bg-black/60 px-2 py-0.5 text-[10px] font-medium text-white hover:bg-black/75"
                    >
                      <Star className="size-3" />
                      Cover
                    </button>
                  )}
                  <button
                    type="button"
                    onClick={() => removeImage(image.id)}
                    className="absolute top-2 right-2 inline-flex size-6 items-center justify-center rounded-full bg-black/60 text-white hover:bg-black/75"
                    aria-label={`Remove image ${index + 1}`}
                  >
                    <X className="size-3.5" />
                  </button>
                </li>
              ))}
            </ul>
          ) : null}
          <p className="text-muted-foreground mt-2 text-xs">
            {images.length} of {MAX_PRODUCT_IMAGES} selected
          </p>
          <Button
            type="button"
            variant="secondary"
            className="mt-4 w-full"
            disabled={!cover || identifying}
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
                value={categoriesText}
                onChange={(event) => {
                  const text = event.target.value;
                  setCategoriesText(text);
                  setDraft({
                    ...draft,
                    categorySlugs: text
                      .split(",")
                      .map((slug) => slug.trim())
                      .filter(Boolean),
                  });
                }}
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
            <Button type="submit" disabled={publishing || !images.length}>
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
