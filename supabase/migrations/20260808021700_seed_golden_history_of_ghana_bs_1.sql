-- Catalog: Golden History of Ghana BS 1 (NaCCA Primary History)
-- Idempotent seed for author, book, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified)
values (
  'mercy-gyaa-adiyiah',
  'Mercy Gyaa-Adiyiah',
  'Ghanaian',
  'Author of the Golden History of Ghana series for basic schools, aligned with the NaCCA syllabus.',
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
  'golden-history-of-ghana-bs-1',
  'Golden History of Ghana BS 1',
  'Based on the New NaCCA Syllabus',
  'Golden History of Ghana BS 1 is a primary school history textbook based on the new NaCCA syllabus. It introduces Basic 1 learners to Ghana''s story, people, and community life through clear lessons and classroom activities.',
  'Aligned with the National Council for Curriculum and Assessment (NaCCA) syllabus for Primary School. This Golden series title helps Basic 1 pupils explore the history of Ghana with age-appropriate content.',
  '978-9988-2-6901-9',
  120,
  'English',
  '2024-01-01',
  p.id,
  '/covers/golden-history-of-ghana-bs-1/front.jpg',
  'from-[#0F766E] via-[#FACC15] to-[#EA580C]',
  '#DC2626',
  array['History','Primary 1','Textbooks','NaCCA'],
  array['Our Community','People Around Us','National Life','Everyday History'],
  true,
  true,
  jsonb_build_object('series','Golden','level','BS 1','curriculum','NaCCA','subject','History')
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
where b.slug = 'golden-history-of-ghana-bs-1'
  and a.slug = 'mercy-gyaa-adiyiah'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id
from public.books b
cross join public.categories c
where b.slug = 'golden-history-of-ghana-bs-1'
  and c.slug in ('primary-school', 'primary-history', 'level-primary-1')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select
  b.id,
  'paperback'::public.book_format,
  'SKU-GOLDEN-HIST-BS1-PB',
  5000,
  null,
  'GHS',
  100,
  0,
  10,
  true
from public.books b
where b.slug = 'golden-history-of-ghana-bs-1'
on conflict (book_id, format) do update set
  price_cents = excluded.price_cents,
  compare_at_cents = excluded.compare_at_cents,
  sku = excluded.sku,
  is_active = true,
  updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag
from public.books b
cross join (values ('history'), ('primary-1'), ('nacca'), ('golden'), ('textbook'), ('ghana')) as t(tag)
where b.slug = 'golden-history-of-ghana-bs-1'
on conflict do nothing;

delete from public.book_images
where book_id = (select id from public.books where slug = 'golden-history-of-ghana-bs-1');

insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, v.url, v.alt_text, v.sort_order, v.is_primary
from public.books b
cross join (
  values
    ('/covers/golden-history-of-ghana-bs-1/front.jpg', 'Golden History of Ghana BS 1 front cover', 0, true),
    ('/covers/golden-history-of-ghana-bs-1/angle.jpg', 'Golden History of Ghana BS 1 angled view', 1, false)
) as v(url, alt_text, sort_order, is_primary)
where b.slug = 'golden-history-of-ghana-bs-1';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0
from public.collections c
cross join public.books b
where b.slug = 'golden-history-of-ghana-bs-1'
  and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
