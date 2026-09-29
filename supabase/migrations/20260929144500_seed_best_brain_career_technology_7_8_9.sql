-- Catalog: Best Brain Career Technology for Basics 7, 8 & 9 at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('angelina-anima-kwarkye', 'Angelina Anima Kwarkye', 'Ghanaian', 'Co-author of Best Brain Career Technology for Basics 7, 8 and 9.', true),
  ('ophelia-baah-ampomah', 'Ophelia Baah Ampomah', 'Ghanaian', 'Co-author of Best Brain Career Technology for Basics 7, 8 and 9.', true),
  ('henric-atta-baah-yeboah', 'Henric Atta Baah-Yeboah', 'Ghanaian', 'Author of Best Brain combined textbooks for junior high schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'best-brain',
  'Best Brain',
  'Ghana',
  'Publisher of Best Brain textbooks for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'best-brain-career-technology-for-basics-7-8-9',
  'Best Brain Career Technology for Basics 7, 8 & 9',
  'New Standard-Based Curriculum · NaCCA',
  'Best Brain Career Technology for Basics 7, 8 & 9 is a combined junior high textbook for the new NaCCA standard-based curriculum. It covers practical skills, design, and technology across JHS 1 to JHS 3.',
  'Combined Best Brain title for Basics 7, 8 and 9, aligned with the new NaCCA standard-based curriculum.',
  '978-9988-2-7048-3',
  240,
  'English',
  '2024-01-01',
  p.id,
  '/covers/best-brain-career-technology-for-basics-7-8-9/front.jpg',
  'from-[#EF4444] via-[#001F3E] to-[#F97316]',
  '#EF4444',
  array['Career Technology','JHS','NaCCA','Combined'],
  array['JHS 1 (Basic 7)','JHS 2 (Basic 8)','JHS 3 (Basic 9)'],
  true,
  true,
  jsonb_build_object(
    'series', 'Best Brain',
    'level', 'Basics 7, 8 & 9',
    'subject', 'Career Technology',
    'curriculum', 'NaCCA'
  )
from public.publishers p
where p.slug = 'best-brain'
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
select b.id, a.id, (a.slug = 'angelina-anima-kwarkye'),
  case a.slug
    when 'angelina-anima-kwarkye' then 0
    when 'ophelia-baah-ampomah' then 1
    else 2
  end
from public.books b
cross join public.authors a
where b.slug = 'best-brain-career-technology-for-basics-7-8-9'
  and a.slug in ('angelina-anima-kwarkye', 'ophelia-baah-ampomah', 'henric-atta-baah-yeboah')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'best-brain-career-technology-for-basics-7-8-9'
  and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', 'jhs-career-technology')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-BESTBRAIN-CT-789-PB', 15000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug = 'best-brain-career-technology-for-basics-7-8-9'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('best-brain'), ('jhs'), ('combined'), ('nacca'), ('ghana'), ('basics-7-8-9'), ('career-technology')) as t(tag)
where b.slug = 'best-brain-career-technology-for-basics-7-8-9'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'best-brain-career-technology-for-basics-7-8-9');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/best-brain-career-technology-for-basics-7-8-9/front.jpg',
  'Best Brain Career Technology for Basics 7, 8 & 9 front cover', 0, true
from public.books b
where b.slug = 'best-brain-career-technology-for-basics-7-8-9';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'best-brain-career-technology-for-basics-7-8-9'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
