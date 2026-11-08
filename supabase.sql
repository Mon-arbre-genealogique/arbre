-- À coller dans Supabase > SQL Editor > New query > Run
-- Peut être relancé sans erreur : il recrée simplement les règles.
-- Une ligne par utilisateur : tous ses arbres sont stockés dans la colonne "data" (JSON).

create table if not exists public.arbres (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- Sécurité : chaque utilisateur ne voit et ne modifie QUE sa propre ligne.
alter table public.arbres enable row level security;

drop policy if exists "lecture perso"     on public.arbres;
drop policy if exists "insertion perso"   on public.arbres;
drop policy if exists "mise a jour perso" on public.arbres;
drop policy if exists "suppression perso" on public.arbres;

create policy "lecture perso"     on public.arbres for select using ((select auth.uid()) = user_id);
create policy "insertion perso"   on public.arbres for insert with check ((select auth.uid()) = user_id);
create policy "mise a jour perso" on public.arbres for update using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "suppression perso" on public.arbres for delete using ((select auth.uid()) = user_id);

-- Vérification : doit afficher 4 lignes (select, insert, update, delete)
select policyname, cmd from pg_policies where schemaname = 'public' and tablename = 'arbres';


-- =====================================================================
-- PARTAGE EN LECTURE SEULE (lien secret)  —  à exécuter une fois, peut être relancé
-- =====================================================================
-- Chaque lien = une copie ("instantané") d'UN arbre, identifiée par un jeton secret de 64 caractères.
-- La table n'est lisible que par son propriétaire. Les proches n'y accèdent QUE via la fonction
-- lire_partage(jeton), qui ne renvoie que l'arbre correspondant au jeton exact : impossible de lister ou deviner les autres.
create table if not exists public.partages (
  token      text primary key check (token ~ '^[0-9a-f]{64}$'),
  user_id    uuid not null references auth.users(id) on delete cascade,
  arbre_id   text not null,
  nom        text,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.partages enable row level security;

drop policy if exists "partages lecture"     on public.partages;
drop policy if exists "partages insertion"   on public.partages;
drop policy if exists "partages mise a jour" on public.partages;
drop policy if exists "partages suppression" on public.partages;

create policy "partages lecture"     on public.partages for select using ((select auth.uid()) = user_id);
create policy "partages insertion"   on public.partages for insert with check ((select auth.uid()) = user_id);
create policy "partages mise a jour" on public.partages for update using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "partages suppression" on public.partages for delete using ((select auth.uid()) = user_id);

create or replace function public.lire_partage(p_token text)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select data from public.partages where token = p_token
$$;

revoke all on function public.lire_partage(text) from public;
grant execute on function public.lire_partage(text) to anon, authenticated;
