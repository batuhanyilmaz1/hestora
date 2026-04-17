-- Super-admin: full Storage access for CRM buckets + manage share_templates.
-- Apply after 005_storage_buckets_avatars.sql (uses public.is_admin()).

-- property-images: admin bypass folder ownership
drop policy if exists "property_images_admin_all" on storage.objects;
create policy "property_images_admin_all"
  on storage.objects
  for all
  to authenticated
  using (bucket_id = 'property-images' and public.is_admin())
  with check (bucket_id = 'property-images' and public.is_admin());

-- avatars: admin bypass folder ownership
drop policy if exists "avatars_admin_all" on storage.objects;
create policy "avatars_admin_all"
  on storage.objects
  for all
  to authenticated
  using (bucket_id = 'avatars' and public.is_admin())
  with check (bucket_id = 'avatars' and public.is_admin());

-- share_templates: catalog management for admins only
drop policy if exists "share_templates_admin_write" on public.share_templates;
create policy "share_templates_admin_write"
  on public.share_templates
  for all
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());
