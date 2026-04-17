-- Row level security for Hestora CRM (single-tenant per user_id).
-- Run after 001_initial_schema.sql.

alter table public.profiles enable row level security;
alter table public.customers enable row level security;
alter table public.customer_notes enable row level security;
alter table public.properties enable row level security;
alter table public.property_media enable row level security;
alter table public.tasks enable row level security;
alter table public.matches enable row level security;
alter table public.share_templates enable row level security;
alter table public.share_cards enable row level security;
alter table public.redirect_links enable row level security;
alter table public.tickets enable row level security;

-- Profiles: users manage only their own row.
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- Customers
create policy "customers_all_own" on public.customers
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Customer notes
create policy "customer_notes_all_own" on public.customer_notes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Properties
create policy "properties_all_own" on public.properties
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Property media (via property ownership)
create policy "property_media_all_own" on public.property_media
  for all using (
    exists (
      select 1 from public.properties p
      where p.id = property_media.property_id and p.user_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.properties p
      where p.id = property_media.property_id and p.user_id = auth.uid()
    )
  );

-- Tasks
create policy "tasks_all_own" on public.tasks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Matches
create policy "matches_all_own" on public.matches
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Share templates: read-only catalog for authenticated users (seed via SQL).
create policy "share_templates_read" on public.share_templates
  for select to authenticated using (true);

-- Share cards
create policy "share_cards_all_own" on public.share_cards
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Redirect links
create policy "redirect_links_all_own" on public.redirect_links
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Tickets
create policy "tickets_all_own" on public.tickets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
