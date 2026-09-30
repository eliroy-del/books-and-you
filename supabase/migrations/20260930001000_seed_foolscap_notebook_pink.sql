-- Catalog: Foolscap Notebook (pink cover) at GH₵45.

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
  'foolscap-notebook-pink',
  'Foolscap Notebook',
  'Pink cover · Name, subject, and date fields',
  'A hard-cover foolscap notebook with a pink geometric cover. The front label has spaces for name, subject, and date commenced — suited to school notes and classroom work.',
  'Hard-cover foolscap notebook with a pink patterned cover and labelled name, subject, and date fields.',
  null,
  null,
  'English',
  '2024-01-01',
  p.id,
  '/covers/foolscap-notebook-pink/front.jpg',
  'from-[#EC4899] via-[#BE185D] to-[#DC2626]',
  '#EC4899',
  array['Stationery','Notebooks','Foolscap','School Essentials'],
  array['Name','Subject','Date commenced'],
  true,
  true,
  jsonb_build_object(
    'product_type', 'stationery',
    'cover', 'pink geometric',
    'size', 'foolscap'
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
where b.slug = 'foolscap-notebook-pink'
  and c.slug in ('stationery', 'exercise-note-books', 'notebooks-notebooks')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-FOOLSCAP-NOTEBOOK-PINK', 4500, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'foolscap-notebook-pink'
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
  ('foolscap'),
  ('ghana'),
  ('school')
) as t(tag)
where b.slug = 'foolscap-notebook-pink'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'foolscap-notebook-pink');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/foolscap-notebook-pink/front.jpg', 'Foolscap Notebook pink cover', 0, true),
    ('/covers/foolscap-notebook-pink/edge.jpg', 'Foolscap Notebook page edge', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'foolscap-notebook-pink';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'foolscap-notebook-pink'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
