import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import { assertImage, type CoverDraft } from "@/lib/catalog/identify-cover";
import { publishProduct } from "@/lib/catalog/publish-product";

export const runtime = "nodejs";

export async function POST(request: Request) {
  const auth = await requireAdmin("catalog.write");
  if ("error" in auth) return auth.error;

  try {
    const form = await request.formData();
    const file = form.get("image");
    if (!(file instanceof File)) {
      return NextResponse.json({ ok: false, error: "Choose a product image." }, { status: 400 });
    }
    assertImage(file);

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
    const bytes = Buffer.from(await file.arrayBuffer());
    const product = await publishProduct({
      draft,
      priceCedis,
      bytes,
      mime: file.type,
    });

    return NextResponse.json({ ok: true, ...product });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Could not publish this product.";
    return NextResponse.json({ ok: false, error: message }, { status: 400 });
  }
}
