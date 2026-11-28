-- Run after creating your Supabase Auth user and inserting that user into public."M_User".
-- Replace AUTH_USER_UUID below with the Auth user's UUID before running.
DO $$
DECLARE owner_uuid uuid := 'AUTH_USER_UUID'::uuid;
BEGIN
  INSERT INTO public.categories(name,emoji,sort_order,owner_id) VALUES
    ('Coffee & Tea','☕',1,owner_uuid),('Snacks','🥪',2,owner_uuid),('Juices','🧃',3,owner_uuid),
    ('Soft Drinks','🥤',4,owner_uuid),('Biscuits','🍪',5,owner_uuid),('Milk','🥛',6,owner_uuid),
    ('Curd','🥣',7,owner_uuid),('Icecreams','🍨',8,owner_uuid),('Chinese Fast Food','🍜',9,owner_uuid)
  ON CONFLICT(name,owner_id) DO NOTHING;

  INSERT INTO public.menu_items(category_name,name,price,stock_quantity,emoji,owner_id) VALUES
  ('Coffee & Tea','Tea',10,100,'☕',owner_uuid),('Coffee & Tea','Gud Wali Chai',10,100,'☕',owner_uuid),
  ('Coffee & Tea','Masala Tea',12,100,'☕',owner_uuid),('Coffee & Tea','Elachi Tea',15,100,'☕',owner_uuid),
  ('Coffee & Tea','Green Tea',15,100,'🍵',owner_uuid),('Coffee & Tea','Ginger Tea',15,100,'☕',owner_uuid),
  ('Coffee & Tea','Rabri Tea',15,100,'☕',owner_uuid),('Coffee & Tea','Paan Tea',20,100,'☕',owner_uuid),
  ('Coffee & Tea','Rose Tea',20,100,'☕',owner_uuid),('Coffee & Tea','Irani Masala Tea',20,100,'☕',owner_uuid),
  ('Coffee & Tea','Tandoori Tea',25,100,'☕',owner_uuid),('Coffee & Tea','Tea Chocolate',25,100,'☕',owner_uuid),
  ('Coffee & Tea','Tulsi Lemon Tea',25,100,'🍵',owner_uuid),('Coffee & Tea','Coffee',10,100,'☕',owner_uuid),
  ('Coffee & Tea','Cappuccino Coffee',20,100,'☕',owner_uuid),('Coffee & Tea','Almond Coffee',20,100,'☕',owner_uuid),
  ('Coffee & Tea','Hazelnut Coffee',35,100,'☕',owner_uuid),('Coffee & Tea','Chocolate Coffee',45,100,'☕',owner_uuid),
  ('Coffee & Tea','Cold Coffee',50,100,'🥤',owner_uuid),('Coffee & Tea','Cold Coffee with Ice Cream',55,100,'🥤',owner_uuid),
  ('Coffee & Tea','Cold Coffee with Oreo',65,100,'🥤',owner_uuid),
  ('Snacks','Samosa',25,100,'🥟',owner_uuid),('Snacks','Veg Puffs',25,100,'🥐',owner_uuid),
  ('Snacks','Sandwich',60,100,'🥪',owner_uuid),('Snacks','French Fries',70,100,'🍟',owner_uuid),
  ('Snacks','Veg Nuggets',80,100,'🍗',owner_uuid),('Snacks','Cutlet',40,100,'🍘',owner_uuid),('Snacks','Burger',90,100,'🍔',owner_uuid),
  ('Juices','Orange Juice',60,100,'🍊',owner_uuid),('Juices','Apple Juice',70,100,'🍎',owner_uuid),
  ('Juices','Mango Juice',60,100,'🥭',owner_uuid),('Juices','Pomegranate Juice',80,100,'🍎',owner_uuid),('Juices','Watermelon Juice',50,100,'🍉',owner_uuid),
  ('Soft Drinks','Coca-Cola',40,100,'🥤',owner_uuid),('Soft Drinks','Sprite',40,100,'🥤',owner_uuid),
  ('Soft Drinks','Fanta',40,100,'🥤',owner_uuid),('Soft Drinks','Thums Up',40,100,'🥤',owner_uuid),('Soft Drinks','Soda',25,100,'🥤',owner_uuid),('Soft Drinks','Mineral Water',20,100,'💧',owner_uuid),
  ('Biscuits','Butter Biscuits',30,100,'🍪',owner_uuid),('Biscuits','Chocolate Cookies',40,100,'🍪',owner_uuid),('Biscuits','Oreo',30,100,'🍪',owner_uuid),('Biscuits','Cream Biscuits',25,100,'🍪',owner_uuid),
  ('Milk','Full Cream Milk',30,100,'🥛',owner_uuid),('Milk','Toned Milk',25,100,'🥛',owner_uuid),('Milk','Badam Milk',40,100,'🥛',owner_uuid),('Milk','Chocolate Milk',45,100,'🥛',owner_uuid),
  ('Curd','Curd Cup',25,100,'🥣',owner_uuid),('Curd','Fresh Curd',50,100,'🥣',owner_uuid),('Curd','Lassi',40,100,'🥛',owner_uuid),
  ('Icecreams','Vanilla',40,100,'🍨',owner_uuid),('Icecreams','Chocolate',50,100,'🍨',owner_uuid),('Icecreams','Strawberry',50,100,'🍨',owner_uuid),('Icecreams','Butterscotch',50,100,'🍨',owner_uuid),('Icecreams','Kulfi',40,100,'🍦',owner_uuid),
  ('Chinese Fast Food','Veg Noodles',100,100,'🍜',owner_uuid),('Chinese Fast Food','Fried Rice',110,100,'🍚',owner_uuid),
  ('Chinese Fast Food','Manchurian',120,100,'🥘',owner_uuid),('Chinese Fast Food','Spring Rolls',90,100,'🥟',owner_uuid),
  ('Chinese Fast Food','Chilli Paneer',150,100,'🥘',owner_uuid),('Chinese Fast Food','Hakka Noodles',110,100,'🍜',owner_uuid)
  ON CONFLICT(category_name,name,owner_id) DO NOTHING;
END $$;
