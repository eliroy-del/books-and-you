-- Catalog: Don Series French Premier Textbook 1, 3, 4, 5 and 6 at GH₵65.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('donsimon-quarshie-attipoe', 'Donsimon Quarshie Attipoe', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('raphael-awindaniko', 'Raphael Awindaniko', 'Ghanaian', 'Co-author of Don Series French Premier textbooks for lower primary.', true),
  ('norvianyo-dordzeavudzi', 'Norvianyo Dordzeavudzi', 'Ghanaian', 'Co-author of Don Series French Premier textbooks for upper primary.', true),
  ('alassan-safiou', 'Alassan Safiou', 'Ghanaian', 'Co-author of Don Series French Premier textbooks for upper primary.', true),
  ('margaret-dela-tetteh', 'Margaret Dela Tetteh', 'Ghanaian', 'Co-author of Don Series French Premier textbooks for upper primary.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'don-series',
  'Don Series',
  'Ghana',
  'Publisher of Don Series Premier textbooks for Ghanaian basic schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
  book_slug text;
  book_title text;
  author_slugs text[];
begin
  for r in
    select * from (values
      (1, '978-9988-2-7074-2', 'from-[#1D4ED8] via-[#1E3A8A] to-[#FACC15]', '#1D4ED8', 'SKU-DON-FR-TB-1-PB', array['donsimon-quarshie-attipoe','raphael-awindaniko']),
      (3, '978-9988-2-7075-9', 'from-[#2563EB] via-[#1E40AF] to-[#93C5FD]', '#2563EB', 'SKU-DON-FR-TB-3-PB', array['donsimon-quarshie-attipoe','raphael-awindaniko']),
      (4, '978-9988-2-7076-6', 'from-[#7C3AED] via-[#5B21B6] to-[#FACC15]', '#7C3AED', 'SKU-DON-FR-TB-4-PB', array['norvianyo-dordzeavudzi','alassan-safiou','margaret-dela-tetteh']),
      (5, '978-9988-2-7077-3', 'from-[#9F1239] via-[#7F1D1D] to-[#FACC15]', '#9F1239', 'SKU-DON-FR-TB-5-PB', array['norvianyo-dordzeavudzi','alassan-safiou','margaret-dela-tetteh']),
      (6, '978-9988-2-7078-0', 'from-[#15803D] via-[#14532D] to-[#86EFAC]', '#15803D', 'SKU-DON-FR-TB-6-PB', array['norvianyo-dordzeavudzi','alassan-safiou','margaret-dela-tetteh'])
    ) as v(level_n, isbn, gradient, accent, sku, authors)
  loop
    book_slug := 'don-series-french-premier-textbook-' || r.level_n;
    book_title := 'Don Series French Premier Textbook ' || r.level_n;
    author_slugs := r.authors;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      'For Basic Schools · NaCCA Approved Standard Based Curriculum',
      book_title || ' is a Don Series primary French textbook based on the NaCCA approved standard based curriculum. It builds dialogue, comprehension, vocabulary, grammar, and composition for Basic ' || r.level_n || '.',
      'Part of the Don Series Premier French range for basic schools. This Basic ' || r.level_n || ' textbook supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      144,
      'French',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['French','Primary ' || r.level_n,'Don Series','NaCCA'],
      array['Dialogue','Comprehension','Vocabulary','Grammar','Composition'],
      true,
      true,
      jsonb_build_object(
        'series', 'Don Series',
        'level', 'Basic ' || r.level_n,
        'subject', 'French',
        'curriculum', 'NaCCA'
      )
    from public.publishers p
    where p.slug = 'don-series'
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
    select b.id, a.id, (a.slug = author_slugs[1]),
      array_position(author_slugs, a.slug) - 1
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and a.slug = any(author_slugs)
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
      and c.slug in ('primary-school', 'primary-french', 'level-primary-' || r.level_n)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 6500, null, 'GHS', 100, 0, 10, true
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
    cross join (values ('don-series'), ('french'), ('primary-' || r.level_n), ('nacca'), ('ghana'), ('textbook')) as t(tag)
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
