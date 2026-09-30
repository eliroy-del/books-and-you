-- Catalog: Aki-Ola Asante Twi and French for Junior High Schools at GH₵60.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('osei-kwabena-justice', 'Osei Kwabena Justice', 'Ghanaian', 'Co-author of Aki-Ola Series Asante Twi for junior high schools.', true),
  ('effah-williams', 'Effah Williams', 'Ghanaian', 'Co-author of Aki-Ola Series Asante Twi for junior high schools.', true),
  ('victor-afari', 'Victor Afari', 'Ghanaian', 'Co-author of Aki-Ola Series French for junior high schools.', true),
  ('isaac-wireko-ampem', 'Isaac Wireko-Ampem', 'Ghanaian', 'Co-author of Aki-Ola Series French for junior high schools.', true)
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
  'aki-ola-asante-twi-for-junior-high-schools',
  'Aki-Ola Series Asante Twi for Junior High Schools',
  'Aki-Ola Series · Junior High Schools',
  'Aki-Ola Series Asante Twi for Junior High Schools is a combined junior high Asante Twi textbook. It builds listening, speaking, reading, and writing across JHS.',
  'Combined Aki-Ola Series Asante Twi title for junior high schools, distributed by Aki-Ola Publications.',
  '978-9988-2-7099-5',
  200,
  'Asante Twi',
  '2024-01-01',
  p.id,
  '/covers/aki-ola-asante-twi-for-junior-high-schools/front.jpg',
  'from-[#111827] via-[#FACC15] to-[#1F2937]',
  '#FACC15',
  array['Ghanaian Language','Asante Twi','JHS','Combined','Aki-Ola'],
  array['Listening','Speaking','Reading','Writing'],
  true,
  true,
  jsonb_build_object(
    'series', 'Aki-Ola Series',
    'level', 'JHS',
    'subject', 'Asante Twi'
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

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'aki-ola-french-for-junior-high-schools-1-2-3',
  'Aki-Ola Series French for Junior High Schools',
  'Forms 1, 2 and 3 · New Edition',
  'Aki-Ola Series French for Junior High Schools is a combined JHS Form 1–3 French textbook. New edition covering dialogue, vocabulary, and writing for junior high.',
  'Combined Aki-Ola Series French title for junior high Form 1, 2 and 3. New edition, distributed by Aki-Ola Publications.',
  '978-9988-2-7100-8',
  200,
  'French',
  '2024-01-01',
  p.id,
  '/covers/aki-ola-french-for-junior-high-schools-1-2-3/front.jpg',
  'from-[#DC2626] via-[#111827] to-[#FACC15]',
  '#DC2626',
  array['French','JHS','Combined','Aki-Ola'],
  array['Dialogue','Vocabulary','Writing'],
  true,
  true,
  jsonb_build_object(
    'series', 'Aki-Ola Series',
    'level', 'JHS Form 1, 2 & 3',
    'subject', 'French',
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
select b.id, a.id, (a.slug = 'osei-kwabena-justice'),
  case a.slug when 'osei-kwabena-justice' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'aki-ola-asante-twi-for-junior-high-schools'
  and a.slug in ('osei-kwabena-justice', 'effah-williams')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (a.slug = 'victor-afari'),
  case a.slug when 'victor-afari' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'aki-ola-french-for-junior-high-schools-1-2-3'
  and a.slug in ('victor-afari', 'isaac-wireko-ampem')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'aki-ola-asante-twi-for-junior-high-schools'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-ghanaian-language')
on conflict do nothing;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'aki-ola-french-for-junior-high-schools-1-2-3'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-french')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, v.sku, 6000, null, 'GHS', 100, 0, 10, true
from public.books b
join (values
  ('aki-ola-asante-twi-for-junior-high-schools', 'SKU-AKIOLA-ASANTE-TWI-JHS-PB'),
  ('aki-ola-french-for-junior-high-schools-1-2-3', 'SKU-AKIOLA-FR-JHS123-PB')
) as v(slug, sku) on v.slug = b.slug
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('aki-ola'), ('jhs'), ('combined'), ('ghana'), ('textbook')) as t(tag)
where b.slug in (
  'aki-ola-asante-twi-for-junior-high-schools',
  'aki-ola-french-for-junior-high-schools-1-2-3'
)
on conflict do nothing;

delete from public.book_images
where book_id in (
  select id from public.books where slug in (
    'aki-ola-asante-twi-for-junior-high-schools',
    'aki-ola-french-for-junior-high-schools-1-2-3'
  )
);

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/' || b.slug || '/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug in (
  'aki-ola-asante-twi-for-junior-high-schools',
  'aki-ola-french-for-junior-high-schools-1-2-3'
);

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug in (
  'aki-ola-asante-twi-for-junior-high-schools',
  'aki-ola-french-for-junior-high-schools-1-2-3'
)
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
