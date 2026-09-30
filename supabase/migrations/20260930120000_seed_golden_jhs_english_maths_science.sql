-- Catalog: Golden English JHS 1, Mathematics JHS 2, and Science JHS 2 at GH₵70.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('okyere-baafi-alexander', 'Okyere Baafi Alexander', 'Ghanaian', 'Author of Golden series textbooks for Ghanaian schools.', true),
  ('kwaku-okyere', 'Kwaku Okyere', 'Ghanaian', 'Author of Golden series mathematics textbooks for Ghanaian schools.', true),
  ('akwasi-nkansah', 'Akwasi Nkansah', 'Ghanaian', 'Author of Golden Science textbooks for junior high schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'new-golden-publications',
  'New Golden Publications',
  'Ghana',
  'Kumasi-based educational publisher of the Golden series for primary schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'golden-english-literacy-jhs-1',
        'Golden English (Literacy) JHS 1',
        'For Junior High Schools · Based on the Common Core Curriculum',
        'Golden English (Literacy) JHS 1 is a junior high English textbook based on the Common Core Curriculum. It covers oral language, reading, grammar usage, writing, and literature for JHS 1.',
        '978-9988-2-7096-4',
        'from-[#EA580C] via-[#1E3A8A] to-[#F8FAFC]',
        '#EA580C',
        'SKU-GOLDEN-ENG-JHS1-PB',
        'English',
        'jhs-english-language',
        'level-jhs-1',
        'okyere-baafi-alexander'
      ),
      (
        'golden-mathematics-jhs-2',
        'Golden Mathematics JHS 2 (B8)',
        'Common Core Programme · Junior High School 2',
        'Golden Mathematics JHS 2 (B8) is a junior high mathematics textbook based on the Common Core Programme. It supports JHS 2 learners with number, geometry, and data topics aligned to the Common Core Curriculum.',
        '978-9988-2-7097-1',
        'from-[#15803D] via-[#DC2626] to-[#F8FAFC]',
        '#DC2626',
        'SKU-GOLDEN-MATH-JHS2-PB',
        'Mathematics',
        'jhs-mathematics',
        'level-jhs-2',
        'kwaku-okyere'
      ),
      (
        'golden-science-jhs-2',
        'Golden Science JHS 2',
        'For Junior High Schools · Based on the Common Core Curriculum',
        'Golden Science JHS 2 is a junior high science textbook based on the Common Core Curriculum. It supports JHS 2 learners with clear lessons aligned to the Common Core Programme.',
        '978-9988-2-7098-8',
        'from-[#1D4ED8] via-[#0EA5E9] to-[#F8FAFC]',
        '#1D4ED8',
        'SKU-GOLDEN-SCI-JHS2-PB',
        'Science',
        'jhs-science',
        'level-jhs-2',
        'akwasi-nkansah'
      )
    ) as v(book_slug, book_title, subtitle, description, isbn, gradient, accent, sku, subject, subject_slug, level_slug, author_slug)
  loop
    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      r.book_slug,
      r.book_title,
      r.subtitle,
      r.description,
      'Part of the Golden series for junior high schools. This ' || r.subject || ' title is based on the Common Core Curriculum.',
      r.isbn,
      176,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || r.book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[r.subject, 'JHS', 'Golden', 'Common Core'],
      array['Lessons','Practice'],
      true,
      true,
      jsonb_build_object(
        'series', 'Golden',
        'subject', r.subject,
        'curriculum', 'Common Core Programme'
      )
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
    where b.slug = r.book_slug
      and a.slug = r.author_slug
    on conflict (book_id, author_id) do update
      set is_primary = true, sort_order = 0;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = r.book_slug
      and c.slug in ('junior-high-school', r.subject_slug, r.level_slug)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 7000, null, 'GHS', 100, 0, 10, true
    from public.books b
    where b.slug = r.book_slug
    on conflict (book_id, format) do update set
      price_cents = excluded.price_cents,
      sku = excluded.sku,
      is_active = true,
      updated_at = timezone('utc', now());

    insert into public.book_tags (book_id, tag)
    select b.id, t.tag
    from public.books b
    cross join (values
      ('golden'),
      ('jhs'),
      ('common-core'),
      ('ghana'),
      ('textbook')
    ) as t(tag)
    where b.slug = r.book_slug
    on conflict do nothing;

    delete from public.book_images where book_id = (select id from public.books where slug = r.book_slug);

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select b.id, '/covers/' || r.book_slug || '/front.jpg', r.book_title || ' front cover', 0, true
    from public.books b
    where b.slug = r.book_slug;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = r.book_slug
      and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;
