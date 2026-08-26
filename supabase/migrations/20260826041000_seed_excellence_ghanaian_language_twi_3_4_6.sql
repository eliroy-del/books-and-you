-- Catalog: Excellence Ghanaian Language Akuapem Twi 3 & 6, Asante Twi 4
-- Idempotent seed for authors, publisher, books, categories, inventory, gallery, tags, collections.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('francis-benjamin-appiah', 'Francis Benjamin Appiah', 'Ghanaian', 'Co-author of Excellence Ghanaian Language textbooks for Ghanaian schools.', true),
  ('dennis-nsafoah', 'Dennis Nsafoah', 'Ghanaian', 'Co-author of Excellence Ghanaian Language textbooks for Ghanaian schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'excellence',
  'Excellence',
  'Ghana',
  'Publisher of the Excellence series for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
  book_slug text;
  book_title text;
  dialect text;
begin
  for r in
    select * from (values
      (
        'akuapem-twi', 3, '978-9988-2-7031-5',
        'from-[#7F1D1D] via-[#991B1B] to-[#F97316]', '#7F1D1D',
        'SKU-EXCEL-AKUAPEM-3-PB'
      ),
      (
        'asante-twi', 4, '978-9988-2-7032-2',
        'from-[#14532D] via-[#166534] to-[#EFC076]', '#14532D',
        'SKU-EXCEL-ASANTE-4-PB'
      ),
      (
        'akuapem-twi', 6, '978-9988-2-7033-9',
        'from-[#001F3E] via-[#1E3A5F] to-[#EFC076]', '#001F3E',
        'SKU-EXCEL-AKUAPEM-6-PB'
      )
    ) as v(dialect_slug, level_n, isbn, gradient, accent, sku)
  loop
    dialect := case r.dialect_slug
      when 'asante-twi' then 'Asante Twi'
      else 'Akuapem Twi'
    end;
    book_slug := 'excellence-ghanaian-language-' || r.dialect_slug || '-for-ghana-schools-' || r.level_n;
    book_title := 'Excellence Ghanaian Language ' || dialect || ' for Ghana Schools ' || r.level_n;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      book_title,
      'Based on the New NaCCA Standards-Based Curriculum',
      book_title ||
        ' is a primary school ' || dialect || ' textbook based on the new NaCCA Standards-Based Curriculum. It builds listening, speaking, reading, and writing skills through clear lessons and classroom activities.',
      'Part of the Excellence Ghanaian Language series. This Book ' || r.level_n ||
        ' supports classroom learning in ' || dialect || ' aligned with the NaCCA curriculum.',
      r.isbn,
      112,
      dialect,
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['Ghanaian Language', dialect, 'Primary ' || r.level_n, 'NaCCA'],
      array['Listening and Speaking','Reading','Writing','Culture and Values','Language Practice'],
      true,
      true,
      jsonb_build_object(
        'series', 'Excellence Ghanaian Language',
        'level', 'Primary ' || r.level_n,
        'subject', dialect,
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
      language = excluded.language,
      is_featured = true,
      is_new_arrival = true,
      publisher_id = excluded.publisher_id,
      metadata = excluded.metadata,
      updated_at = timezone('utc', now());

    insert into public.book_authors (book_id, author_id, is_primary, sort_order)
    select b.id, a.id, (a.slug = 'francis-benjamin-appiah'),
      case a.slug when 'francis-benjamin-appiah' then 0 else 1 end
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and a.slug in ('francis-benjamin-appiah', 'dennis-nsafoah')
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
      and c.slug in ('primary-school', 'primary-ghanaian-language', 'level-primary-' || r.level_n)
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
      (r.dialect_slug),
      ('ghanaian-language'),
      ('twi'),
      ('excellence'),
      ('nacca'),
      ('ghana'),
      ('primary-' || r.level_n)
    ) as t(tag)
    where b.slug = book_slug
    on conflict do nothing;

    delete from public.book_images
    where book_id = (select id from public.books where slug = book_slug);

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select
      b.id,
      '/covers/' || book_slug || '/front.jpg',
      book_title || ' front cover',
      0,
      true
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
