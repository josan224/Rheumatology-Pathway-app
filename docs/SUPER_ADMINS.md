# Super-admins (who can see all workspaces)

Super-admins are normal app users who are also listed in the database table `public.super_admins`. Row Level Security in Supabase checks that table so they can read (and manage) every user’s data.

## Before you start

The database must already include the `super_admins` table and updated policies:

- **New project:** run `docs/supabase_schema.sql` once in **SQL Editor**.
- **Existing project** that only had the older schema: run `docs/supabase_super_admins_migration.sql` once, then continue below.

## Add a super user

1. In Supabase, open **Authentication** → **Users**.
2. Find the person and open their user. Copy their **User UID** (UUID).
3. Open **SQL Editor** and run (replace the placeholder with that UUID):

```sql
insert into public.super_admins (user_id)
values ('xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx');
```

4. Ask them to **sign out and sign in again** (or hard refresh the app) so the app picks up their access.

Repeat the `insert` for each person who should be a super-admin.

## Remove super access

```sql
delete from public.super_admins
where user_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
```

Use the same UUID from **Authentication** → **Users**.

## Notes

- Only project owners (or anyone with SQL / service-role access) should change `super_admins`. The app does not expose “promote myself” in the UI.
- If someone is removed from **Authentication** users, their row in `super_admins` is removed automatically (`ON DELETE CASCADE`).
