-- Super-admin flag on profiles + RLS: admins see and manage all tenant rows (Refine panel).
-- After apply: set your admin user once, e.g.:
--   update public.profiles set is_admin = true where id = '<auth.users uuid>';

alter table public.profiles
  add column if not exists is_admin boolean not null default false;

comment on column public.profiles.is_admin is 'When true, RLS allows full access to CRM tables (use only for trusted operators).';

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select p.is_admin from public.profiles p where p.id = auth.uid()),
    false
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

-- Replace per-user policies with (own row OR admin).

drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;

create policy "profiles_select_own_or_admin" on public.profiles
  for select using (auth.uid() = id or public.is_admin());

create policy "profiles_update_own_or_admin" on public.profiles
  for update using (auth.uid() = id or public.is_admin());

drop policy if exists "customers_all_own" on public.customers;
create policy "customers_all_own_or_admin" on public.customers
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "customer_notes_all_own" on public.customer_notes;
create policy "customer_notes_all_own_or_admin" on public.customer_notes
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "properties_all_own" on public.properties;
create policy "properties_all_own_or_admin" on public.properties
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "property_media_all_own" on public.property_media;
create policy "property_media_all_own_or_admin" on public.property_media
  for all using (
    public.is_admin()
    or exists (
      select 1 from public.properties p
      where p.id = property_media.property_id and p.user_id = auth.uid()
    )
  )
  with check (
    public.is_admin()
    or exists (
      select 1 from public.properties p
      where p.id = property_media.property_id and p.user_id = auth.uid()
    )
  );

drop policy if exists "tasks_all_own" on public.tasks;
create policy "tasks_all_own_or_admin" on public.tasks
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "matches_all_own" on public.matches;
create policy "matches_all_own_or_admin" on public.matches
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "share_cards_all_own" on public.share_cards;
create policy "share_cards_all_own_or_admin" on public.share_cards
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "redirect_links_all_own" on public.redirect_links;
create policy "redirect_links_all_own_or_admin" on public.redirect_links
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

drop policy if exists "tickets_all_own" on public.tickets;
create policy "tickets_all_own_or_admin" on public.tickets
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());
