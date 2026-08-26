-- Catalog: Alpha Creative Arts Learners' Books 1–3
-- Idempotent seed for authors, publisher, books, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('kwasi-agyekum-hene', 'Kwasi Agyekum-Hene', 'Ghanaian', 'Co-author of Alpha Creative Arts textbooks for Ghanaian primary schools.', true),
  ('kwabena-nyanor-aboraa', 'Kwabena Nyanor Aboraa', 'Ghanaian', 'Co-author of Alpha Creative Arts textbooks for Ghanaian primary schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'alpha',
  'Alpha',
  'Ghana',
  'Publisher of the Alpha Creative Arts series for Ghanaian primary schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (1, '978-9988-2-7028-5', 'from-[#38BDF8] via-[#F97316] to-[#22C55E]', '#0EA5E9', 'SKU-ALPHA-CA-LB1-PB'),
      (2, '978-9988-2-7029-2', 'from-[#FACC15] via-[#EF4444] to-[#166534]', '#EAB308', 'SKU-ALPHA-CA-LB2-PB'),
      (3, '978-9988-2-7030-8', 'from-[#84CC16] via-[#EF4444] to-[#166534]', '#65A30D', 'SKU-ALPHA-CA-LB3-PB')
    ) as v(level_n, isbn, gradient, accent, sku)
  loop
    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      'alpha-creative-arts-learners-book-' || r.level_n,
      'Alpha Creative Arts Learners'' Book ' || r.level_n,
      'A Learner Centred Book · Based on the New NaCCA Standards-Based Curriculum',
      'Alpha Creative Arts Learners'' Book ' || r.level_n ||
        ' is a primary school creative arts textbook based on the new NaCCA Standards-Based Curriculum. It introduces learners to drawing, colour, craft, and creative expression through learner-centred activities.',
      'Part of the Alpha Creative Arts series for primary schools. This Learners'' Book ' || r.level_n ||
        ' supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      96,
      'English',
      '2024-01-01',
      p.id,
      '/covers/alpha-creative-arts-learners-book-' || r.level_n || '/front.jpg',
      r.gradient,
      r.accent,
      array['Creative Arts','Primary ' || r.level_n,'NaCCA','Art'],
      array['Drawing and Colour','Craft Activities','Music and Movement','Creative Expression','Projects'],
      true,
      true,
      jsonb_build_object(
        'series', 'Alpha Creative Arts',
        'level', 'Primary ' || r.level_n,
        'subject', 'Creative Arts',
        'curriculum', 'NaCCA'
      )
    from public.publishers p
    where p.slug = 'alpha'
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
    select b.id, a.id, (a.slug = 'kwasi-agyekum-hene'),
      case a.slug when 'kwasi-agyekum-hene' then 0 else 1 end
    from public.books b
    cross join public.authors a
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n
      and a.slug in ('kwasi-agyekum-hene', 'kwabena-nyanor-aboraa')
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n
      and c.slug in ('primary-school', 'primary-creative-arts', 'level-primary-' || r.level_n)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select
      b.id,
      'paperback'::public.book_format,
      r.sku,
      6000,
      null,
      'GHS',
      100,
      0,
      10,
      true
    from public.books b
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n
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
      ('creative-arts'),
      ('art'),
      ('alpha'),
      ('nacca'),
      ('ghana'),
      ('primary-' || r.level_n)
    ) as t(tag)
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n
    on conflict do nothing;

    delete from public.book_images
    where book_id = (
      select id from public.books
      where slug = 'alpha-creative-arts-learners-book-' || r.level_n
    );

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select
      b.id,
      '/covers/alpha-creative-arts-learners-book-' || r.level_n || '/front.jpg',
      'Alpha Creative Arts Learners'' Book ' || r.level_n || ' front cover',
      0,
      true
    from public.books b
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = 'alpha-creative-arts-learners-book-' || r.level_n
      and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;
