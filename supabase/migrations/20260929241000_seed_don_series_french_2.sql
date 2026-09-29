-- Catalog: Don Series French Premier Textbook 2 at GH₵65.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('donsimon-quarshie-attipoe', 'Donsimon Quarshie Attipoe', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('raphael-awindaniko', 'Raphael Awindaniko', 'Ghanaian', 'Co-author of Don Series French Premier textbooks for lower primary.', true)
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
  'don-series-french-premier-textbook-2',
  'Don Series French Premier Textbook 2',
  'For Basic Schools · NaCCA Approved Standard Based Curriculum',
  'Don Series French Premier Textbook 2 is a Don Series primary French textbook based on the NaCCA approved standard based curriculum. It builds dialogue, comprehension, vocabulary, grammar, and composition for Basic 2.',
  'Part of the Don Series Premier French range for basic schools. This Basic 2 textbook supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7082-7',
  144,
  'French',
  '2024-01-01',
  p.id,
  '/covers/don-series-french-premier-textbook-2/front.jpg',
  'from-[#C2410C] via-[#9A3412] to-[#FDBA74]',
  '#C2410C',
  array['French','Primary 2','Don Series','NaCCA'],
  array['Dialogue','Comprehension','Vocabulary','Grammar','Composition'],
  true,
  true,
  jsonb_build_object(
    'series', 'Don Series',
    'level', 'Basic 2',
    'subject', 'French',
    'curriculum', 'NaCCA'
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
select b.id, a.id, (a.slug = 'donsimon-quarshie-attipoe'),
  case a.slug when 'donsimon-quarshie-attipoe' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'don-series-french-premier-textbook-2'
  and a.slug in ('donsimon-quarshie-attipoe', 'raphael-awindaniko')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'don-series-french-premier-textbook-2'
  and c.slug in ('primary-school', 'primary-french', 'level-primary-2')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-DON-FR-TB-2-PB', 6500, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'don-series-french-premier-textbook-2'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('don-series'), ('french'), ('primary-2'), ('nacca'), ('ghana'), ('textbook')) as t(tag)
where b.slug = 'don-series-french-premier-textbook-2'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'don-series-french-premier-textbook-2');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/don-series-french-premier-textbook-2/front.jpg',
  'Don Series French Premier Textbook 2 front cover', 0, true
from public.books b
where b.slug = 'don-series-french-premier-textbook-2';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'don-series-french-premier-textbook-2'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
