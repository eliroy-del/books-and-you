-- Catalog: Golden Colour Work for KG
-- Idempotent seed for author, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'okyere-baafi-alexander',
  'Okyere Baafi Alexander',
  'Ghanaian',
  'Author of Golden series textbooks and early-years activity books for Ghanaian schools.',
  true
)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'new-golden-publications',
  'New Golden Publications',
  'Ghana',
  'Kumasi-based educational publisher of the Golden series for primary schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'golden-colour-work-for-kg',
  'Golden Colour Work for KG',
  'Kindergarten colouring and activity book',
  'Golden Colour Work for KG is a kindergarten colouring and activity book that helps young learners practise colouring, observation, and early motor skills through fun pictures and simple exercises.',
  'Part of the Golden series for early years. This KG title supports classroom and home colouring practice with child-friendly illustrations.',
  '978-9988-2-7001-8',
  64,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-colour-work-for-kg/front.jpg',
  'from-[#1E3A8A] via-[#EF4444] to-[#FACC15]',
  '#FDE047',
  array['Colouring','Kindergarten','Activity Books','Early Years'],
  array['Colouring Practice','Shapes and Objects','Everyday Pictures','Fun Activities'],
  true,
  true,
  jsonb_build_object('series','Golden','level','KG','subject','Colour Work')
from public.publishers p
where p.slug = 'new-golden-publications'
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
select b.id, a.id, true, 0
from public.books b
cross join public.authors a
where b.slug = 'golden-colour-work-for-kg'
  and a.slug = 'okyere-baafi-alexander'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-colour-work-for-kg'
  and c.slug in ('nursery-kindergarten', 'nursery-coloring-and-activity-books', 'level-kindergarten')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-COLOUR-KG-PB',
  5500,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-colour-work-for-kg'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('colouring'), ('kindergarten'), ('kg'), ('golden'), ('activity'), ('ghana')) as t(tag)
where b.slug = 'golden-colour-work-for-kg'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-colour-work-for-kg');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-colour-work-for-kg/front.jpg', 'Golden Colour Work for KG front cover', 0, true),
    ('/covers/golden-colour-work-for-kg/angle.jpg', 'Golden Colour Work for KG angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-colour-work-for-kg';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-colour-work-for-kg'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
