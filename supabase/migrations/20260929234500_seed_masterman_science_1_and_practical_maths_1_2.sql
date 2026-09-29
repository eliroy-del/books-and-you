-- Catalog: Masterman New Age Science 1 and Practical Mathematics 1–2 at GH₵60.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('j-k-adoku', 'J. K. Adoku', 'Ghanaian', 'Co-author of Masterman New Age Science for Basic Schools.', true),
  ('b-s-amu', 'B. S. Amu', 'Ghanaian', 'Co-author of Masterman New Age Science for Basic Schools.', true),
  ('e-e-k-gala', 'E.E.K. Gala', 'Ghanaian', 'Co-author of Masterman New Age Science for Basic Schools.', true),
  ('douglas-owusu-achiaw', 'Douglas Owusu-Achiaw', 'Ghanaian', 'Co-author of Masterman Practical Mathematics for Basic Schools.', true),
  ('roger-nortey', 'Roger Nortey', 'Ghanaian', 'Co-author of Masterman Practical Mathematics for Basic Schools.', true),
  ('samuel-adjei-oduro', 'Samuel Adjei Oduro', 'Ghanaian', 'Co-author of Masterman Practical Mathematics for Basic Schools.', true)
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
  'masterman-new-age-science-for-basic-schools-1',
  'New Age Science Basic 1',
  'Masterman · For Basic Schools · Based on the 2019 New Curriculum',
  'New Age Science Basic 1 is a Masterman primary science textbook for Basic Schools, based on the 2019 new curriculum. It introduces Basic 1 learners to everyday science through clear lessons and activities.',
  'Part of the Masterman New Age Science series. This Basic 1 title supports classroom learning aligned with the 2019 new curriculum.',
  '978-9988-2-7059-9',
  128,
  'English',
  '2019-01-01',
  p.id,
  '/covers/masterman-new-age-science-for-basic-schools-1/front.jpg',
  'from-[#FACC15] via-[#111827] to-[#CA8A04]',
  '#FACC15',
  array['Science','Primary 1','Masterman','2019 Curriculum'],
  array['Lessons','Activities','Review'],
  true,
  true,
  jsonb_build_object('series','New Age Science','level','Basic 1','subject','Science','curriculum','2019 New Curriculum')
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

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'masterman-practical-mathematics-for-basic-schools-1',
  'Practical Mathematics Basic 1',
  'Masterman · For Basic Schools · Based on the 2019 New Curriculum',
  'Practical Mathematics Basic 1 is a Masterman primary mathematics textbook for Basic Schools, based on the 2019 new curriculum. It builds number sense and problem-solving for Basic 1 learners.',
  'Part of the Masterman Practical Mathematics series. This Basic 1 title supports classroom learning aligned with the 2019 new curriculum.',
  '978-9988-2-7060-5',
  144,
  'English',
  '2019-01-01',
  p.id,
  '/covers/masterman-practical-mathematics-for-basic-schools-1/front.jpg',
  'from-[#16A34A] via-[#14532D] to-[#FACC15]',
  '#16A34A',
  array['Mathematics','Primary 1','Masterman','2019 Curriculum'],
  array['Lessons','Practice','Review'],
  true,
  true,
  jsonb_build_object('series','Practical Mathematics','level','Basic 1','subject','Mathematics','curriculum','2019 New Curriculum')
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

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'masterman-practical-mathematics-for-basic-schools-2',
  'Practical Mathematics Basic 2',
  'Masterman · For Basic Schools · Based on the 2019 New Curriculum',
  'Practical Mathematics Basic 2 is a Masterman primary mathematics textbook for Basic Schools, based on the 2019 new curriculum. It builds number sense and problem-solving for Basic 2 learners.',
  'Part of the Masterman Practical Mathematics series. This Basic 2 title supports classroom learning aligned with the 2019 new curriculum.',
  '978-9988-2-7061-2',
  144,
  'English',
  '2019-01-01',
  p.id,
  '/covers/masterman-practical-mathematics-for-basic-schools-2/front.jpg',
  'from-[#DB2777] via-[#9D174D] to-[#FACC15]',
  '#DB2777',
  array['Mathematics','Primary 2','Masterman','2019 Curriculum'],
  array['Lessons','Practice','Review'],
  true,
  true,
  jsonb_build_object('series','Practical Mathematics','level','Basic 2','subject','Mathematics','curriculum','2019 New Curriculum')
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
select b.id, a.id, (a.slug = 'j-k-adoku'),
  case a.slug
    when 'j-k-adoku' then 0
    when 'b-s-amu' then 1
    else 2
  end
from public.books b
cross join public.authors a
where b.slug = 'masterman-new-age-science-for-basic-schools-1'
  and a.slug in ('j-k-adoku', 'b-s-amu', 'e-e-k-gala')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (a.slug = 'douglas-owusu-achiaw'),
  case a.slug
    when 'douglas-owusu-achiaw' then 0
    when 'roger-nortey' then 1
    else 2
  end
from public.books b
cross join public.authors a
where b.slug in (
    'masterman-practical-mathematics-for-basic-schools-1',
    'masterman-practical-mathematics-for-basic-schools-2'
  )
  and a.slug in ('douglas-owusu-achiaw', 'roger-nortey', 'samuel-adjei-oduro')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'masterman-new-age-science-for-basic-schools-1'
  and c.slug in ('primary-school', 'primary-science', 'level-primary-1')
on conflict do nothing;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'masterman-practical-mathematics-for-basic-schools-1'
  and c.slug in ('primary-school', 'primary-mathematics', 'level-primary-1')
on conflict do nothing;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'masterman-practical-mathematics-for-basic-schools-2'
  and c.slug in ('primary-school', 'primary-mathematics', 'level-primary-2')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format,
  case b.slug
    when 'masterman-new-age-science-for-basic-schools-1' then 'SKU-MASTERMAN-NAS-1-PB'
    when 'masterman-practical-mathematics-for-basic-schools-1' then 'SKU-MASTERMAN-PM-1-PB'
    else 'SKU-MASTERMAN-PM-2-PB'
  end,
  6000, null, 'GHS', 100, 0, 10, true
from public.books b
where b.slug in (
  'masterman-new-age-science-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-2'
)
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('masterman'), ('science'), ('primary-1'), ('curriculum'), ('ghana')) as t(tag)
where b.slug = 'masterman-new-age-science-for-basic-schools-1'
on conflict do nothing;

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('masterman'), ('mathematics'), ('primary-1'), ('curriculum'), ('ghana')) as t(tag)
where b.slug = 'masterman-practical-mathematics-for-basic-schools-1'
on conflict do nothing;

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('masterman'), ('mathematics'), ('primary-2'), ('curriculum'), ('ghana')) as t(tag)
where b.slug = 'masterman-practical-mathematics-for-basic-schools-2'
on conflict do nothing;

delete from public.book_images
where book_id in (
  select id from public.books where slug in (
    'masterman-new-age-science-for-basic-schools-1',
    'masterman-practical-mathematics-for-basic-schools-1',
    'masterman-practical-mathematics-for-basic-schools-2'
  )
);

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/' || b.slug || '/front.jpg', b.title || ' front cover', 0, true
from public.books b
where b.slug in (
  'masterman-new-age-science-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-2'
);

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug in (
  'masterman-new-age-science-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-1',
  'masterman-practical-mathematics-for-basic-schools-2'
)
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
