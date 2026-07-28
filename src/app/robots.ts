import type { MetadataRoute } from "next";
import { PRODUCTION_SITE_URL, siteUrl } from "@/lib/seo";

function publicHost() {
  if (/localhost|127\.0\.0\.1/.test(siteUrl)) {
    return PRODUCTION_SITE_URL;
  }
  return siteUrl;
}

export default function robots(): MetadataRoute.Robots {
  const host = publicHost();
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: [
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
        ],
      },
    ],
    sitemap: `${host}/sitemap.xml`,
    host,
  };
}
