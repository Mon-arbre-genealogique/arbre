# Ma généalogie

Appli d'arbre généalogique en un seul fichier (`index.html`), avec sauvegarde cloud optionnelle via Supabase.

## Fichiers
- `index.html` : toute l'appli
- `supabase.sql` : table + règles de sécurité à exécuter une fois dans Supabase
- `app.py`, `requirements.txt` : uniquement si tu l'héberges sur Streamlit Community Cloud

## Mise en place
1. Supabase : créer un projet, exécuter `supabase.sql`, puis copier *Project URL* et la clé *anon public* (Settings > API).
2. Les coller dans `index.html` (`SUPABASE_URL` et `SUPABASE_KEY`, vers la fin du fichier).
3. Pousser sur GitHub, puis activer GitHub Pages (Settings > Pages > Deploy from a branch > main / root).
4. Supabase > Authentication > URL Configuration : mettre l'adresse du site dans *Site URL*.
