-- Customers must not mutate order status (or any order row) via the user client.
-- Fulfillment and shipping updates run as service role or staff with orders.write.
drop policy if exists "orders_update_staff" on public.orders;
create policy "orders_update_staff" on public.orders
  for update to authenticated
  using (public.has_permission('orders.write'))
  with check (public.has_permission('orders.write'));
