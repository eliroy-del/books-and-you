-- Raise Sinarline ruled paper, 200 sheets, from GH₵70 to GH₵80.

update public.book_inventory i
set price_cents = 8000,
    updated_at = timezone('utc', now())
from public.books b
where i.book_id = b.id
  and b.slug = 'sinarline-ruled-paper-33x42-200'
  and i.sku = 'SKU-SINARLINE-RULED-200';
