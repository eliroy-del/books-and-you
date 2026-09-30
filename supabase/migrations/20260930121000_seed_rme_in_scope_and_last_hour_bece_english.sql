-- Catalog: RME In Scope JHS 1–3 and Last Hour BECE English JHS 1–3 at GH₵75.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('k-d-twumasi', 'K. D. Twumasi', 'Ghanaian', 'Co-author of Religious and Moral Education In Scope for junior high schools.', true),
  ('c-adade', 'C. Adade', 'Ghanaian', 'Co-author of Religious and Moral Education In Scope for junior high schools.', true),
  ('evans-gadeto-djikunu', 'Evans Gadeto Djikunu', 'Ghanaian', 'Author of Last Hour Series B.E.C.E. English for junior high schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values
  (
    'in-scope',
    'In Scope',
    'Ghana',
    'Publisher of In Scope educational titles for Ghanaian junior high schools.'
  ),
  (
    'last-hour',
    'Last Hour Series',
    'Ghana',
    'Publisher of Last Hour Series BECE revision titles for junior high schools.'
  )
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'religious-and-moral-education-in-scope-jhs-1-3',
  'Religious and Moral Education In Scope for Junior High Schools 1–3',
  'In Scope · Revised Edition',
  'Religious and Moral Education In Scope is a combined JHS 1–3 textbook covering Christianity, Islam, and African Traditional Religion. Revised edition for junior high schools.',
  'Combined In Scope RME title for junior high Form 1, 2 and 3. Revised edition.',
  '978-9988-2-7101-5',
  220,
  'English',
  '2024-01-01',
  p.id,
  '/covers/religious-and-moral-education-in-scope-jhs-1-3/front.jpg',
  'from-[#7F1D1D] via-[#60A5FA] to-[#F8FAFC]',
  '#7F1D1D',
  array['RME', 'JHS', 'Combined', 'In Scope'],
  array['Christianity', 'Islam', 'African Traditional Religion'],
  true,
  true,
  jsonb_build_object(
    'series', 'In Scope',
    'level', 'JHS 1–3',
    'subject', 'Religious and Moral Education',
    'edition', 'Revised Edition'
  )
from public.publishers p
where p.slug = 'in-scope'
on conflict (slug) do update set
  title = excluded.title,
  subtitle = excluded.subtitle,
  description = excluded.description,
  synopsis = excluded.synopsis,
  isbn = excluded.isbn,
  cover_url = excluded.cover_url,
  cover_gradient = excluded.cover_gradient,
  cover_accent = excluded.cover_accent,
  genres = excluded.genres,
  is_featured = true,
  is_new_arrival = true,
  publisher_id = excluded.publisher_id,
  metadata = excluded.metadata,
  updated_at = timezone('utc', now());

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'last-hour-bece-english-jhs-1-2-3',
  'Last Hour Series B.E.C.E. English for Junior High Schools',
  'Junior High Schools (1, 2 & 3)',
  'Last Hour Series B.E.C.E. English is a combined JHS Form 1–3 revision textbook covering essay and letter writing, comprehension, grammar, literature, and past B.E.C.E. questions and answers.',
  'Combined Last Hour Series English title for junior high Form 1, 2 and 3, with past B.E.C.E. questions and answers.',
  '978-9988-2-7102-2',
  220,
  'English',
  '2024-01-01',
  p.id,
  '/covers/last-hour-bece-english-jhs-1-2-3/front.jpg',
  'from-[#2563EB] via-[#F9A8D4] to-[#DC2626]',
  '#2563EB',
  array['English', 'BECE', 'JHS', 'Combined', 'Last Hour'],
  array['Essay & letter writing', 'Comprehension', 'Grammar', 'Literature', 'Past B.E.C.E. questions and answers'],
  true,
  true,
  jsonb_build_object(
    'series', 'Last Hour Series',
    'level', 'JHS Form 1, 2 & 3',
    'subject', 'English',
    'exam', 'BECE'
  )
from public.publishers p
where p.slug = 'last-hour'
on conflict (slug) do update set
  title = excluded.title,
  subtitle = excluded.subtitle,
  description = excluded.description,
  synopsis = excluded.synopsis,
  isbn = excluded.isbn,
  cover_url = excluded.cover_url,
  cover_gradient = excluded.cover_gradient,
  cover_accent = excluded.cover_accent,
  genres = excluded.genres,
  is_featured = true,
  is_new_arrival = true,
  publisher_id = excluded.publisher_id,
  metadata = excluded.metadata,
  updated_at = timezone('utc', now());

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (a.slug = 'k-d-twumasi'),
  case a.slug when 'k-d-twumasi' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'religious-and-moral-education-in-scope-jhs-1-3'
  and a.slug in ('k-d-twumasi', 'c-adade')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, true, 0
from public.books b
cross join public.authors a
where b.slug = 'last-hour-bece-english-jhs-1-2-3'
  and a.slug = 'evans-gadeto-djikunu'
on conflict (book_id, author_id) do update
  set is_primary = true, sort_order = 0;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'religious-and-moral-education-in-scope-jhs-1-3'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-rme')
on conflict do nothing;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'last-hour-bece-english-jhs-1-2-3'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-english-language')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, v.sku, 7500, null, 'GHS', 100, 0, 10, true
from public.books b
join (values
  ('religious-and-moral-education-in-scope-jhs-1-3', 'SKU-INSCOPE-RME-JHS13-PB'),
  ('last-hour-bece-english-jhs-1-2-3', 'SKU-LASTHOUR-BECE-ENG-JHS13-PB')
) as v(slug, sku) on v.slug = b.slug
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('jhs'), ('combined'), ('ghana'), ('textbook')) as t(tag)
where b.slug in (
  'religious-and-moral-education-in-scope-jhs-1-3',
  'last-hour-bece-english-jhs-1-2-3'
)
on conflict do nothing;

delete from public.book_images
where book_id in (
  select id from public.books where slug in (
    'religious-and-moral-education-in-scope-jhs-1-3',
    'last-hour-bece-english-jhs-1-2-3'
  )
);

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/' || b.slug || '/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug in (
  'religious-and-moral-education-in-scope-jhs-1-3',
  'last-hour-bece-english-jhs-1-2-3'
);

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug in (
  'religious-and-moral-education-in-scope-jhs-1-3',
  'last-hour-bece-english-jhs-1-2-3'
)
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
