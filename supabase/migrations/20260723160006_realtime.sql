-- Books & You — Realtime publication for live inventory / orders / support

do $$
begin
  -- Ignore if publication or table already added
  begin
    alter publication supabase_realtime add table public.book_inventory;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.orders;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.shipping;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.tracking_events;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.notifications;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.ticket_messages;
  exception when duplicate_object then null; when undefined_object then null; end;

  begin
    alter publication supabase_realtime add table public.cart_items;
  exception when duplicate_object then null; when undefined_object then null; end;
end $$;
