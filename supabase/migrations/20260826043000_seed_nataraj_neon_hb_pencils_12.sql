-- Catalog: Nataraj Neon Eraser tipped HB pencils (12 units)
-- Idempotent seed for publisher, product, categories, inventory, gallery, tags, collections.

insert into public.publishers (slug, name, country, description)
values (
  'nataraj',
  'Nataraj',
  'India',
  'School stationery brand known for pencils, sharpeners, and writing essentials.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'nataraj-neon-eraser-tipped-hb-pencils-12',
  'Nataraj Neon Eraser tipped HB Pencils',
  '12 units · Free sharpener · Clear and smooth writing',
  'Nataraj Neon eraser-tipped HB pencils in a pack of 12. Bright neon barrels, HB graphite for clear smooth writing, and a free sharpener included — ideal for school, homework, and everyday notes.',
  'Pack of 12 Nataraj Neon HB pencils with eraser tips. Includes a free sharpener.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/nataraj-neon-eraser-tipped-hb-pencils-12/front.jpg',
  'from-[#DC2626] via-[#FACC15] to-[#001F3E]',
  '#DC2626',
  array['Stationery','Pencils','Writing Supplies','School Essentials'],
  array['12 Neon HB Pencils','Eraser tipped','Free Sharpener'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Nataraj',
    'pack_size', 12,
    'grade', 'HB',
    'includes', 'free sharpener'
  )
from public.publishers p
where p.slug = 'nataraj'
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
where b.slug = 'nataraj-neon-eraser-tipped-hb-pencils-12'
  and c.slug in ('stationery', 'writing-supplies', 'writing-pencils')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-NATARAJ-NEON-HB-12',
  1600,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'nataraj-neon-eraser-tipped-hb-pencils-12'
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
  ('stationery'),
  ('pencils'),
  ('nataraj'),
  ('hb'),
  ('neon'),
  ('school'),
  ('writing')
) as t(tag)
where b.slug = 'nataraj-neon-eraser-tipped-hb-pencils-12'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'nataraj-neon-eraser-tipped-hb-pencils-12');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/nataraj-neon-eraser-tipped-hb-pencils-12/front.jpg', 'Nataraj Neon Eraser tipped HB Pencils 12-pack front', 0, true)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'nataraj-neon-eraser-tipped-hb-pencils-12';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'nataraj-neon-eraser-tipped-hb-pencils-12'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
