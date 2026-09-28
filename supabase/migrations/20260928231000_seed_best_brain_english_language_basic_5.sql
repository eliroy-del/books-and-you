-- Catalog: Best Brain English Language for Basic Schools Basic 5
-- Idempotent seed for authors, publisher, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('mavis-baah-yeboah', 'Mavis Baah-Yeboah', 'Ghanaian', 'Co-author of Best Brain English Language textbooks for Ghanaian basic schools.', true),
  ('albert-mcphiliphy-anamuah', 'Albert Mcphiliphy Anamuah', 'Ghanaian', 'Co-author of Best Brain English Language textbooks for Ghanaian basic schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'best-brain',
  'Best Brain',
  'Ghana',
  'Publisher of the Best Brain English Language series for Ghanaian basic schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'best-brain-english-language-for-basic-schools-5',
  'Best Brain English Language for Basic Schools Basic 5',
  'Based on the New NaCCA Standards-Based Curriculum',
  'Best Brain English Language for Basic Schools Basic 5 is a primary school English textbook based on the new NaCCA Standards-Based Curriculum. It builds grammar, reading, writing, and oral language through clear lessons and classroom activities.',
  'Part of the Best Brain English Language series. This Basic 5 title supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7040-7',
  144,
  'English',
  '2024-01-01',
  p.id,
  '/covers/best-brain-english-language-for-basic-schools-5/front.jpg',
  'from-[#6D28D9] via-[#F97316] to-[#166534]',
  '#F97316',
  array['English Language','Primary 5','NaCCA','Basic Schools'],
  array['Grammar','Reading','Writing','Oral Language','Comprehension'],
  true,
  true,
  jsonb_build_object(
    'series', 'Best Brain English Language',
    'level', 'Basic 5',
    'subject', 'English Language',
    'curriculum', 'NaCCA'
  )
from public.publishers p
where p.slug = 'best-brain'
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
select b.id, a.id, (a.slug = 'mavis-baah-yeboah'),
  case a.slug when 'mavis-baah-yeboah' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'best-brain-english-language-for-basic-schools-5'
  and a.slug in ('mavis-baah-yeboah', 'albert-mcphiliphy-anamuah')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'best-brain-english-language-for-basic-schools-5'
  and c.slug in ('primary-school', 'primary-english-language', 'level-primary-5')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-BESTBRAIN-ENG-B5-PB',
  7000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'best-brain-english-language-for-basic-schools-5'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values
  ('english'),
  ('english-language'),
  ('best-brain'),
  ('nacca'),
  ('ghana'),
  ('primary-5'),
  ('basic-5')
) as t(tag)
where b.slug = 'best-brain-english-language-for-basic-schools-5'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'best-brain-english-language-for-basic-schools-5');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select
  b.id,
  '/covers/best-brain-english-language-for-basic-schools-5/front.jpg',
  'Best Brain English Language for Basic Schools Basic 5 front cover',
  0,
  true
from public.books b
where b.slug = 'best-brain-english-language-for-basic-schools-5';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'best-brain-english-language-for-basic-schools-5'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
