import { siteConfig } from "@/data/mock";
import { PRODUCTION_SITE_URL, siteDescription, siteName, siteUrl } from "@/lib/seo";

export type JsonLdObject = Record<string, unknown>;

/** Absolute public site URL for schema (never localhost). */
export function schemaBaseUrl() {
  if (/localhost|127\.0\.0\.1/.test(siteUrl)) return PRODUCTION_SITE_URL;
  return siteUrl;
}

export function buildBreadcrumbs(
  crumbs: { name: string; path?: string }[],
  baseUrl: string = schemaBaseUrl()
) {
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: crumbs.map((crumb, index) => ({
      "@type": "ListItem",
      position: index + 1,
      name: crumb.name,
      ...(crumb.path
        ? { item: crumb.path.startsWith("http") ? crumb.path : `${baseUrl}${crumb.path}` }
        : {}),
    })),
  };
}

export function buildFAQSchema(faqs: { question: string; answer: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((faq) => ({
      "@type": "Question",
      name: faq.question,
      acceptedAnswer: { "@type": "Answer", text: faq.answer },
    })),
  };
}

/** E.164-ish Ghana phone for schema telephone fields. */
export function schemaTelephone(raw: string = siteConfig.supportPhone) {
  const digits = raw.replace(/\D/g, "");
  if (digits.startsWith("233") && digits.length === 12) return `+${digits}`;
  if (digits.startsWith("0") && digits.length === 10) return `+233${digits.slice(1)}`;
  if (digits.length === 9) return `+233${digits}`;
  return raw.startsWith("+") ? raw : `+${digits || raw}`;
}

export function organizationSchema(): JsonLdObject {
  const base = schemaBaseUrl();
  const { address, social, supportEmail } = siteConfig;
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: siteName,
    legalName: "Books & You",
    url: base,
    logo: `${base}/brand/logo.png`,
    description: siteDescription,
    email: supportEmail,
    telephone: schemaTelephone(),
    address: {
      "@type": "PostalAddress",
      streetAddress: address.line1,
      addressLocality: "Greater Accra",
      addressCountry: "GH",
    },
    areaServed: {
      "@type": "Country",
      name: "Ghana",
    },
    sameAs: [social.facebook, social.instagram].filter(
      (u) => u && !u.endsWith("facebook.com/") && !u.endsWith("instagram.com/")
    ),
    contactPoint: {
      "@type": "ContactPoint",
      contactType: "customer service",
      telephone: schemaTelephone(),
      email: supportEmail,
      areaServed: "GH",
      availableLanguage: ["en"],
      url: `${base}/contact`,
    },
  };
}

export function websiteSchema(): JsonLdObject {
  const base = schemaBaseUrl();
  return {
    "@context": "https://schema.org",
    "@type": "WebSite",
    name: siteName,
    url: base,
    description: siteDescription,
    inLanguage: "en",
    publisher: { "@type": "Organization", name: siteName, url: base },
    potentialAction: {
      "@type": "SearchAction",
      target: {
        "@type": "EntryPoint",
        urlTemplate: `${base}/books?q={search_term_string}`,
      },
      "query-input": "required name=search_term_string",
    },
  };
}

export function bookstoreSchema(): JsonLdObject {
  const base = schemaBaseUrl();
  const { address, maps, supportEmail } = siteConfig;
  return {
    "@context": "https://schema.org",
    "@type": "Bookstore",
    name: siteName,
    url: base,
    image: `${base}/og.png`,
    email: supportEmail,
    telephone: schemaTelephone(),
    priceRange: "GH₵",
    address: {
      "@type": "PostalAddress",
      streetAddress: address.line1,
      addressLocality: "Greater Accra",
      addressCountry: "GH",
    },
    geo: {
      "@type": "GeoCoordinates",
      latitude: maps.lat,
      longitude: maps.lng,
    },
    openingHoursSpecification: [
      {
        "@type": "OpeningHoursSpecification",
        dayOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        opens: "06:00",
        closes: "17:00",
      },
    ],
  };
}

export function bookProductSchema(input: {
  name: string;
  description: string;
  url: string;
  image?: string | null;
  authorName?: string;
  rating?: number;
  reviewCount?: number;
  priceGhs?: number | null;
  currency?: string;
  availability?: "InStock" | "OutOfStock" | "PreOrder";
}): JsonLdObject {
  const offer =
    typeof input.priceGhs === "number" && input.priceGhs > 0
      ? {
          "@type": "Offer",
          url: input.url,
          price: String(input.priceGhs),
          priceCurrency: input.currency || "GHS",
          availability: `https://schema.org/${input.availability || "InStock"}`,
          seller: { "@type": "Organization", name: siteName },
        }
      : undefined;

  return {
    "@context": "https://schema.org",
    "@type": "Book",
    name: input.name,
    description: input.description.slice(0, 500),
    url: input.url,
    ...(input.image ? { image: input.image } : {}),
    ...(input.authorName
      ? { author: { "@type": "Person", name: input.authorName } }
      : {}),
    ...(input.rating && input.reviewCount
      ? {
          aggregateRating: {
            "@type": "AggregateRating",
            ratingValue: input.rating,
            reviewCount: input.reviewCount,
            bestRating: 5,
          },
        }
      : {}),
    ...(offer ? { offers: offer } : {}),
  };
}

export function blogPostingSchema(input: {
  headline: string;
  description: string;
  url: string;
  datePublished: string;
  dateModified?: string;
  authorName: string;
  image?: string;
}): JsonLdObject {
  const base = schemaBaseUrl();
  const published = input.datePublished.includes("T")
    ? input.datePublished
    : `${input.datePublished}T08:00:00+00:00`;
  return {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: input.headline,
    description: input.description,
    datePublished: published,
    dateModified: input.dateModified || published,
    author: { "@type": "Organization", name: input.authorName, url: base },
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": input.url,
    },
    publisher: {
      "@type": "Organization",
      name: siteName,
      logo: { "@type": "ImageObject", url: `${base}/brand/logo.png` },
    },
    ...(input.image ? { image: input.image } : {}),
  };
}
