-- Catalog: Calculus Mathematics 1, 3 & 4 and English 2, 3, 5 & 6 at GH₵70,
-- Best Brain English Basic 6 at GH₵70, Premco Akuapem Twi Gyinapɛn 6 at GH₵60.

insert into public.authors (slug, name, nationality, bio, is_verified) values
  ('philip-kwame-nkrumah', 'Philip Kwame Nkrumah', 'Ghanaian', 'Co-author of Calculus Series Mathematics for primary schools.', true),
  ('calculus-yeboah', 'Calculus Yeboah', 'Ghanaian', 'Co-author of Calculus Series Mathematics for primary schools.', true),
  ('samuel-adjei-oduro', 'Samuel Adjei Oduro', 'Ghanaian', 'Co-author of Calculus Series Mathematics for primary schools.', true),
  ('edward-mettle-nunoo', 'Edward Mettle Nunoo', 'Ghanaian', 'Co-author of Calculus Series English Language for primary schools.', true),
  ('paulyn-naa-amanshia-apprey', 'Paulyn Naa Amanshia Apprey', 'Ghanaian', 'Co-author of Calculus Series English Language for primary schools.', true),
  ('benjamin-acquah-cassidy', 'Benjamin Acquah Cassidy', 'Ghanaian', 'Co-author of Calculus Series English Language for primary schools.', true),
  ('mavis-baah-yeboah', 'Mavis Baah-Yeboah', 'Ghanaian', 'Co-author of Best Brain English Language textbooks for Ghanaian basic schools.', true),
  ('henrieta-ataa-baah', 'Henrieta Ataa Baah', 'Ghanaian', 'Co-author of Best Brain English Language for Basic Schools Basic 6.', true),
  ('nana-akwasi-agyeman-prempeh', 'Nana Akwasi Agyeman Prempeh', 'Ghanaian', 'Author of Premco Series Akuapem Twi Nyansapɔw for primary schools.', true)
on conflict (slug) do update set name = excluded.name;

insert into public.publishers (slug, name, country, description) values
  ('calculus-publications', 'Calculus Publications', 'Ghana', 'Publisher of the Calculus Series for Ghanaian primary schools.'),
  ('best-brain', 'Best Brain', 'Ghana', 'Publisher of Best Brain textbooks for Ghanaian schools.'),
  ('premsco', 'Premco', 'Ghana', 'Publisher of the Premco Series Ghanaian language textbooks.')
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
  book_slug text;
