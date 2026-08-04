-- Books & You · Storage buckets + policies

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('book-covers', 'book-covers', true, 5242880, array['image/jpeg','image/png','image/webp','image/avif']),
  ('ebooks', 'ebooks', false, 104857600, array['application/epub+zip','application/pdf','application/octet-stream']),
  ('author-images', 'author-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/avif']),
  ('publisher-logos', 'publisher-logos', true, 2097152, array['image/jpeg','image/png','image/webp','image/svg+xml']),
  ('receipts', 'receipts', false, 10485760, array['application/pdf','image/jpeg','image/png']),
  ('user-uploads', 'user-uploads', false, 10485760, array['image/jpeg','image/png','image/webp','application/pdf']),
  ('avatars', 'avatars', true, 2097152, array['image/jpeg','image/png','image/webp']),
  ('marketing-assets', 'marketing-assets', true, 10485760, array['image/jpeg','image/png','image/webp','image/avif','image/gif'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Public read for public buckets
drop policy if exists "Public read book-covers" on storage.objects;
create policy "Public read book-covers" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'book-covers');

drop policy if exists "Public read author-images" on storage.objects;
create policy "Public read author-images" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'author-images');

drop policy if exists "Public read publisher-logos" on storage.objects;
create policy "Public read publisher-logos" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'publisher-logos');

drop policy if exists "Public read avatars" on storage.objects;
create policy "Public read avatars" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'avatars');

drop policy if exists "Public read marketing-assets" on storage.objects;
create policy "Public read marketing-assets" on storage.objects
  for select to anon, authenticated
  using (bucket_id = 'marketing-assets');

-- Staff write for catalog assets
drop policy if exists "Staff write catalog media" on storage.objects;
create policy "Staff write catalog media" on storage.objects
  for all to authenticated
  using (
    bucket_id in ('book-covers', 'author-images', 'publisher-logos', 'marketing-assets', 'ebooks')
    and public.has_any_permission(array['catalog.write', 'inventory.write', 'marketing.write'])
  )
  with check (
    bucket_id in ('book-covers', 'author-images', 'publisher-logos', 'marketing-assets', 'ebooks')
    and public.has_any_permission(array['catalog.write', 'inventory.write', 'marketing.write'])
  );

-- Avatars: users manage own folder {user_id}/...
drop policy if exists "Users manage own avatars" on storage.objects;
create policy "Users manage own avatars" on storage.objects
  for all to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- User uploads: own folder
drop policy if exists "Users manage own uploads" on storage.objects;
create policy "Users manage own uploads" on storage.objects
  for all to authenticated
  using (
    bucket_id = 'user-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'user-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Receipts: own folder or finance staff
drop policy if exists "Users read own receipts" on storage.objects;
create policy "Users read own receipts" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'receipts'
    and (
      (storage.foldername(name))[1] = auth.uid()::text
      or public.has_permission('finance.read')
    )
  );

drop policy if exists "Staff write receipts" on storage.objects;
create policy "Staff write receipts" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'receipts'
    and public.has_any_permission(array['finance.write', 'orders.write'])
  );

-- eBooks: owners via library OR staff
drop policy if exists "Readers access purchased ebooks" on storage.objects;
create policy "Readers access purchased ebooks" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'ebooks'
    and (
      public.has_permission('inventory.read')
      or exists (
        select 1
        from public.library_items li
        join public.books b on b.id = li.book_id
        where li.user_id = auth.uid()
          and li.format in ('ebook', 'audiobook')
          and (
            name like '%' || b.slug || '%'
            or name like li.book_id::text || '%'
          )
      )
    )
  );
