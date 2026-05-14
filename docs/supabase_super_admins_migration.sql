-- Add super-admin support to an EXISTING Pathway Tool database
-- (You already ran docs/supabase_schema.sql without super-admins.)
-- Run the whole script once in Supabase → SQL Editor.

-- ─── Super-admins + helpers ─────────────────────────────────────────────────

create table if not exists public.super_admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.super_admins enable row level security;

drop policy if exists "super_admins_select_self" on public.super_admins;
create policy "super_admins_select_self" on public.super_admins
  for select to authenticated using (auth.uid() = user_id);

create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.super_admins s where s.user_id = auth.uid()
  );
$$;

grant execute on function public.is_super_admin() to authenticated;

create or replace function public.list_data_owner_directory()
returns table (user_id uuid, email text)
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  if not public.is_super_admin() then
    return;
  end if;
  return query
  select distinct u.id, coalesce(u.email::text, '')
  from auth.users u
  where u.id in (
    select s2.user_id from public.stakeholders s2
    union
    select p.user_id from public.pathway_roles p
    union
    select g.user_id from public.pains_gains g
  )
  order by 2 nulls last, 1;
end;
$$;

grant execute on function public.list_data_owner_directory() to authenticated;

grant select on public.super_admins to authenticated;

-- ─── Replace RLS on data tables ─────────────────────────────────────────────

-- stakeholders
drop policy if exists "stakeholders_select_own" on public.stakeholders;
drop policy if exists "stakeholders_insert_own" on public.stakeholders;
drop policy if exists "stakeholders_update_own" on public.stakeholders;
drop policy if exists "stakeholders_delete_own" on public.stakeholders;
drop policy if exists "stakeholders_select" on public.stakeholders;
drop policy if exists "stakeholders_insert" on public.stakeholders;
drop policy if exists "stakeholders_update" on public.stakeholders;
drop policy if exists "stakeholders_delete" on public.stakeholders;

create policy "stakeholders_select" on public.stakeholders
  for select to authenticated
  using (auth.uid() = user_id or public.is_super_admin());
create policy "stakeholders_insert" on public.stakeholders
  for insert to authenticated with check (auth.uid() = user_id or public.is_super_admin());
create policy "stakeholders_update" on public.stakeholders
  for update to authenticated
  using (auth.uid() = user_id or public.is_super_admin())
  with check (auth.uid() = user_id or public.is_super_admin());
create policy "stakeholders_delete" on public.stakeholders
  for delete to authenticated
  using (auth.uid() = user_id or public.is_super_admin());

-- pathway_roles
drop policy if exists "pathway_roles_select_own" on public.pathway_roles;
drop policy if exists "pathway_roles_insert_own" on public.pathway_roles;
drop policy if exists "pathway_roles_update_own" on public.pathway_roles;
drop policy if exists "pathway_roles_delete_own" on public.pathway_roles;
drop policy if exists "pathway_roles_select" on public.pathway_roles;
drop policy if exists "pathway_roles_insert" on public.pathway_roles;
drop policy if exists "pathway_roles_update" on public.pathway_roles;
drop policy if exists "pathway_roles_delete" on public.pathway_roles;

create policy "pathway_roles_select" on public.pathway_roles
  for select to authenticated
  using (auth.uid() = user_id or public.is_super_admin());
create policy "pathway_roles_insert" on public.pathway_roles
  for insert to authenticated with check (auth.uid() = user_id or public.is_super_admin());
create policy "pathway_roles_update" on public.pathway_roles
  for update to authenticated
  using (auth.uid() = user_id or public.is_super_admin())
  with check (auth.uid() = user_id or public.is_super_admin());
create policy "pathway_roles_delete" on public.pathway_roles
  for delete to authenticated
  using (auth.uid() = user_id or public.is_super_admin());

-- pains_gains
drop policy if exists "pains_gains_select_own" on public.pains_gains;
drop policy if exists "pains_gains_insert_own" on public.pains_gains;
drop policy if exists "pains_gains_update_own" on public.pains_gains;
drop policy if exists "pains_gains_delete_own" on public.pains_gains;
drop policy if exists "pains_gains_select" on public.pains_gains;
drop policy if exists "pains_gains_insert" on public.pains_gains;
drop policy if exists "pains_gains_update" on public.pains_gains;
drop policy if exists "pains_gains_delete" on public.pains_gains;

create policy "pains_gains_select" on public.pains_gains
  for select to authenticated
  using (auth.uid() = user_id or public.is_super_admin());
create policy "pains_gains_insert" on public.pains_gains
  for insert to authenticated with check (auth.uid() = user_id or public.is_super_admin());
create policy "pains_gains_update" on public.pains_gains
  for update to authenticated
  using (auth.uid() = user_id or public.is_super_admin())
  with check (auth.uid() = user_id or public.is_super_admin());
create policy "pains_gains_delete" on public.pains_gains
  for delete to authenticated
  using (auth.uid() = user_id or public.is_super_admin());
