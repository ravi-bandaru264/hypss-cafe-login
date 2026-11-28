# Hypss-Cafe Management System

A static frontend deployed on Vercel, backed by Supabase Authentication, PostgreSQL, Row Level Security (RLS), and an Edge Function for **username + password** login.

## Important security notes

- Passwords are handled by Supabase Auth. **Do not store passwords in `M_User`.**
- `config.js` contains only your Supabase Project URL and public/anon key. Never paste the `service_role` key into frontend files or GitHub.
- The username-login Edge Function uses the service role only server-side to look up the username and active status, then asks Supabase Auth to verify the password.
- The project does not contain hardcoded demo credentials or an insecure demo-login bypass.

## Project files

- `index.html` — final approved login page and app shell
- `style.css` — responsive styling and login design
- `app.js` — login, dashboard, category menu, billing, orders, inventory, reports and settings
- `config.js` — Supabase URL and public key placeholders
- `supabase-setup.sql` — database schema, RLS and automatic bill-number function
- `seed-menu.sql` — initial menu/categories seed; replace `AUTH_USER_UUID`
- `supabase/functions/login-by-username/index.ts` — secure username login function
- `supabase/config.toml` — function deployment configuration
- `assets/cafe-background.jpg` — login background

## Step 1 — Create/configure Supabase project

1. Open your Supabase project.
2. Go to **Project Settings → API** (or API Keys).
3. Copy the Project URL and the publishable/anon key.
4. Open this project’s `config.js` and replace:
   - `YOUR_SUPABASE_PROJECT_URL`
   - `YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY`
5. Save `config.js`.

## Step 2 — Create database tables

1. Supabase → **SQL Editor** → New query.
2. Open/copy the full contents of `supabase-setup.sql`.
3. Run it.

This creates `M_User`, categories, menu items, bills, bill items, cafe settings, RLS policies, and the automatic unique bill-number generator.

## Step 3 — Create the Admin Auth account

1. Supabase → **Authentication → Users**.
2. Add a new user with a real email address you control and a password of your choice.
3. Confirm the user if your Auth settings require confirmation.
4. Copy that Auth user’s UUID and email.
5. In SQL Editor, run this, replacing the values:

```sql
insert into public."M_User" (auth_user_id, username, email, display_name, role, active)
values ('PASTE_AUTH_USER_UUID', 'admin', 'PASTE_AUTH_EMAIL', 'Admin', 'Administrator', true);
```

Your cafe login screen uses **Username `admin`** and the password you set for this Auth user. The password is not saved in `M_User`.

## Step 4 — Seed the menu/categories

1. Open `seed-menu.sql`.
2. Replace `AUTH_USER_UUID` with the Auth UUID copied in Step 3.
3. Run the SQL in Supabase SQL Editor.

The starter menu contains the nine categories and sample menu prices. You can edit prices and stock later in the application. These are starter/example prices—confirm them with your actual cafe menu before use.

## Step 5 — Deploy username-login Edge Function

Install the Supabase CLI if needed and sign in, then from this project folder:

```bash
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase functions deploy login-by-username --no-verify-jwt
```

The Edge Function requires the Supabase environment secrets. Supabase provides `SUPABASE_URL` and the public/anon key in its runtime; ensure the `SUPABASE_SERVICE_ROLE_KEY` secret is configured for the function environment. Set it through the Supabase Dashboard → Edge Functions → Secrets, or the CLI:

```bash
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=YOUR_SERVICE_ROLE_KEY
```

**Never put the service-role key in `config.js`, `app.js`, or any GitHub file.**

## Step 6 — Deploy to Vercel

1. Upload/commit all files in this project folder to the root of your GitHub repository.
2. Vercel → import the repository or use your existing project.
3. Framework preset: **Other**.
4. Build command: leave blank.
5. Output directory: `.` (root).
6. Deploy.
7. Open the live URL and log in using the `admin` username and the Auth password you created.

## Bill numbers

Bills get a database-generated unique number using the format `HC-YYYYMMDD-000001` (sequence-based). The frontend also displays a generated preview number when offline, but the database number is authoritative when Supabase is connected.

## Features included

- Login screen matching the approved café image design
- Supabase username/password authentication
- Dashboard and nine menu categories
- Category menu cards, add/edit menu item and price
- Billing with category/sub-item selection, quantity, discount, GST, payment mode and receipt printing
- Automatic unique bill number from the database
- Orders history
- Inventory and low-stock indicators
- Reports
- Cafe Settings
- Logout/session restoration

## Troubleshooting

- **Login says Supabase not configured:** update `config.js` with the correct Project URL and public/anon key.
- **Function not found:** deploy `login-by-username` to the linked Supabase project.
- **Invalid login:** check the Auth user exists, the `M_User` row has the correct email and username `admin`, and `active=true`.
- **No categories/menu:** run `seed-menu.sql` after replacing the Auth UUID.
- **Permission errors:** verify `supabase-setup.sql` ran successfully and that the user profile’s `auth_user_id` matches the Auth UUID.
