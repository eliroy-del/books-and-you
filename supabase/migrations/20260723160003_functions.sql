-- Books & You · Helper functions, triggers, search

-- ---------------------------------------------------------------------------
-- RBAC helpers (SECURITY DEFINER for RLS)
-- ---------------------------------------------------------------------------

create or replace function public.current_profile_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select auth.uid();
$$;

create or replace function public.is_superadmin()
returns boolean
language sql
stable
security definer
set search_path = public
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

create or replace function public.has_permission(permission_key text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    public.is_superadmin()
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

create or replace function public.has_any_permission(permission_keys text[])
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    public.is_superadmin()
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

create or replace function public.is_staff()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    public.is_superadmin()
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

-- ---------------------------------------------------------------------------
-- Auth profile bootstrap
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  customer_role_id uuid;
  new_code text;
begin
  select id into customer_role_id from public.roles where key = 'customer' limit 1;

  new_code := upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));

  insert into public.profiles (id, email, full_name, role_id, referral_code, avatar_url)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    customer_role_id,
    new_code,
    new.raw_user_meta_data->>'avatar_url'
  )
  on conflict (id) do update
    set email = excluded.email,
        updated_at = timezone('utc', now());

  insert into public.wallets (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  if not exists (
    select 1 from public.wishlists where user_id = new.id and is_default
  ) then
    insert into public.wishlists (user_id, name, is_default)
    values (new.id, 'Default', true);
  end if;

  insert into public.carts (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Book search vector
-- ---------------------------------------------------------------------------

create or replace function public.books_search_vector_update()
returns trigger
language plpgsql
as $$
begin
  new.search_vector :=
    setweight(to_tsvector('english', coalesce(new.title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(new.subtitle, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(new.isbn, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(array_to_string(new.genres, ' '), '')), 'B') ||
    setweight(to_tsvector('english', coalesce(new.description, '')), 'C') ||
    setweight(to_tsvector('english', coalesce(new.synopsis, '')), 'C');
  return new;
end;
$$;

drop trigger if exists books_search_vector_trigger on public.books;
create trigger books_search_vector_trigger
  before insert or update of title, subtitle, isbn, genres, description, synopsis
  on public.books
  for each row execute function public.books_search_vector_update();

-- ---------------------------------------------------------------------------
-- Review aggregates
-- ---------------------------------------------------------------------------

create or replace function public.refresh_book_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_book uuid;
begin
  target_book := coalesce(new.book_id, old.book_id);
  update public.books b
  set
    rating_avg = coalesce((
      select round(avg(r.rating)::numeric, 2)
      from public.book_reviews r
      where r.book_id = target_book and r.is_published
    ), 0),
    review_count = (
      select count(*)::integer
      from public.book_reviews r
      where r.book_id = target_book and r.is_published
    ),
    updated_at = timezone('utc', now())
  where b.id = target_book;
  return coalesce(new, old);
end;
$$;

drop trigger if exists book_reviews_refresh_rating on public.book_reviews;
create trigger book_reviews_refresh_rating
  after insert or update or delete on public.book_reviews
  for each row execute function public.refresh_book_rating();

-- ---------------------------------------------------------------------------
-- Order number generator
-- ---------------------------------------------------------------------------

create or replace function public.generate_order_number()
returns trigger
language plpgsql
as $$
begin
  if new.order_number is null or new.order_number = '' then
    new.order_number := 'BY-' || to_char(timezone('utc', now()), 'YYMMDD') || '-' ||
      upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 6));
  end if;
  return new;
end;
$$;

drop trigger if exists orders_generate_number on public.orders;
create trigger orders_generate_number
  before insert on public.orders
  for each row execute function public.generate_order_number();

create or replace function public.generate_ticket_number()
returns trigger
language plpgsql
as $$
begin
  if new.ticket_number is null or new.ticket_number = '' then
    new.ticket_number := 'TCK-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
  end if;
  return new;
end;
$$;

drop trigger if exists tickets_generate_number on public.tickets;
create trigger tickets_generate_number
  before insert on public.tickets
  for each row execute function public.generate_ticket_number();

-- ---------------------------------------------------------------------------
-- updated_at triggers
-- ---------------------------------------------------------------------------

do $$
declare
  t text;
begin
  foreach t in array array[
    'roles','profiles','addresses','saved_payment_methods','authors','publishers',
    'categories','books','book_inventory','book_reviews','collections','wishlists',
    'library_items','carts','cart_items','orders','transactions','payments','refunds',
    'shipping','coupons','gift_cards','plans','subscriptions','wallets','tickets',
    'notification_templates'
  ]
  loop
    execute format('drop trigger if exists set_updated_at on public.%I', t);
    execute format(
      'create trigger set_updated_at before update on public.%I
       for each row execute function public.set_updated_at()',
      t
    );
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Inventory availability helper (for realtime consumers)
-- ---------------------------------------------------------------------------

create or replace function public.inventory_available(p_inventory_id uuid)
returns integer
language sql
stable
as $$
  select greatest(quantity_on_hand - quantity_reserved, 0)
  from public.book_inventory
  where id = p_inventory_id;
$$;

grant execute on function public.is_superadmin() to authenticated, anon;
grant execute on function public.has_permission(text) to authenticated, anon;
grant execute on function public.has_any_permission(text[]) to authenticated, anon;
grant execute on function public.is_staff() to authenticated, anon;
grant execute on function public.current_profile_id() to authenticated, anon;
grant execute on function public.inventory_available(uuid) to authenticated, anon;
