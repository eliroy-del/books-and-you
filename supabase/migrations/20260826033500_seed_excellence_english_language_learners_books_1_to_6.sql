-- Catalog: Excellence English Language for Basic Schools Learner's Books 1–6
-- Idempotent seed for authors, publisher, books, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('francis-benjamin-appiah', 'Francis Benjamin Appiah', 'Ghanaian', 'Co-author of Excellence English Language textbooks for Ghanaian basic schools.', true),
  ('dennis-nsafoah', 'Dennis Nsafoah', 'Ghanaian', 'Co-author of Excellence English Language textbooks for Ghanaian basic schools.', true),
  ('faustina-appiah', 'Faustina Appiah', 'Ghanaian', 'Co-author of Excellence English Language textbooks for Ghanaian basic schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'excellence',
  'Excellence',
  'Ghana',
  'Publisher of the Excellence English Language series for Ghanaian basic schools.'
)
on conflict (slug) do update set name = excluded.name;

-- Seed each level via a shared pattern
do $$
declare
  r record;
begin
  for r in
    select * from (values
      (1, '978-9988-2-7017-9', 'from-[#9D174D] via-[#BE185D] to-[#F472B6]', '#BE185D', 'SKU-EXCEL-ENG-LB1-PB'),
      (2, '978-9988-2-7018-6', 'from-[#166534] via-[#15803D] to-[#86EFAC]', '#166534', 'SKU-EXCEL-ENG-LB2-PB'),
      (3, '978-9988-2-7019-3', 'from-[#78350F] via-[#92400E] to-[#FBBF24]', '#78350F', 'SKU-EXCEL-ENG-LB3-PB'),
      (4, '978-9988-2-7020-9', 'from-[#DC2626] via-[#EA580C] to-[#FBBF24]', '#DC2626', 'SKU-EXCEL-ENG-LB4-PB'),
      (5, '978-9988-2-7021-6', 'from-[#7F1D1D] via-[#991B1B] to-[#F87171]', '#7F1D1D', 'SKU-EXCEL-ENG-LB5-PB'),
      (6, '978-9988-2-7022-3', 'from-[#001F3E] via-[#1E3A5F] to-[#EFC076]', '#001F3E', 'SKU-EXCEL-ENG-LB6-PB')
    ) as v(level_n, isbn, gradient, accent, sku)
  loop
    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      'excellence-english-language-for-basic-schools-learners-book-' || r.level_n,
      'Excellence English Language for Basic Schools Learner''s Book ' || r.level_n,
      'Based on the New NaCCA Standards-Based Curriculum',
      'Excellence English Language for Basic Schools Learner''s Book ' || r.level_n ||
        ' is a primary school English textbook based on the new NaCCA Standards-Based Curriculum. It builds grammar, phonics, literature, reading comprehension, and penmanship through clear lessons and classroom activities.',
      'Part of the Excellence English Language series for basic schools. This Learner''s Book ' || r.level_n ||
        ' supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      144,
      'English',
      '2024-01-01',
      p.id,
      '/covers/excellence-english-language-for-basic-schools-learners-book-' || r.level_n || '/front.jpg',
      r.gradient,
      r.accent,
      array['English Language','Primary ' || r.level_n,'NaCCA','Basic Schools'],
      array['Grammar Usage','Phonics','Literature','Reading and Comprehension','Penmanship'],
      true,
      true,
      jsonb_build_object(
        'series', 'Excellence English Language',
        'level', 'Basic ' || r.level_n,
        'subject', 'English Language',
        'curriculum', 'NaCCA'
      )
    from public.publishers p
    where p.slug = 'excellence'
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
    select b.id, a.id, (a.slug = 'francis-benjamin-appiah'),
      case a.slug
        when 'francis-benjamin-appiah' then 0
        when 'dennis-nsafoah' then 1
        else 2
      end
    from public.books b
    cross join public.authors a
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
      and a.slug in ('francis-benjamin-appiah', 'dennis-nsafoah', 'faustina-appiah')
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
      and c.slug in ('primary-school', 'primary-english-language', 'level-primary-' || r.level_n)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select
      b.id,
      'paperback'::public.book_format,
      r.sku,
      7000,
      null,
      'GHS',
      100,
      0,
      10,
      true
    from public.books b
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
    on conflict (book_id, format) do update set
      price_cents = excluded.price_cents,
      compare_at_cents = excluded.compare_at_cents,
      sku = excluded.sku,
      is_active = true,
      updated_at = timezone('utc', now());

    insert into public.book_tags (book_id, tag)
    select b.id, t.tag
    from public.books b
    cross join (values
      ('english'),
      ('english-language'),
      ('excellence'),
      ('nacca'),
      ('ghana'),
      ('primary-' || r.level_n),
      ('basic-' || r.level_n)
    ) as t(tag)
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
    on conflict do nothing;

    delete from public.book_images
    where book_id = (
      select id from public.books
      where slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
    );

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select
      b.id,
      '/covers/excellence-english-language-for-basic-schools-learners-book-' || r.level_n || '/front.jpg',
      'Excellence English Language for Basic Schools Learner''s Book ' || r.level_n || ' front cover',
      0,
      true
    from public.books b
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = 'excellence-english-language-for-basic-schools-learners-book-' || r.level_n
      and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;
