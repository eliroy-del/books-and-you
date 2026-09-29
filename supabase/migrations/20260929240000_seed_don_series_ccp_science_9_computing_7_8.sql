-- Catalog: Don Series CCP Science 9 and Computing 7–8 at GH₵85.

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
  jhs_n int;
begin
  for r in
    select * from (values
      ('science', 9, '978-9988-2-7079-7', 'from-[#15803D] via-[#14532D] to-[#86EFAC]', '#15803D', 'SKU-DON-SCI-CCP-TB-9-PB', 'jhs-science'),
      ('computing', 8, '978-9988-2-7080-3', 'from-[#1D4ED8] via-[#1E3A8A] to-[#93C5FD]', '#1D4ED8', 'SKU-DON-COMP-CCP-TB-8-PB', 'jhs-computing'),
      ('computing', 7, '978-9988-2-7081-0', 'from-[#C2410C] via-[#9A3412] to-[#FDBA74]', '#C2410C', 'SKU-DON-COMP-CCP-TB-7-PB', 'jhs-computing')
    ) as v(kind, level_n, isbn, gradient, accent, sku, subject_slug)
  loop
    jhs_n := r.level_n - 6;
    book_slug := 'don-series-' || r.kind || '-ccp-premier-textbook-' || r.level_n;
    book_title := 'Don Series ' || initcap(r.kind) || ' CCP Premier Textbook ' || r.level_n;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      'Common Core Programme · For Basic Schools · NaCCA Approved',
      book_title || ' is a Don Series junior high ' || r.kind || ' textbook based on the NaCCA Common Core Programme. It supports Basic ' || r.level_n || ' (JHS ' || jhs_n || ') learners with clear lessons, activities, and video tutorials.',
      'Part of the Don Series Common Core Programme range for basic schools. This Basic ' || r.level_n || ' textbook supports classroom learning aligned with the NaCCA CCP curriculum.',
      r.isbn,
      176,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[initcap(r.kind), 'JHS ' || jhs_n, 'Basic ' || r.level_n, 'Don Series', 'CCP'],
      array['Lessons','Practice','Self tuition'],
      true,
      true,
      jsonb_build_object(
        'series', 'Don Series',
        'level', 'Basic ' || r.level_n,
        'jhs', 'JHS ' || jhs_n,
        'subject', initcap(r.kind),
        'curriculum', 'Common Core Programme'
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
      and c.slug in ('junior-high-school', r.subject_slug, 'level-jhs-' || jhs_n)
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
      ('don-series'),
      (r.kind),
      ('jhs-' || jhs_n),
      ('basic-' || r.level_n),
      ('ccp'),
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
