import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin/guard";
import { assertImage, identifyCover } from "@/lib/catalog/identify-cover";
import { createServiceClient } from "@/lib/supabase/admin";

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

    const supabase = createServiceClient();
    const { data: categories, error } = await supabase
      .from("categories")
      .select("slug, name")
      .order("name");
    if (error) throw new Error(error.message);

    const bytes = Buffer.from(await file.arrayBuffer());
    const draft = await identifyCover({
      bytes,
      mime: file.type,
      categories: (categories || []).map((c) => ({
        slug: String(c.slug),
        name: String(c.name),
      })),
    });

    return NextResponse.json({ ok: true, draft });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Could not identify this cover.";
    return NextResponse.json({ ok: false, error: message }, { status: 400 });
  }
}
