-- Catalog: Golden Mathematics KG 2
-- Idempotent seed for author, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'akosua-animah',
  'Akosua Animah',
  'Ghanaian',
  'Co-author of Golden series textbooks for Ghanaian schools.',
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
  'golden-mathematics-kg-2',
  'Golden Mathematics KG 2',
  'Based on the new NaCCA syllabus',
  'Golden Mathematics KG 2 is a kindergarten mathematics textbook based on the new NaCCA syllabus. It helps young learners practise counting, simple addition, and early number skills through clear, age-appropriate exercises.',
  'Part of the Golden series for early years. This KG 2 Mathematics title supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7009-4',
  96,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-mathematics-kg-2/front.jpg',
  'from-[#FACC15] via-[#3B82F6] to-[#F97316]',
  '#FDE047',
  array['Mathematics','Kindergarten','Numbers','Early Years'],
  array['Counting','Simple Addition','Number Recognition','Early Problem Solving'],
  true,
  true,
  jsonb_build_object('series','Golden','level','KG 2','subject','Mathematics','curriculum','NaCCA')
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
where b.slug = 'golden-mathematics-kg-2'
  and a.slug = 'akosua-animah'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-mathematics-kg-2'
  and c.slug in ('nursery-kindergarten', 'nursery-textbooks', 'nursery-numbers-and-counting', 'level-kindergarten')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-MATHS-KG2-PB',
  5500,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-mathematics-kg-2'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('mathematics'), ('maths'), ('kindergarten'), ('kg-2'), ('golden'), ('nacca'), ('ghana')) as t(tag)
where b.slug = 'golden-mathematics-kg-2'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-mathematics-kg-2');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-mathematics-kg-2/front.jpg', 'Golden Mathematics KG 2 front cover', 0, true)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-mathematics-kg-2';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-mathematics-kg-2'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
