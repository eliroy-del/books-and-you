-- Catalog: Notebook 3 (blue stripe) at GH₵20.

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
  'notebook-3-blue-stripe',
  'Notebook 3',
  'Blue stripe cover · Name, class, and year fields',
  'A hard-cover Notebook 3 with a blue-and-white stripe cover and kraft spine. The front label has spaces for name, class or form, and year — suited to school notes.',
  'Hard-cover Notebook 3 with a blue stripe cover and labelled name, class, and year fields.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/notebook-3-blue-stripe/front.jpg',
  'from-[#2563EB] via-[#BFDBFE] to-[#D6D3D1]',
  '#2563EB',
  array['Stationery','Notebooks','School Essentials'],
  array['Name','Class / Form','Year'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'cover', 'blue stripe',
    'size', 'notebook 3'
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
where b.slug = 'notebook-3-blue-stripe'
  and c.slug in ('stationery', 'exercise-note-books', 'notebooks-notebooks')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-NOTEBOOK-3-BLUE-STRIPE', 2000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'notebook-3-blue-stripe'
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
  ('notebook'),
  ('notebook-3'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'notebook-3-blue-stripe'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'notebook-3-blue-stripe');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/notebook-3-blue-stripe/front.jpg',
  'Notebook 3 blue stripe cover', 0, true
from public.books b
where b.slug = 'notebook-3-blue-stripe';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'notebook-3-blue-stripe'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
