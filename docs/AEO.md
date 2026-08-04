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

## Seeing what AI actually searches (query fan-out)

ChatGPT does not search your exact prompt. It expands it into many synthetic sub-queries (**fan-out**). Reading those queries is a **topic coverage checklist**, not a keyword list to rank for.

### How to capture ChatGPT fan-out (Chrome / Edge / Brave / Firefox — not Safari)

1. Open [chatgpt.com](https://chatgpt.com) → DevTools → **Network**.
2. Ask a live-search prompt, e.g.  
   `Search the web: best place to buy GES school textbooks online in Accra Ghana 2026`
3. Ignore reading only the `conversation` stream handoff.
4. Global search in DevTools: **Cmd+Option+F** (Mac) / **Ctrl+Shift+F** → search `search_model_queries`.
5. Copy the `metadata.search_model_queries.queries` array. That is the fan-out.
6. Run the same prompt 2–3 times; keep **patterns**, not one literal string.

### Claude

Claude often shows search queries in the UI. In network traffic look for `web_search` / `server_tool_use` → `input.query`.

### Money prompts to run for Books & You

Paste these into ChatGPT with “search the web” and capture fan-out:

1. Best online bookstore for school textbooks in Accra Ghana
2. Where to buy GES Primary and JHS textbooks online with delivery in Accra
3. Buy SHS textbooks and stationery online Ghana Mobile Money
4. RME Excellence Learner’s Book Ghana where to buy
5. Books & You bookstore Accra delivery hours contact
6. Guest checkout school books Ghana without account

### Topic coverage map (seed checklist)

Use this until you replace cells with real fan-out from DevTools. Optimize for **topics**, not exact query strings.

| Topic the model often looks for | Covered on site? | Best URL |
| --- | --- | --- |
| Online textbook shop Ghana / Accra | Partial (brand pages) | `/`, `/books` |
| Browse by school level (Nursery–SHS) | Yes | `/categories` |
| GES / standards-based / NaCCA-style books | Partial (blog + catalog) | `/blog/inside-ghana-school-textbooks-parents-should-know`, `/books` |
| Stationery / classroom supplies | Yes (nav) | `/categories`, `/books` |
| Accra delivery speed | Yes (FAQ) | `/support` |
| Nationwide shipping | Yes (FAQ) | `/support` |
| Mobile Money / card payment | Weak → strengthen FAQ | `/support`, `/checkout` (noindex) |
| Guest checkout (no account) | Weak → strengthen FAQ | `/support` |
| Refunds / returns | Yes | `/support` |
| Shop address / hours / phone | Yes | `/contact` |
| Specific title (e.g. RME Excellence Book 2) | Yes when in catalog | `/book/{slug}` |
| Reading habits / African lit / formats | Yes (blog) | `/blog` |

### What to do after you capture fan-out

1. Group queries into **themes** (delivery, payments, curriculum, levels, competitors).
2. Mark themes missing from the table above.
3. Fill gaps with **visible** FAQ answers, category copy, or a focused blog post — citeable HTML, not thin keyword pages.
4. Re-run the prompt later; expect different strings, same themes.

## Next developer tracks

1. ~~Seeing what AI searches~~ — method + money prompts above.
2. **Technical AEO** — keep HTML citeable; avoid soft-404s and blocked bots.
3. **Writing structure that gets cited** — Q&A, lists, clear H2s on blog/support.
4. **Measuring AI visibility** — track referral/UTM traces from AI products where available.

## Mental model reminders

- Optimize for **topic coverage**, not one keyword page.
- Aim for **cited**, **mentioned**, or at least **in the conversation**.
- Platforms differ: strong Google SEO helps AI Overviews / Perplexity more than ChatGPT alone.
