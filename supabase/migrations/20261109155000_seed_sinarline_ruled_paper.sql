-- Catalog: Sinarline ruled paper, 33 × 42 cm, 200 sheets, at GH₵70.

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
  'sinarline-ruled-paper-33x42-200',
  'Sinarline Ruled Paper',
  '33 × 42 cm · 56 GSM · 200 sheets',
  'Sinarline ruled paper, a ream of 200 sheets. Each sheet is 33 × 42 cm and 56 GSM, product RP01021.',
  'Ream of 200 Sinarline ruled sheets, 33 × 42 cm, 56 GSM.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/sinarline-ruled-paper-33x42-200/front.jpg',
  'from-[#1D4ED8] via-[#FACC15] to-[#22C55E]',
  '#1D4ED8',
  array['Stationery','Office Supplies','Ruled Paper','School Essentials'],
  array['200 sheets','33 × 42 cm','56 GSM'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Sinarline',
    'size', '33 × 42 cm',
    'gsm', 56,
    'sheets', 200,
    'code', 'RP01021'
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
where b.slug = 'sinarline-ruled-paper-33x42-200'
  and c.slug in ('stationery', 'office-school-supplies', 'office-printing-paper')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-SINARLINE-RULED-200', 7000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'sinarline-ruled-paper-33x42-200'
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
  ('ruled'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'sinarline-ruled-paper-33x42-200'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'sinarline-ruled-paper-33x42-200');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/sinarline-ruled-paper-33x42-200/front.jpg', 'Sinarline Ruled Paper 200 sheets', 0, true
from public.books b
where b.slug = 'sinarline-ruled-paper-33x42-200';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'sinarline-ruled-paper-33x42-200'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
