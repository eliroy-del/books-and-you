-- Catalog: Science for Basic Schools Learner's Book 3
-- Idempotent seed for authors, publisher, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('francis-benjamin-appiah', 'Francis Benjamin Appiah', 'Ghanaian', 'Co-author of Science for Basic Schools textbooks aligned with the NaCCA curriculum.', true),
  ('derrick-appiah', 'Derrick Appiah', 'Ghanaian', 'Co-author of Science for Basic Schools textbooks aligned with the NaCCA curriculum.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'eps',
  'EPS',
  'Ghana',
  'Educational publisher of Science for Basic Schools learner books for Ghanaian primary schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'science-for-basic-schools-learners-book-3',
  'Science for Basic Schools Learner''s Book 3',
  'Based on the New NaCCA Standards-Based Curriculum · Revised Edition',
  'Science for Basic Schools Learner''s Book 3 is a primary school science textbook based on the new NaCCA Standards-Based Curriculum. It helps Basic 3 learners explore everyday science through clear lessons, activities, and illustrations.',
  'Part of the Science for Basic Schools series. This Learner''s Book 3 supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7016-2',
  120,
  'English',
  '2024-01-01',
  p.id,
  '/covers/science-for-basic-schools-learners-book-3/front.jpg',
  'from-[#DC2626] via-[#FFFFFF] to-[#F59E0B]',
  '#DC2626',
  array['Science','Primary 3','NaCCA','Basic Schools'],
  array['Living Things','Materials','Forces and Energy','Earth and Space','Science Skills'],
  true,
  true,
  jsonb_build_object('series','Science for Basic Schools','level','Basic 3','subject','Science','curriculum','NaCCA','edition','Revised')
from public.publishers p
where p.slug = 'eps'
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
where b.slug = 'science-for-basic-schools-learners-book-3'
  and a.slug = 'francis-benjamin-appiah'
on conflict (book_id, author_id) do update set is_primary = true, sort_order = 0;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, false, 1
from public.books b
cross join public.authors a
where b.slug = 'science-for-basic-schools-learners-book-3'
  and a.slug = 'derrick-appiah'
on conflict (book_id, author_id) do update set is_primary = false, sort_order = 1;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'science-for-basic-schools-learners-book-3'
  and c.slug in ('primary-school', 'primary-science', 'level-primary-3')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-SCIENCE-BASIC-LB3-PB',
  6000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'science-for-basic-schools-learners-book-3'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('science'), ('primary-3'), ('basic-3'), ('eps'), ('nacca'), ('ghana')) as t(tag)
where b.slug = 'science-for-basic-schools-learners-book-3'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'science-for-basic-schools-learners-book-3');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/science-for-basic-schools-learners-book-3/front.jpg', 'Science for Basic Schools Learner''s Book 3 front cover', 0, true)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'science-for-basic-schools-learners-book-3';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'science-for-basic-schools-learners-book-3'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
