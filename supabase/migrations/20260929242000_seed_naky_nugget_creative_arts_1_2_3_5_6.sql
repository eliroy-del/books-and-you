-- Catalog: Naky Nugget Series Creative Arts Learners' Books 1, 2, 3, 5 and 6 at GH₵85.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('oppong-k-christopher', 'Oppong K. Christopher', 'Ghanaian', 'Co-author of Naky Nugget Series Creative Arts textbooks for Ghanaian primary schools.', true),
  ('anning-karikari-gyebi', 'Anning Karikari-Gyebi', 'Ghanaian', 'Co-author of Naky Nugget Series Creative Arts textbooks for Ghanaian primary schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'naky-nugget',
  'Naky Nugget Series',
  'Ghana',
  'Publisher of Naky Nugget Series textbooks for Ghanaian basic schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
  book_slug text;
  book_title text;
begin
  for r in
    select * from (values
      (1, '978-9988-2-7083-4', 'from-[#EAB308] via-[#CA8A04] to-[#FDE68A]', '#EAB308', 'SKU-NAKY-CA-LB-1-PB', true),
      (2, '978-9988-2-7084-1', 'from-[#EA580C] via-[#C2410C] to-[#FDBA74]', '#EA580C', 'SKU-NAKY-CA-LB-2-PB', true),
      (3, '978-9988-2-7085-8', 'from-[#15803D] via-[#14532D] to-[#86EFAC]', '#15803D', 'SKU-NAKY-CA-LB-3-PB', true),
      (5, '978-9988-2-7086-5', 'from-[#2563EB] via-[#1E3A8A] to-[#93C5FD]', '#2563EB', 'SKU-NAKY-CA-LB-5-PB', false),
      (6, '978-9988-2-7087-2', 'from-[#DC2626] via-[#991B1B] to-[#FECACA]', '#DC2626', 'SKU-NAKY-CA-LB-6-PB', false)
    ) as v(level_n, isbn, gradient, accent, sku, revised)
  loop
    book_slug := 'naky-nugget-creative-arts-learners-book-' || r.level_n;
    book_title := 'Naky Nugget Series Creative Arts Learners'' Book ' || r.level_n;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      case when r.revised
        then 'Revised Edition · Based on the New Standard Based Curriculum'
        else 'Based on the New Standard Based Curriculum'
      end,
      book_title || ' is a primary school creative arts textbook from the Naky Nugget Series, based on the new standard based curriculum. It introduces learners to drawing, colour, craft, and creative expression through classroom activities.',
      'Part of the Naky Nugget Series Creative Arts range for primary schools. This Learners'' Book ' || r.level_n || ' supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      96,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['Creative Arts','Primary ' || r.level_n,'Naky Nugget','NaCCA'],
      array['Drawing and Colour','Craft Activities','Creative Expression','Projects'],
      true,
      true,
      jsonb_build_object(
        'series', 'Naky Nugget Series',
        'level', 'Primary ' || r.level_n,
        'subject', 'Creative Arts',
        'curriculum', 'NaCCA',
        'revised', r.revised
      )
    from public.publishers p
    where p.slug = 'naky-nugget'
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
    select b.id, a.id, (a.slug = 'oppong-k-christopher'),
      case a.slug when 'oppong-k-christopher' then 0 else 1 end
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and a.slug in ('oppong-k-christopher', 'anning-karikari-gyebi')
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
      and c.slug in ('primary-school', 'primary-creative-arts', 'level-primary-' || r.level_n)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 8500, null, 'GHS', 100, 0, 10, true
    from public.books b
    where b.slug = book_slug
    on conflict (book_id, format) do update set
      price_cents = excluded.price_cents,
      sku = excluded.sku,
      is_active = true,
      updated_at = timezone('utc', now());

    insert into public.book_tags (book_id, tag)
    select b.id, t.tag
    from public.books b
    cross join (values
      ('naky-nugget'),
      ('creative-arts'),
      ('art'),
      ('primary-' || r.level_n),
      ('nacca'),
      ('ghana'),
      ('textbook')
    ) as t(tag)
    where b.slug = book_slug
    on conflict do nothing;

    delete from public.book_images where book_id = (select id from public.books where slug = book_slug);

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select b.id, '/covers/' || book_slug || '/front.jpg', book_title || ' front cover', 0, true
    from public.books b
    where b.slug = book_slug;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = book_slug
      and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;
