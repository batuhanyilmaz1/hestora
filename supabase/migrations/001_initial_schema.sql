-- Hestora CRM initial schema. Run in Supabase SQL Editor (or supabase db push).
-- After this file, add RLS policies in 002_rls_policies.sql.

-- Profiles mirror auth user preferences.
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  phone text,
  country_code text,
  language_code text default 'tr',
  currency_code text default 'TRY',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  phone text,
  email text,
  notes text,
  tags text[] default '{}',
  listing_intent text,
  preferred_location text,
  budget_min numeric,
  budget_max numeric,
  room_count int,
  area_min_sqm numeric,
  area_max_sqm numeric,
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists customers_user_id_idx on public.customers (user_id);
create index if not exists customers_name_idx on public.customers (name);

create table if not exists public.customer_notes (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create index if not exists customer_notes_customer_id_idx on public.customer_notes (customer_id);

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  description text,
  listing_type text not null default 'sale',
  category text,
  price numeric,
  currency text default 'TRY',
  area_sqm numeric,
  room_count int,
  bathroom_count int,
  location text,
  features text[] default '{}',
  listing_url text,
  active boolean not null default true,
  share_click_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists properties_user_id_idx on public.properties (user_id);
create index if not exists properties_listing_type_idx on public.properties (listing_type);

create table if not exists public.property_media (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties (id) on delete cascade,
  storage_path text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  customer_id uuid references public.customers (id) on delete set null,
  property_id uuid references public.properties (id) on delete set null,
  title text not null,
  body text,
  due_at timestamptz,
  priority text default 'normal',
  status text not null default 'open',
  archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tasks_user_id_idx on public.tasks (user_id);

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  customer_id uuid not null references public.customers (id) on delete cascade,
  property_id uuid not null references public.properties (id) on delete cascade,
  score numeric not null,
  created_at timestamptz not null default now(),
  unique (customer_id, property_id)
);

create table if not exists public.share_templates (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  label text not null,
  aspect text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.share_cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  property_id uuid not null references public.properties (id) on delete cascade,
  template_id uuid references public.share_templates (id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.redirect_links (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  property_id uuid not null references public.properties (id) on delete cascade,
  short_code text not null unique,
  target_url text not null,
  click_count int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  subject text not null,
  body text,
  status text not null default 'open',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Keep updated_at in sync (simple trigger pattern).
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists customers_updated_at on public.customers;
create trigger customers_updated_at
before update on public.customers
for each row execute function public.set_updated_at();

drop trigger if exists properties_updated_at on public.properties;
create trigger properties_updated_at
before update on public.properties
for each row execute function public.set_updated_at();

drop trigger if exists tasks_updated_at on public.tasks;
create trigger tasks_updated_at
before update on public.tasks
for each row execute function public.set_updated_at();

drop trigger if exists tickets_updated_at on public.tickets;
create trigger tickets_updated_at
before update on public.tickets
for each row execute function public.set_updated_at();

-- Auto-create profile row on signup.
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id)
  values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer set search_path = public;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
