-- Catalog: Foolscap Notebooks — red floral at GH₵35 and blue at GH₵40.

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
        'foolscap-notebook-red-floral',
        'Foolscap Notebook',
        'Red floral cover · Name, school, and class fields',
        'A hard-cover foolscap notebook with a red floral cover and green spine. The front label has spaces for name, school, and class or form — suited to school notes and classroom work.',
        'Hard-cover foolscap notebook with a red floral cover and labelled name, school, and class fields.',
        'from-[#DC2626] via-[#15803D] to-[#FECACA]',
        '#DC2626',
        'SKU-FOOLSCAP-NOTEBOOK-RED-FLORAL',
        3500,
        'red floral'
      ),
      (
        'foolscap-notebook-blue',
        'Foolscap Notebook',
        'Blue cover · Name, school, and class fields',
        'A hard-cover foolscap notebook with a blue patterned cover and black spine. The front label has spaces for name, school, and class or form — suited to school notes and classroom work.',
        'Hard-cover foolscap notebook with a blue patterned cover and labelled name, school, and class fields.',
        'from-[#2563EB] via-[#1E3A8A] to-[#93C5FD]',
        '#2563EB',
        'SKU-FOOLSCAP-NOTEBOOK-BLUE',
        4000,
        'blue'
      )
    ) as v(book_slug, book_title, subtitle, description, synopsis, gradient, accent, sku, price_cents, cover_style)
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
      array['Stationery','Notebooks','Foolscap','School Essentials'],
      array['Name','School','Class / Form'],
      true,
      true,
      jsonb_build_object(
        'product_type', 'stationery',
        'cover', r.cover_style,
        'size', 'foolscap'
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
      ('foolscap'),
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
