-- Books & You · Phase 2 Schema
-- Extensions, enums, core tables

create extension if not exists "pgcrypto";
create extension if not exists "unaccent";

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

do $$ begin
  create type public.user_status as enum ('active', 'suspended', 'deleted');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.book_format as enum ('hardcover', 'paperback', 'ebook', 'audiobook');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.order_status as enum (
    'pending', 'ordered', 'packed', 'shipped', 'delivered', 'completed', 'cancelled', 'refunded'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.payment_status as enum (
    'pending', 'processing', 'succeeded', 'failed', 'refunded', 'partially_refunded'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.payment_provider as enum (
    'paystack', 'flutterwave', 'stripe', 'wallet', 'manual', 'moolre'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.subscription_interval as enum ('monthly', 'quarterly', 'annual');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.subscription_status as enum (
    'trialing', 'active', 'past_due', 'cancelled', 'expired', 'paused'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.ticket_status as enum ('open', 'pending', 'resolved', 'closed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.ticket_priority as enum ('low', 'medium', 'high', 'urgent');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.wallet_tx_type as enum (
    'credit', 'debit', 'referral_reward', 'refund', 'purchase', 'adjustment'
  );
exception when duplicate_object then null; end $$;

-- ---------------------------------------------------------------------------
-- Updated-at helper
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- RBAC
-- ---------------------------------------------------------------------------

create table if not exists public.roles (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  name text not null,
  description text,
  is_system boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.permissions (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  name text not null,
  module text not null,
  description text,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.role_permissions (
  role_id uuid not null references public.roles(id) on delete cascade,
  permission_id uuid not null references public.permissions(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (role_id, permission_id)
);

-- ---------------------------------------------------------------------------
-- Profiles & user data
-- ---------------------------------------------------------------------------

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  avatar_url text,
  phone text,
  status public.user_status not null default 'active',
  role_id uuid references public.roles(id),
  referral_code text unique,
  referred_by uuid references public.profiles(id),
  favorite_genres text[] not null default '{}',
  reading_goal integer not null default 12,
  reading_streak integer not null default 0,
  locale text not null default 'en-GH',
  currency text not null default 'GHS',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists profiles_role_id_idx on public.profiles(role_id);
create index if not exists profiles_referral_code_idx on public.profiles(referral_code);

create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  label text not null default 'Home',
  full_name text not null,
  line1 text not null,
  line2 text,
  city text not null,
  region text not null,
  postal_code text,
  country text not null default 'Ghana',
  phone text,
  is_default boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists addresses_user_id_idx on public.addresses(user_id);

create table if not exists public.saved_payment_methods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  provider public.payment_provider not null,
  provider_ref text,
  brand text,
  last4 text,
  exp_month integer,
  exp_year integer,
  is_default boolean not null default false,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists saved_payment_methods_user_id_idx on public.saved_payment_methods(user_id);

-- ---------------------------------------------------------------------------
-- Catalog
-- ---------------------------------------------------------------------------

create table if not exists public.authors (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  bio text,
  nationality text,
  avatar_url text,
  avatar_color text,
  website_url text,
  followers_count integer not null default 0,
  is_verified boolean not null default false,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.publishers (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  country text,
  logo_url text,
  website_url text,
  description text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text,
  accent text,
  parent_id uuid references public.categories(id) on delete cascade,
  depth integer not null default 0,
  sort_order integer not null default 0,
  is_featured boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists categories_parent_id_idx on public.categories(parent_id);

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  subtitle text,
  description text,
  synopsis text,
  isbn text unique,
  pages integer,
  language text not null default 'English',
  published_at date,
  publisher_id uuid references public.publishers(id) on delete set null,
  cover_url text,
  cover_gradient text,
  cover_accent text,
  rating_avg numeric(3,2) not null default 0,
  review_count integer not null default 0,
  is_featured boolean not null default false,
  is_bestseller boolean not null default false,
  is_new_arrival boolean not null default false,
  is_staff_pick boolean not null default false,
  is_award_winner boolean not null default false,
  is_preorder boolean not null default false,
  release_date date,
  table_of_contents text[] not null default '{}',
  genres text[] not null default '{}',
  search_vector tsvector,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists books_publisher_id_idx on public.books(publisher_id);
create index if not exists books_featured_idx on public.books(is_featured) where is_featured;
create index if not exists books_search_vector_idx on public.books using gin(search_vector);
create index if not exists books_genres_idx on public.books using gin(genres);

create table if not exists public.book_authors (
  book_id uuid not null references public.books(id) on delete cascade,
  author_id uuid not null references public.authors(id) on delete cascade,
  is_primary boolean not null default true,
  sort_order integer not null default 0,
  primary key (book_id, author_id)
);

create table if not exists public.book_categories (
  book_id uuid not null references public.books(id) on delete cascade,
  category_id uuid not null references public.categories(id) on delete cascade,
  primary key (book_id, category_id)
);

create table if not exists public.book_images (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  url text not null,
  alt_text text,
  sort_order integer not null default 0,
  is_primary boolean not null default false,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists book_images_book_id_idx on public.book_images(book_id);

create table if not exists public.book_tags (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  tag text not null,
  unique (book_id, tag)
);

create index if not exists book_tags_tag_idx on public.book_tags(tag);

create table if not exists public.book_inventory (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  format public.book_format not null,
  sku text unique,
  price_cents integer not null check (price_cents >= 0),
  compare_at_cents integer check (compare_at_cents is null or compare_at_cents >= 0),
  currency text not null default 'GHS',
  quantity_on_hand integer not null default 0,
  quantity_reserved integer not null default 0,
  low_stock_threshold integer not null default 10,
  is_active boolean not null default true,
  digital_asset_path text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (book_id, format)
);

create index if not exists book_inventory_book_id_idx on public.book_inventory(book_id);

create table if not exists public.book_reviews (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.books(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  title text,
  body text,
  is_verified_purchase boolean not null default false,
  is_published boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (book_id, user_id)
);

create index if not exists book_reviews_book_id_idx on public.book_reviews(book_id);

create table if not exists public.collections (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  description text,
  is_featured boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.collection_books (
  collection_id uuid not null references public.collections(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  sort_order integer not null default 0,
  primary key (collection_id, book_id)
);

create table if not exists public.favorites (
  user_id uuid not null references public.profiles(id) on delete cascade,
  author_id uuid not null references public.authors(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, author_id)
);

create table if not exists public.wishlists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null default 'Default',
  is_default boolean not null default true,
  is_public boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists wishlists_one_default_per_user
  on public.wishlists(user_id)
  where is_default;

create table if not exists public.wishlist_items (
  id uuid primary key default gen_random_uuid(),
  wishlist_id uuid not null references public.wishlists(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  created_at timestamptz not null default timezone('utc', now()),
  unique (wishlist_id, book_id)
);

create table if not exists public.reading_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  viewed_at timestamptz not null default timezone('utc', now()),
  source text
);

create index if not exists reading_history_user_id_idx on public.reading_history(user_id, viewed_at desc);

create table if not exists public.library_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  format public.book_format not null check (format in ('ebook', 'audiobook')),
  progress_percent integer not null default 0 check (progress_percent between 0 and 100),
  last_opened_at timestamptz,
  bookmarks_count integer not null default 0,
  highlights_count integer not null default 0,
  notes_count integer not null default 0,
  order_item_id uuid,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (user_id, book_id, format)
);

create index if not exists library_items_user_id_idx on public.library_items(user_id);
