-- Catalog: History of Ghana for Basic Schools Book 5 (Masterman / 2019 Curriculum)
-- Idempotent seed for author, publisher, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'cyril-k-atipoe',
  'Cyril K. Atipoe',
  'Ghanaian',
  'Author of History of Ghana for Basic Schools with Masterman Publications.',
  true
)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'masterman-publications',
  'Masterman Publications Ltd.',
  'Ghana',
  'Ghanaian educational publisher of Masterman textbooks for basic schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'history-of-ghana-for-basic-schools-book-5',
  'History of Ghana for Basic Schools',
  'Book 5 · Based on the 2019 New Curriculum',
  'History of Ghana for Basic Schools Book 5 from Masterman Publications is aligned with the 2019 new curriculum. It helps Basic 5 learners explore Ghana''s history through clear lessons and classroom activities.',
  'Published by Masterman Publications Ltd. This Book 5 title supports primary learners with curriculum-based history content on Ghana''s people, independence, and national life.',
  '978-9988-3-8205-4',
  160,
  'English',
  '2020-01-01',
  p.id,
  '/covers/history-of-ghana-for-basic-schools-book-5/front.jpg',
  'from-[#6D28D9] via-[#7C3AED] to-[#1E1B4B]',
  '#FACC15',
  array['History','Primary 5','Textbooks','Curriculum'],
  array['Our Nation','Independence','Governance','National Life'],
  true,
  true,
  jsonb_build_object('series','Masterman','level','Book 5','curriculum','2019 New Curriculum','subject','History')
from public.publishers p
where p.slug = 'masterman-publications'
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
where b.slug = 'history-of-ghana-for-basic-schools-book-5'
  and a.slug = 'cyril-k-atipoe'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'history-of-ghana-for-basic-schools-book-5'
  and c.slug in ('primary-school', 'primary-history', 'level-primary-5')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-MASTERMAN-HIST-B5-PB',
  5000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'history-of-ghana-for-basic-schools-book-5'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('history'), ('primary-5'), ('curriculum'), ('masterman'), ('textbook'), ('ghana')) as t(tag)
where b.slug = 'history-of-ghana-for-basic-schools-book-5'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'history-of-ghana-for-basic-schools-book-5');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/history-of-ghana-for-basic-schools-book-5/front.jpg', 'History of Ghana for Basic Schools Book 5 front cover', 0, true),
    ('/covers/history-of-ghana-for-basic-schools-book-5/angle.jpg', 'History of Ghana for Basic Schools Book 5 angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'history-of-ghana-for-basic-schools-book-5';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'history-of-ghana-for-basic-schools-book-5'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
