-- Guest checkout: orders/transactions may exist without a signed-in profile.
ALTER TABLE public.orders ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE public.transactions ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS guest_email text,
  ADD COLUMN IF NOT EXISTS guest_phone text,
  ADD COLUMN IF NOT EXISTS guest_name text,
  ADD COLUMN IF NOT EXISTS is_guest boolean NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS orders_guest_phone_idx
  ON public.orders (guest_phone)
  WHERE guest_phone IS NOT NULL;

CREATE INDEX IF NOT EXISTS orders_is_guest_idx
  ON public.orders (is_guest)
  WHERE is_guest = true;
