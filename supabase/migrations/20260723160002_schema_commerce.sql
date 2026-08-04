-- Books & You · Commerce, subscriptions, referrals, support, system

-- ---------------------------------------------------------------------------
-- Cart & orders
-- ---------------------------------------------------------------------------

create table if not exists public.carts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references public.profiles(id) on delete cascade,
  session_id text unique,
  currency text not null default 'GHS',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint carts_owner_check check (user_id is not null or session_id is not null)
);

create table if not exists public.cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid not null references public.carts(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  inventory_id uuid not null references public.book_inventory(id) on delete restrict,
  format public.book_format not null,
  quantity integer not null default 1 check (quantity > 0),
  unit_price_cents integer not null check (unit_price_cents >= 0),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (cart_id, inventory_id)
);

create index if not exists cart_items_cart_id_idx on public.cart_items(cart_id);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number text not null unique,
  user_id uuid references public.profiles(id) on delete restrict,
  is_guest boolean not null default false,
  guest_name text,
  guest_phone text,
  guest_email text,
  status public.order_status not null default 'pending',
  currency text not null default 'GHS',
  subtotal_cents integer not null default 0,
  shipping_cents integer not null default 0,
  discount_cents integer not null default 0,
  tax_cents integer not null default 0,
  total_cents integer not null default 0,
  coupon_code text,
  shipping_address jsonb,
  billing_address jsonb,
  notes text,
  placed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists orders_user_id_idx on public.orders(user_id);
create index if not exists orders_status_idx on public.orders(status);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete restrict,
  inventory_id uuid references public.book_inventory(id) on delete set null,
  title text not null,
  format public.book_format not null,
  quantity integer not null check (quantity > 0),
  unit_price_cents integer not null check (unit_price_cents >= 0),
  total_cents integer not null check (total_cents >= 0),
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists order_items_order_id_idx on public.order_items(order_id);

alter table public.library_items
  drop constraint if exists library_items_order_item_id_fkey;

alter table public.library_items
  add constraint library_items_order_item_id_fkey
  foreign key (order_item_id) references public.order_items(id) on delete set null;

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete set null,
  user_id uuid references public.profiles(id) on delete restrict,
  provider public.payment_provider not null,
  provider_reference text,
  amount_cents integer not null check (amount_cents >= 0),
  currency text not null default 'GHS',
  status public.payment_status not null default 'pending',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists transactions_order_id_idx on public.transactions(order_id);
create index if not exists transactions_user_id_idx on public.transactions(user_id);

