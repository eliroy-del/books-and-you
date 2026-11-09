-- Catalog: Vneeds colour pencils, 12 colours, at GH₵10.

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
  'vneeds-colour-pencils-12',
  'Vneeds Colour Pencils',
  '12 colours · non-toxic',
  'Pack of 12 Vneeds colour pencils. Non-toxic, with rich colours for school drawing.',
  'Box of 12 non-toxic Vneeds colour pencils.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/vneeds-colour-pencils-12/front.jpg',
  'from-[#FACC15] via-[#0F766E] to-[#DC2626]',
  '#0F766E',
  array['Stationery','Art & Craft','Colour Pencils','School Essentials'],
  array['12 colours','Non-toxic'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Vneeds',
    'pack_size', 12
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
where b.slug = 'vneeds-colour-pencils-12'
  and c.slug in ('stationery', 'art-craft', 'art-colour-pencils')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-VNEEDS-COLOUR-12', 1000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'vneeds-colour-pencils-12'
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
  ('colour-pencils'),
  ('art'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'vneeds-colour-pencils-12'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'vneeds-colour-pencils-12');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/vneeds-colour-pencils-12/front.jpg', 'Vneeds colour pencils 12 colours', 0, true
from public.books b
where b.slug = 'vneeds-colour-pencils-12';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'vneeds-colour-pencils-12'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
