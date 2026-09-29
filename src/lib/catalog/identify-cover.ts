export type CoverDraft = {
  title: string;
  subtitle: string;
  description: string;
  authors: string[];
  publisher: string;
  categorySlugs: string[];
  language: string;
};

const ALLOWED_MIME = new Set(["image/jpeg", "image/png", "image/webp"]);

export const MAX_PRODUCT_IMAGES = 8;

export function slugify(value: string) {
  return value
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 80);
}

export function assertImage(file: File) {
  if (!ALLOWED_MIME.has(file.type)) {
    throw new Error("Use a JPG, PNG, or WebP image.");
  }
  if (file.size > 6 * 1024 * 1024) {
    throw new Error("Image must be 6 MB or smaller.");
  }
}

export function imageExtension(mime: string) {
  if (mime === "image/png") return "png";
  if (mime === "image/webp") return "webp";
  return "jpg";
}

function parseDraft(raw: unknown, allowed: Set<string>): CoverDraft {
  const row = raw && typeof raw === "object" ? (raw as Record<string, unknown>) : {};
  const authors = Array.isArray(row.authors)
    ? row.authors.map((a) => String(a).trim()).filter(Boolean).slice(0, 6)
    : [];
  const categorySlugs = Array.isArray(row.categorySlugs)
    ? row.categorySlugs.map((s) => String(s).trim()).filter((s) => allowed.has(s))
    : [];
  return {
    title: String(row.title || "").trim(),
    subtitle: String(row.subtitle || "").trim(),
    description: String(row.description || "").trim(),
    authors,
    publisher: String(row.publisher || "").trim(),
    categorySlugs,
    language: String(row.language || "English").trim() || "English",
  };
}

function extractJson(text: string) {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  const body = fenced?.[1] || text;
  const start = body.indexOf("{");
  const end = body.lastIndexOf("}");
  if (start < 0 || end < start) throw new Error("The model did not return product details.");
  return JSON.parse(body.slice(start, end + 1)) as unknown;
}

async function identifyWithGemini(
  key: string,
  bytes: Buffer,
  mime: string,
  categories: { slug: string; name: string }[]
) {
  const prompt = `You catalogue products for a Ghana school bookstore (textbooks and stationery).
Read the cover image and return JSON only:
{
  "title": "",
  "subtitle": "",
  "description": "2 sentences for a product page",
  "authors": ["names printed on the cover, else []"],
  "publisher": "imprint or distributor printed on the cover, else empty",
  "categorySlugs": ["only slugs from the list"],
  "language": "English"
}
Pick every matching category slug, including school level (level-primary-1 …) and subject when the cover shows them.
Categories:
${categories.map((c) => `${c.slug} (${c.name})`).join("\n")}`;

  const res = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${encodeURIComponent(key)}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              { text: prompt },
              { inline_data: { mime_type: mime, data: bytes.toString("base64") } },
            ],
          },
        ],
        generationConfig: { temperature: 0.2 },
      }),
    }
  );
  const json = (await res.json()) as {
    error?: { message?: string };
    candidates?: { content?: { parts?: { text?: string }[] } }[];
  };
  if (!res.ok) throw new Error(json.error?.message || "Gemini request failed");
  const text = json.candidates?.[0]?.content?.parts?.map((p) => p.text || "").join("\n") || "";
  return extractJson(text);
}

async function identifyWithOpenAI(
  key: string,
  bytes: Buffer,
  mime: string,
  categories: { slug: string; name: string }[]
) {
  const prompt = `You catalogue products for a Ghana school bookstore (textbooks and stationery).
Read the cover and return JSON only with keys title, subtitle, description, authors, publisher, categorySlugs, language.
authors is an array of names printed on the cover.
categorySlugs must be chosen only from: ${categories.map((c) => c.slug).join(", ")}.
Include level and subject slugs when the cover shows them. description is two sentences.`;

  const res = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-4o-mini",
      temperature: 0.2,
      messages: [
        {
          role: "user",
          content: [
            { type: "text", text: prompt },
            {
              type: "image_url",
              image_url: { url: `data:${mime};base64,${bytes.toString("base64")}` },
            },
          ],
        },
      ],
    }),
  });
  const json = (await res.json()) as {
    error?: { message?: string };
    choices?: { message?: { content?: string } }[];
  };
  if (!res.ok) throw new Error(json.error?.message || "OpenAI request failed");
  return extractJson(json.choices?.[0]?.message?.content || "");
}

export function aiProviderConfigured() {
  return Boolean(
    process.env.GEMINI_API_KEY ||
      process.env.GOOGLE_GENERATIVE_AI_API_KEY ||
      process.env.OPENAI_API_KEY
  );
}

export async function identifyCover(input: {
  bytes: Buffer;
  mime: string;
  categories: { slug: string; name: string }[];
}): Promise<CoverDraft> {
  const allowed = new Set(input.categories.map((c) => c.slug));
  const gemini = process.env.GEMINI_API_KEY || process.env.GOOGLE_GENERATIVE_AI_API_KEY;
  const openai = process.env.OPENAI_API_KEY;
  if (!gemini && !openai) {
    throw new Error(
      "Add GEMINI_API_KEY or OPENAI_API_KEY on the server to identify covers."
    );
  }
  const raw = gemini
    ? await identifyWithGemini(gemini, input.bytes, input.mime, input.categories)
    : await identifyWithOpenAI(openai!, input.bytes, input.mime, input.categories);
  const draft = parseDraft(raw, allowed);
  if (!draft.title) throw new Error("The cover could not be read. Enter the title yourself.");
  return draft;
}
