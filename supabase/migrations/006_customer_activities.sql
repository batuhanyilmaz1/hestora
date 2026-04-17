-- Persistent customer activity timeline + notes alignment helpers.
-- Run after 004_admin_superuser_rls.sql.

create table if not exists public.customer_activities (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  type text not null check (
    type in (
      'customer_created',
      'note_added',
      'task_linked',
      'property_matched',
      'property_shared'
    )
  ),
  body text,
  related_task_id uuid references public.tasks (id) on delete set null,
  related_property_id uuid references public.properties (id) on delete set null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists customer_activities_customer_id_idx
  on public.customer_activities (customer_id, created_at desc);

create index if not exists customer_activities_related_property_idx
  on public.customer_activities (related_property_id)
  where related_property_id is not null;

alter table public.customer_activities enable row level security;

drop policy if exists "customer_activities_all_own_or_admin" on public.customer_activities;
create policy "customer_activities_all_own_or_admin" on public.customer_activities
  for all using (auth.uid() = user_id or public.is_admin())
  with check (auth.uid() = user_id or public.is_admin());

create or replace function public.log_customer_created_activity()
returns trigger
language plpgsql
as $$
begin
  insert into public.customer_activities (
    customer_id,
    user_id,
    type,
    body,
    created_at
  )
  values (
    new.id,
    new.user_id,
    'customer_created',
    new.name,
    coalesce(new.created_at, now())
  );
  return new;
end;
$$;

create or replace function public.log_customer_note_activity()
returns trigger
language plpgsql
as $$
begin
  insert into public.customer_activities (
    customer_id,
    user_id,
    type,
    body,
    created_at
  )
  values (
    new.customer_id,
    new.user_id,
    'note_added',
    new.body,
    coalesce(new.created_at, now())
  );
  return new;
end;
$$;

create or replace function public.log_task_customer_link_activity()
returns trigger
language plpgsql
as $$
begin
  if new.customer_id is null then
    return new;
  end if;

  if tg_op = 'UPDATE' and old.customer_id is not distinct from new.customer_id then
    return new;
  end if;

  insert into public.customer_activities (
    customer_id,
    user_id,
    type,
    body,
    related_task_id,
    related_property_id,
    metadata,
    created_at
  )
  values (
    new.customer_id,
    new.user_id,
    'task_linked',
    new.title,
    new.id,
    new.property_id,
    jsonb_strip_nulls(
      jsonb_build_object(
        'status', new.status,
        'priority', new.priority,
        'due_at', new.due_at
      )
    ),
    now()
  );

  return new;
end;
$$;

drop trigger if exists customers_created_activity on public.customers;
create trigger customers_created_activity
after insert on public.customers
for each row execute function public.log_customer_created_activity();

drop trigger if exists customer_notes_created_activity on public.customer_notes;
create trigger customer_notes_created_activity
after insert on public.customer_notes
for each row execute function public.log_customer_note_activity();

drop trigger if exists tasks_customer_link_activity on public.tasks;
create trigger tasks_customer_link_activity
after insert or update of customer_id on public.tasks
for each row execute function public.log_task_customer_link_activity();

insert into public.customer_activities (customer_id, user_id, type, body, created_at)
select c.id, c.user_id, 'customer_created', c.name, c.created_at
from public.customers c
where not exists (
  select 1
  from public.customer_activities a
  where a.customer_id = c.id
    and a.type = 'customer_created'
);

insert into public.customer_activities (customer_id, user_id, type, body, created_at)
select n.customer_id, n.user_id, 'note_added', n.body, n.created_at
from public.customer_notes n
where not exists (
  select 1
  from public.customer_activities a
  where a.customer_id = n.customer_id
    and a.type = 'note_added'
    and a.created_at = n.created_at
    and a.body is not distinct from n.body
);

insert into public.customer_activities (
  customer_id,
  user_id,
  type,
  body,
  related_task_id,
  related_property_id,
  metadata,
  created_at
)
select
  t.customer_id,
  t.user_id,
  'task_linked',
  t.title,
  t.id,
  t.property_id,
  jsonb_strip_nulls(
    jsonb_build_object(
      'status', t.status,
      'priority', t.priority,
      'due_at', t.due_at
    )
  ),
  coalesce(t.updated_at, t.created_at, now())
from public.tasks t
where t.customer_id is not null
  and not exists (
    select 1
    from public.customer_activities a
    where a.related_task_id = t.id
      and a.type = 'task_linked'
  );
