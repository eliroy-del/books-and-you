-- Public product cover uploads from the admin CMS.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'product-covers',
  'product-covers',
  true,
  6291456,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = true,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "product covers are public" on storage.objects;
create policy "product covers are public"
on storage.objects
for select
to anon, authenticated
using (bucket_id = 'product-covers');
