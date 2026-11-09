-- Catalog: Master A4 Laminating Pouches, pack of 100, at GH₵120.

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
  'master-a4-laminating-pouches-100',
  'Master A4 Laminating Pouches',
  '100 pouches · 216 × 303 mm · 5 mil · 125 micron',
  'Master A4 laminating pouches, a pack of 100. Each pouch is 216 × 303 mm, 5 mil (125 micron), and suitable for use with all hot laminators.',
  'Pack of 100 Master A4 laminating pouches for hot laminators.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/master-a4-laminating-pouches-100/front.jpg',
  'from-[#F59E0B] via-[#FB923C] to-[#1D4ED8]',
  '#F59E0B',
  array['Stationery','Office Supplies','Laminating Pouches','School Essentials'],
  array['100 pouches','A4','125 micron'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Master',
    'size', 'A4',
    'pack', 100,
    'thickness', '125 micron'
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
where b.slug = 'master-a4-laminating-pouches-100'
  and c.slug in ('stationery', 'office-school-supplies', 'office-laminating-pouches')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-MASTER-A4-LAM-100', 12000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'master-a4-laminating-pouches-100'
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
  ('laminating'),
  ('a4'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'master-a4-laminating-pouches-100'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'master-a4-laminating-pouches-100');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/master-a4-laminating-pouches-100/front.jpg', 'Master A4 Laminating Pouches pack of 100', 0, true
from public.books b
where b.slug = 'master-a4-laminating-pouches-100';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'master-a4-laminating-pouches-100'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
