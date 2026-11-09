-- Catalog: Afrafra Asante Twi Gyinapɛn 6 and Masterman Interactive English Language Basic 8 at GH₵70.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('saint-godson-kwasi-baah', 'Saint Godson Kwasi Baah', 'Ghanaian', 'Author of Afrafra Asante Twi Mettiasee Sukuu Nwoma for primary schools.', true),
  ('seth-amoako', 'Seth Amoako', 'Ghanaian', 'Co-author of Masterman Interactive English Language for junior high schools.', true),
  ('jane-sabina-obeng', 'Jane Sabina Obeng', 'Ghanaian', 'Co-author of Masterman Interactive English Language for junior high schools.', true),
  ('mayseth-amoako', 'Mayseth Amoako', 'Ghanaian', 'Co-author of Masterman Interactive English Language for junior high schools.', true),
  ('kwame-oppong-ntim', 'Kwame Oppong-Ntim, Esq', 'Ghanaian', 'Co-author of Masterman Interactive English Language for junior high schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values
  ('afrafra', 'Afrafra', 'Ghana', 'Publisher of Afrafra Ghanaian language textbooks for basic schools.'),
  ('masterman-publications', 'Masterman Publications Ltd', 'Ghana', 'Publisher of Masterman textbooks for Ghanaian schools.')
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6',
  'Afrafra Asante Twi Mettiasee Sukuu Nwoma Gyinapɛn 6',
  'Mettiasee Sukuu Nwoma · Gyinapɛn 6',
  'Afrafra Asante Twi Mettiasee Sukuu Nwoma Gyinapɛn 6 is a primary 6 Asante Twi textbook for listening, speaking, reading, and writing.',
  'Afrafra Asante Twi learners'' book for Gyinapɛn 6, written by Saint Godson Kwasi Baah.',
  '978-9988-2-7121-3',
  160,
  'Asante Twi',
  '2024-01-01',
  p.id,
  '/covers/afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6/front.jpg',
  'from-[#DC2626] via-[#7C3AED] to-[#FACC15]',
  '#DC2626',
  array['Ghanaian Language', 'Asante Twi', 'Primary', 'Afrafra'],
  array['Listening', 'Speaking', 'Reading', 'Writing'],
  true,
  true,
  jsonb_build_object(
    'series', 'Afrafra',
    'level', 'Gyinapɛn 6',
    'subject', 'Asante Twi'
  )
from public.publishers p
where p.slug = 'afrafra'
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
  'masterman-interactive-english-language-basic-8',
  'Masterman Interactive English Language Basic 8',
  'For Junior High Schools',
  'Masterman Interactive English Language Basic 8 is a junior high English textbook for JHS 2, covering oral language, reading, grammar, writing, and literature.',
  'Masterman Interactive English Language title for Basic 8 / JHS 2.',
  '978-9988-2-7122-0',
  200,
  'English',
  '2024-01-01',
  p.id,
  '/covers/masterman-interactive-english-language-basic-8/front.jpg',
  'from-[#DC2626] via-[#15803D] to-[#FACC15]',
  '#DC2626',
  array['English', 'JHS', 'Masterman'],
  array['Oral language', 'Reading', 'Grammar', 'Writing', 'Literature'],
  true,
  true,
  jsonb_build_object(
    'series', 'Masterman',
    'level', 'Basic 8',
    'subject', 'English Language'
  )
from public.publishers p
where p.slug = 'masterman-publications'
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
where b.slug = 'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6'
  and a.slug = 'saint-godson-kwasi-baah'
on conflict (book_id, author_id) do update
  set is_primary = true, sort_order = 0;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (u.ord = 1), (u.ord - 1)::int
from public.books b
cross join unnest(array['seth-amoako', 'jane-sabina-obeng', 'mayseth-amoako', 'kwame-oppong-ntim']) with ordinality as u(author_slug, ord)
join public.authors a on a.slug = u.author_slug
where b.slug = 'masterman-interactive-english-language-basic-8'
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6'
  and c.slug in ('primary-school', 'primary-ghanaian-language', 'level-primary-6')
on conflict do nothing;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'masterman-interactive-english-language-basic-8'
  and c.slug in ('junior-high-school', 'jhs-english-language', 'level-jhs-2')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, v.sku, 7000, null, 'GHS', 100, 0, 10, true
from public.books b
join (values
  ('afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6', 'SKU-AFRAFRA-ASANTE-TWI-6-PB'),
  ('masterman-interactive-english-language-basic-8', 'SKU-MASTERMAN-ENG-B8-PB')
) as v(slug, sku) on v.slug = b.slug
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('ghana'), ('textbook')) as t(tag)
where b.slug in (
  'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6',
  'masterman-interactive-english-language-basic-8'
)
on conflict do nothing;

delete from public.book_images
where book_id in (
  select id from public.books where slug in (
    'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6',
    'masterman-interactive-english-language-basic-8'
  )
);

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/' || b.slug || '/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug in (
  'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6',
  'masterman-interactive-english-language-basic-8'
);

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug in (
  'afrafra-asante-twi-mettiasee-sukuu-nwoma-gyinapen-6',
  'masterman-interactive-english-language-basic-8'
)
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