create table if not exists public.transaction_events (
  id uuid primary key default gen_random_uuid(),
  transaction_id uuid not null references public.transactions(id) on delete cascade,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  transaction_id uuid not null references public.transactions(id) on delete cascade,
  order_id uuid references public.orders(id) on delete set null,
  amount_cents integer not null check (amount_cents >= 0),
  currency text not null default 'GHS',
  status public.payment_status not null default 'pending',
  paid_at timestamptz,
  receipt_url text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.refunds (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid not null references public.payments(id) on delete cascade,
  order_id uuid references public.orders(id) on delete set null,
  amount_cents integer not null check (amount_cents >= 0),
  reason text,
  status public.payment_status not null default 'pending',
  provider_reference text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.shipping (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders(id) on delete cascade,
  carrier text,
  tracking_number text,
  status text not null default 'pending',
  estimated_delivery date,
  shipped_at timestamptz,
  delivered_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.tracking_events (
  id uuid primary key default gen_random_uuid(),
  shipping_id uuid not null references public.shipping(id) on delete cascade,
  status text not null,
  note text,
  occurred_at timestamptz not null default timezone('utc', now()),
  location text,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists tracking_events_shipping_id_idx on public.tracking_events(shipping_id);

-- ---------------------------------------------------------------------------
-- Coupons & gift cards
-- ---------------------------------------------------------------------------

create table if not exists public.coupons (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  description text,
  discount_type text not null check (discount_type in ('fixed', 'percent')),
  discount_value integer not null check (discount_value > 0),
  min_order_cents integer not null default 0,
  max_redemptions integer,
  redemption_count integer not null default 0,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.gift_cards (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  initial_balance_cents integer not null check (initial_balance_cents > 0),
  balance_cents integer not null check (balance_cents >= 0),
  currency text not null default 'GHS',
  purchased_by uuid references public.profiles(id) on delete set null,
  redeemed_by uuid references public.profiles(id) on delete set null,
  expires_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Subscriptions
-- ---------------------------------------------------------------------------

create table if not exists public.plans (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  name text not null,
  interval public.subscription_interval not null,
  price_cents integer not null check (price_cents >= 0),
  currency text not null default 'GHS',
  books_per_period integer not null default 1,
  features text[] not null default '{}',
  is_popular boolean not null default false,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  plan_id uuid not null references public.plans(id) on delete restrict,
  status public.subscription_status not null default 'active',
  current_period_start timestamptz not null default timezone('utc', now()),
  current_period_end timestamptz not null,
  cancel_at_period_end boolean not null default false,
  cancelled_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists subscriptions_user_id_idx on public.subscriptions(user_id);

create table if not exists public.subscription_payments (
  id uuid primary key default gen_random_uuid(),
  subscription_id uuid not null references public.subscriptions(id) on delete cascade,
  transaction_id uuid references public.transactions(id) on delete set null,
  amount_cents integer not null,
  currency text not null default 'GHS',
  status public.payment_status not null default 'pending',
  period_start timestamptz,
  period_end timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Referrals & wallet
-- ---------------------------------------------------------------------------

create table if not exists public.wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.profiles(id) on delete cascade,
  balance_cents integer not null default 0 check (balance_cents >= 0),
  currency text not null default 'GHS',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  wallet_id uuid not null references public.wallets(id) on delete cascade,
  type public.wallet_tx_type not null,
  amount_cents integer not null,
  balance_after_cents integer not null,
  description text,
  reference_type text,
  reference_id uuid,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists wallet_transactions_wallet_id_idx on public.wallet_transactions(wallet_id);

create table if not exists public.referrals (
  id uuid primary key default gen_random_uuid(),
  referrer_id uuid not null references public.profiles(id) on delete cascade,
  referred_id uuid not null unique references public.profiles(id) on delete cascade,
  referral_code text not null,
  status text not null default 'pending' check (status in ('pending', 'qualified', 'rewarded', 'rejected')),
  qualified_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists referrals_referrer_id_idx on public.referrals(referrer_id);

create table if not exists public.referral_rewards (
  id uuid primary key default gen_random_uuid(),
  referral_id uuid not null references public.referrals(id) on delete cascade,
  wallet_transaction_id uuid references public.wallet_transactions(id) on delete set null,
  amount_cents integer not null,
  status text not null default 'pending',
  created_at timestamptz not null default timezone('utc', now())
);

-- ---------------------------------------------------------------------------
-- Support
-- ---------------------------------------------------------------------------

create table if not exists public.tickets (
  id uuid primary key default gen_random_uuid(),
  ticket_number text not null unique,
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject text not null,
  status public.ticket_status not null default 'open',
  priority public.ticket_priority not null default 'medium',
  assigned_to uuid references public.profiles(id) on delete set null,
  order_id uuid references public.orders(id) on delete set null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists tickets_user_id_idx on public.tickets(user_id);

create table if not exists public.ticket_messages (
  id uuid primary key default gen_random_uuid(),
  ticket_id uuid not null references public.tickets(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  is_staff boolean not null default false,
  attachments jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists ticket_messages_ticket_id_idx on public.ticket_messages(ticket_id);

-- ---------------------------------------------------------------------------
-- System
-- ---------------------------------------------------------------------------

create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  description text,
  updated_by uuid references public.profiles(id) on delete set null,
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.notification_templates (
  id uuid primary key default gen_random_uuid(),
  key text not null unique,
  channel text not null check (channel in ('email', 'sms', 'push')),
  subject text,
  body text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text,
  type text not null default 'general',
  link text,
  is_read boolean not null default false,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists notifications_user_id_idx on public.notifications(user_id, created_at desc);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  resource_type text,
  resource_id uuid,
  ip_address inet,
  user_agent text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists audit_logs_created_at_idx on public.audit_logs(created_at desc);

create table if not exists public.webhook_logs (
  id uuid primary key default gen_random_uuid(),
  provider text not null,
  event_type text,
  payload jsonb not null default '{}'::jsonb,
  status text not null default 'received',
  error text,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.feature_flags (
  key text primary key,
  enabled boolean not null default false,
  description text,
  metadata jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.promotions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  banner_url text,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default timezone('utc', now())
);
