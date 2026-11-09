-- Catalog: Paperline Ghana Schools Exercise Book, Note 1, 40 sheets, at GH₵60.

insert into public.publishers (slug, name, country, description)
values (
  'school-essentials',
  'School Essentials',
  'Ghana',
  'Everyday school stationery and classroom supplies.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'paperline-ghana-schools-exercise-book-note-1-40',
  'Paperline Ghana Schools Exercise Book',
  'Note 1 · 40 sheets · single line',
  'Paperline Ghana Schools exercise book, Note 1. 40 sheets, single line, with name, class, school, and subject lines on the cover.',
  'Paperline Note 1 exercise book, 40 single-line sheets.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/paperline-ghana-schools-exercise-book-note-1-40/front.jpg',
  'from-[#111827] via-[#F59E0B] to-[#2563EB]',
  '#F59E0B',
  array['Stationery','Exercise Books','School Essentials'],
  array['40 sheets','Single line','Note 1'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Paperline',
    'note', 1,
    'sheets', 40,
    'ruling', 'single line'
  )
from public.publishers p
where p.slug = 'school-essentials'
on conflict (slug) do update set
  title = excluded.title,
  subtitle = excluded.subtitle,
  description = excluded.description,
  synopsis = excluded.synopsis,
  cover_url = excluded.cover_url,
  cover_gradient = excluded.cover_gradient,
  cover_accent = excluded.cover_accent,
  genres = excluded.genres,
  is_featured = true,
  is_new_arrival = true,
  publisher_id = excluded.publisher_id,
  metadata = excluded.metadata,
  updated_at = timezone('utc', now());

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'paperline-ghana-schools-exercise-book-note-1-40'
  and c.slug in ('stationery', 'exercise-note-books', 'notebooks-exercise-books')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-PAPERLINE-NOTE1-40', 6000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'paperline-ghana-schools-exercise-book-note-1-40'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values
  ('stationery'),
  ('exercise-book'),
  ('note-1'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'paperline-ghana-schools-exercise-book-note-1-40'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'paperline-ghana-schools-exercise-book-note-1-40');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/paperline-ghana-schools-exercise-book-note-1-40/front.jpg', 'Paperline Ghana Schools Exercise Book Note 1', 0, true
from public.books b
where b.slug = 'paperline-ghana-schools-exercise-book-note-1-40';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'paperline-ghana-schools-exercise-book-note-1-40'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
