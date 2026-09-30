-- Catalog: Teacher's Notebook pink GH₵15, Notebook 3 GH₵25,
-- Teacher's Notebook wave blue GH₵30, Foolscap Notebook blue wave GH₵25.

insert into public.publishers (slug, name, country, description)
values (
  'school-essentials',
  'School Essentials',
  'Ghana',
  'Everyday school stationery and classroom supplies.'
)
on conflict (slug) do update set name = excluded.name;

do $$
declare
  r record;
begin
  for r in
    select * from (values
      (
        'teachers-notebook-pink',
        'Teacher''s Notebook',
        'Pink cover · Name, subject, and date fields',
        'A hard-cover Teacher''s Notebook with a pink geometric cover. The front label has spaces for name, subject, and date commenced — suited to lesson notes and classroom records.',
        'Hard-cover teacher notebook with a pink cover and labelled name, subject, and date fields.',
        'from-[#DB2777] via-[#F9A8D4] to-[#FCE7F3]',
        '#DB2777',
        'SKU-TEACHERS-NOTEBOOK-PINK',
        1500,
        'pink',
        'teacher',
        array['Name','Subject','Date commenced']::text[]
      ),
      (
        'notebook-3',
        'Notebook 3',
        'Blue stripe cover · Name, class, and year fields',
        'A hard-cover Notebook 3 with a blue-and-white stripe cover and kraft spine. The front label has spaces for name, class or form, and year — suited to school notes.',
        'Hard-cover Notebook 3 with a blue stripe cover and labelled name, class, and year fields.',
        'from-[#2563EB] via-[#BFDBFE] to-[#D6D3D1]',
        '#2563EB',
        'SKU-NOTEBOOK-3',
        2500,
        'blue stripe',
        'notebook 3',
        array['Name','Class / Form','Year']::text[]
      ),
      (
        'teachers-notebook-wave-blue',
        'Teacher''s Notebook',
        'Blue wave cover · Name, subject, and date fields',
        'A hard-cover Teacher''s Notebook with a blue wave-pattern cover. The front label has spaces for name, subject, and date commenced — suited to lesson notes and classroom records.',
        'Hard-cover teacher notebook with a blue wave cover and labelled name, subject, and date fields.',
        'from-[#2563EB] via-[#22C55E] to-[#1E3A8A]',
        '#2563EB',
        'SKU-TEACHERS-NOTEBOOK-WAVE-BLUE',
        3000,
        'blue wave',
        'teacher',
        array['Name','Subject','Date commenced']::text[]
      ),
      (
        'foolscap-notebook-blue-wave',
        'Foolscap Notebook',
        'Blue wave cover · Name, subject, and date fields',
        'A hard-cover foolscap notebook with a blue wave-pattern cover and brown spine. The front label has spaces for name, subject, and date commenced — suited to school notes.',
        'Hard-cover foolscap notebook with a blue wave cover and labelled name, subject, and date fields.',
        'from-[#2563EB] via-[#7C2D12] to-[#93C5FD]',
        '#2563EB',
        'SKU-FOOLSCAP-NOTEBOOK-BLUE-WAVE',
        2500,
        'blue wave',
        'foolscap',
        array['Name','Subject','Date commenced']::text[]
      )
    ) as v(book_slug, book_title, subtitle, description, synopsis, gradient, accent, sku, price_cents, cover_style, kind, toc)
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
      r.synopsis,
      null,
      null,
      'English',
      '2024-01-01',
      p.id,
      '/covers/' || r.book_slug || '/front.jpg',
      r.gradient,
      r.accent,
      array['Stationery','Notebooks','School Essentials'],
      r.toc,
      true,
      true,
      jsonb_build_object(
        'product_type', 'stationery',
        'cover', r.cover_style,
        'kind', r.kind
      )
    from public.publishers p
    where p.slug = 'school-essentials'
    on conflict (slug) do update set
      title = excluded.title,
      subtitle = excluded.subtitle,
      description = excluded.description,
      synopsis = excluded.synopsis,
      cover_url = excluded.cover_url,
      cover_gradient = excluded.cover_gradient,
      cover_accent = excluded.cover_accent,
      genres = excluded.genres,
      is_featured = true,
      is_new_arrival = true,
      publisher_id = excluded.publisher_id,
      metadata = excluded.metadata,
      updated_at = timezone('utc', now());

    insert into public.book_categories (book_id, category_id)
    select b.id, c.id
    from public.books b
    cross join public.categories c
    where b.slug = r.book_slug
      and c.slug in ('stationery', 'exercise-note-books', 'notebooks-notebooks')
    on conflict do nothing;

    insert into public.book_inventory (
      book_id, format, sku, price_cents, compare_at_cents, currency,
      quantity_on_hand, quantity_reserved, low_stock_threshold, is_active
    )
    select b.id, 'paperback'::public.book_format, r.sku, r.price_cents, null, 'GHS', 100, 0, 10, true
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
    cross join (values
      ('stationery'),
      ('notebook'),
      (r.kind),
      ('ghana'),
      ('school')
    ) as t(tag)
    where b.slug = r.book_slug
    on conflict do nothing;

    delete from public.book_images where book_id = (select id from public.books where slug = r.book_slug);

    insert into public.book_images (book_id, url, alt_text, sort_order, is_primary)
    select b.id, '/covers/' || r.book_slug || '/front.jpg', r.book_title || ' ' || r.cover_style || ' cover', 0, true
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