begin
  for r in
    select * from (values
      ('math', 1, '978-9988-2-7049-0', 7000, 'from-[#0284C7] via-[#F472B6] to-[#F97316]', '#0284C7', 'SKU-CALC-MATH-P1-PB'),
      ('math', 3, '978-9988-2-7050-6', 7000, 'from-[#16A34A] via-[#F97316] to-[#FACC15]', '#16A34A', 'SKU-CALC-MATH-P3-PB'),
      ('math', 4, '978-9988-2-7051-3', 7000, 'from-[#DB2777] via-[#F97316] to-[#FACC15]', '#DB2777', 'SKU-CALC-MATH-P4-PB'),
      ('eng', 2, '978-9988-2-7052-0', 7000, 'from-[#DB2777] via-[#F472B6] to-[#FACC15]', '#DB2777', 'SKU-CALC-ENG-P2-PB'),
      ('eng', 3, '978-9988-2-7053-7', 7000, 'from-[#166534] via-[#16A34A] to-[#FACC15]', '#166534', 'SKU-CALC-ENG-P3-PB'),
      ('eng', 5, '978-9988-2-7054-4', 7000, 'from-[#166534] via-[#22C55E] to-[#FACC15]', '#166534', 'SKU-CALC-ENG-P5-PB'),
      ('eng', 6, '978-9988-2-7055-1', 7000, 'from-[#6D28D9] via-[#A855F7] to-[#FACC15]', '#6D28D9', 'SKU-CALC-ENG-P6-PB')
    ) as v(kind, level_n, isbn, price_cents, gradient, accent, sku)
  loop
    book_slug := case
      when r.kind = 'math' then 'calculus-mathematics-for-primary-schools-' || r.level_n
      else 'calculus-english-language-for-primary-schools-' || r.level_n
    end;

    insert into public.books (
      slug, title, subtitle, description, synopsis, isbn, pages, language,
      published_at, publisher_id, cover_url, cover_gradient, cover_accent,
      genres, table_of_contents, is_featured, is_new_arrival, metadata
    )
    select
      book_slug,
      case when r.kind = 'math'
        then 'Calculus Mathematics for Primary Schools Basic ' || r.level_n
        else 'Calculus English Language for Primary Schools Basic ' || r.level_n
      end,
      'New Edition · Based on the new NaCCA Curriculum',
      case when r.kind = 'math'
        then 'Calculus Mathematics for Primary Schools Basic ' || r.level_n || ' is a primary mathematics textbook based on the new NaCCA curriculum.'
        else 'Calculus English Language for Primary Schools Basic ' || r.level_n || ' is a primary English textbook based on the new NaCCA curriculum.'
      end,
      'Part of the Calculus Series for primary schools. This Basic ' || r.level_n || ' title supports classroom learning aligned with the NaCCA curriculum.',
      r.isbn,
      144,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array[
        case when r.kind = 'math' then 'Mathematics' else 'English Language' end,
        'Primary ' || r.level_n,
        'NaCCA',
        'Calculus Series'
      ],
      array['Lessons','Practice','Review'],
      true,
      true,
      jsonb_build_object(
        'series', 'Calculus',
        'level', 'Basic ' || r.level_n,
        'subject', case when r.kind = 'math' then 'Mathematics' else 'English Language' end,
        'curriculum', 'NaCCA'
      )
    from public.publishers p
    where p.slug = 'calculus-publications'
    on conflict (slug) do update set
      title = excluded.title,
      subtitle = excluded.subtitle,
      description = excluded.description,
      cover_url = excluded.cover_url,
      cover_gradient = excluded.cover_gradient,
      cover_accent = excluded.cover_accent,
      is_featured = true,
      is_new_arrival = true,
      publisher_id = excluded.publisher_id,
      metadata = excluded.metadata,
      updated_at = timezone('utc', now());

    insert into public.book_authors (book_id, author_id, is_primary, sort_order)
    select b.id, a.id,
      case
        when r.kind = 'math' and a.slug = 'philip-kwame-nkrumah' then true
        when r.kind = 'eng' and a.slug = 'edward-mettle-nunoo' then true
        else false
      end,
      case a.slug
        when 'philip-kwame-nkrumah' then 0
        when 'calculus-yeboah' then 1
        when 'samuel-adjei-oduro' then 2
        when 'edward-mettle-nunoo' then 0
        when 'paulyn-naa-amanshia-apprey' then 1
        else 2
      end
    from public.books b
    cross join public.authors a
    where b.slug = book_slug
      and (
        (r.kind = 'math' and a.slug in ('philip-kwame-nkrumah', 'calculus-yeboah', 'samuel-adjei-oduro'))
        or (r.kind = 'eng' and a.slug in ('edward-mettle-nunoo', 'paulyn-naa-amanshia-apprey', 'benjamin-acquah-cassidy'))
      )
    on conflict (book_id, author_id) do update
      set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = book_slug
      and c.slug in (
        'primary-school',
        'level-primary-' || r.level_n,
        case when r.kind = 'math' then 'primary-mathematics' else 'primary-english-language' end
      )
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, r.price_cents, null, 'GHS', 100, 0, 10, true
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
    cross join (values ('calculus'), ('nacca'), ('ghana'), ('primary-' || r.level_n)) as t(tag)
    where b.slug = book_slug
    on conflict do nothing;

    delete from public.book_images where book_id = (select id from public.books where slug = book_slug);
    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select b.id, '/covers/' || book_slug || '/front.jpg', book_slug || ' front cover', 0, true
    from public.books b where b.slug = book_slug;

    insert into public.collection_books (collection_id, book_id, sort_order)
    select c.id, b.id, 0
    from public.collections c
    cross join public.books b
    where b.slug = book_slug and c.slug in ('new-arrivals', 'best-sellers')
    on conflict do nothing;
  end loop;
end $$;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'best-brain-english-language-for-basic-schools-6',
  'Best Brain English Language for Basic Schools Basic 6',
  'Based on the New Standard-Based Curriculum',
  'Best Brain English Language for Basic Schools Basic 6 is a primary school English textbook based on the new NaCCA standard-based curriculum.',
  'Part of the Best Brain English Language series. This Basic 6 title supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7056-8',
  160,
  'English',
  '2024-01-01',
  p.id,
  '/covers/best-brain-english-language-for-basic-schools-6/front.jpg',
  'from-[#0F766E] via-[#EF4444] to-[#F9A8D4]',
  '#0F766E',
  array['English Language','Primary 6','NaCCA','Basic Schools'],
  array['Grammar','Reading','Writing','Oral Language'],
  true,
  true,
  jsonb_build_object('series','Best Brain English Language','level','Basic 6','subject','English Language','curriculum','NaCCA')
from public.publishers p
where p.slug = 'best-brain'
on conflict (slug) do update set
  title = excluded.title, cover_url = excluded.cover_url, is_featured = true, is_new_arrival = true,
  publisher_id = excluded.publisher_id, updated_at = timezone('utc', now());

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, (a.slug = 'mavis-baah-yeboah'), case a.slug when 'mavis-baah-yeboah' then 0 else 1 end
from public.books b
cross join public.authors a
where b.slug = 'best-brain-english-language-for-basic-schools-6'
  and a.slug in ('mavis-baah-yeboah', 'henrieta-ataa-baah')
on conflict (book_id, author_id) do update set is_primary = excluded.is_primary, sort_order = excluded.sort_order;

