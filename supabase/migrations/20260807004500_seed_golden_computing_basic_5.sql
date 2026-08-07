-- Catalog: Golden Computing Basic 5 (NaCCA Primary ICT)
-- Idempotent seed for authors, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('akosua-animah', 'Akosua Animah', 'Ghanaian', 'Co-author of the Golden Computing series for Ghana primary schools.', true),
  ('kwadwo-baafi', 'Kwadwo Baafi', 'Ghanaian', 'Co-author of the Golden Computing series for Ghana primary schools.', true)
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
  'golden-computing-basic-5',
  'Golden Computing Basic 5',
  'For Primary Schools · Based on NaCCA Syllabus',
  'Golden Computing Basic 5 is a primary school computing textbook based on the NaCCA syllabus. It builds digital literacy, computer skills, and foundational ICT knowledge for Basic 5 learners.',
  'Aligned with the National Council for Curriculum and Assessment (NaCCA) syllabus for Primary Schools. This Golden series title helps Basic 5 pupils strengthen computing skills through clear lessons and classroom-ready activities.',
  '978-9988-2-6805-3',
  144,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-computing-basic-5/front.jpg',
  'from-[#DC2626] via-[#16A34A] to-[#FACC15]',
  '#FDE047',
  array['Computing / ICT','Primary 5','Textbooks','NaCCA'],
  array['Computer Basics','Digital Literacy','Applications','Internet Safety'],
  true,
  true,
  jsonb_build_object('series','Golden','level','Basic 5','curriculum','NaCCA','subject','Computing')
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
select b.id, a.id, v.is_primary, v.sort_order
from public.books b
cross join (
  values
    ('akosua-animah', true, 0),
    ('kwadwo-baafi', false, 1)
) as v(author_slug, is_primary, sort_order)
join public.authors a on a.slug = v.author_slug
where b.slug = 'golden-computing-basic-5'
on conflict (book_id, author_id) do update set
  is_primary = excluded.is_primary,
  sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-computing-basic-5'
  and c.slug in ('primary-school', 'primary-computing-ict', 'level-primary-5')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-COMP-B5-PB',
  6000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-computing-basic-5'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('computing'), ('ict'), ('primary-5'), ('nacca'), ('golden'), ('textbook'), ('ghana')) as t(tag)
where b.slug = 'golden-computing-basic-5'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-computing-basic-5');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-computing-basic-5/front.jpg', 'Golden Computing Basic 5 front cover', 0, true),
    ('/covers/golden-computing-basic-5/angle.jpg', 'Golden Computing Basic 5 angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-computing-basic-5';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-computing-basic-5'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
