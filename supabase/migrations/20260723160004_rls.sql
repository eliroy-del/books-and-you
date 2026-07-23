-- Books & You — Row Level Security

-- Enable RLS on all public tables
do $$
declare
  r record;
begin
  for r in
    select c.relname as table_name
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'r'
      and c.relname not like 'pg_%'
  loop
    execute format('alter table public.%I enable row level security', r.table_name);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Profiles
-- ---------------------------------------------------------------------------

drop policy if exists "profiles_select_own_or_staff" on public.profiles;
create policy "profiles_select_own_or_staff" on public.profiles
  for select to authenticated
  using (id = auth.uid() or public.is_staff());

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = auth.uid() or public.has_permission('customers.write'))
  with check (id = auth.uid() or public.has_permission('customers.write'));

-- ---------------------------------------------------------------------------
-- Addresses / payment methods
-- ---------------------------------------------------------------------------

drop policy if exists "addresses_own_all" on public.addresses;
create policy "addresses_own_all" on public.addresses
  for all to authenticated
  using (user_id = auth.uid() or public.has_permission('customers.write'))
  with check (user_id = auth.uid() or public.has_permission('customers.write'));

drop policy if exists "saved_payment_methods_own_all" on public.saved_payment_methods;
create policy "saved_payment_methods_own_all" on public.saved_payment_methods
  for all to authenticated
  using (user_id = auth.uid() or public.has_permission('finance.read'))
  with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Public catalog (read for everyone)
-- ---------------------------------------------------------------------------

drop policy if exists "authors_public_read" on public.authors;
create policy "authors_public_read" on public.authors
  for select to anon, authenticated using (true);

drop policy if exists "authors_staff_write" on public.authors;
create policy "authors_staff_write" on public.authors
  for all to authenticated
  using (public.has_any_permission(array['authors.write', 'catalog.write']))
  with check (public.has_any_permission(array['authors.write', 'catalog.write']));

drop policy if exists "publishers_public_read" on public.publishers;
create policy "publishers_public_read" on public.publishers
  for select to anon, authenticated using (true);

drop policy if exists "publishers_staff_write" on public.publishers;
create policy "publishers_staff_write" on public.publishers
  for all to authenticated
  using (public.has_any_permission(array['publishers.write', 'catalog.write']))
  with check (public.has_any_permission(array['publishers.write', 'catalog.write']));

drop policy if exists "categories_public_read" on public.categories;
create policy "categories_public_read" on public.categories
  for select to anon, authenticated using (true);

drop policy if exists "categories_staff_write" on public.categories;
create policy "categories_staff_write" on public.categories
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "books_public_read" on public.books;
create policy "books_public_read" on public.books
  for select to anon, authenticated using (true);

drop policy if exists "books_staff_write" on public.books;
create policy "books_staff_write" on public.books
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "book_authors_public_read" on public.book_authors;
create policy "book_authors_public_read" on public.book_authors
  for select to anon, authenticated using (true);

drop policy if exists "book_authors_staff_write" on public.book_authors;
create policy "book_authors_staff_write" on public.book_authors
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "book_categories_public_read" on public.book_categories;
create policy "book_categories_public_read" on public.book_categories
  for select to anon, authenticated using (true);

drop policy if exists "book_categories_staff_write" on public.book_categories;
create policy "book_categories_staff_write" on public.book_categories
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "book_images_public_read" on public.book_images;
create policy "book_images_public_read" on public.book_images
  for select to anon, authenticated using (true);

drop policy if exists "book_images_staff_write" on public.book_images;
create policy "book_images_staff_write" on public.book_images
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "book_tags_public_read" on public.book_tags;
create policy "book_tags_public_read" on public.book_tags
  for select to anon, authenticated using (true);

drop policy if exists "book_tags_staff_write" on public.book_tags;
create policy "book_tags_staff_write" on public.book_tags
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "book_inventory_public_read" on public.book_inventory;
create policy "book_inventory_public_read" on public.book_inventory
  for select to anon, authenticated using (is_active = true or public.has_permission('inventory.read'));

drop policy if exists "book_inventory_staff_write" on public.book_inventory;
create policy "book_inventory_staff_write" on public.book_inventory
  for all to authenticated
  using (public.has_permission('inventory.write'))
  with check (public.has_permission('inventory.write'));

