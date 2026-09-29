-- Catalog: Golden Creative Arts Basic 1–5 at GH₵50.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('kwadwo-baafi', 'Kwadwo Baafi', 'Ghanaian', 'Co-author of Golden series textbooks for Ghanaian schools.', true),
  ('akosua-animah', 'Akosua Animah', 'Ghanaian', 'Co-author of Golden series textbooks for Ghanaian schools.', true)
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
  book_slug text;
  book_title text;
begin
  for r in
    select * from (values
      (1, '978-9988-2-7090-2', 'from-[#2563EB] via-[#1D4ED8] to-[#93C5FD]', '#2563EB', 'SKU-GOLDEN-CA-B1-PB'),
      (2, '978-9988-2-7091-9', 'from-[#EA580C] via-[#C2410C] to-[#FDBA74]', '#EA580C', 'SKU-GOLDEN-CA-B2-PB'),
      (3, '978-9988-2-7092-6', 'from-[#16A34A] via-[#15803D] to-[#86EFAC]', '#16A34A', 'SKU-GOLDEN-CA-B3-PB'),
      (4, '978-9988-2-7093-3', 'from-[#7C3AED] via-[#5B21B6] to-[#DDD6FE]', '#7C3AED', 'SKU-GOLDEN-CA-B4-PB'),
      (5, '978-9988-2-7094-0', 'from-[#DC2626] via-[#991B1B] to-[#FECACA]', '#DC2626', 'SKU-GOLDEN-CA-B5-PB')
    ) as v(level_n, isbn, gradient, accent, sku)
  loop
    book_slug := 'golden-creative-arts-basic-' || r.level_n;
    book_title := 'Golden Creative Arts Basic ' || r.level_n;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      'For Primary Schools · Golden Series',
      book_title || ' is a Golden series primary creative arts textbook for Basic ' || r.level_n || '. It introduces learners to drawing, colour, craft, and creative expression through classroom activities.',
      'Part of the Golden Creative Arts range for primary schools. This Basic ' || r.level_n || ' title supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      80,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['Creative Arts','Primary ' || r.level_n,'Golden','Art'],
      array['Drawing and Colour','Craft Activities','Creative Expression'],
      true,
      true,
      jsonb_build_object(
        'series', 'Golden',
        'level', 'Basic ' || r.level_n,
        'subject', 'Creative Arts',
        'curriculum', 'NaCCA'
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
    select b.id, a.id, (a.slug = 'kwadwo-baafi'),
      case a.slug when 'kwadwo-baafi' then 0 else 1 end
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and a.slug in ('kwadwo-baafi', 'akosua-animah')
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
    select b.id, 'paperback'::public.book_format, r.sku, 5000, null, 'GHS', 100, 0, 10, true
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
      ('golden'),
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
