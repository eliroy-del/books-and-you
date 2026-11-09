-- Sinar Spectra A4 colour paper is a 100-sheet rainbow pack at GH₵85.

update public.books
set
  subtitle = 'A4 · 100 sheets · rainbow pack',
  description = 'Sinar Spectra premium colour paper, A4 (210 × 297 mm). Rainbow pack of 100 sheets.',
  synopsis = 'A4 rainbow pack of 100 Sinar Spectra colour sheets.',
  table_of_contents = array['A4','100 sheets','Rainbow pack'],
  metadata = jsonb_build_object(
    'product_type', 'stationery',
    'brand', 'Sinar Spectra',
    'size', 'A4 (210 × 297 mm)',
    'sheets', 100,
    'pack', 'rainbow',
    'barcode', '6965955465683'
  ),
  updated_at = timezone('utc', now())
where slug = 'sinar-spectra-premium-colour-paper-a4';

update public.book_inventory i
set price_cents = 8500,
    updated_at = timezone('utc', now())
from public.books b
where i.book_id = b.id
  and b.slug = 'sinar-spectra-premium-colour-paper-a4'
  and i.sku = 'SKU-SINAR-SPECTRA-A4';

update public.book_images
set alt_text = 'Sinar Spectra A4 colour paper, 100-sheet rainbow pack'
where book_id = (select id from public.books where slug = 'sinar-spectra-premium-colour-paper-a4')
  and is_primary = true;