drop policy if exists "collections_public_read" on public.collections;
create policy "collections_public_read" on public.collections
  for select to anon, authenticated using (true);

drop policy if exists "collections_staff_write" on public.collections;
create policy "collections_staff_write" on public.collections
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "collection_books_public_read" on public.collection_books;
create policy "collection_books_public_read" on public.collection_books
  for select to anon, authenticated using (true);

drop policy if exists "collection_books_staff_write" on public.collection_books;
create policy "collection_books_staff_write" on public.collection_books
  for all to authenticated
  using (public.has_permission('catalog.write'))
  with check (public.has_permission('catalog.write'));

drop policy if exists "plans_public_read" on public.plans;
create policy "plans_public_read" on public.plans
  for select to anon, authenticated using (is_active = true or public.is_staff());

drop policy if exists "plans_staff_write" on public.plans;
create policy "plans_staff_write" on public.plans
  for all to authenticated
  using (public.has_permission('subscriptions.write'))
  with check (public.has_permission('subscriptions.write'));

drop policy if exists "promotions_public_read" on public.promotions;
create policy "promotions_public_read" on public.promotions
  for select to anon, authenticated using (is_active = true or public.is_staff());

drop policy if exists "promotions_staff_write" on public.promotions;
create policy "promotions_staff_write" on public.promotions
  for all to authenticated
  using (public.has_permission('marketing.write'))
  with check (public.has_permission('marketing.write'));

-- ---------------------------------------------------------------------------
-- Reviews
-- ---------------------------------------------------------------------------

drop policy if exists "reviews_public_read" on public.book_reviews;
create policy "reviews_public_read" on public.book_reviews
  for select to anon, authenticated
  using (is_published = true or user_id = auth.uid() or public.has_permission('reviews.moderate'));

drop policy if exists "reviews_insert_own" on public.book_reviews;
create policy "reviews_insert_own" on public.book_reviews
  for insert to authenticated
  with check (user_id = auth.uid());

drop policy if exists "reviews_update_own_or_mod" on public.book_reviews;
create policy "reviews_update_own_or_mod" on public.book_reviews
  for update to authenticated
  using (user_id = auth.uid() or public.has_permission('reviews.moderate'))
  with check (user_id = auth.uid() or public.has_permission('reviews.moderate'));

drop policy if exists "reviews_delete_own_or_mod" on public.book_reviews;
create policy "reviews_delete_own_or_mod" on public.book_reviews
  for delete to authenticated
  using (user_id = auth.uid() or public.has_permission('reviews.moderate'));

-- ---------------------------------------------------------------------------
-- User-owned reading data
-- ---------------------------------------------------------------------------

drop policy if exists "favorites_own_all" on public.favorites;
create policy "favorites_own_all" on public.favorites
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "wishlists_own_all" on public.wishlists;
create policy "wishlists_own_all" on public.wishlists
  for all to authenticated
  using (user_id = auth.uid() or is_public = true or public.is_staff())
  with check (user_id = auth.uid());

drop policy if exists "wishlist_items_own_all" on public.wishlist_items;
create policy "wishlist_items_own_all" on public.wishlist_items
  for all to authenticated
  using (
    exists (
      select 1 from public.wishlists w
      where w.id = wishlist_id and (w.user_id = auth.uid() or w.is_public or public.is_staff())
    )
  )
  with check (
    exists (
      select 1 from public.wishlists w
      where w.id = wishlist_id and w.user_id = auth.uid()
    )
  );

drop policy if exists "reading_history_own_all" on public.reading_history;
create policy "reading_history_own_all" on public.reading_history
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "library_items_own_all" on public.library_items;
create policy "library_items_own_all" on public.library_items
  for all to authenticated
  using (user_id = auth.uid() or public.has_permission('orders.read'))
  with check (user_id = auth.uid() or public.has_permission('orders.write'));

-- ---------------------------------------------------------------------------
-- Cart / orders / payments
-- ---------------------------------------------------------------------------

