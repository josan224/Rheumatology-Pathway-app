# User accounts across browsers and devices

The Pathway Tool is a static HTML app. By default it can keep **local-only** accounts (hashed in the browser). To let people **sign in from any device** with the same credentials, you need a small hosted **authentication service** with a real user database.

This repository is wired for **[Supabase](https://supabase.com/) Auth** (PostgreSQL-backed users, free tier, EU hosting options). You configure the project in the Supabase dashboard; the app only needs the **Project URL** and **anon (public) key** in `index.html`.

---

## 1. Create a Supabase project

1. Go to [https://supabase.com](https://supabase.com) and sign in.
2. **New project** → choose organisation, name, database password (store safely), and region (pick one that meets your data residency needs).
3. Wait until the project finishes provisioning.

---

## 2. Get the API credentials

1. In the Supabase dashboard: **Settings** (gear) → **API**.
2. Copy:
   - **Project URL** (looks like `https://xxxxxxxx.supabase.co`)
   - **anon public** key (long JWT-like string under “Project API keys”).

---

## 3. Paste credentials into the app

In `index.html`, find:

```javascript
const SB_URL = '';
const SB_ANON_KEY = '';
```

Set them to your values, for example:

```javascript
const SB_URL = 'https://xxxxxxxx.supabase.co';
const SB_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Commit and deploy. The sign-in screen will switch to **work email** + password and use Supabase for registration and login.

> The anon key is **public** by design (it ships in the browser). Protect data with **Row Level Security** if you later add Supabase tables that the browser reads. For **Auth-only** usage (this app today), you are not exposing custom tables through the client.

---

## 4. Auth settings that usually match this tool

### Email sign-ups

- **Authentication** → **Providers** → ensure **Email** is enabled.

### Let users sign in immediately (typical for internal tools)

By default Supabase may require **email confirmation** before a session is issued.

- **Authentication** → **Providers** → **Email** → disable **“Confirm email”** if everyone who can register is trusted (e.g. internal UCB users only).

If you leave confirmation **on**, new users must click the link in their email before they can sign in; the app will show a message if sign-up returns no session.

### Password strength

Supabase enforces its own minimum length. The app still enforces your policy client-side (8+ characters, uppercase, special character). You can align **Authentication** → **Policies** (password rules) with your organisation if available in your plan.

---

## 5. Password resets (admin-assisted)

The app **does not** offer self-service password reset. Users are told to contact an **administrator**.

As an admin you can reset a password in Supabase:

1. **Authentication** → **Users**
2. Find the user by email → open the row → use the menu to **Send password recovery** or **Update user** / set password (wording depends on Supabase version), or use the **SQL Editor** / Auth admin APIs if your workflow requires it.

Alternatively, enable Supabase’s **email recovery** flow for users who should reset themselves in the future; that would be a product decision and optional UI work in the app.

---

## 6. Who can register?

With the anon key in the page, **anyone who can load the site** can call the public sign-up API unless you restrict it.

Typical mitigations:

- **Disable public sign-up** in Supabase and create users only from the dashboard (or a small internal script).
- Or keep sign-up on but restrict access at the **network** level (VPN, Netlify password gate, IP allow list) if your deployment platform supports it.
- Or use Supabase **hooks / RLS** and custom flows as you grow.

Pick what matches your compliance model.

---

## 7. Optional checks after go-live

- Register one test user, sign out, sign in from **another browser** with the same email.
- Confirm **HTTPS** on your live URL (`crypto.subtle` requires a secure context).
- If sessions drop after ~1 hour, the app refreshes tokens when the tab is reloaded; very long idle periods may require signing in again depending on Supabase refresh settings.

---

## Alternatives (not implemented in code)

The same patterns work with **Firebase Auth**, **Auth0**, **Clerk**, or your own API backed by PostgreSQL or Entra ID. Those would replace the `fetch` calls to `/auth/v1/...` with the vendor’s SDK or REST API; the UI would stay similar.

If you need help choosing for enterprise SSO (SAML / Entra), involve your IT security team early.
