-- Catalog: Best Brain combined JHS titles at GH₵150.
-- Creative Arts and Design, and Mathematics, each covering Basics 7, 8 and 9.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('emmanuel-yeboah', 'Emmanuel Yeboah', 'Ghanaian', 'Co-author of Best Brain Creative Arts and Design for Basics 7, 8 and 9.', true),
  ('matthias-nsiah-opoku', 'Matthias Nsiah Opoku', 'Ghanaian', 'Co-author of Best Brain Creative Arts and Design for Basics 7, 8 and 9.', true),
  ('henric-atta-baah-yeboah', 'Henric Atta Baah-Yeboah', 'Ghanaian', 'Author of Best Brain Mathematics for Basics 7, 8 and 9.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'best-brain',
  'Best Brain',
  'Ghana',
  'Publisher of Best Brain textbooks for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'best-brain-creative-arts-and-design-for-basics-7-8-9',
        'Best Brain Creative Arts and Design for Basics 7, 8 & 9',
        'New Standard-Based Curriculum · NaCCA',
        'Best Brain Creative Arts and Design for Basics 7, 8 & 9 is a combined junior high textbook for the new NaCCA standard-based curriculum. It covers drawing, design, and creative practice across JHS 1 to JHS 3.',
        '978-9988-2-7046-9',
        'from-[#22C55E] via-[#EF4444] to-[#2563EB]',
        '#EF4444',
        'SKU-BESTBRAIN-CAD-789-PB',
        'Creative Arts and Design',
        'jhs-creative-arts-and-design'
      ),
      (
        'best-brain-mathematics-for-basics-7-8-9',
        'Best Brain Mathematics for Basics 7, 8 & 9',
        'New Standard-Based Curriculum · NaCCA',
        'Best Brain Mathematics for Basics 7, 8 & 9 is a combined junior high textbook for the new NaCCA standard-based curriculum. It covers number, algebra, geometry, and data across JHS 1 to JHS 3, with objective tests and theory questions.',
        '978-9988-2-7047-6',
        'from-[#001F3E] via-[#7C3AED] to-[#EF4444]',
        '#001F3E',
        'SKU-BESTBRAIN-MATH-789-PB',
        'Mathematics',
        'jhs-mathematics'
      )
    ) as v(slug, title, subtitle, description, isbn, gradient, accent, sku, subject, subject_slug)
  loop
    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      r.slug,
      r.title,
      r.subtitle,
      r.description,
      'Combined Best Brain title for Basics 7, 8 and 9, aligned with the new NaCCA standard-based curriculum.',
      r.isbn,
      240,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || r.slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[r.subject, 'JHS', 'NaCCA', 'Combined'],
      array['JHS 1 (Basic 7)', 'JHS 2 (Basic 8)', 'JHS 3 (Basic 9)'],
      true,
      true,
      jsonb_build_object(
        'series', 'Best Brain',
        'level', 'Basics 7, 8 & 9',
        'subject', r.subject,
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

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = r.slug
      and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', r.subject_slug)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 15000, null, 'GHS', 100, 0, 10, true
    from public.books b
    where b.slug = r.slug
    on conflict (book_id, format) do update set
      price_cents = excluded.price_cents,
      sku = excluded.sku,
      is_active = true,
      updated_at = timezone('utc', now());

    insert into public.book_tags (book_id, tag)
    select b.id, t.tag
    from public.books b
    cross join (values ('best-brain'), ('jhs'), ('combined'), ('nacca'), ('ghana'), ('basics-7-8-9')) as t(tag)
    where b.slug = r.slug
    on conflict do nothing;

    delete from public.book_images
    where book_id = (select id from public.books where slug = r.slug);

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select b.id, '/covers/' || r.slug || '/front.jpg', r.title || ' front cover', 0, true
    from public.books b
    where b.slug = r.slug;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = r.slug
      and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (a.slug = 'emmanuel-yeboah'),
  case a.slug when 'emmanuel-yeboah' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'best-brain-creative-arts-and-design-for-basics-7-8-9'
  and a.slug in ('emmanuel-yeboah', 'matthias-nsiah-opoku')
on conflict (book_id, author_id) do update
  set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, true, 0
from public.books b
cross join public.authors a
where b.slug = 'best-brain-mathematics-for-basics-7-8-9'
  and a.slug = 'henric-atta-baah-yeboah'
on conflict (book_id, author_id) do update set is_primary = true, sort_order = 0;