drop policy if exists "carts_own_all" on public.carts;
create policy "carts_own_all" on public.carts
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "cart_items_own_all" on public.cart_items;
create policy "cart_items_own_all" on public.cart_items
  for all to authenticated
  using (
    exists (select 1 from public.carts c where c.id = cart_id and c.user_id = auth.uid())
  )
  with check (
    exists (select 1 from public.carts c where c.id = cart_id and c.user_id = auth.uid())
  );

drop policy if exists "orders_select_own_or_staff" on public.orders;
create policy "orders_select_own_or_staff" on public.orders
  for select to authenticated
  using (user_id = auth.uid() or public.has_permission('orders.read'));

drop policy if exists "orders_insert_own" on public.orders;
create policy "orders_insert_own" on public.orders
  for insert to authenticated
  with check (user_id = auth.uid());

drop policy if exists "orders_update_staff" on public.orders;
create policy "orders_update_staff" on public.orders
  for update to authenticated
  using (public.has_permission('orders.write') or user_id = auth.uid())
  with check (public.has_permission('orders.write') or user_id = auth.uid());

drop policy if exists "order_items_select" on public.order_items;
create policy "order_items_select" on public.order_items
  for select to authenticated
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_id and (o.user_id = auth.uid() or public.has_permission('orders.read'))
    )
  );

drop policy if exists "order_items_insert_own" on public.order_items;
create policy "order_items_insert_own" on public.order_items
  for insert to authenticated
  with check (
    exists (
      select 1 from public.orders o
      where o.id = order_id and (o.user_id = auth.uid() or public.has_permission('orders.write'))
    )
  );

drop policy if exists "transactions_select" on public.transactions;
create policy "transactions_select" on public.transactions
  for select to authenticated
  using (user_id = auth.uid() or public.has_permission('finance.read'));

drop policy if exists "transactions_insert_own" on public.transactions;
create policy "transactions_insert_own" on public.transactions
  for insert to authenticated
  with check (user_id = auth.uid() or public.has_permission('finance.write'));

drop policy if exists "transaction_events_select" on public.transaction_events;
create policy "transaction_events_select" on public.transaction_events
  for select to authenticated
  using (
    exists (
      select 1 from public.transactions t
      where t.id = transaction_id
        and (t.user_id = auth.uid() or public.has_permission('finance.read'))
    )
  );

drop policy if exists "payments_select" on public.payments;
create policy "payments_select" on public.payments
  for select to authenticated
  using (
    exists (
      select 1 from public.transactions t
      where t.id = transaction_id
        and (t.user_id = auth.uid() or public.has_permission('finance.read'))
    )
  );

drop policy if exists "refunds_select" on public.refunds;
create policy "refunds_select" on public.refunds
  for select to authenticated
  using (public.has_permission('finance.read') or public.is_superadmin());

drop policy if exists "refunds_staff_write" on public.refunds;
create policy "refunds_staff_write" on public.refunds
  for all to authenticated
  using (public.has_permission('finance.write'))
  with check (public.has_permission('finance.write'));

drop policy if exists "shipping_select" on public.shipping;
create policy "shipping_select" on public.shipping
  for select to authenticated
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_id and (o.user_id = auth.uid() or public.has_permission('orders.read'))
    )
  );

drop policy if exists "shipping_staff_write" on public.shipping;
create policy "shipping_staff_write" on public.shipping
  for all to authenticated
  using (public.has_permission('orders.write'))
  with check (public.has_permission('orders.write'));

drop policy if exists "tracking_events_select" on public.tracking_events;
create policy "tracking_events_select" on public.tracking_events
  for select to authenticated
  using (
    exists (
      select 1
      from public.shipping s
      join public.orders o on o.id = s.order_id
      where s.id = shipping_id
        and (o.user_id = auth.uid() or public.has_permission('orders.read'))
    )
  );

drop policy if exists "tracking_events_staff_write" on public.tracking_events;
create policy "tracking_events_staff_write" on public.tracking_events
  for all to authenticated
  using (public.has_permission('orders.write'))
  with check (public.has_permission('orders.write'));

-- ---------------------------------------------------------------------------
-- Coupons / gift cards
-- ---------------------------------------------------------------------------

drop policy if exists "coupons_public_read_active" on public.coupons;
create policy "coupons_public_read_active" on public.coupons
  for select to authenticated
  using (is_active = true or public.has_permission('marketing.read'));

