import type { MetadataRoute } from "next";
import { PRODUCTION_SITE_URL, siteUrl } from "@/lib/seo";

function publicHost() {
  if (/localhost|127\.0\.0\.1/.test(siteUrl)) {
    return PRODUCTION_SITE_URL;
  }
  return siteUrl;
}

/** Private / transactional paths — keep out of SEO and AI retrieval. */
const DISALLOW = [
  "/api/",
  "/admin",
  "/admin/",
  "/superadmin",
  "/superadmin/",
  "/dashboard",
  "/dashboard/",
  "/checkout",
  "/cart",
  "/orders",
  "/library",
  "/wishlist",
  "/auth",
];

/**
 * Explicit AI crawler agents (AEO). Same allow/disallow as humans so live
 * retrieval (RAG) can read public HTML; private routes stay blocked.
 */
const AI_USER_AGENTS = [
  "GPTBot",
  "ChatGPT-User",
  "OAI-SearchBot",
  "ClaudeBot",
  "anthropic-ai",
  "PerplexityBot",
  "Google-Extended",
  "Applebot-Extended",
  "Bytespider",
  "CCBot",
] as const;

export default function robots(): MetadataRoute.Robots {
  const host = publicHost();
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: DISALLOW,
      },
      ...AI_USER_AGENTS.map((userAgent) => ({
        userAgent,
        allow: "/" as const,
        disallow: DISALLOW,
      })),
    ],
    sitemap: `${host}/sitemap.xml`,
    host,
  };
}
