# Explore with Toluwani

Spin a wheel of food spots in Nigerian cities, then read and post reviews.

- `index.html` is the whole app (static, no build step). Vercel serves it as is.
- Reviews and photos live in Supabase (`reviews` table, `review-photos` bucket).
- `supabase-setup.sql` creates the table, rules and photo bucket. Run it once in the Supabase SQL Editor.
- To remove a review: Supabase → Table Editor → reviews → delete the row.
