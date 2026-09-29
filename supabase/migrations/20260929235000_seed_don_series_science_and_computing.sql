-- Catalog: Don Series Science 1–6, Computing 2–6, and Computing Workbook 5 at GH₵70.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('wilson-osafo-apeanti', 'Wilson Osafo Apeanti', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('donsimon-quarshie-attipoe', 'Donsimon Quarshie Attipoe', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true)
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
  subject_name text;
  kind_label text;
  cat_subject text;
  tag_subject text;
begin
  for r in
    select * from (values
      ('science', 'textbook', 1, '978-9988-2-7062-9', 'from-[#6D28D9] via-[#4C1D95] to-[#FACC15]', '#6D28D9', 'SKU-DON-SCI-TB-1-PB'),
      ('science', 'textbook', 2, '978-9988-2-7063-6', 'from-[#B45309] via-[#78350F] to-[#FACC15]', '#B45309', 'SKU-DON-SCI-TB-2-PB'),
      ('science', 'textbook', 3, '978-9988-2-7064-3', 'from-[#2563EB] via-[#1E3A8A] to-[#38BDF8]', '#2563EB', 'SKU-DON-SCI-TB-3-PB'),
      ('science', 'textbook', 4, '978-9988-2-7065-0', 'from-[#7C3AED] via-[#5B21B6] to-[#F472B6]', '#7C3AED', 'SKU-DON-SCI-TB-4-PB'),
      ('science', 'textbook', 5, '978-9988-2-7066-7', 'from-[#EA580C] via-[#9A3412] to-[#FACC15]', '#EA580C', 'SKU-DON-SCI-TB-5-PB'),
      ('science', 'textbook', 6, '978-9988-2-7067-4', 'from-[#15803D] via-[#14532D] to-[#86EFAC]', '#15803D', 'SKU-DON-SCI-TB-6-PB'),
      ('computing', 'textbook', 2, '978-9988-2-7068-1', 'from-[#C2410C] via-[#7C2D12] to-[#FDBA74]', '#C2410C', 'SKU-DON-COMP-TB-2-PB'),
      ('computing', 'textbook', 3, '978-9988-2-7069-8', 'from-[#1D4ED8] via-[#1E3A8A] to-[#93C5FD]', '#1D4ED8', 'SKU-DON-COMP-TB-3-PB'),
      ('computing', 'textbook', 4, '978-9988-2-7070-4', 'from-[#7E22CE] via-[#581C87] to-[#E9D5FF]', '#7E22CE', 'SKU-DON-COMP-TB-4-PB'),
      ('computing', 'textbook', 5, '978-9988-2-7071-1', 'from-[#C2410C] via-[#9A3412] to-[#FDBA74]', '#C2410C', 'SKU-DON-COMP-TB-5-PB'),
      ('computing', 'textbook', 6, '978-9988-2-7072-8', 'from-[#15803D] via-[#14532D] to-[#86EFAC]', '#15803D', 'SKU-DON-COMP-TB-6-PB'),
      ('computing', 'workbook', 5, '978-9988-2-7073-5', 'from-[#B45309] via-[#7C2D12] to-[#FDE68A]', '#B45309', 'SKU-DON-COMP-WB-5-PB')
    ) as v(kind, format_kind, level_n, isbn, gradient, accent, sku)
  loop
    subject_name := initcap(r.kind);
    kind_label := case when r.format_kind = 'workbook' then 'Premier Workbook' else 'Premier Textbook' end;
    book_slug := 'don-series-' || r.kind || '-premier-' || r.format_kind || '-' || r.level_n;
    book_title := 'Don Series ' || subject_name || ' ' || kind_label || ' ' || r.level_n;
    cat_subject := case when r.kind = 'science' then 'primary-science' else 'primary-computing-ict' end;
    tag_subject := r.kind;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      'For Basic Schools · NaCCA Approved Standard Based Curriculum',
      book_title || ' is a Don Series primary ' || r.kind || ' ' || r.format_kind || ' based on the NaCCA approved standard based curriculum. It supports Basic ' || r.level_n || ' learners with clear lessons, activities, and self-tuition resources.',
      'Part of the Don Series Premier range for basic schools. This Basic ' || r.level_n || ' ' || r.format_kind || ' supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      case when r.format_kind = 'workbook' then 96 else 160 end,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[subject_name, 'Primary ' || r.level_n, 'Don Series', 'NaCCA'],
      array['Lessons','Practice','Self tuition'],
      true,
      true,
      jsonb_build_object(
        'series', 'Don Series',
        'level', 'Basic ' || r.level_n,
        'subject', subject_name,
        'format', kind_label,
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
    select b.id, a.id, (a.slug = 'wilson-osafo-apeanti'),
      case a.slug when 'wilson-osafo-apeanti' then 0 else 1 end
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and a.slug in ('wilson-osafo-apeanti', 'donsimon-quarshie-attipoe')
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
      and c.slug in ('primary-school', cat_subject, 'level-primary-' || r.level_n)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 7000, null, 'GHS', 100, 0, 10, true
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
      ('don-series'),
      (tag_subject),
      ('primary-' || r.level_n),
      ('nacca'),
      ('ghana'),
      (r.format_kind)
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
