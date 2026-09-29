-- Catalog: Excellence Series Akuapem Twi for Junior High Schools (JHS 1–3) at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('francis-benjamin-appiah', 'Francis Benjamin Appiah', 'Ghanaian', 'Co-author of Excellence series textbooks for Ghanaian schools.', true),
  ('nana-amma-oppongwaa-ghartey', 'Nana Amma Oppongwaa Ghartey', 'Ghanaian', 'Co-author of Excellence Akuapem Twi for Junior High Schools.', true),
  ('banful-ghartey-ghartey', 'Banful Ghartey Ghartey', 'Ghanaian', 'Co-author of Excellence Akuapem Twi for Junior High Schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'excellence',
  'Excellence',
  'Ghana',
  'Publisher of Excellence Series textbooks for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'excellence-akuapem-twi-for-junior-high-schools-1-3',
  'Excellence Akuapem Twi for Junior High Schools (JHS 1–3)',
  'Excellence Series · Based on the Common Core Programme',
  'Excellence Akuapem Twi for Junior High Schools is a combined JHS 1–3 textbook from the Excellence Series, based on the Common Core Programme. It builds Akuapem Twi listening, speaking, reading, and writing across junior high.',
  'Combined Excellence Series Akuapem Twi title for JHS 1 to JHS 3, aligned with the Common Core Programme.',
  '978-9988-2-7058-2',
  240,
  'Akuapem Twi',
  '2024-01-01',
  p.id,
  '/covers/excellence-akuapem-twi-for-junior-high-schools-1-3/front.jpg',
  'from-[#7F1D1D] via-[#1C1917] to-[#B45309]',
  '#D4A017',
  array['Ghanaian Language','Akuapem Twi','JHS','Common Core','Combined'],
  array['JHS 1 (Basic 7)','JHS 2 (Basic 8)','JHS 3 (Basic 9)'],
  true,
  true,
  jsonb_build_object(
    'series', 'Excellence Series',
    'level', 'JHS 1–3',
    'subject', 'Akuapem Twi',
    'curriculum', 'Common Core Programme'
  )
from public.publishers p
where p.slug = 'excellence'
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
select b.id, a.id, (a.slug = 'francis-benjamin-appiah'),
  case a.slug
    when 'francis-benjamin-appiah' then 0
    when 'nana-amma-oppongwaa-ghartey' then 1
    else 2
  end
from public.books b
cross join public.authors a
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3'
  and a.slug in ('francis-benjamin-appiah', 'nana-amma-oppongwaa-ghartey', 'banful-ghartey-ghartey')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-ghanaian-language')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-EXCELLENCE-AKUAPEM-TWI-JHS13-PB', 15000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('excellence'), ('akuapem-twi'), ('ghanaian-language'), ('jhs'), ('combined'), ('common-core'), ('ghana'), ('jhs-1-3')) as t(tag)
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/excellence-akuapem-twi-for-junior-high-schools-1-3/front.jpg',
  'Excellence Akuapem Twi for Junior High Schools JHS 1–3 front cover', 0, true
from public.books b
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'excellence-akuapem-twi-for-junior-high-schools-1-3'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
