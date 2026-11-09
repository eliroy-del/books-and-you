-- Catalog: Excellence Series combined JHS 1–3 titles at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('francis-benjamin-appiah', 'Francis Benjamin Appiah', 'Ghanaian', 'Co-author of Excellence series textbooks for Ghanaian schools.', true),
  ('appiah-benjamin-francis', 'Appiah Benjamin Francis', 'Ghanaian', 'Co-author of Excellence Series textbooks for Ghanaian junior high schools.', true),
  ('derrick-appiah', 'Derrick Appiah', 'Ghanaian', 'Co-author of Excellence Series Science for JHS 1–3.', true),
  ('frank-asiamah', 'Frank Asiama', 'Ghanaian', 'Co-author of Excellence Series Social Studies for JHS 1, 2 and 3.', true),
  ('zutaah-puotier', 'Zutaah Puotier', 'Ghanaian', 'Co-author of Excellence Series Mathematics for JHS 1, 2 and 3.', true),
  ('emmanuel-kofi-otchere-larbi', 'Emmanuel Kofi Otchere Larbi', 'Ghanaian', 'Co-author of Excellence Series Mathematics for JHS 1, 2 and 3.', true),
  ('george-britwum', 'George Britwum', 'Ghanaian', 'Co-author of Excellence Series Career Technology for JHS 1–3.', true),
  ('faustina-appiah', 'Faustina Appiah', 'Ghanaian', 'Co-author of Excellence Series English Language for JHS 1–3.', true),
  ('dennis-nsafoah', 'Dennis Nsafoah', 'Ghanaian', 'Co-author of Excellence Series English Language for JHS 1–3.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values (
  'excellence',
  'Excellence',
  'Ghana',
  'Publisher of Excellence Series textbooks for Ghanaian schools.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'excellence-science-for-jhs-1-3',
        'Excellence Series Science for JHS 1–3',
        'Based on the Common Core Programme · Revised Edition',
        'Excellence Series Science for JHS 1–3 is a combined junior high science textbook based on the Common Core Programme. Revised edition, NaCCA approved.',
        '978-9988-2-7123-7',
        'from-[#14532D] via-[#FACC15] to-[#0F172A]',
        '#15803D',
        'SKU-EXCEL-SCI-JHS13-PB',
        'Science',
        'jhs-science',
        ARRAY['francis-benjamin-appiah', 'derrick-appiah']::text[]
      ),
      (
        'excellence-social-studies-jhs-1-2-3',
        'Excellence Series Social Studies for JHS 1, 2 & 3',
        'Based on the Common Core Programme · Revised Edition',
        'Excellence Series Social Studies for JHS 1, 2 & 3 is a combined junior high Social Studies textbook based on the Common Core Programme. Revised edition.',
        '978-9988-2-7124-4',
        'from-[#78350F] via-[#CA8A04] to-[#F8FAFC]',
        '#CA8A04',
        'SKU-EXCEL-SOC-JHS13-PB',
        'Social Studies',
        'jhs-social-studies',
        ARRAY['appiah-benjamin-francis', 'frank-asiamah']::text[]
      ),
      (
        'excellence-religious-and-moral-education-jhs-1-2-3',
        'Excellence Series Religious and Moral Education for JHS 1, 2 & 3',
        'Based on the Common Core Programme · Revised Edition',
        'Excellence Series Religious and Moral Education for JHS 1, 2 & 3 is a combined junior high RME textbook based on the Common Core Programme. Revised edition, NaCCA approved.',
        '978-9988-2-7125-1',
        'from-[#A16207] via-[#44403C] to-[#F8FAFC]',
        '#A16207',
        'SKU-EXCEL-RME-JHS13-PB',
        'RME',
        'jhs-rme',
        ARRAY['francis-benjamin-appiah']::text[]
      ),
      (
        'excellence-mathematics-for-jhs-1-2-3',
        'Excellence Series Mathematics for JHS 1, 2 & 3',
        'Based on the Common Core Programme',
        'Excellence Series Mathematics for JHS 1, 2 & 3 is a combined junior high mathematics textbook based on the Common Core Programme.',
        '978-9988-2-7126-8',
        'from-[#6D28D9] via-[#F8FAFC] to-[#111827]',
        '#6D28D9',
        'SKU-EXCEL-MATH-JHS13-PB',
        'Mathematics',
        'jhs-mathematics',
        ARRAY['francis-benjamin-appiah', 'zutaah-puotier', 'emmanuel-kofi-otchere-larbi']::text[]
      ),
      (
        'excellence-career-technology-for-jhs-1-3',
        'Excellence Series Career Technology for JHS 1–3',
        'Based on the Common Core Programme · Revised Edition',
        'Excellence Series Career Technology for JHS 1–3 is a combined junior high Career Technology textbook based on the Common Core Programme. Revised edition, NaCCA approved.',
        '978-9988-2-7127-5',
        'from-[#1D4ED8] via-[#F8FAFC] to-[#111827]',
        '#1D4ED8',
        'SKU-EXCEL-CT-JHS13-PB',
        'Career Technology',
        'jhs-career-technology',
        ARRAY['francis-benjamin-appiah', 'george-britwum']::text[]
      ),
      (
        'excellence-english-language-for-jhs-1-3',
        'Excellence Series English Language for JHS 1–3',
        'Based on the Common Core Programme · Revised Edition',
        'Excellence Series English Language for JHS 1–3 is a combined junior high English textbook based on the Common Core Programme. Revised edition, NaCCA approved.',
        '978-9988-2-7128-2',
        'from-[#15803D] via-[#FACC15] to-[#F8FAFC]',
        '#15803D',
        'SKU-EXCEL-ENG-JHS13-PB',
        'English',
        'jhs-english-language',
        ARRAY['appiah-benjamin-francis', 'faustina-appiah', 'dennis-nsafoah']::text[]
      )
    ) as v(
      book_slug, book_title, subtitle, description, isbn, gradient, accent, sku,
      subject, subject_slug, author_slugs
    )
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
      'Combined Excellence Series title for junior high Form 1, 2 and 3, based on the Common Core Programme.',
      r.isbn,
      240,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || r.book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[r.subject, 'JHS', 'Combined', 'Excellence Series'],
      array['JHS 1', 'JHS 2', 'JHS 3'],
      true,
      true,
      jsonb_build_object(
        'series', 'Excellence Series',
        'level', 'JHS 1–3',
        'subject', r.subject,
        'curriculum', 'Common Core Programme',
        'edition', 'Revised Edition'
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
    select b.id, a.id, (u.ord = 1), (u.ord - 1)::int
    from public.books b
    cross join unnest(r.author_slugs) with ordinality as u(author_slug, ord)
    join public.authors a on a.slug = u.author_slug
    where b.slug = r.book_slug
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = r.book_slug
      and c.slug in ('junior-high-school', 'jhs-combined', 'level-jhs-combined', r.subject_slug)
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, 15000, null, 'GHS', 100, 0, 10, true
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
    cross join (values ('jhs'), ('combined'), ('ghana'), ('textbook'), ('excellence')) as t(tag)
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
