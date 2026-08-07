-- Catalog: Learn History of Ghana Learners' Book 4 (Victory Series / NaCCA)
-- Idempotent seed for author, publisher, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'dent-augustine-theophilus',
  'Dent-Augustine Theophilus',
  'Ghanaian',
  'Author of the Victory Series Learn History of Ghana learners'' books for primary schools.',
  true
)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'victory-series',
  'Victory Series',
  'Ghana',
  'Publisher of the Victory Series NaCCA-compliant learners'' books for Ghanaian primary schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'learn-history-of-ghana-learners-book-4',
  'Learn History of Ghana',
  'Learners'' Book 4 · Victory Series · New NaCCA Curriculum Compliant',
  'Learn History of Ghana Learners'' Book 4 is a Victory Series primary textbook aligned with the new NaCCA curriculum. It introduces Basic 4 learners to Ghana''s history through clear lessons and classroom activities.',
  'Part of the Victory Series for primary schools. This learners'' book helps Basic 4 pupils explore the history of Ghana with curriculum-compliant content designed for the classroom.',
  '978-9988-3-7104-1',
  160,
  'English',
  '2024-01-01',
  p.id,
  '/covers/learn-history-of-ghana-learners-book-4/front.jpg',
  'from-[#7C3AED] via-[#2563EB] to-[#FACC15]',
  '#DC2626',
  array['History','Primary 4','Textbooks','NaCCA'],
  array['Our Country Ghana','People and Culture','Independence','Nation Building'],
  true,
  true,
  jsonb_build_object('series','Victory Series','level','Learners Book 4','curriculum','NaCCA','subject','History')
from public.publishers p
where p.slug = 'victory-series'
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
where b.slug = 'learn-history-of-ghana-learners-book-4'
  and a.slug = 'dent-augustine-theophilus'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'learn-history-of-ghana-learners-book-4'
  and c.slug in ('primary-school', 'primary-history', 'level-primary-4')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-LEARN-HIST-GH-B4-PB',
  7000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'learn-history-of-ghana-learners-book-4'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('history'), ('primary-4'), ('nacca'), ('victory-series'), ('textbook'), ('ghana')) as t(tag)
where b.slug = 'learn-history-of-ghana-learners-book-4'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'learn-history-of-ghana-learners-book-4');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/learn-history-of-ghana-learners-book-4/front.jpg', 'Learn History of Ghana Learners Book 4 front cover', 0, true),
    ('/covers/learn-history-of-ghana-learners-book-4/angle.jpg', 'Learn History of Ghana Learners Book 4 angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'learn-history-of-ghana-learners-book-4';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'learn-history-of-ghana-learners-book-4'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
