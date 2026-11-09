-- Catalog: Yi Chen A4 colour paper at GH₵7.

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
  'yi-chen-a4-colour-paper',
  'Yi Chen A4 Colour Paper',
  'A4 colour paper',
  'Ream of Yi Chen A4 colour paper for home, school, and office.',
  'Yi Chen A4 colour paper.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/yi-chen-a4-colour-paper/front.jpg',
  'from-[#F8FAFC] via-[#84CC16] to-[#65A30D]',
  '#65A30D',
  array['Stationery','Office Supplies','Printing Paper','School Essentials'],
  array['A4','Colour paper'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Yi Chen',
    'size', 'A4',
    'barcode', '6973587160060'
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
where b.slug = 'yi-chen-a4-colour-paper'
  and c.slug in ('stationery', 'office-school-supplies', 'office-printing-paper')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-YI-CHEN-A4-COLOUR', 700, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'yi-chen-a4-colour-paper'
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
  ('paper'),
  ('colour'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'yi-chen-a4-colour-paper'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'yi-chen-a4-colour-paper');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/yi-chen-a4-colour-paper/front.jpg', 'Yi Chen A4 colour paper', 0, true
from public.books b
where b.slug = 'yi-chen-a4-colour-paper';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'yi-chen-a4-colour-paper'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
