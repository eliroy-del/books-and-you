-- Combined JHS (Basics 7–9) and SHS (1–3) category slots.

insert into public.categories (slug, name, description, accent, sort_order, depth, is_featured, parent_id)
select
  v.slug,
  v.name,
  v.description,
  v.accent,
  v.sort_order,
  1,
  false,
  p.id
from (
  values
    (
      'jhs-combined',
      'Combined (Basics 7–9)',
      'One book covering JHS 1, 2 and 3.',
      'from-[#001f3e] to-[#3d5a80]',
      24,
      'junior-high-school'
    ),
    (
      'shs-combined',
      'Combined (SHS 1–3)',
      'One book covering SHS 1, 2 and 3.',
      'from-[#0d2136] to-[#efc076]',
      39,
      'senior-high-school'
    ),
    (
      'level-jhs-combined',
      'JHS Combined',
      'Books that cover Basics 7, 8 and 9 together.',
      'from-indigo-700 to-violet-500',
      148,
      'by-school-level'
    ),
    (
      'level-shs-combined',
      'SHS Combined',
      'Books that cover SHS 1, 2 and 3 together.',
      'from-amber-600 to-orange-400',
      152,
      'by-school-level'
    )
) as v(slug, name, description, accent, sort_order, parent_slug)
join public.categories p on p.slug = v.parent_slug
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  parent_id = excluded.parent_id,
  sort_order = excluded.sort_order;
