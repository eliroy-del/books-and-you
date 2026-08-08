-- Catalog: Golden Our World Our People KG 1
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
  'golden-our-world-our-people-kg-1',
  'Golden Our World Our People KG 1',
  'Based on the new NaCCA syllabus',
  'Golden Our World Our People KG 1 is a kindergarten textbook based on the new NaCCA syllabus. It introduces young learners to their community, environment, and everyday life through simple, age-appropriate lessons.',
  'Part of the Golden series for early years. This KG 1 Our World Our People title supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7005-6',
  80,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-our-world-our-people-kg-1/front.jpg',
  'from-[#DC2626] via-[#FFFFFF] to-[#F59E0B]',
  '#EF4444',
  array['Our World Our People','Kindergarten','OWOP','Early Years'],
  array['Our Community','Our Environment','People Around Us','Everyday Life'],
  true,
  true,
  jsonb_build_object('series','Golden','level','KG 1','subject','Our World Our People','curriculum','NaCCA')
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
where b.slug = 'golden-our-world-our-people-kg-1'
  and a.slug = 'okyere-baafi-alexander'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-our-world-our-people-kg-1'
  and c.slug in ('nursery-kindergarten', 'nursery-textbooks', 'level-kindergarten')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-OWOP-KG1-PB',
  5500,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-our-world-our-people-kg-1'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('owop'), ('our-world-our-people'), ('kindergarten'), ('kg-1'), ('golden'), ('nacca'), ('ghana')) as t(tag)
where b.slug = 'golden-our-world-our-people-kg-1'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-our-world-our-people-kg-1');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-our-world-our-people-kg-1/front.jpg', 'Golden Our World Our People KG 1 front cover', 0, true)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-our-world-our-people-kg-1';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-our-world-our-people-kg-1'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
