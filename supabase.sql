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
