-- Pathway Tool: per-user data tables + RLS
-- Run once in Supabase → SQL Editor (as project owner).

-- ─── stakeholders ───────────────────────────────────────────────────────────

create table if not exists public.stakeholders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  org text not null default '',
  name text not null default '',
  title text not null default '',
  role text not null default '',
  indication text not null default '',
  impact text not null default '',
  influence text not null default '',
  advocacy text not null default '',
  steps int[] not null default '{}',
  interests text not null default '',
  strategy text not null default '',
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists stakeholders_user_id_idx on public.stakeholders (user_id);

alter table public.stakeholders enable row level security;

drop policy if exists "stakeholders_select_own" on public.stakeholders;
drop policy if exists "stakeholders_insert_own" on public.stakeholders;
drop policy if exists "stakeholders_update_own" on public.stakeholders;
drop policy if exists "stakeholders_delete_own" on public.stakeholders;

create policy "stakeholders_select_own" on public.stakeholders
  for select to authenticated using (auth.uid() = user_id);

create policy "stakeholders_insert_own" on public.stakeholders
  for insert to authenticated with check (auth.uid() = user_id);

create policy "stakeholders_update_own" on public.stakeholders
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "stakeholders_delete_own" on public.stakeholders
  for delete to authenticated using (auth.uid() = user_id);

-- ─── pathway_roles (global + trust-specific rows per user) ────────────────

create table if not exists public.pathway_roles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  step_number int not null,
  trust text not null default '',
  leads text not null default '',
  supports text not null default '',
  created_at timestamptz not null default now(),
  constraint pathway_roles_user_step_trust unique (user_id, step_number, trust)
);

create index if not exists pathway_roles_user_id_idx on public.pathway_roles (user_id);

alter table public.pathway_roles enable row level security;

drop policy if exists "pathway_roles_select_own" on public.pathway_roles;
drop policy if exists "pathway_roles_insert_own" on public.pathway_roles;
drop policy if exists "pathway_roles_update_own" on public.pathway_roles;
drop policy if exists "pathway_roles_delete_own" on public.pathway_roles;

create policy "pathway_roles_select_own" on public.pathway_roles
  for select to authenticated using (auth.uid() = user_id);

create policy "pathway_roles_insert_own" on public.pathway_roles
  for insert to authenticated with check (auth.uid() = user_id);

create policy "pathway_roles_update_own" on public.pathway_roles
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "pathway_roles_delete_own" on public.pathway_roles
  for delete to authenticated using (auth.uid() = user_id);

-- ─── pains_gains ───────────────────────────────────────────────────────────

create table if not exists public.pains_gains (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  trust text not null default '',
  pain text not null default '',
  gain text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists pains_gains_user_id_idx on public.pains_gains (user_id);

alter table public.pains_gains enable row level security;

drop policy if exists "pains_gains_select_own" on public.pains_gains;
drop policy if exists "pains_gains_insert_own" on public.pains_gains;
drop policy if exists "pains_gains_update_own" on public.pains_gains;
drop policy if exists "pains_gains_delete_own" on public.pains_gains;

create policy "pains_gains_select_own" on public.pains_gains
  for select to authenticated using (auth.uid() = user_id);

create policy "pains_gains_insert_own" on public.pains_gains
  for insert to authenticated with check (auth.uid() = user_id);

create policy "pains_gains_update_own" on public.pains_gains
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "pains_gains_delete_own" on public.pains_gains
  for delete to authenticated using (auth.uid() = user_id);

-- ─── API access for logged-in users (JWT role = authenticated) ─────────────

grant usage on schema public to authenticated;

grant select, insert, update, delete on public.stakeholders to authenticated;
grant select, insert, update, delete on public.pathway_roles to authenticated;
grant select, insert, update, delete on public.pains_gains to authenticated;
