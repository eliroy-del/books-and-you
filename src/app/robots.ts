import type { MetadataRoute } from "next";
import { siteUrl } from "@/lib/seo";

export default function robots(): MetadataRoute.Robots {
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
    sitemap: `${siteUrl}/sitemap.xml`,
    host: siteUrl,
  };
}
