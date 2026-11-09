-- Catalog: Sinar Spectra premium colour paper, A4, at GH₵130.

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
  'sinar-spectra-premium-colour-paper-a4',
  'Sinar Spectra Premium Colour Paper',
  'A4 · 210 × 297 mm',
  'Box of Sinar Spectra premium colour paper, A4 (210 × 297 mm).',
  'Sinar Spectra premium colour paper, A4.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/sinar-spectra-premium-colour-paper-a4/front.jpg',
  'from-[#DC2626] via-[#F8FAFC] to-[#EAB308]',
  '#DC2626',
  array['Stationery','Office Supplies','Printing Paper','School Essentials'],
  array['A4','210 × 297 mm','Premium colour paper'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Sinar Spectra',
    'size', 'A4 (210 × 297 mm)'
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
where b.slug = 'sinar-spectra-premium-colour-paper-a4'
  and c.slug in ('stationery', 'office-school-supplies', 'office-printing-paper')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-SINAR-SPECTRA-A4', 13000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'sinar-spectra-premium-colour-paper-a4'
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
where b.slug = 'sinar-spectra-premium-colour-paper-a4'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'sinar-spectra-premium-colour-paper-a4');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/sinar-spectra-premium-colour-paper-a4/front.jpg', 'Sinar Spectra premium colour paper A4', 0, true
from public.books b
where b.slug = 'sinar-spectra-premium-colour-paper-a4';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'sinar-spectra-premium-colour-paper-a4'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
