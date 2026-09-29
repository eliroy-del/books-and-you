-- Rename admin-listed New Age Science to include Basic 6.

update public.books
set
  title = 'New Age Science Basic 6',
  updated_at = timezone('utc', now())
where slug = 'new-age-science';

update public.book_images
set alt_text = replace(alt_text, 'New Age Science', 'New Age Science Basic 6')
where book_id = (select id from public.books where slug = 'new-age-science');
