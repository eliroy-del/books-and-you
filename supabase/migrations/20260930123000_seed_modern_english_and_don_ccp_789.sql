-- Catalog: Modern English JHS 7–9 and Don Series CCP combined 7–8–9 titles at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('daniel-nipah', 'Daniel Nipah', 'Ghanaian', 'Co-author of Modern English for Junior High Schools Basic 7, 8 and 9.', true),
  ('nimako-opoku-joe', 'Rev. Nimako Opoku Joe', 'Ghanaian', 'Co-author of Modern English for Junior High Schools Basic 7, 8 and 9.', true),
  ('lebene-heponou-akatsi', 'Lebene Heponou Akatsi', 'Ghanaian', 'Co-author of Don Series French CCP Premier Textbook for Basic 7, 8 and 9.', true),
  ('margaret-dela-tetteh', 'Margaret Dela Tetteh', 'Ghanaian', 'Co-author of Don Series French Premier textbooks.', true),
  ('alassan-safiou', 'Alassan Safiou', 'Ghanaian', 'Co-author of Don Series French Premier textbooks.', true),
  ('norvianyo-dordzeavudzi', 'Norvianyo Dordzeavudzi', 'Ghanaian', 'Co-author of Don Series French Premier textbooks.', true),
  ('wilson-osafo-apeanti', 'Wilson Osafo Apeanti', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('donsimon-quarshie-attipoe', 'Donsimon Quarshie Attipoe', 'Ghanaian', 'Co-author of Don Series Premier textbooks for Ghanaian basic schools.', true),
  ('g-v-attipoe', 'G V Attipoe', 'Ghanaian', 'Author of Don Series English CCP Premier Textbook for Basic 7, 8 and 9.', true),
  ('francis-okoh', 'Francis Okoh', 'Ghanaian', 'Author of Don Series RME CCP Premier Textbook for Basic 7, 8 and 9.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values
  ('ab-publications', 'AB Publications', 'Ghana', 'Publisher of Modern English textbooks for Ghanaian junior high schools.'),
  ('don-series', 'Don Series', 'Ghana', 'Publisher of Don Series Premier textbooks for Ghanaian basic schools.')
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'modern-english-for-junior-high-schools-basic-7-8-9',
        'Modern English for Junior High Schools Basic 7, 8 & 9',
        'New Curriculum · Activity-Based',
        'Modern English for Junior High Schools Basic 7, 8 & 9 is a combined junior high English textbook covering grammar, oral language, literature, writing, comprehension and summarising, with exercises and activities.',
        '978-9988-2-7115-2',
        'from-[#1E3A8A] via-[#FACC15] to-[#F8FAFC]',
        '#1E3A8A',
        'SKU-MODERN-ENG-789-PB',
        'English',
        'jhs-english-language',
        'ab-publications',
        'English',
        'Modern English',
        ARRAY['daniel-nipah', 'nimako-opoku-joe']::text[]
      ),
      (
        'don-series-french-ccp-premier-textbook-7-8-9',
        'Don Series French CCP Premier Textbook for Basic Schools 7, 8 & 9',
        'Common Core Programme · NaCCA Approved',
        'Don Series French CCP Premier Textbook for Basic Schools 7, 8 & 9 is a combined junior high French textbook based on the NaCCA-approved standard-based curriculum, with dialogue, vocabulary, and composition.',
        '978-9988-2-7116-9',
        'from-[#1D4ED8] via-[#FACC15] to-[#DC2626]',
        '#1D4ED8',
        'SKU-DON-FR-CCP-789-PB',
        'French',
        'jhs-french',
        'don-series',
        'French',
        'Don Series',
        ARRAY['lebene-heponou-akatsi', 'margaret-dela-tetteh', 'alassan-safiou', 'norvianyo-dordzeavudzi']::text[]
      ),
      (
        'don-series-science-ccp-premier-textbook-7-8-9',
        'Don Series Science CCP Premier Textbook for Basic Schools 7, 8 & 9',
        'Common Core Programme · NaCCA Approved',
        'Don Series Science CCP Premier Textbook for Basic Schools 7, 8 & 9 is a combined junior high science textbook covering material, agricultural, biology, chemistry, physics, health, and climate science.',
        '978-9988-2-7117-6',
        'from-[#15803D] via-[#FACC15] to-[#111827]',
        '#15803D',
        'SKU-DON-SCI-CCP-789-PB',
        'Science',
        'jhs-science',
        'don-series',
        'English',
        'Don Series',
        ARRAY['wilson-osafo-apeanti', 'donsimon-quarshie-attipoe']::text[]
      ),
      (
        'don-series-english-ccp-premier-textbook-7-8-9',
        'Don Series English CCP Premier Textbook for Basic Schools 7, 8 & 9',
        'Common Core Programme · NaCCA Approved',
        'Don Series English CCP Premier Textbook for Basic Schools 7, 8 & 9 is a combined junior high English textbook covering oral language, reading, writing, grammar, composition, summary, and literature.',
        '978-9988-2-7118-3',
        'from-[#1D4ED8] via-[#FACC15] to-[#F8FAFC]',
        '#1D4ED8',
        'SKU-DON-ENG-CCP-789-PB',
        'English',
        'jhs-english-language',
        'don-series',
        'English',
        'Don Series',
        ARRAY['g-v-attipoe']::text[]
      ),
      (
        'don-series-rme-ccp-premier-textbook-7-8-9',
        'Don Series Religious and Moral Education CCP Premier Textbook for Basic Schools 7, 8 & 9',
        'Common Core Programme · NaCCA Approved',
        'Don Series RME CCP Premier Textbook for Basic Schools 7, 8 & 9 is a combined junior high Religious and Moral Education textbook based on the NaCCA-approved standard-based curriculum.',
        '978-9988-2-7119-0',
        'from-[#A21CAF] via-[#F8FAFC] to-[#111827]',
        '#A21CAF',
        'SKU-DON-RME-CCP-789-PB',
        'RME',
        'jhs-rme',
        'don-series',
        'English',
        'Don Series',
        ARRAY['francis-okoh']::text[]
      )
    ) as v(
      book_slug, book_title, subtitle, description, isbn, gradient, accent, sku,
      subject, subject_slug, publisher_slug, book_language, series, author_slugs
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
      'Combined ' || r.series || ' title for junior high Basic 7, 8 and 9 / JHS 1–3.',
      r.isbn,
      240,
      r.book_language,
      '2024-01-01',
      p.id,
      '/covers/' || r.book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[r.subject, 'JHS', 'Combined', r.series],
      array['JHS 1 (Basic 7)', 'JHS 2 (Basic 8)', 'JHS 3 (Basic 9)'],
      true,
      true,
      jsonb_build_object(
        'series', r.series,
        'level', 'Basic 7, 8 & 9',
        'subject', r.subject,
        'curriculum', 'Common Core Programme'
      )
    from public.publishers p
    where p.slug = r.publisher_slug
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
    cross join (values ('jhs'), ('combined'), ('ghana'), ('textbook'), ('ccp')) as t(tag)
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
