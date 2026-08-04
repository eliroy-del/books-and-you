# AEO Foundations (Books & You)

Answer Engine Optimization sits **on top of** SEO. AI systems cite from training data and live web retrieval (RAG); citations are probabilistic, not fixed rankings.

## What we control in code

| Lever | Status on this site |
| --- | --- |
| Real HTML for crawlers (Next.js SSR/SSG) | Yes — not an empty SPA shell |
| Unique titles, descriptions, canonicals | Yes on public routes |
| `robots.txt` allows AI crawlers on public pages | Yes — explicit GPTBot, ClaudeBot, PerplexityBot, Google-Extended, etc. |
| Private routes blocked | Yes — cart, checkout, auth, admin, API |
| `llms.txt` brand summary for AI agents | Yes — `/llms.txt` |
| Structured data (Organization, Book, FAQ, Article) | Yes — JSON-LD helpers |
| Sitemap of public URLs | Yes — `/sitemap.xml` |

## Strategy work (not automated here)

Brand mentions, outreach, YouTube/Reddit presence, and prompt tracking need marketing effort (e.g. Ahrefs Brand Radar). Code cannot replace consensus and freshness across the web.

## Next developer tracks

1. **Seeing what AI searches** — inspect fan-out queries in the browser.
2. **Technical AEO** — keep HTML citeable; avoid soft-404s and blocked bots.
3. **Writing structure that gets cited** — Q&A, lists, clear H2s on blog/support.
4. **Measuring AI visibility** — track referral/UTM traces from AI products where available.

## Mental model reminders

- Optimize for **topic coverage**, not one keyword page.
- Aim for **cited**, **mentioned**, or at least **in the conversation**.
- Platforms differ: strong Google SEO helps AI Overviews / Perplexity more than ChatGPT alone.
