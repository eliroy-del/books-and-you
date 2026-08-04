import {
  organizationSchema,
  websiteSchema,
  type JsonLdObject,
} from "@/lib/structured-data";

/** Server-rendered JSON-LD script. Data must be developer-controlled (no raw user HTML). */
export function JsonLd({ data }: { data: JsonLdObject | JsonLdObject[] }) {
  const payload = Array.isArray(data)
    ? {
        "@context": "https://schema.org",
        "@graph": data.map((item) => {
          const { "@context": _ctx, ...rest } = item;
          return rest;
        }),
      }
    : data;

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(payload) }}
    />
  );
}

/** Global Organization + WebSite schemas for every page (root layout). */
export function GlobalStructuredData() {
  return <JsonLd data={[organizationSchema(), websiteSchema()]} />;
}
