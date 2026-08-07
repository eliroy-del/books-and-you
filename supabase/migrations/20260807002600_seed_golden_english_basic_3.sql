-- Catalog: Golden English Basic 3 (NaCCA Primary English)
-- Idempotent seed for book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'okyere-baafi-alexander',
  'Okyere Baafi Alexander',
  'Ghanaian',
  'Author of the Golden English series for Ghana primary schools, aligned with the NaCCA syllabus.',
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
  'golden-english-basic-3',
  'Golden English Basic 3',
  'Comprehension · Grammar · Listening and Speaking · Writing',
  'Golden English Basic 3 is a primary school English language textbook based on the NaCCA syllabus. It covers comprehension, grammar, listening and speaking, and writing to help pupils succeed in communication.',
  'Developed in accordance with the English syllabus issued by the National Council for Curriculum and Assessment (NaCCA) for Primary School. This Golden series title helps Basic 3 pupils strengthen comprehension, grammar, listening and speaking, and writing skills.',
  '978-9988-2-6614-1',
  148,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-english-basic-3/front.jpg',
  'from-[#65A30D] via-[#F97316] to-[#0F172A]',
  '#FBBF24',
  array['English Language','Primary 3','Textbooks','NaCCA'],
  array['Comprehension','Grammar','Listening and Speaking','Writing'],
  true,
  true,
  jsonb_build_object('series','Golden','level','Basic 3','curriculum','NaCCA','subject','English Language')
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
where b.slug = 'golden-english-basic-3'
  and a.slug = 'okyere-baafi-alexander'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-english-basic-3'
  and c.slug in ('primary-school', 'primary-english-language', 'level-primary-3')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-ENG-B3-PB',
  7000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-english-basic-3'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('english'), ('primary-3'), ('nacca'), ('golden'), ('textbook'), ('ghana')) as t(tag)
where b.slug = 'golden-english-basic-3'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-english-basic-3');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-english-basic-3/front.jpg', 'Golden English Basic 3 front cover', 0, true),
    ('/covers/golden-english-basic-3/angle.jpg', 'Golden English Basic 3 angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-english-basic-3';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-english-basic-3'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
