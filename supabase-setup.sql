-- Explore with Toluwani: reviews table + photo storage
-- Paste all of this into Supabase > SQL Editor > New query, then press Run.

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  city text not null check (char_length(city) between 1 and 40),
  spot text not null check (char_length(spot) between 1 and 120),
  name text not null check (char_length(name) between 1 and 120),
  area text not null default '' check (char_length(area) <= 120),
  by_name text not null default 'Someone' check (char_length(by_name) between 1 and 40),
  stars smallint not null default 0 check (stars between 0 and 5),
  note text not null default '' check (char_length(note) <= 2000),
  company text not null default '' check (char_length(company) <= 30),
  spent integer check (spent is null or spent between 0 and 10000000),
  back text not null default '' check (back in ('', 'yes', 'maybe', 'no')),
  photos text[] not null default '{}' check (cardinality(photos) <= 4),
  check (stars > 0 or char_length(note) > 0)
);

create index if not exists reviews_city_created_idx on public.reviews (city, created_at desc);

-- anyone can read and post reviews; nobody can edit or delete through the app
alter table public.reviews enable row level security;
drop policy if exists "anyone can read reviews" on public.reviews;
create policy "anyone can read reviews" on public.reviews for select to anon, authenticated using (true);
drop policy if exists "anyone can post a review" on public.reviews;
create policy "anyone can post a review" on public.reviews for insert to anon, authenticated with check (true);
grant select, insert on public.reviews to anon, authenticated;

-- public bucket for review photos: jpg only, up to 2 MB each
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('review-photos', 'review-photos', true, 2097152, array['image/jpeg'])
on conflict (id) do nothing;

drop policy if exists "anyone can upload review photos" on storage.objects;
create policy "anyone can upload review photos" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'review-photos');
