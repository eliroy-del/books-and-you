-- Catalog: Aki-Ola Series English Language with Literature for JHS Form 1–3 at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('f-n-john', 'F. N. John', 'Ghanaian', 'Author of Aki-Ola Series English Language with Literature for junior high schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'aki-ola',
  'Aki-Ola Publications',
  'Ghana',
  'Publisher of the Aki-Ola Series textbooks for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'aki-ola-english-language-with-literature-jhs-1-2-3',
  'Aki-Ola Series English Language with Literature',
  'For Junior High Schools Form 1, 2 & 3 · New Edition',
  'Aki-Ola Series English Language with Literature is a combined JHS Form 1–3 textbook covering grammar, synonyms and antonyms, idioms, comprehension, and composition, with objective tests and sample essay topics.',
  'Combined Aki-Ola Series English Language with Literature title for junior high Form 1, 2 and 3. New edition, distributed by Aki-Ola Publications.',
  '978-9988-2-7095-7',
  240,
  'English',
  '2024-01-01',
  p.id,
  '/covers/aki-ola-english-language-with-literature-jhs-1-2-3/front.jpg',
  'from-[#EC4899] via-[#9F1239] to-[#FCE7F3]',
  '#EC4899',
  array['English','Literature','JHS','Combined','Aki-Ola'],
  array['Grammar','Objective tests on grammar','Synonyms and antonyms','Idioms','Comprehension','Composition','Sample essay topics'],
  true,
  true,
  jsonb_build_object(
    'series', 'Aki-Ola Series',
    'level', 'JHS Form 1, 2 & 3',
    'subject', 'English Language with Literature',
    'edition', 'New Edition'
  )
from public.publishers p
where p.slug = 'aki-ola'
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
select b.id, a.id, true, 0
from public.books b
cross join public.authors a
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3'
  and a.slug = 'f-n-john'
on conflict (book_id, author_id) do update
  set is_primary = true, sort_order = 0;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-english-language')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-AKIOLA-ENG-LIT-JHS123-PB', 15000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values
  ('aki-ola'),
  ('english'),
  ('literature'),
  ('jhs'),
  ('combined'),
  ('ghana'),
  ('jhs-1-2-3')
) as t(tag)
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'aki-ola-english-language-with-literature-jhs-1-2-3');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/aki-ola-english-language-with-literature-jhs-1-2-3/front.jpg',
  'Aki-Ola Series English Language with Literature JHS 1–3 front cover', 0, true
from public.books b
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'aki-ola-english-language-with-literature-jhs-1-2-3'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
