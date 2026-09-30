-- Catalog: combined JHS / Basic 7–9 titles at GH₵150.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('koffi-bio', 'Koffi Bio', 'Ghanaian', 'Author of Bio Series French textbooks for Ghanaian junior high schools.', true),
  ('gideon-essiaw', 'Gideon Essiaw', 'Ghanaian', 'Co-author of Flamingo R.M.E. for Basic 7, 8 and 9.', true),
  ('ahmed-ibrahim', 'Ahmed Ibrahim', 'Ghanaian', 'Co-author of Flamingo R.M.E. for Basic 7, 8 and 9.', true),
  ('philip-sarpong', 'Ps. Philip Sarpong', 'Ghanaian', 'Co-author of Naky Nugget Series Creative Arts and Design for Basic 7, 8 and 9.', true),
  ('jeffrey-kwakye-akosah', 'Jeffrey Kwakye Akosah', 'Ghanaian', 'Co-author of Naky Nugget Series Creative Arts and Design for Basic 7, 8 and 9.', true),
  ('appiah-benjamin-francis', 'Appiah Benjamin Francis', 'Ghanaian', 'Co-author of Excellence Series Creative Arts and Design for Basic 7, 8 and 9.', true),
  ('martha-ankomah', 'Martha Ankomah', 'Ghanaian', 'Co-author of Excellence Series Creative Arts and Design for Basic 7, 8 and 9.', true),
  ('timothy-abaidoo', 'Timothy Abaidoo', 'Ghanaian', 'Author of TIM Series junior high Career Technology and Creative Arts titles.', true),
  ('e-k-nyarko', 'E. K. Nyarko', 'Ghanaian', 'Co-author of Victory Series junior high Career Technology and Creative Arts titles.', true),
  ('kofi-ashinyo', 'Kofi Ashinyo', 'Ghanaian', 'Co-author of Victory Career Technology for Junior High Schools Basic 7–9.', true),
  ('collins-annor', 'Collins Annor', 'Ghanaian', 'Co-author of Victory Creative Arts & Design for Junior High Schools Basic 7–9.', true),
  ('bawa-alhassan', 'Bawa Alhassan', 'Ghanaian', 'Co-author of Victory Creative Arts & Design for Junior High Schools Basic 7–9.', true),
  ('akwasi-nkansah', 'Akwasi Nkansah', 'Ghanaian', 'Author of Golden Science textbooks for junior high schools.', true),
  ('kwaku-okyere', 'Kwaku Okyere', 'Ghanaian', 'Author of Golden series mathematics textbooks for Ghanaian schools.', true),
  ('okyere-baafi-alexander', 'Okyere Baafi Alexander', 'Ghanaian', 'Author of Golden series textbooks for Ghanaian schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description)
values
  ('bio-series', 'Bio Series', 'Ghana', 'Publisher of Bio Series / BS Publication textbooks for Ghanaian schools.'),
  ('flamingo', 'Flamingo Publications', 'Ghana', 'Publisher of Flamingo textbooks for Ghanaian junior high schools.'),
  ('naky-nugget', 'Naky Nugget Series', 'Ghana', 'Publisher of Naky Nugget Series textbooks for Ghanaian basic schools.'),
  ('excellence', 'Excellence', 'Ghana', 'Publisher of Excellence Series textbooks for Ghanaian schools.'),
  ('tim-series', 'TIM Series', 'Ghana', 'Publisher of TIM Series textbooks for Ghanaian junior high schools.'),
  ('victory-series', 'Victory Series', 'Ghana', 'Publisher of the Victory Series NaCCA-compliant learners'' books for Ghanaian schools.'),
  ('new-golden-publications', 'New Golden Publications', 'Ghana', 'Kumasi-based educational publisher of the Golden series for Ghanaian schools.')
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'bio-series-guide-to-the-study-of-french-basic-7-8-9',
        'Bio Series A Guide to the Study of French for Basic 7, 8 & 9',
        'Based on New GES Standard-Based Curriculum',
        'Bio Series A Guide to the Study of French for Basic 7, 8 & 9 is a combined junior high French textbook covering dialogue, comprehension, vocabulary, grammar, and composition.',
        '978-9988-2-7103-9',
        'from-[#38BDF8] via-[#1D4ED8] to-[#F8FAFC]',
        '#1D4ED8',
        'SKU-BIO-FR-789-PB',
        'French',
        'jhs-french',
        'bio-series',
        'French',
        'Bio Series',
        ARRAY['koffi-bio']::text[]
      ),
      (
        'flamingo-rme-for-basic-7-8-9',
        'Flamingo R.M.E. for Basic 7, 8 & 9',
        'Based on the Common Core Programme · NaCCA',
        'Flamingo R.M.E. for Basic 7, 8 & 9 is a combined junior high Religious and Moral Education textbook based on the Common Core Programme, with simplified notes, past questions, and sample B.E.C.E. questions.',
        '978-9988-2-7104-6',
        'from-[#15803D] via-[#DC2626] to-[#F9A8D4]',
        '#DC2626',
        'SKU-FLAMINGO-RME-789-PB',
        'RME',
        'jhs-rme',
        'flamingo',
        'English',
        'Flamingo',
        ARRAY['gideon-essiaw', 'ahmed-ibrahim']::text[]
      ),
      (
        'naky-nugget-creative-arts-and-design-basic-7-8-9',
        'Naky Nugget Series Creative Arts and Design for Basic 7, 8 & 9 Learners',
        'Naky Nugget Series · Basic 7, 8 & 9',
        'Naky Nugget Series Creative Arts and Design for Basic 7, 8 & 9 Learners is a combined junior high Creative Arts and Design textbook covering drawing, design, and creative practice across JHS.',
        '978-9988-2-7105-3',
        'from-[#1D4ED8] via-[#F97316] to-[#F8FAFC]',
        '#1D4ED8',
        'SKU-NAKY-CAD-789-PB',
        'Creative Arts and Design',
        'jhs-creative-arts-and-design',
        'naky-nugget',
        'English',
        'Naky Nugget Series',
        ARRAY['philip-sarpong', 'jeffrey-kwakye-akosah']::text[]
      ),
      (
        'excellence-creative-arts-and-design-basic-7-8-9',
        'Excellence Series Creative Arts and Design for Basic 7, 8, 9',
        'Based on the Common Core Programme',
        'Excellence Series Creative Arts and Design for Basic 7, 8, 9 is a combined junior high Creative Arts and Design textbook based on the Common Core Programme.',
        '978-9988-2-7106-0',
        'from-[#1E3A8A] via-[#2563EB] to-[#F59E0B]',
        '#2563EB',
        'SKU-EXCEL-CAD-789-PB',
        'Creative Arts and Design',
        'jhs-creative-arts-and-design',
        'excellence',
        'English',
        'Excellence Series',
        ARRAY['appiah-benjamin-francis', 'martha-ankomah']::text[]
      ),
      (
        'tim-series-career-technology-jhs-7-8-9',
        'TIM Series Career Technology for Junior High Schools BS 7, 8 & 9',
        'Based on the New Common Core Programme',
        'TIM Series Career Technology for Junior High Schools is a combined BS 7, 8 and 9 textbook with comprehensive notes, illustrations, and assessments aligned to the Common Core Programme.',
        '978-9988-2-7107-7',
        'from-[#15803D] via-[#FACC15] to-[#F8FAFC]',
        '#15803D',
        'SKU-TIM-CT-789-PB',
        'Career Technology',
        'jhs-career-technology',
        'tim-series',
        'English',
        'TIM Series',
        ARRAY['timothy-abaidoo']::text[]
      ),
      (
        'tim-series-creative-arts-and-design-jhs-7-8-9',
        'TIM Series Creative Arts & Design for Junior High Schools BS 7, 8 & 9',
        'Based on the New Common Core Programme',
        'TIM Series Creative Arts & Design for Junior High Schools is a combined BS 7, 8 and 9 textbook with comprehensive notes, illustrations, and assessments aligned to the Common Core Programme.',
        '978-9988-2-7108-4',
        'from-[#7C3AED] via-[#FACC15] to-[#F8FAFC]',
        '#7C3AED',
        'SKU-TIM-CAD-789-PB',
        'Creative Arts and Design',
        'jhs-creative-arts-and-design',
        'tim-series',
        'English',
        'TIM Series',
        ARRAY['timothy-abaidoo']::text[]
      ),
      (
        'victory-career-technology-jhs-basic-7-9',
        'Victory Career Technology for Junior High Schools Basic 7–9',
        'Based on the New Curriculum',
        'Victory Career Technology for Junior High Schools Basic 7–9 is a combined junior high Career Technology textbook based on the new curriculum.',
        '978-9988-2-7109-1',
        'from-[#7DD3FC] via-[#111827] to-[#F8FAFC]',
        '#0284C7',
        'SKU-VICTORY-CT-789-PB',
        'Career Technology',
        'jhs-career-technology',
        'victory-series',
        'English',
        'Victory',
        ARRAY['e-k-nyarko', 'kofi-ashinyo']::text[]
      ),
      (
        'victory-creative-arts-and-design-jhs-basic-7-9',
        'Victory Creative Arts & Design for Junior High Schools Basic 7–9',
        'Based on the New NaCCA Curriculum',
        'Victory Creative Arts & Design for Junior High Schools Basic 7–9 is a combined junior high Creative Arts and Design textbook based on the new NaCCA curriculum.',
        '978-9988-2-7110-7',
        'from-[#F9A8D4] via-[#111827] to-[#F8FAFC]',
        '#EC4899',
        'SKU-VICTORY-CAD-789-PB',
        'Creative Arts and Design',
        'jhs-creative-arts-and-design',
        'victory-series',
        'English',
        'Victory',
        ARRAY['e-k-nyarko', 'collins-annor', 'bawa-alhassan']::text[]
      ),
      (
        'golden-science-jhs-1-2-3',
        'Golden Science for Junior High Schools JHS 1, 2 & 3',
        'Based on the Common Core Curriculum',
        'Golden Science for Junior High Schools JHS 1, 2 & 3 is a combined junior high science textbook based on the Common Core Curriculum.',
        '978-9988-2-7111-4',
        'from-[#111827] via-[#FACC15] to-[#2563EB]',
        '#FACC15',
        'SKU-GOLDEN-SCI-JHS123-PB',
        'Science',
        'jhs-science',
        'new-golden-publications',
        'English',
        'Golden',
        ARRAY['akwasi-nkansah']::text[]
      ),
      (
        'golden-mathematics-jhs-1-2-3',
        'Golden Mathematics for Junior High Schools JHS 1, 2 & 3',
        'Common Core Programme',
        'Golden Mathematics for Junior High Schools JHS 1, 2 & 3 is a combined junior high mathematics textbook based on the Common Core Programme.',
        '978-9988-2-7112-1',
        'from-[#0F766E] via-[#DC2626] to-[#F8FAFC]',
        '#DC2626',
        'SKU-GOLDEN-MATH-JHS123-PB',
        'Mathematics',
        'jhs-mathematics',
        'new-golden-publications',
        'English',
        'Golden',
        ARRAY['kwaku-okyere']::text[]
      ),
      (
        'golden-english-language-jhs-1-2-3',
        'Golden English Language for Junior High Schools JHS 1, 2 & 3',
        'Based on the Common Core Curriculum',
        'Golden English Language for Junior High Schools JHS 1, 2 & 3 is a combined junior high English textbook covering oral language, reading, grammar usage, writing, and literature.',
        '978-9988-2-7113-8',
        'from-[#EA580C] via-[#1E3A8A] to-[#F8FAFC]',
        '#EA580C',
        'SKU-GOLDEN-ENG-JHS123-PB',
        'English',
        'jhs-english-language',
        'new-golden-publications',
        'English',
        'Golden',
        ARRAY['okyere-baafi-alexander']::text[]
      ),
      (
        'golden-social-studies-jhs-1-2-3',
        'Golden Social Studies for Junior High Schools 1, 2 & 3',
        'Based on the New NaCCA Syllabus',
        'Golden Social Studies for Junior High Schools 1, 2 & 3 is a combined junior high Social Studies textbook based on the new NaCCA syllabus.',
        '978-9988-2-7114-5',
        'from-[#6B7280] via-[#DC2626] to-[#F8FAFC]',
        '#DC2626',
        'SKU-GOLDEN-SOC-JHS123-PB',
        'Social Studies',
        'jhs-social-studies',
        'new-golden-publications',
        'English',
        'Golden',
        ARRAY['okyere-baafi-alexander']::text[]
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
