-- Align payment_provider with Moolre-only checkout.
ALTER TYPE public.payment_provider ADD VALUE IF NOT EXISTS 'moolre';

UPDATE public.site_settings
SET value = '{"providers":["moolre"]}'::jsonb,
    updated_at = now()
WHERE key = 'payments';
