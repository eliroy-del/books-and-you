-- Catalog: Don Series Computing CCP Premier Textbook 7, 8 & 9 at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('wilson-osafo-apeanti', 'Wilson Osafo Apeanti', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('donsimon-quarshie-attipoe', 'Donsimon Quarshie Attipoe', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'don-series',
  'Don Series',
  'Ghana',
  'Publisher of Don Series Premier textbooks for Ghanaian basic schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'don-series-computing-ccp-premier-textbook-7-8-9',
  'Don Series Computing CCP Premier Textbook for Basic Schools 7, 8 & 9',
  'Common Core Programme · NaCCA Approved',
  'Don Series Computing CCP Premier Textbook for Basic Schools 7, 8 & 9 is a combined junior high computing textbook based on the NaCCA-approved standard-based curriculum. It covers introduction to computing, productivity software, communication networks, computational thinking, practical lessons, keyboard shortcuts, and VB.net.',
  'Combined Don Series Computing title for junior high Basic 7, 8 and 9 / JHS 1–3.',
  '978-9988-2-7120-6',
  240,
  'English',
  '2024-01-01',
  p.id,
  '/covers/don-series-computing-ccp-premier-textbook-7-8-9/front.jpg',
  'from-[#C2410C] via-[#1D4ED8] to-[#7F1D1D]',
  '#C2410C',
  array['Computing', 'JHS', 'Combined', 'Don Series'],
  array['Introduction to computing', 'Productivity software', 'Communication networks', 'Computational thinking', 'Practical lessons', 'Keyboard shortcuts', 'VB.net'],
  true,
  true,
  jsonb_build_object(
    'series', 'Don Series',
    'level', 'Basic 7, 8 & 9',
    'subject', 'Computing',
    'curriculum', 'Common Core Programme'
  )
from public.publishers p
where p.slug = 'don-series'
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
select b.id, a.id, (a.slug = 'wilson-osafo-apeanti'),
  case a.slug when 'wilson-osafo-apeanti' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9'
  and a.slug in ('wilson-osafo-apeanti', 'donsimon-quarshie-attipoe')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-computing')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-DON-COMP-CCP-789-PB', 15000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('jhs'), ('combined'), ('ghana'), ('textbook'), ('ccp'), ('don-series')) as t(tag)
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'don-series-computing-ccp-premier-textbook-7-8-9');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/don-series-computing-ccp-premier-textbook-7-8-9/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'don-series-computing-ccp-premier-textbook-7-8-9'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