insert into public.book_categories (book_id, category_id)
select b.id, c.id from public.books b cross join public.categories c
where b.slug = 'best-brain-english-language-for-basic-schools-6'
  and c.slug in ('primary-school', 'primary-english-language', 'level-primary-6')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-BESTBRAIN-ENG-B6-PB', 7000, null, 'GHS', 100, 0, 10, true
from public.books b where b.slug = 'best-brain-english-language-for-basic-schools-6'
on conflict (book_id, format) do update set price_cents = 7000, sku = excluded.sku, is_active = true, updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag from public.books b
cross join (values ('english'), ('best-brain'), ('nacca'), ('ghana'), ('primary-6')) as t(tag)
where b.slug = 'best-brain-english-language-for-basic-schools-6'
on conflict do nothing;

delete from public.book_images where book_id = (select id from public.books where slug = 'best-brain-english-language-for-basic-schools-6');
insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/best-brain-english-language-for-basic-schools-6/front.jpg',
  'Best Brain English Language for Basic Schools Basic 6 front cover', 0, true
from public.books b where b.slug = 'best-brain-english-language-for-basic-schools-6';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0 from public.collections c cross join public.books b
where b.slug = 'best-brain-english-language-for-basic-schools-6' and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;

insert into public.books (
  slug, title, subtitle, description, synopsis, isbn, pages, language,
  published_at, publisher_id, cover_url, cover_gradient, cover_accent,
  genres, table_of_contents, is_featured, is_new_arrival, metadata
)
select
  'premsco-akuapem-twi-nyansapow-gyinapen-6',
  'Akuapem Twi Nyansapɔw Gyinapɛn 6',
  'Premco Series · Based on the New Ghanaian Language Curriculum for Primary Schools (NaCCA 2019)',
  'Akuapem Twi Nyansapɔw Gyinapɛn 6 is a Premco Series primary textbook for Akuapem Twi, based on the NaCCA Ghanaian language curriculum. It builds listening, speaking, reading, and writing for Basic 6.',
  'Premco Series Akuapem Twi for primary schools. This Gyinapɛn 6 title supports classroom learning aligned with the NaCCA curriculum.',
  '978-9988-2-7057-5',
  128,
  'Akuapem Twi',
  '2019-01-01',
  p.id,
  '/covers/premsco-akuapem-twi-nyansapow-gyinapen-6/front.jpg',
  'from-[#6D28D9] via-[#F9A8D4] to-[#BE123C]',
  '#6D28D9',
  array['Ghanaian Language','Akuapem Twi','Primary 6','NaCCA'],
  array['Listening and Speaking','Reading','Writing','Language Practice'],
  true,
  true,
  jsonb_build_object('series','Premco','level','Primary 6','subject','Akuapem Twi','curriculum','NaCCA 2019')
from public.publishers p
where p.slug = 'premsco'
on conflict (slug) do update set
  title = excluded.title, subtitle = excluded.subtitle, description = excluded.description,
  cover_url = excluded.cover_url, language = excluded.language, is_featured = true, is_new_arrival = true,
  publisher_id = excluded.publisher_id, metadata = excluded.metadata, updated_at = timezone('utc', now());

insert into public.book_authors (book_id, author_id, is_primary, sort_order)
select b.id, a.id, true, 0
from public.books b cross join public.authors a
where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6' and a.slug = 'nana-akwasi-agyeman-prempeh'
on conflict (book_id, author_id) do update set is_primary = true;

insert into public.book_categories (book_id, category_id)
select b.id, c.id from public.books b cross join public.categories c
where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6'
  and c.slug in ('primary-school', 'primary-ghanaian-language', 'level-primary-6')
on conflict do nothing;

insert into public.book_inventory (
  book_id, format, sku, price_cents, compare_at_cents, currency,
  quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
)
select b.id, 'paperback'::public.book_format, 'SKU-PREMSCO-AKUAPEM-6-PB', 6000, null, 'GHS', 100, 0, 10, true
from public.books b where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6'
on conflict (book_id, format) do update set price_cents = 6000, sku = excluded.sku, is_active = true, updated_at = timezone('utc', now());

insert into public.book_tags (book_id, tag)
select b.id, t.tag from public.books b
cross join (values ('akuapem-twi'), ('ghanaian-language'), ('premsco'), ('nacca'), ('ghana'), ('primary-6')) as t(tag)
where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6'
on conflict do nothing;

delete from public.book_images where book_id = (select id from public.books where slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6');
insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
select b.id, '/covers/premsco-akuapem-twi-nyansapow-gyinapen-6/front.jpg',
  'Akuapem Twi Nyansapɔw Gyinapɛn 6 front cover', 0, true
from public.books b where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6';

insert into public.collection_books (collection_id, book_id, sort_order)
select c.id, b.id, 0 from public.collections c cross join public.books b
where b.slug = 'premsco-akuapem-twi-nyansapow-gyinapen-6' and c.slug in ('new-arrivals', 'best-sellers')
on conflict do nothing;
