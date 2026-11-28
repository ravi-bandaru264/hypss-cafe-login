-- HY PSS-CAFE INITIAL SUPABASE SETUP
-- Run this script in Supabase Dashboard > SQL Editor.
-- IMPORTANT: User passwords are NOT stored in M_User. Supabase Auth handles passwords securely.

create extension if not exists pgcrypto;

-- Application user profile table. Username is used by the login Edge Function to resolve Auth email.
create table if not exists public."M_User" (
  user_id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique not null references auth.users(id) on delete cascade,
  username text unique not null,
  email text unique not null,
  display_name text not null default 'Admin',
  role text not null default 'Administrator',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  emoji text default '🍽️',
  sort_order int default 0,
  owner_id uuid not null references auth.users(id) on delete cascade,
  unique(name,owner_id)
);

create table if not exists public.menu_items (
  id uuid primary key default gen_random_uuid(),
  category_name text not null,
  name text not null,
  price numeric(10,2) not null check(price>=0),
  stock_quantity numeric(10,2) not null default 0,
  emoji text default '🍽️',
  active boolean default true,
  owner_id uuid not null references auth.users(id) on delete cascade,
  unique(category_name,name,owner_id)
);

create sequence if not exists public.bill_number_seq;
create or replace function public.generate_bill_number()
returns text language plpgsql security definer set search_path=public as $$
begin
  return 'HC-'||to_char(now(),'YYYYMMDD')||'-'||lpad(nextval('public.bill_number_seq')::text,6,'0');
end; $$;

create table if not exists public.bills (
  id uuid primary key default gen_random_uuid(),
  bill_number text unique not null default public.generate_bill_number(),
  subtotal numeric(12,2) not null default 0,
  discount_amount numeric(12,2) not null default 0,
  gst_amount numeric(12,2) not null default 0,
  total_amount numeric(12,2) not null default 0,
  payment_mode text not null check(payment_mode in ('Cash','UPI','Card')),
  status text not null default 'Completed',
  owner_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  created_at timestamptz not null default now()
);

create table if not exists public.bill_items (
  id uuid primary key default gen_random_uuid(),
  bill_id uuid not null references public.bills(id) on delete cascade,
  menu_item_id uuid references public.menu_items(id) on delete set null,
  item_name text not null,
  category_name text not null,
  unit_price numeric(10,2) not null,
  quantity int not null check(quantity>0),
  line_total numeric(12,2) not null
);

create table if not exists public.cafe_settings (
  id uuid primary key default gen_random_uuid(),
  cafe_name text not null default 'Hypss-Cafe',
  tagline text default 'Cafe Management System',
  address text,
  phone text,
  email text,
  gst_percent numeric(5,2) default 0,
  owner_id uuid unique not null references auth.users(id) on delete cascade
);

alter table public."M_User" enable row level security;
alter table public.categories enable row level security;
alter table public.menu_items enable row level security;
alter table public.bills enable row level security;
alter table public.bill_items enable row level security;
alter table public.cafe_settings enable row level security;

-- M_User: authenticated users can only read their own profile.
drop policy if exists "users read own profile" on public."M_User";
create policy "users read own profile" on public."M_User" for select to authenticated using(auth_user_id=auth.uid());

-- Owner-scoped cafe data policies.
drop policy if exists "owner categories" on public.categories;
create policy "owner categories" on public.categories for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "owner menu" on public.menu_items;
create policy "owner menu" on public.menu_items for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "owner bills" on public.bills;
create policy "owner bills" on public.bills for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());
drop policy if exists "owner bill items" on public.bill_items;
create policy "owner bill items" on public.bill_items for all to authenticated using(exists(select 1 from public.bills b where b.id=bill_id and b.owner_id=auth.uid())) with check(exists(select 1 from public.bills b where b.id=bill_id and b.owner_id=auth.uid()));
drop policy if exists "owner settings" on public.cafe_settings;
create policy "owner settings" on public.cafe_settings for all to authenticated using(owner_id=auth.uid()) with check(owner_id=auth.uid());

grant select on public."M_User" to authenticated;
grant select,insert,update,delete on public.categories,public.menu_items,public.bills,public.bill_items,public.cafe_settings to authenticated;
grant usage,select on sequence public.bill_number_seq to authenticated;

-- STEP A: Create your first user in Supabase Authentication > Users.
-- Use a valid email address and set the password there. Do NOT insert a password into M_User.
-- STEP B: Copy the Auth user's UUID and email, then run this INSERT (replace values):
-- insert into public."M_User" (auth_user_id,username,email,display_name,role,active)
-- values ('AUTH_USER_UUID','admin','YOUR_AUTH_EMAIL','Admin','Administrator',true);
-- STEP C: Seed categories/menu after replacing AUTH_USER_UUID in the block below.
-- The starter menu has sample prices; edit them from the app's menu item editing flow.

-- Example starter category seed:
-- insert into public.categories(name,emoji,sort_order,owner_id) values
-- ('Coffee & Tea','☕',1,'AUTH_USER_UUID'),('Snacks','🥪',2,'AUTH_USER_UUID'),('Juices','🧃',3,'AUTH_USER_UUID'),
-- ('Soft Drinks','🥤',4,'AUTH_USER_UUID'),('Biscuits','🍪',5,'AUTH_USER_UUID'),('Milk','🥛',6,'AUTH_USER_UUID'),
-- ('Curd','🥣',7,'AUTH_USER_UUID'),('Icecreams','🍨',8,'AUTH_USER_UUID'),('Chinese Fast Food','🍜',9,'AUTH_USER_UUID');
-- Starter menu example (category, item, price, stock, emoji, owner):
-- insert into public.menu_items(category_name,name,price,stock_quantity,emoji,owner_id) values
-- ('Coffee & Tea','Tea',10,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Gud Wali Chai',10,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Masala Tea',12,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Elachi Tea',15,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Green Tea',15,100,'🍵','AUTH_USER_UUID'),('Coffee & Tea','Ginger Tea',15,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Rabri Tea',15,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Paan Tea',20,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Rose Tea',20,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Irani Masala Tea',20,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Tandoori Tea',25,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Tea Chocolate',25,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Tulsi Lemon Tea',25,100,'🍵','AUTH_USER_UUID'),('Coffee & Tea','Coffee',10,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Cappuccino Coffee',20,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Almond Coffee',20,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Hazelnut Coffee',35,100,'☕','AUTH_USER_UUID'),('Coffee & Tea','Chocolate Coffee',45,100,'☕','AUTH_USER_UUID'),
-- ('Coffee & Tea','Cold Coffee',50,100,'🥤','AUTH_USER_UUID'),('Coffee & Tea','Cold Coffee with Ice Cream',55,100,'🥤','AUTH_USER_UUID'),
-- ('Coffee & Tea','Cold Coffee with Oreo',65,100,'🥤','AUTH_USER_UUID');
