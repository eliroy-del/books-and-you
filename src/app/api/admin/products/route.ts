import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import {
  assertImage,
  MAX_PRODUCT_IMAGES,
  type CoverDraft,
} from "@/lib/catalog/identify-cover";
import { publishProduct } from "@/lib/catalog/publish-product";

export const runtime = "nodejs";

function collectImageFiles(form: FormData): File[] {
  const fromList = form.getAll("images").filter((value): value is File => value instanceof File);
  if (fromList.length) return fromList;
  const single = form.get("image");
  return single instanceof File ? [single] : [];
}

export async function POST(request: Request) {
  const auth = await requireAdmin("catalog.write");
  if ("error" in auth) return auth.error;

  try {
    const form = await request.formData();
    const files = collectImageFiles(form);
    if (!files.length) {
      return NextResponse.json({ ok: false, error: "Choose a product image." }, { status: 400 });
    }
    if (files.length > MAX_PRODUCT_IMAGES) {
      return NextResponse.json(
        { ok: false, error: `You can add up to ${MAX_PRODUCT_IMAGES} images.` },
        { status: 400 }
      );
    }
    for (const file of files) assertImage(file);

    const authors = String(form.get("authors") || "")
      .split("\n")
      .map((name) => name.trim())
      .filter(Boolean);
    const categorySlugs = String(form.get("categorySlugs") || "")
      .split(",")
      .map((slug) => slug.trim())
      .filter(Boolean);
    const draft: CoverDraft = {
      title: String(form.get("title") || "").trim(),
      subtitle: String(form.get("subtitle") || "").trim(),
      description: String(form.get("description") || "").trim(),
      authors,
      publisher: String(form.get("publisher") || "").trim(),
      categorySlugs,
      language: String(form.get("language") || "English").trim() || "English",
    };
    const priceCedis = Number(form.get("price"));
    const images = await Promise.all(
      files.map(async (file) => ({
        bytes: Buffer.from(await file.arrayBuffer()),
        mime: file.type,
      }))
    );
    const product = await publishProduct({
      draft,
      priceCedis,
      images,
    });

    return NextResponse.json({ ok: true, ...product });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Could not publish this product.";
    return NextResponse.json({ ok: false, error: message }, { status: 400 });
  }
}