drop policy if exists "coupons_staff_write" on public.coupons;
create policy "coupons_staff_write" on public.coupons
  for all to authenticated
  using (public.has_permission('marketing.write'))
  with check (public.has_permission('marketing.write'));

drop policy if exists "gift_cards_own_or_staff" on public.gift_cards;
create policy "gift_cards_own_or_staff" on public.gift_cards
  for select to authenticated
  using (
    purchased_by = auth.uid()
    or redeemed_by = auth.uid()
    or public.has_permission('finance.read')
  );

drop policy if exists "gift_cards_staff_write" on public.gift_cards;
create policy "gift_cards_staff_write" on public.gift_cards
  for all to authenticated
  using (public.has_permission('finance.write'))
  with check (public.has_permission('finance.write'));

-- ---------------------------------------------------------------------------
-- Subscriptions / wallet / referrals
-- ---------------------------------------------------------------------------

drop policy if exists "subscriptions_own_or_staff" on public.subscriptions;
create policy "subscriptions_own_or_staff" on public.subscriptions
  for select to authenticated
  using (user_id = auth.uid() or public.has_permission('subscriptions.read'));

drop policy if exists "subscriptions_insert_own" on public.subscriptions;
create policy "subscriptions_insert_own" on public.subscriptions
  for insert to authenticated
  with check (user_id = auth.uid() or public.has_permission('subscriptions.write'));

drop policy if exists "subscriptions_update" on public.subscriptions;
create policy "subscriptions_update" on public.subscriptions
  for update to authenticated
  using (user_id = auth.uid() or public.has_permission('subscriptions.write'))
  with check (user_id = auth.uid() or public.has_permission('subscriptions.write'));

drop policy if exists "subscription_payments_select" on public.subscription_payments;
create policy "subscription_payments_select" on public.subscription_payments
  for select to authenticated
  using (
    exists (
      select 1 from public.subscriptions s
      where s.id = subscription_id
        and (s.user_id = auth.uid() or public.has_permission('subscriptions.read'))
    )
  );

drop policy if exists "wallets_own_or_staff" on public.wallets;
create policy "wallets_own_or_staff" on public.wallets
  for select to authenticated
  using (user_id = auth.uid() or public.has_permission('finance.read'));

drop policy if exists "wallets_staff_write" on public.wallets;
create policy "wallets_staff_write" on public.wallets
  for update to authenticated
  using (public.has_permission('finance.write') or public.is_superadmin())
  with check (public.has_permission('finance.write') or public.is_superadmin());

drop policy if exists "wallet_tx_own_or_staff" on public.wallet_transactions;
create policy "wallet_tx_own_or_staff" on public.wallet_transactions
  for select to authenticated
  using (
    exists (
      select 1 from public.wallets w
      where w.id = wallet_id
        and (w.user_id = auth.uid() or public.has_permission('finance.read'))
    )
  );

drop policy if exists "referrals_own_or_staff" on public.referrals;
create policy "referrals_own_or_staff" on public.referrals
  for select to authenticated
  using (
    referrer_id = auth.uid()
    or referred_id = auth.uid()
    or public.has_permission('marketing.read')
  );

drop policy if exists "referrals_insert" on public.referrals;
create policy "referrals_insert" on public.referrals
  for insert to authenticated
  with check (referrer_id = auth.uid() or referred_id = auth.uid());

drop policy if exists "referral_rewards_own_or_staff" on public.referral_rewards;
create policy "referral_rewards_own_or_staff" on public.referral_rewards
  for select to authenticated
  using (
    exists (
      select 1 from public.referrals r
      where r.id = referral_id
        and (r.referrer_id = auth.uid() or public.has_permission('marketing.read'))
    )
  );

-- ---------------------------------------------------------------------------
-- Support
-- ---------------------------------------------------------------------------

drop policy if exists "tickets_own_or_staff" on public.tickets;
create policy "tickets_own_or_staff" on public.tickets
  for select to authenticated
  using (user_id = auth.uid() or public.has_permission('support.read'));

drop policy if exists "tickets_insert_own" on public.tickets;
create policy "tickets_insert_own" on public.tickets
  for insert to authenticated
  with check (user_id = auth.uid());

