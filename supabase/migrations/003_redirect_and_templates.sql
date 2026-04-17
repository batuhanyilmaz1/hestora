-- Redirect uniqueness, click tracking RPC, share template seed.
-- Run after 002_rls_policies.sql.

-- At most one short link per user per property (matches app createOrGet).
create unique index if not exists redirect_links_user_property_uidx
  on public.redirect_links (user_id, property_id);

-- Called by Edge Function `redirect` with service role: increments counters and returns target URL.
create or replace function public.track_redirect_click(p_short_code text)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  v_target text;
  v_property_id uuid;
  v_link_id uuid;
begin
  select id, target_url, property_id
  into v_link_id, v_target, v_property_id
  from public.redirect_links
  where short_code = p_short_code
  limit 1;

  if v_target is null or v_property_id is null then
    return null;
  end if;

  update public.redirect_links
  set click_count = click_count + 1
  where id = v_link_id;

  update public.properties
  set share_click_count = coalesce(share_click_count, 0) + 1
  where id = v_property_id;

  return json_build_object('target_url', v_target);
end;
$$;

revoke all on function public.track_redirect_click(text) from public;
grant execute on function public.track_redirect_click(text) to service_role;

-- Catalog rows for share card templates (idempotent).
insert into public.share_templates (code, label, aspect)
values
  ('story', 'Story 9:16', '9:16'),
  ('square', 'Square 1:1', '1:1')
on conflict (code) do nothing;
