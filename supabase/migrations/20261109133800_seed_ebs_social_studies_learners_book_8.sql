-- Catalog: EBS Series Social Studies Learners' Book 8 at GH₵75.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('solomon-owusu', 'Solomon Owusu', 'Ghanaian', 'Co-author of EBS Series Social Studies learners'' books.', true),
  ('enock-kwasi-addo', 'Enock Kwasi Addo', 'Ghanaian', 'Co-author of EBS Series Social Studies learners'' books.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'ebs-series',
  'EBS Series',
  'Ghana',
  'Publisher of EBS Series learners'' books for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'ebs-social-studies-learners-book-8',
  'EBS Series Social Studies Learners'' Book 8',
  'Based on the New NaCCA Standard-Based Curriculum',
  'EBS Series Social Studies Learners'' Book 8 is a junior high Social Studies textbook for Basic 8, based on the Common Core Curriculum and the new NaCCA standard-based curriculum.',
  'EBS Series Social Studies learners'' book for Basic 8 / JHS 2.',
  '978-9988-2-7129-9',
  200,
  'English',
  '2024-01-01',
  p.id,
  '/covers/ebs-social-studies-learners-book-8/front.jpg',
  'from-[#1E3A8A] via-[#34D399] to-[#F8FAFC]',
  '#1E3A8A',
  array['Social Studies', 'JHS', 'EBS Series', 'NaCCA'],
  array['Lessons', 'Activities', 'Self-assessment', 'Revision'],
  true,
  true,
  jsonb_build_object(
    'series', 'EBS Series',
    'level', 'Basic 8',
    'subject', 'Social Studies',
    'curriculum', 'Common Core Programme'
  )
from public.publishers p
where p.slug = 'ebs-series'
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
select b.id, a.id, (a.slug = 'solomon-owusu'),
  case a.slug when 'solomon-owusu' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'ebs-social-studies-learners-book-8'
  and a.slug in ('solomon-owusu', 'enock-kwasi-addo')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'ebs-social-studies-learners-book-8'
  and c.slug in ('junior-high-school', 'jhs-social-studies', 'level-jhs-2')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-EBS-SOC-B8-PB', 7500, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'ebs-social-studies-learners-book-8'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('jhs'), ('ghana'), ('textbook'), ('ebs'), ('nacca')) as t(tag)
where b.slug = 'ebs-social-studies-learners-book-8'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'ebs-social-studies-learners-book-8');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/ebs-social-studies-learners-book-8/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug = 'ebs-social-studies-learners-book-8';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'ebs-social-studies-learners-book-8'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
