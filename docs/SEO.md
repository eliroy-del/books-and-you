# SEO — Books & You

This document contains (1) the reusable "God-level SEO" master prompt for this website and (2) a record of what is already implemented in the codebase.

---

## Part 1 — God-Level SEO Master Prompt

Copy-paste this prompt to any AI agent or engineer when doing SEO work on Books & You:

```
You are a world-class technical SEO engineer working on "Books & You" — a premium
Next.js (App Router) bookstore at ${NEXT_PUBLIC_SITE_URL}, backed by Supabase.
Your job is to make every page maximally discoverable, shareable, and rich-result
eligible, without hurting Core Web Vitals. Follow these rules exactly.

## 1. Metadata foundation
- Every route must resolve a unique <title> (55–60 chars) and meta description
  (140–160 chars) via the Metadata API. Use the root template "%s · Books & You".
- Always set metadataBase from NEXT_PUBLIC_SITE_URL. Never hardcode domains.
- Every indexable page gets a self-referencing canonical URL. Pages with query
  params (filters, sorts, pagination) canonicalize to the clean base URL.
- Dynamic routes (books, authors, categories) must use generateMetadata that
  fetches real data from Supabase, with a mock-data fallback so builds never fail.

## 2. Open Graph + Twitter
- Every page ships og:title, og:description, og:url, og:site_name, og:type
  (website for index pages, book for book detail pages) and og:image (1200×630).
- Twitter card is summary_large_image everywhere.
- Book pages: title format "{Book Title} by {Author} · Books & You".
- Use the App Router file conventions (opengraph-image.png / twitter-image.png)
  for defaults; consider dynamic OG image generation (next/og ImageResponse)
  per book, rendering the gradient cover, title, author, and rating.

## 3. Structured data (JSON-LD)
- Site-wide: Organization (name, url, logo) and WebSite with SearchAction
  targeting /books?q={search_term_string}.
- Book pages: Book schema with name, author (Person), description, and
  AggregateRating (only when reviewCount > 0). Add Offer with price, currency
  (GHS), and availability when the buy box renders server-side.
- Category/author listing pages: BreadcrumbList.
- Never emit empty or placeholder values — omit fields you can't populate.

## 4. Crawling and indexing
- robots.txt: allow all storefront routes; disallow /api, /admin, /superadmin,
  /dashboard, /checkout, /cart, /orders, /library, /wishlist, /auth.
- sitemap.xml: dynamically generated; includes home, /books, /categories,
  /authors, /blog, all book slugs, all author slugs, category-filtered
  listing URLs. Use lastModified from updated_at when available; revalidate hourly.
- Private/transactional pages additionally get robots noindex metadata.
- Submit sitemap to Google Search Console and Bing Webmaster Tools after deploy.

## 5. Icons and PWA
- Provide icon.png (512×512), apple-icon.png (180×180), favicon.ico, and a
  web app manifest with theme_color matching the brand (navy #0B1220 / teal
  #0F766E). All icons derive from the official "B" book emblem.

## 6. Performance = ranking
- Keep LCP < 2.5s, CLS < 0.1, INP < 200ms. Fonts via next/font (already done),
  images via next/image with explicit sizes, no layout-shifting banners.
- Prefer server components for indexable content: crawlers must see book
  titles, descriptions, and prices in the initial HTML, not after client fetch.
  When a page is client-rendered, at minimum server-render the metadata and
  JSON-LD (the pattern used in /book/[slug]/page.tsx).

## 7. Content rules
- One <h1> per page containing the primary keyword (book title, category name).
- Descriptive link text ("View all fiction books", never "click here").
- alt text on every image: "{Book title} book cover — Books & You".
- Breadcrumbs visible on detail pages, mirrored in BreadcrumbList JSON-LD.

## 8. Verification checklist (run after every SEO change)
- `npm run build` passes with no metadata warnings.
- /sitemap.xml and /robots.txt return 200 and validate.
- Facebook Sharing Debugger, Twitter Card Validator, and LinkedIn Post
  Inspector all render the correct card for / and one /book/{slug} URL.
- Google Rich Results Test passes for Organization, WebSite, and Book schema.
- Lighthouse SEO score ≥ 95.
```

---

## Part 2 — What is implemented

| Item | Location |
| --- | --- |
| Root metadata (title template, description, keywords, robots, canonical) | `src/app/layout.tsx` |
| Open Graph + Twitter card defaults | `src/app/layout.tsx` + `src/app/opengraph-image.png`, `src/app/twitter-image.png` |
| Favicon / app icons | `src/app/favicon.ico`, `src/app/icon.png` (512), `src/app/apple-icon.png` (180) |
| Social share image (1200-wide brand banner) | `src/app/opengraph-image.png`, also `public/og.png` |
| Dynamic sitemap (books, authors, categories from Supabase with mock fallback) | `src/app/sitemap.ts` → `/sitemap.xml` |
| Robots rules (blocks admin/api/account routes) | `src/app/robots.ts` → `/robots.txt` |
| PWA web manifest | `src/app/manifest.ts` → `/manifest.webmanifest` |
| JSON-LD: Organization + WebSite (SearchAction) | `src/app/layout.tsx` |
| JSON-LD: Book + AggregateRating, per-book generateMetadata | `src/app/book/[slug]/page.tsx` |
| Shared SEO constants (siteUrl, name, description, keywords) | `src/lib/seo.ts` |

### Production reminders
- Set `NEXT_PUBLIC_SITE_URL=https://booksandyou.shop` in Vercel — the sitemap, canonicals, and OG URLs all derive from it.
- After deploy: submit `https://booksandyou.shop/sitemap.xml` in Google Search Console, and validate a book URL in the Facebook Sharing Debugger.
- Update the `creator: "@booksandyou"` Twitter handle in `src/app/layout.tsx` if the real handle differs.
