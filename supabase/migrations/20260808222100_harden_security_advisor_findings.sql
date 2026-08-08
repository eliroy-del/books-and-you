-- Harden functions flagged by Supabase security advisors.
-- 1) Pin search_path on mutable helper/trigger functions
-- 2) Move unaccent out of public
-- 3) Put SECURITY DEFINER RLS helpers in private schema
-- 4) Expose thin SECURITY INVOKER public wrappers for app RPC + existing policies
-- 5) Revoke API execute on trigger-only DEFINER functions

create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to postgres, anon, authenticated, service_role;

create schema if not exists extensions;

do $$
begin
  if exists (
    select 1
    from pg_extension e
    join pg_namespace n on n.oid = e.extnamespace
    where e.extname = 'unaccent' and n.nspname = 'public'
  ) then
    execute 'alter extension unaccent set schema extensions';
  elsif not exists (select 1 from pg_extension where extname = 'unaccent') then
    execute 'create extension unaccent with schema extensions';
  end if;
end $$;

alter function public.set_updated_at() set search_path to public;
alter function public.books_search_vector_update() set search_path to public;
alter function public.generate_order_number() set search_path to public;
alter function public.generate_ticket_number() set search_path to public;
alter function public.inventory_available(uuid) set search_path to public;

create or replace function private.current_profile_id()
returns uuid
language sql
stable
security definer
set search_path to public
as $$
  select auth.uid();
$$;

create or replace function private.is_superadmin()
returns boolean
language sql
stable
security definer
set search_path to public
as $$
  select exists (
    select 1
    from public.profiles p
    join public.roles r on r.id = p.role_id
    where p.id = auth.uid()
      and r.key = 'super_admin'
      and p.status = 'active'
  );
$$;

create or replace function private.has_permission(permission_key text)
returns boolean
language sql
stable
security definer
set search_path to public
as $$
  select
    private.is_superadmin()
    or exists (
      select 1
      from public.profiles p
      join public.role_permissions rp on rp.role_id = p.role_id
      join public.permissions perm on perm.id = rp.permission_id
      where p.id = auth.uid()
        and p.status = 'active'
        and perm.key = permission_key
    );
$$;

create or replace function private.has_any_permission(permission_keys text[])
returns boolean
language sql
stable
security definer
set search_path to public
as $$
  select
    private.is_superadmin()
    or exists (
      select 1
      from public.profiles p
      join public.role_permissions rp on rp.role_id = p.role_id
      join public.permissions perm on perm.id = rp.permission_id
      where p.id = auth.uid()
        and p.status = 'active'
        and perm.key = any(permission_keys)
    );
$$;

create or replace function private.is_staff()
returns boolean
language sql
stable
security definer
set search_path to public
as $$
  select
    private.is_superadmin()
    or exists (
      select 1
      from public.profiles p
      join public.roles r on r.id = p.role_id
      where p.id = auth.uid()
        and p.status = 'active'
        and r.key in (
          'super_admin',
          'inventory_manager',
          'sales_manager',
          'support_agent',
          'finance',
          'marketing_manager',
          'publisher_manager'
        )
    );
$$;

revoke all on function private.current_profile_id() from public;
revoke all on function private.is_superadmin() from public;
revoke all on function private.has_permission(text) from public;
revoke all on function private.has_any_permission(text[]) from public;
revoke all on function private.is_staff() from public;

grant execute on function private.current_profile_id() to anon, authenticated, service_role;
grant execute on function private.is_superadmin() to anon, authenticated, service_role;
grant execute on function private.has_permission(text) to anon, authenticated, service_role;
grant execute on function private.has_any_permission(text[]) to anon, authenticated, service_role;
grant execute on function private.is_staff() to anon, authenticated, service_role;

create or replace function public.current_profile_id()
returns uuid
language sql
stable
security invoker
set search_path to public, private
as $$
  select private.current_profile_id();
$$;

create or replace function public.is_superadmin()
returns boolean
language sql
stable
security invoker
set search_path to public, private
as $$
  select private.is_superadmin();
$$;

create or replace function public.has_permission(permission_key text)
returns boolean
language sql
stable
security invoker
set search_path to public, private
as $$
  select private.has_permission(permission_key);
$$;

create or replace function public.has_any_permission(permission_keys text[])
returns boolean
language sql
stable
security invoker
set search_path to public, private
as $$
  select private.has_any_permission(permission_keys);
$$;

create or replace function public.is_staff()
returns boolean
language sql
stable
security invoker
set search_path to public, private
as $$
  select private.is_staff();
$$;

revoke all on function public.current_profile_id() from public;
revoke all on function public.is_superadmin() from public;
revoke all on function public.has_permission(text) from public;
revoke all on function public.has_any_permission(text[]) from public;
revoke all on function public.is_staff() from public;

grant execute on function public.current_profile_id() to anon, authenticated, service_role;
grant execute on function public.is_superadmin() to anon, authenticated, service_role;
grant execute on function public.has_permission(text) to anon, authenticated, service_role;
grant execute on function public.has_any_permission(text[]) to anon, authenticated, service_role;
grant execute on function public.is_staff() to anon, authenticated, service_role;

alter function public.handle_new_user() set search_path to public;
alter function public.refresh_book_rating() set search_path to public;

revoke all on function public.handle_new_user() from public;
revoke all on function public.handle_new_user() from anon, authenticated;
revoke all on function public.refresh_book_rating() from public;
revoke all on function public.refresh_book_rating() from anon, authenticated;
revoke all on function public.rls_auto_enable() from public;
revoke all on function public.rls_auto_enable() from anon, authenticated;

grant execute on function public.handle_new_user() to postgres, service_role;
grant execute on function public.refresh_book_rating() to postgres, service_role;