drop policy if exists "tickets_update" on public.tickets;
create policy "tickets_update" on public.tickets
  for update to authenticated
  using (user_id = auth.uid() or public.has_permission('support.write'))
  with check (user_id = auth.uid() or public.has_permission('support.write'));

drop policy if exists "ticket_messages_select" on public.ticket_messages;
create policy "ticket_messages_select" on public.ticket_messages
  for select to authenticated
  using (
    exists (
      select 1 from public.tickets t
      where t.id = ticket_id
        and (t.user_id = auth.uid() or public.has_permission('support.read'))
    )
  );

drop policy if exists "ticket_messages_insert" on public.ticket_messages;
create policy "ticket_messages_insert" on public.ticket_messages
  for insert to authenticated
  with check (
    sender_id = auth.uid()
    and exists (
      select 1 from public.tickets t
      where t.id = ticket_id
        and (t.user_id = auth.uid() or public.has_permission('support.write'))
    )
  );

drop policy if exists "notifications_own" on public.notifications;
create policy "notifications_own" on public.notifications
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- System / RBAC (superadmin + specific perms)
-- ---------------------------------------------------------------------------

drop policy if exists "roles_read_staff" on public.roles;
create policy "roles_read_staff" on public.roles
  for select to authenticated
  using (public.is_staff());

drop policy if exists "roles_write_superadmin" on public.roles;
create policy "roles_write_superadmin" on public.roles
  for all to authenticated
  using (public.is_superadmin())
  with check (public.is_superadmin());

drop policy if exists "permissions_read_staff" on public.permissions;
create policy "permissions_read_staff" on public.permissions
  for select to authenticated
  using (public.is_staff());

drop policy if exists "permissions_write_superadmin" on public.permissions;
create policy "permissions_write_superadmin" on public.permissions
  for all to authenticated
  using (public.is_superadmin())
  with check (public.is_superadmin());

drop policy if exists "role_permissions_read_staff" on public.role_permissions;
create policy "role_permissions_read_staff" on public.role_permissions
  for select to authenticated
  using (public.is_staff());

drop policy if exists "role_permissions_write_superadmin" on public.role_permissions;
create policy "role_permissions_write_superadmin" on public.role_permissions
  for all to authenticated
  using (public.is_superadmin())
  with check (public.is_superadmin());

drop policy if exists "site_settings_read" on public.site_settings;
create policy "site_settings_read" on public.site_settings
  for select to anon, authenticated using (true);

drop policy if exists "site_settings_write" on public.site_settings;
create policy "site_settings_write" on public.site_settings
  for all to authenticated
  using (public.is_superadmin() or public.has_permission('settings.write'))
  with check (public.is_superadmin() or public.has_permission('settings.write'));

drop policy if exists "notification_templates_read_staff" on public.notification_templates;
create policy "notification_templates_read_staff" on public.notification_templates
  for select to authenticated
  using (public.is_staff());

drop policy if exists "notification_templates_write" on public.notification_templates;
create policy "notification_templates_write" on public.notification_templates
  for all to authenticated
  using (public.is_superadmin() or public.has_permission('settings.write'))
  with check (public.is_superadmin() or public.has_permission('settings.write'));

drop policy if exists "audit_logs_read" on public.audit_logs;
create policy "audit_logs_read" on public.audit_logs
  for select to authenticated
  using (public.is_superadmin() or public.has_permission('audit.read'));

drop policy if exists "audit_logs_insert_staff" on public.audit_logs;
create policy "audit_logs_insert_staff" on public.audit_logs
  for insert to authenticated
  with check (public.is_staff());

drop policy if exists "webhook_logs_superadmin" on public.webhook_logs;
create policy "webhook_logs_superadmin" on public.webhook_logs
  for all to authenticated
  using (public.is_superadmin())
  with check (public.is_superadmin());

drop policy if exists "feature_flags_read" on public.feature_flags;
create policy "feature_flags_read" on public.feature_flags
  for select to anon, authenticated using (true);

drop policy if exists "feature_flags_write" on public.feature_flags;
create policy "feature_flags_write" on public.feature_flags
  for all to authenticated
  using (public.is_superadmin())
  with check (public.is_superadmin());
