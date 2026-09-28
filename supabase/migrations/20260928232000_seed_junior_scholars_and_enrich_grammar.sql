-- Catalog: Junior Scholars English Grammar Basic 1 & 4, Enrich your Grammar 1, 3 & 5
-- Idempotent seed at GH₵55.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('sc-kwashie-gamor', 'S. C. Kwashie-Gamor', 'Ghanaian', 'Co-author of Junior Scholars English Grammar for Basic Schools.', true),
  ('so-alabi', 'S. O. Alabi', 'Ghanaian', 'Co-author of Junior Scholars English Grammar for Basic Schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description) values
  (
    'junior-scholars',
    'Junior Scholars',
    'Ghana',
    'Publisher of the Junior Scholars English Grammar series for Ghanaian basic schools.'
  ),
  (
    'epp-books-services',
    'EPP Books Services',
    'Ghana',
    'Distributor of Enrich your Grammar for primary schools.'
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
      (
        'junior', 1, '978-9988-2-7041-4',
        'from-[#38BDF8] via-[#FACC15] to-[#F472B6]', '#0EA5E9',
        'SKU-JS-ENG-GRAM-B1-PB'
      ),
      (
        'junior', 4, '978-9988-2-7042-1',
        'from-[#F97316] via-[#FACC15] to-[#F472B6]', '#EA580C',
        'SKU-JS-ENG-GRAM-B4-PB'
      ),
      (
        'enrich', 1, '978-9988-2-7043-8',
        'from-[#2563EB] via-[#FACC15] to-[#EF4444]', '#2563EB',
        'SKU-ENRICH-GRAM-P1-PB'
      ),
      (
        'enrich', 3, '978-9988-2-7044-5',
        'from-[#22C55E] via-[#2563EB] to-[#F97316]', '#16A34A',
        'SKU-ENRICH-GRAM-P3-PB'
      ),
      (
        'enrich', 5, '978-9988-2-7045-2',
        'from-[#F97316] via-[#7C3AED] to-[#2563EB]', '#7C3AED',
        'SKU-ENRICH-GRAM-P5-PB'
      )
    ) as v(series_key, level_n, isbn, gradient, accent, sku)
  loop
    if r.series_key = 'junior' then
      book_slug := 'junior-scholars-english-grammar-for-basic-schools-' || r.level_n;
      book_title := 'Junior Scholars English Grammar for Basic Schools Basic ' || r.level_n;
    else
      book_slug := 'enrich-your-grammar-for-primary-schools-' || r.level_n;
      book_title := 'Enrich your Grammar for Primary Schools ' || r.level_n;
    end if;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      case
        when r.series_key = 'junior' then 'Based on the new GES Curriculum · Revised Edition'
        when r.level_n = 5 then 'New Edition'
        else 'New Colour Edition'
      end,
      book_title ||
        ' is a primary school grammar book with exercises that build sentence structure, usage, and written English for classroom and home practice.',
      'Grammar practice for Primary ' || r.level_n || '. Exercises include answers for classroom and independent work.',
      r.isbn,
      96,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['English Grammar','Primary ' || r.level_n,'Basic Schools'],
      array['Sentence Structure','Parts of Speech','Usage','Exercises'],
      true,
      true,
      jsonb_build_object(
        'series', case when r.series_key = 'junior' then 'Junior Scholars' else 'Enrich your Grammar' end,
        'level', 'Primary ' || r.level_n,
        'subject', 'English Grammar',
        'edition', case
          when r.series_key = 'junior' then 'Revised'
          when r.level_n = 5 then 'New Edition'
          else 'New Colour'
        end
      )
    from public.publishers p
    where p.slug = case when r.series_key = 'junior' then 'junior-scholars' else 'epp-books-services' end
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

    if r.series_key = 'junior' then
      insert into public.book_authors (book_id, author_id, is_primary, sort_order)
      select b.id, a.id, (a.slug = 'sc-kwashie-gamor'),
        case a.slug when 'sc-kwashie-gamor' then 0 else 1 end
      from public.books b
      cross join public.authors a
      where b.slug = book_slug
        and a.slug in ('sc-kwashie-gamor', 'so-alabi')
      on conflict (book_id, author_id) do update
        set is_primary = excluded.is_primary, sort_order = excluded.sort_order;
    end if;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
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
      5500,
      null,
      'GHS',
      100,
      0,
      10,
      true
    from public.books b
    where b.slug = book_slug
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
      ('grammar'),
      ('english'),
      ('ghana'),
      ('primary-' || r.level_n),
      (case when r.series_key = 'junior' then 'junior-scholars' else 'enrich-your-grammar' end)
    ) as t(tag)
    where b.slug = book_slug
    on conflict do nothing;

    delete from public.book_images
    where book_id = (select id from public.books where slug = book_slug);

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
