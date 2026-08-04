-- Books & You seed data (generated 2026-07-23T16:18:38.886Z)
-- Do not edit by hand; regenerate with: node scripts/generate-seed.mjs
begin;

-- Clear dependent demo data carefully (local/dev only)
-- Catalog + system seed is idempotent via fixed UUIDs / upserts

-- Roles
insert into public.roles (id, key, name, description, is_system) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'super_admin', 'Super Admin', 'Super Admin role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('d11354a9-0f9a-406a-a892-816918621bbd', 'inventory_manager', 'Inventory Manager', 'Inventory Manager role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', 'sales_manager', 'Sales Manager', 'Sales Manager role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', 'support_agent', 'Support Agent', 'Support Agent role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', 'finance', 'Finance', 'Finance role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('6a585ebc-5b41-4281-a247-85d9a76ec58a', 'marketing_manager', 'Marketing Manager', 'Marketing Manager role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', 'publisher_manager', 'Publisher Manager', 'Publisher Manager role', true) on conflict (key) do update set name = excluded.name;
insert into public.roles (id, key, name, description, is_system) values ('2177b2ee-b999-473f-aaac-27769f91b881', 'customer', 'Customer', 'Customer role', true) on conflict (key) do update set name = excluded.name;

-- Permissions
insert into public.permissions (id, key, name, module, description) values ('3ee263fd-c30e-4231-a24f-9740d63ed3df', 'catalog.read', 'Read catalog', 'Catalog', 'Read catalog') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('41dfee64-67a5-45ba-a5e7-20effd2870d7', 'catalog.write', 'Manage catalog', 'Catalog', 'Manage catalog') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('c07a79f6-5819-45b1-ac3a-9dd0896154c6', 'authors.write', 'Manage authors', 'Catalog', 'Manage authors') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('d9970010-aab5-44ff-a98a-d21cc0ce658b', 'publishers.write', 'Manage publishers', 'Catalog', 'Manage publishers') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('e863a578-8c80-424e-a705-0daf0c66d145', 'inventory.read', 'View inventory', 'Inventory', 'View inventory') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('0da84b17-2b91-473f-afb1-f7a8a3580054', 'inventory.write', 'Manage inventory', 'Inventory', 'Manage inventory') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('e37840ff-e865-4c39-a1e6-471deba229a0', 'orders.read', 'View orders', 'Orders', 'View orders') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('e0320efa-0768-4001-a26e-9a2e1df34f87', 'orders.write', 'Manage orders', 'Orders', 'Manage orders') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('06670b4a-0b4b-418f-adf3-3f37467e6b38', 'customers.read', 'View customers', 'Customers', 'View customers') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('0d67a49d-4213-4f3f-af77-d523e797d42b', 'customers.write', 'Manage customers', 'Customers', 'Manage customers') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('2e13a0ac-d688-4f5a-a886-b97e62577414', 'finance.read', 'View finance', 'Finance', 'View finance') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('aad80d5f-c746-4573-abde-c11b6b70a93b', 'finance.write', 'Manage finance', 'Finance', 'Manage finance') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('6568106a-7f8b-4e8c-a218-b4ab642ef977', 'marketing.read', 'View marketing', 'Marketing', 'View marketing') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('4390d594-fcdc-4295-afac-d9c1213ab394', 'marketing.write', 'Manage marketing', 'Marketing', 'Manage marketing') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('5e1aed49-fae9-47ee-a2a0-6b73481456a4', 'support.read', 'View support', 'Support', 'View support') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('7175f815-089c-4378-acfc-45d59800dbd4', 'support.write', 'Manage support', 'Support', 'Manage support') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('e091da42-bf99-412e-a18e-0aa4e1de5193', 'reviews.moderate', 'Moderate reviews', 'Reviews', 'Moderate reviews') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('36d52137-f250-4eeb-acd2-9c09b12af1c7', 'subscriptions.read', 'View subscriptions', 'Subscriptions', 'View subscriptions') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('ccbfda5d-c4af-4c81-ab3f-3b3d0ef72309', 'subscriptions.write', 'Manage subscriptions', 'Subscriptions', 'Manage subscriptions') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('d8cb1a22-4733-4429-a692-3d1fbb149c1e', 'settings.write', 'Edit settings', 'System', 'Edit settings') on conflict (key) do update set name = excluded.name;
insert into public.permissions (id, key, name, module, description) values ('29a61b63-eefa-47a7-a645-28b26ddecccf', 'audit.read', 'Read audit logs', 'System', 'Read audit logs') on conflict (key) do update set name = excluded.name;

-- Role permissions
delete from public.role_permissions;
insert into public.role_permissions (role_id, permission_id) values ('d11354a9-0f9a-406a-a892-816918621bbd', '3ee263fd-c30e-4231-a24f-9740d63ed3df') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('d11354a9-0f9a-406a-a892-816918621bbd', '41dfee64-67a5-45ba-a5e7-20effd2870d7') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('d11354a9-0f9a-406a-a892-816918621bbd', 'e863a578-8c80-424e-a705-0daf0c66d145') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('d11354a9-0f9a-406a-a892-816918621bbd', '0da84b17-2b91-473f-afb1-f7a8a3580054') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('d11354a9-0f9a-406a-a892-816918621bbd', 'e37840ff-e865-4c39-a1e6-471deba229a0') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', '3ee263fd-c30e-4231-a24f-9740d63ed3df') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', 'e37840ff-e865-4c39-a1e6-471deba229a0') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', 'e0320efa-0768-4001-a26e-9a2e1df34f87') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', '06670b4a-0b4b-418f-adf3-3f37467e6b38') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('948e5fdb-2414-44b1-a0e5-ce3315468459', '6568106a-7f8b-4e8c-a218-b4ab642ef977') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', '5e1aed49-fae9-47ee-a2a0-6b73481456a4') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', '7175f815-089c-4378-acfc-45d59800dbd4') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', 'e37840ff-e865-4c39-a1e6-471deba229a0') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', '06670b4a-0b4b-418f-adf3-3f37467e6b38') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', '2e13a0ac-d688-4f5a-a886-b97e62577414') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', 'aad80d5f-c746-4573-abde-c11b6b70a93b') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', 'e37840ff-e865-4c39-a1e6-471deba229a0') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', '36d52137-f250-4eeb-acd2-9c09b12af1c7') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('6a585ebc-5b41-4281-a247-85d9a76ec58a', '6568106a-7f8b-4e8c-a218-b4ab642ef977') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('6a585ebc-5b41-4281-a247-85d9a76ec58a', '4390d594-fcdc-4295-afac-d9c1213ab394') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('6a585ebc-5b41-4281-a247-85d9a76ec58a', '3ee263fd-c30e-4231-a24f-9740d63ed3df') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('6a585ebc-5b41-4281-a247-85d9a76ec58a', 'e091da42-bf99-412e-a18e-0aa4e1de5193') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', '3ee263fd-c30e-4231-a24f-9740d63ed3df') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', '41dfee64-67a5-45ba-a5e7-20effd2870d7') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', 'c07a79f6-5819-45b1-ac3a-9dd0896154c6') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', 'd9970010-aab5-44ff-a98a-d21cc0ce658b') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('0e044bc4-801f-422c-a700-336ce3bdb8ff', 'e863a578-8c80-424e-a705-0daf0c66d145') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '3ee263fd-c30e-4231-a24f-9740d63ed3df') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '41dfee64-67a5-45ba-a5e7-20effd2870d7') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'c07a79f6-5819-45b1-ac3a-9dd0896154c6') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'd9970010-aab5-44ff-a98a-d21cc0ce658b') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'e863a578-8c80-424e-a705-0daf0c66d145') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '0da84b17-2b91-473f-afb1-f7a8a3580054') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'e37840ff-e865-4c39-a1e6-471deba229a0') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'e0320efa-0768-4001-a26e-9a2e1df34f87') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '06670b4a-0b4b-418f-adf3-3f37467e6b38') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '0d67a49d-4213-4f3f-af77-d523e797d42b') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '2e13a0ac-d688-4f5a-a886-b97e62577414') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'aad80d5f-c746-4573-abde-c11b6b70a93b') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '6568106a-7f8b-4e8c-a218-b4ab642ef977') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '4390d594-fcdc-4295-afac-d9c1213ab394') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '5e1aed49-fae9-47ee-a2a0-6b73481456a4') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '7175f815-089c-4378-acfc-45d59800dbd4') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'e091da42-bf99-412e-a18e-0aa4e1de5193') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '36d52137-f250-4eeb-acd2-9c09b12af1c7') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'ccbfda5d-c4af-4c81-ab3f-3b3d0ef72309') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', 'd8cb1a22-4733-4429-a692-3d1fbb149c1e') on conflict do nothing;
insert into public.role_permissions (role_id, permission_id) values ('2ae17bac-b6f1-4a6e-a955-911e7808d370', '29a61b63-eefa-47a7-a645-28b26ddecccf') on conflict do nothing;

-- Categories
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('0995a5fe-fd6c-4441-a50e-83d938bf97f9', 'fiction', 'Fiction', 'Immersive stories that transport and transform.', 'from-teal-700 to-emerald-500', 0, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('c59e4058-d6cb-4bf9-a912-dfca2c5d30ca', 'non-fiction', 'Non-Fiction', 'Ideas and narratives from the real world.', 'from-slate-700 to-slate-500', 1, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('ef29be2a-5276-4102-ab1d-be3273dbe6a2', 'business', 'Business', 'Strategy, leadership, and entrepreneurship.', 'from-amber-700 to-yellow-500', 2, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('509363c1-d4ad-4848-a47f-6ff8b6e166a0', 'technology', 'Technology', 'Computing, AI, and the digital frontier.', 'from-cyan-700 to-teal-400', 3, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('263fbd32-995f-45f3-a391-9165f4dcae10', 'childrens', 'Children''s', 'Wonder-filled reads for young minds.', 'from-rose-600 to-orange-400', 4, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('9198798f-e943-4c0c-add5-ac61293b5b00', 'academic', 'Academic', 'Scholarly works for schools and research.', 'from-indigo-700 to-blue-500', 5, true) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('477d75cc-492d-4eaf-a7e8-55199f98b349', 'self-help', 'Self-Help', 'Growth, habits, and personal mastery.', 'from-emerald-700 to-lime-500', 6, false) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('875c2a1e-bb7c-4cea-a8da-06f0c3b16c96', 'biographies', 'Biographies', 'Lives that shaped history and culture.', 'from-stone-700 to-stone-500', 7, false) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('0b6c9bf8-e863-43fd-a4a1-8c499eae859a', 'poetry', 'Poetry', 'Verse from Ghana and the wider world.', 'from-fuchsia-700 to-pink-500', 8, false) on conflict (slug) do update set name = excluded.name, description = excluded.description;
insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values ('538daed6-ae09-4993-acc4-64ac35735ca0', 'history', 'History', 'Past worlds, present insights.', 'from-orange-800 to-amber-600', 9, false) on conflict (slug) do update set name = excluded.name, description = excluded.description;

-- Publishers
insert into public.publishers (id, slug, name, country, description) values ('4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'sub-saharan', 'Sub-Saharan Publishers', 'Ghana', 'Sub-Saharan Publishers, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('998e188c-d29c-45b8-a74a-cf8390558c47', 'heinemann', 'Heinemann', 'UK', 'Heinemann, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'cassava', 'Cassava Republic', 'Nigeria', 'Cassava Republic, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('5f4f9543-7660-45d4-a99a-726bc98748f1', 'penguin', 'Penguin Random House', 'USA', 'Penguin Random House, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'knopf', 'Alfred A. Knopf', 'USA', 'Alfred A. Knopf, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'harvard', 'Harvard University Press', 'USA', 'Harvard University Press, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'woeli', 'Woeli Publishing', 'Ghana', 'Woeli Publishing, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('55e6a204-c370-46a1-a692-ff30de70289e', 'afram', 'Afram Publications', 'Ghana', 'Afram Publications, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'vintage', 'Vintage Books', 'UK', 'Vintage Books, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'faber', 'Faber & Faber', 'UK', 'Faber & Faber, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'oxford', 'Oxford University Press', 'UK', 'Oxford University Press, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('a73de719-f474-47b3-a869-87de7255a175', 'macmillan', 'Macmillan', 'USA', 'Macmillan, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'bloomsbury', 'Bloomsbury', 'UK', 'Bloomsbury, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'spectacle', 'Spectacle Press Accra', 'Ghana', 'Spectacle Press Accra, a trusted publisher') on conflict (slug) do update set name = excluded.name;
insert into public.publishers (id, slug, name, country, description) values ('e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'sahara', 'Sahara Books', 'Ghana', 'Sahara Books, a trusted publisher') on conflict (slug) do update set name = excluded.name;

-- Authors
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('d573bf4a-8bd3-4975-a9a3-393340afacd3', 'ama-ata-aidoo', 'Ama Ata Aidoo', 'Ama Ata Aidoo is a celebrated author contributing to African and global literature.', 'Ghana', '#0F766E', 2329, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('b3eceb4c-ad0d-4199-a2fd-50dee6fac18b', 'chimamanda-adichie', 'Chimamanda Ngozi Adichie', 'Chimamanda Ngozi Adichie is a celebrated author contributing to African and global literature.', 'Nigeria', '#D4A017', 4658, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('17c911e7-168d-40c5-a97c-f184cf65a6ce', 'kwame-gyasi', 'Kwame Gyasi', 'Kwame Gyasi is a celebrated author contributing to African and global literature.', 'Ghana', '#134E4A', 6987, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('bfccf5a0-d964-4008-a991-4593b44727f9', 'maya-okoro', 'Maya Okoro', 'Maya Okoro is a celebrated author contributing to African and global literature.', 'Ghana', '#B45309', 9316, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('46417788-10e5-4bb7-af0d-1bc435949515', 'james-mensah', 'James Mensah', 'James Mensah is a celebrated author contributing to African and global literature.', 'Ghana', '#0E7490', 11645, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('05863f3e-980d-44c8-af63-ab4fe4732859', 'elena-boateng', 'Elena Boateng', 'Elena Boateng is a celebrated author contributing to African and global literature.', 'Ghana', '#BE123C', 13974, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('efe952d2-5cbd-4e6d-a704-aa5f6e519cd0', 'dr-akosua-frimpong', 'Dr. Akosua Frimpong', 'Dr. Akosua Frimpong is a celebrated author contributing to African and global literature.', 'Ghana', '#4338CA', 16303, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('a36bf591-edb4-4338-ab33-5e09e030cf9b', 'nathan-quaye', 'Nathan Quaye', 'Nathan Quaye is a celebrated author contributing to African and global literature.', 'Ghana', '#047857', 18632, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('bf7936bc-c806-433b-a9c6-6c6771e55343', 'yaw-asante', 'Yaw Asante', 'Yaw Asante is a celebrated author contributing to African and global literature.', 'Ghana', '#0F766E', 20961, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('91a19c52-3dcc-4cf3-a6a7-47fb31998590', 'fatima-diallo', 'Fatima Diallo', 'Fatima Diallo is a celebrated author contributing to African and global literature.', 'Senegal', '#7C2D12', 23290, true) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('b42a4e93-3580-4ea9-acb5-fd910f607b18', 'ibrahim-toure', 'Ibrahim Touré', 'Ibrahim Touré is a celebrated author contributing to African and global literature.', 'Mali', '#1E3A5F', 25619, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('5f649099-b47c-4411-a491-614e1c286713', 'nina-okeke', 'Nina Okeke', 'Nina Okeke is a celebrated author contributing to African and global literature.', 'Nigeria', '#BE185D', 27948, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('d8d33f2c-03bd-4ae2-add6-5e235e0e1e3a', 'samuel-owusu', 'Samuel Owusu', 'Samuel Owusu is a celebrated author contributing to African and global literature.', 'Ghana', '#365314', 30277, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('40d13eff-de83-430e-a370-96e5d9468417', 'leila-hassan', 'Leila Hassan', 'Leila Hassan is a celebrated author contributing to African and global literature.', 'Egypt', '#9A3412', 32606, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('5c989d3c-d88d-40a0-a4c5-15b1305c461a', 'kojo-annor', 'Kojo Annor', 'Kojo Annor is a celebrated author contributing to African and global literature.', 'Ghana', '#155E75', 34935, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('f029cf83-27f5-4adb-a298-2ca6c3df12fc', 'amara-cole', 'Amara Cole', 'Amara Cole is a celebrated author contributing to African and global literature.', 'Ghana', '#831843', 37264, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('a4153962-9975-4fc7-a7a6-bdf658aae36e', 'benedict-darko', 'Benedict Darko', 'Benedict Darko is a celebrated author contributing to African and global literature.', 'Ghana', '#1C1917', 39593, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('612736cb-3175-4d74-a1c1-85fd911b579c', 'zainab-musa', 'Zainab Musa', 'Zainab Musa is a celebrated author contributing to African and global literature.', 'Nigeria', '#713F12', 41922, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('226e7e1a-2410-4f6e-a522-0ef6a35b106e', 'efua-sutherland', 'Efua Sutherland', 'Efua Sutherland is a celebrated author contributing to African and global literature.', 'Ghana', '#14532D', 44251, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('0ccbd4aa-c785-4dca-a7be-93bec6632a30', 'ayo-adebayo', 'Ayo Adebayo', 'Ayo Adebayo is a celebrated author contributing to African and global literature.', 'Nigeria', '#1E40AF', 46580, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('d686fe9e-024c-4a68-ac0c-1a4c73ccdd1e', 'nadia-mensah', 'Nadia Mensah', 'Nadia Mensah is a celebrated author contributing to African and global literature.', 'Ghana', '#9F1239', 48909, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('d6e834cd-a49d-4cb5-a152-6bfcc5de5dcf', 'kofi-agyeman', 'Kofi Agyeman', 'Kofi Agyeman is a celebrated author contributing to African and global literature.', 'Ghana', '#115E59', 51238, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('871d544a-0863-4619-aeae-b67b13430320', 'sarah-nkrumah', 'Sarah Nkrumah', 'Sarah Nkrumah is a celebrated author contributing to African and global literature.', 'Ghana', '#854D0E', 53567, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('503b988f-6a31-4f28-a240-a77fc2a43ddc', 'daniel-boateng', 'Daniel Boateng', 'Daniel Boateng is a celebrated author contributing to African and global literature.', 'Ghana', '#312E81', 55896, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;
insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values ('2babd4bb-e159-457f-a40a-581c5d7af499', 'precious-adjei', 'Precious Adjei', 'Precious Adjei is a celebrated author contributing to African and global literature.', 'Ghana', '#064E3B', 58225, false) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;

-- Books (100)
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'the-accra-chronicle-1', 'The Accra Chronicle', 'A Books & You edition',
      'A compelling literary fiction title exploring baobab and life in Accra.',
      'In this work, the author unfolds a narrative of baobab, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000000', 120, 'English', '2015-01-01',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      true, true, true, true, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      3.80, 20
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'd573bf4a-8bd3-4975-a9a3-393340afacd3', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('1851e7ae-8958-4db1-a9bc-6e0742c60ac7', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0f82d852-1ecd-431b-ae56-63bd3a5eb16f', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cec8d778-f85b-4f10-ad1f-fc1e783a6d21', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f12c3f8b-cf1e-44f5-ada4-557a6ec4665c', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'paperback', 'SKU-1-PA', 4500, 6000, 30, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('471777d3-8e31-401d-a1d6-4bb84cc4f76d', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'hardcover', 'SKU-1-HA', 9000, null, 8, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('799834cf-515b-4bae-accc-d42343d50512', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'ebook', 'SKU-1-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('46bf1b07-b6cc-4d18-a404-12d54eb3c917', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'audiobook', 'SKU-1-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'letters-from-kumasi-2', 'Letters from Kumasi', null,
      'A compelling literary fiction title exploring market and life in Kumasi.',
      'In this work, the author unfolds a narrative of market, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000001', 137, 'English', '2016-02-02',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      3.90, 23
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'b3eceb4c-ad0d-4199-a2fd-50dee6fac18b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('3429ce3c-66b9-47f7-a001-a0bdd46fd72e', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3600df7b-19cc-48da-af7e-4452fbf6ba48', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9485ea82-026c-4b8d-ab1c-0cc6d8d80403', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('41e0d294-9e03-4a52-a4b1-dff5d924b986', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'paperback', 'SKU-2-PA', 5000, null, 31, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b6427697-b276-4e7a-a807-42573266773e', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'hardcover', 'SKU-2-HA', 9700, null, 9, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0f0acd01-185f-47af-aae3-3cfff173dc23', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'ebook', 'SKU-2-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '26a957f9-f793-4552-a8dc-072c7c310b0b', 'library-at-dawn-3', 'Library at Dawn', null,
      'A compelling contemporary fiction title exploring library and life in Cape Coast.',
      'In this work, the author unfolds a narrative of library, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000002', 154, 'English', '2017-03-03',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Contemporary Fiction'],
      4.00, 26
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('26a957f9-f793-4552-a8dc-072c7c310b0b', '17c911e7-168d-40c5-a97c-f184cf65a6ce', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('26a957f9-f793-4552-a8dc-072c7c310b0b', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9401ca69-ec2f-41b0-a277-d1a4b44238ac', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'contemporary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2ef9a091-3aef-44e2-a41d-db351e8d5aeb', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d82d30a8-4af6-4908-a846-f2bd4ac25b63', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'paperback', 'SKU-3-PA', 5500, null, 32, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a164489c-ec43-4eba-ad68-f5f74e649134', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'hardcover', 'SKU-3-HA', 10400, null, 10, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5cb598b7-3cfe-407b-a6e4-010960534ecb', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'ebook', 'SKU-3-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'cd79e247-f43a-4682-a833-1a059a8d9793', 'midnight-river-4', 'Midnight River', null,
      'A compelling mystery title exploring river and life in Tamale.',
      'In this work, the author unfolds a narrative of river, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000003', 171, 'English', '2018-04-04',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Mystery'],
      4.10, 29
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('cd79e247-f43a-4682-a833-1a059a8d9793', 'bfccf5a0-d964-4008-a991-4593b44727f9', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('cd79e247-f43a-4682-a833-1a059a8d9793', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2dafc5b2-c660-41e4-a880-84778f0ee139', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'mystery') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b4f36c06-c029-479f-a2d8-e132f4d3f3e0', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('492bfe69-3f93-430b-acd4-7ea4a99eda41', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'paperback', 'SKU-4-PA', 6000, null, 33, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('322d9841-a25a-473e-a3e2-9d1b546039b1', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'hardcover', 'SKU-4-HA', 11100, null, 11, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6c24d231-f663-424a-a04a-10787eed8935', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'ebook', 'SKU-4-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '63ba640e-3f35-402a-a71d-090dd09da19a', 'the-last-horizon-5', 'The Last Horizon', 'A Books & You edition',
      'A compelling historical fiction title exploring horizon and life in Tema.',
      'In this work, the author unfolds a narrative of horizon, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000004', 188, 'English', '2019-05-05',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Historical Fiction'],
      4.20, 32
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('63ba640e-3f35-402a-a71d-090dd09da19a', '46417788-10e5-4bb7-af0d-1bc435949515', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('63ba640e-3f35-402a-a71d-090dd09da19a', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('92f3d36b-7411-4c71-a08d-0689286051b8', '63ba640e-3f35-402a-a71d-090dd09da19a', 'historical-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c503712b-919b-4ca3-a74d-0696dd0d192d', '63ba640e-3f35-402a-a71d-090dd09da19a', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('54371930-ff3f-4da8-adf5-73191cb4ecd4', '63ba640e-3f35-402a-a71d-090dd09da19a', 'paperback', 'SKU-5-PA', 6500, null, 34, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ee9eddef-0ad3-461a-a206-66e5a7328914', '63ba640e-3f35-402a-a71d-090dd09da19a', 'hardcover', 'SKU-5-HA', 11800, null, 12, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('287b626f-913d-4bc7-a055-d9ff945bcd96', '63ba640e-3f35-402a-a71d-090dd09da19a', 'ebook', 'SKU-5-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c99c137f-ba07-48f9-ac95-28832bd8da6b', '63ba640e-3f35-402a-a71d-090dd09da19a', 'audiobook', 'SKU-5-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'building-drum-6', 'Building Drum', null,
      'A compelling entrepreneurship title exploring drum and life in Lagos.',
      'In this work, the author unfolds a narrative of drum, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000005', 205, 'English', '2020-06-06',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Entrepreneurship', 'Business'],
      4.30, 35
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('804e4cde-8e97-48ff-a34c-423385a1ed6a', '05863f3e-980d-44c8-af63-ab4fe4732859', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('804e4cde-8e97-48ff-a34c-423385a1ed6a', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('5f8b1e64-75ab-42ad-ae1a-5abcfa952b96', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'entrepreneurship') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7522107f-1a88-441f-a806-151aeec4e94e', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9cc49967-6aff-450d-a35a-ee6f96bdcd34', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('47e2f536-4214-4b71-a5f2-dbbb1acf1f65', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'paperback', 'SKU-6-PA', 7000, null, 35, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6af59fdb-d7f5-4ab1-a967-6fc9671665bb', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'hardcover', 'SKU-6-HA', 12500, null, 13, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b9630425-8850-44f2-af59-fd69a6d77d24', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'ebook', 'SKU-6-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c75949db-dcf0-4c30-aa62-20a893944def', 'capital-of-harbor-7', 'Capital of Harbor', null,
      'A compelling finance title exploring harbor and life in Nairobi.',
      'In this work, the author unfolds a narrative of harbor, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000006', 222, 'English', '2021-07-07',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Finance', 'Business'],
      4.40, 38
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c75949db-dcf0-4c30-aa62-20a893944def', 'efe952d2-5cbd-4e6d-a704-aa5f6e519cd0', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c75949db-dcf0-4c30-aa62-20a893944def', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d9a6055d-8290-4bc6-a296-cc307dbf88a5', 'c75949db-dcf0-4c30-aa62-20a893944def', 'finance') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d60d4617-2f16-4c13-a82d-be9c471fdf0f', 'c75949db-dcf0-4c30-aa62-20a893944def', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1074040b-acd8-4580-a16d-f10b0f0d6d1c', 'c75949db-dcf0-4c30-aa62-20a893944def', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('149f32b1-1307-4e0c-a182-19aa05c929c3', 'c75949db-dcf0-4c30-aa62-20a893944def', 'paperback', 'SKU-7-PA', 7500, 9000, 36, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('093fd4a6-f015-4bbf-a8eb-407c3cfcc6ac', 'c75949db-dcf0-4c30-aa62-20a893944def', 'hardcover', 'SKU-7-HA', 13200, null, 14, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6d51f934-45ce-45bb-a731-d93c8a7c60f4', 'c75949db-dcf0-4c30-aa62-20a893944def', 'ebook', 'SKU-7-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'lead-like-archive-8', 'Lead Like Archive', null,
      'A compelling leadership title exploring archive and life in Dakar.',
      'In this work, the author unfolds a narrative of archive, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000007', 239, 'English', '2022-08-08',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership'],
      4.50, 41
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'a36bf591-edb4-4338-ab33-5e09e030cf9b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('269fb580-d59d-474f-a742-23b93dec28c5', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4c9e0544-308c-4e4f-a9e0-3fe30ff234d8', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a7bd3e20-5743-42a8-aa65-ed04c97e21e5', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'paperback', 'SKU-8-PA', 8000, null, 37, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d403b8f3-7603-487c-ab01-b7bb50624617', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'hardcover', 'SKU-8-HA', 13900, null, 15, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('19ced410-2463-493c-a0ed-543db2a0c7a6', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'ebook', 'SKU-8-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'the-signal-of-garden-9', 'The Signal of Garden', 'A Books & You edition',
      'A compelling technology title exploring garden and life in Cairo.',
      'In this work, the author unfolds a narrative of garden, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000008', 256, 'English', '2023-09-09',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology', 'AI'],
      4.60, 44
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('5c4a3b12-c81a-4e42-a625-5b243203e01b', 'bf7936bc-c806-433b-a9c6-6c6771e55343', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('5c4a3b12-c81a-4e42-a625-5b243203e01b', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('5b246cde-61aa-490a-ad64-97a020815892', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('91222b14-36f2-47d1-a2af-2ec0794ecfe9', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'ai') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b148a0a8-6708-4876-a0f4-7359213af4f1', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ec2e8b24-a43c-4da3-a6a9-5008c125b34d', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'paperback', 'SKU-9-PA', 8500, null, 38, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('78da5cf7-a254-4ce0-a19c-92ce3aca5832', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'hardcover', 'SKU-9-HA', 14600, null, 16, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('90b49a1f-6a28-4669-a3dd-4a10fde6a916', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'ebook', 'SKU-9-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('29c5583d-a869-4732-a7aa-ce6aacc09524', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 'audiobook', 'SKU-9-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'code-signal-10', 'Code & Signal', null,
      'A compelling technology title exploring signal and life in Kigali.',
      'In this work, the author unfolds a narrative of signal, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000009', 273, 'English', '2024-10-10',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.70, 47
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('cd425aac-19fc-4d6d-a57f-553f83a50c65', '91a19c52-3dcc-4cf3-a6a7-47fb31998590', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('cd425aac-19fc-4d6d-a57f-553f83a50c65', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2c353871-082d-4617-aa64-9cde257a75a9', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b09b850a-1a45-43e3-ab17-2babd7471975', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('27b0be47-ef33-4d24-afb4-f6e7ac4e6a7d', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'paperback', 'SKU-10-PA', 9000, null, 39, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('23055571-3aa2-4e0f-a44f-e7cd0d6c2012', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'hardcover', 'SKU-10-HA', 15300, null, 17, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('eca6e3f1-11f8-4b2b-aec1-6b4647357cf0', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'ebook', 'SKU-10-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'cloud-over-accra-11', 'Cloud over Accra', null,
      'A compelling technology title exploring ledger and life in Accra.',
      'In this work, the author unfolds a narrative of ledger, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000010', 290, 'English', '2025-11-11',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.80, 50
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'b42a4e93-3580-4ea9-acb5-fd910f607b18', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b0872c76-bc61-480b-aa08-adf67e6314c5', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1ef1abdc-04c8-4be6-a36d-45a7b1da6bf2', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('9508cb9b-135c-4669-af1d-106d8da2d57a', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'paperback', 'SKU-11-PA', 9500, null, 40, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5ee29d7b-5d72-4a46-a29d-f8ddeb441c00', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'hardcover', 'SKU-11-HA', 16000, null, 18, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f8068728-5a50-4dc6-a752-e23017ec4e2c', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 'ebook', 'SKU-11-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'lantern-for-children-12', 'Lantern for Children', null,
      'A compelling children''s title exploring lantern and life in Kumasi.',
      'In this work, the author unfolds a narrative of lantern, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000011', 307, 'English', '2015-12-12',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, true, true, '2026-09-15',
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      4.90, 53
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a1ba7428-037e-4118-a9b6-ae5533c245fb', '5f649099-b47c-4411-a491-614e1c286713', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a1ba7428-037e-4118-a9b6-ae5533c245fb', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d46fff91-c0f3-48cf-aaea-ee8f5a91c99d', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0ac831bb-6365-4351-adfd-ec89e26216ae', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a2c71fb0-dac8-416e-ad73-44ff351216c8', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'paperback', 'SKU-12-PA', 10000, null, 0, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d473008c-9be2-4e52-aedd-1964fb725133', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'hardcover', 'SKU-12-HA', 16700, null, 19, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('bc6ea141-54dc-49ec-a47a-370383597b1f', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 'ebook', 'SKU-12-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'ananse-and-the-courier-13', 'Ananse and the Courier', 'A Books & You edition',
      'A compelling children''s title exploring courier and life in Cape Coast.',
      'In this work, the author unfolds a narrative of courier, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000012', 324, 'English', '2016-01-13',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s', 'Folklore'],
      3.80, 56
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'd8d33f2c-03bd-4ae2-add6-5e235e0e1e3a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ce9828eb-e460-40d5-ae3d-764d345e9e5d', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6a2299f9-11d2-475e-ae17-e355a928fb90', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('667d977c-d362-4303-a427-5077b1b2adc0', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'folklore') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7033676d-fa0c-4849-aef1-c5ae6cd36a31', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('98d6b788-ad4d-4cd4-ae4d-2dc4f219e63d', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'paperback', 'SKU-13-PA', 10500, 12000, 42, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('be3ec4a4-258b-4930-aeda-34550976903f', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'hardcover', 'SKU-13-HA', 17400, null, 20, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a220d608-2650-45cf-a103-3a2ded369bde', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'ebook', 'SKU-13-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('11e044ed-1ec8-41fa-a94b-150ced40762b', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 'audiobook', 'SKU-13-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'little-threshold-14', 'Little Threshold', null,
      'A compelling children''s title exploring threshold and life in Tamale.',
      'In this work, the author unfolds a narrative of threshold, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000013', 341, 'English', '2017-02-14',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      3.90, 59
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', '40d13eff-de83-430e-a370-96e5d9468417', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('8cc12eeb-f346-4378-a0a5-0c515429e01d', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9bd2b91b-6311-45d8-a5c7-80b90888e049', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('eafe73f9-f4aa-4df3-ad02-e04b43394485', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'paperback', 'SKU-14-PA', 11000, null, 43, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a421ab6c-11f1-43d7-ad88-f449bc179f28', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'hardcover', 'SKU-14-HA', 18100, null, 21, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7ef8735b-4f25-4fcf-a87d-f53184382b0d', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 'ebook', 'SKU-14-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'studies-in-compass-15', 'Studies in Compass', null,
      'A compelling academic title exploring compass and life in Tema.',
      'In this work, the author unfolds a narrative of compass, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000014', 358, 'English', '2018-03-15',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Academic'],
      4.00, 62
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', '5c989d3c-d88d-40a0-a4c5-15b1305c461a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b1066ffa-8deb-44c1-ae8e-a7d98b23a1bf', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'academic') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('bf10f1d3-2b58-47e0-a71b-22e431822f71', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('804c773f-7cf4-4196-a5dc-d7fe63a35e9f', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'paperback', 'SKU-15-PA', 11500, null, 44, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3a7a0b48-fb5b-4805-a30a-c3590013edca', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'hardcover', 'SKU-15-HA', 18800, null, 22, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ba78c5b7-0169-4e34-a364-0e8bb4a6b543', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'ebook', 'SKU-15-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'empire-of-harvest-16', 'Empire of Harvest', null,
      'A compelling history title exploring harvest and life in Lagos.',
      'In this work, the author unfolds a narrative of harvest, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000015', 375, 'English', '2019-04-16',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History', 'Education'],
      4.10, 65
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'f029cf83-27f5-4adb-a298-2ca6c3df12fc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('0ac21ac9-0f1f-44f0-a1bb-9675729770cf', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('89d1fe6d-4d5f-467e-a20b-743150609ca0', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a9f9c918-1d2d-4f7f-ad4c-f379171e6064', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'education') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1ad2feeb-1d5a-40be-a78a-b219e16f8762', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('57cb70f6-42d6-4c0e-a2e2-e47f665b3a0e', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'paperback', 'SKU-16-PA', 12000, null, 45, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6819de66-c871-4b2f-a63a-66e30370d0c4', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'hardcover', 'SKU-16-HA', 9000, null, 23, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('97d4056f-d5d4-4b61-a3e5-f0cbd01ced78', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'ebook', 'SKU-16-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'reading-nairobi-17', 'Reading Nairobi', 'A Books & You edition',
      'A compelling history title exploring canvas and life in Nairobi.',
      'In this work, the author unfolds a narrative of canvas, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000016', 392, 'English', '2020-05-17',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      4.20, 68
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'a4153962-9975-4fc7-a7a6-bdf658aae36e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('7734f4c8-db29-4dcc-af8e-3f24ef8961ef', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9d5a277b-2bbd-41b0-afea-5fb65dbbe6e8', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('fa0a9420-3837-4c31-a7e6-bdb0d8c77f73', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('78d62e7c-1eb8-4000-a1f7-b7249a2521b1', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'paperback', 'SKU-17-PA', 12500, null, 46, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('038168e8-b856-4bae-ab52-48c83fc6f338', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'hardcover', 'SKU-17-HA', 9700, null, 24, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('45972731-ed1b-4c39-a828-a603f48053c7', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'ebook', 'SKU-17-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('93d59b2d-58c1-4ba7-af0c-c6f9c3f803c0', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'audiobook', 'SKU-17-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'habits-of-echo-18', 'Habits of Echo', null,
      'A compelling self-help title exploring echo and life in Dakar.',
      'In this work, the author unfolds a narrative of echo, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000017', 409, 'English', '2021-06-18',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help', 'Productivity'],
      4.30, 71
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('22352f97-96ef-4ccf-a5dd-e3e2d2332af3', '612736cb-3175-4d74-a1c1-85fd911b579c', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('22352f97-96ef-4ccf-a5dd-e3e2d2332af3', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3253c844-79ec-4e4d-a016-7e8d4a62c94c', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7bb43c20-2aef-4ab8-aaf0-59626808e967', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'productivity') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9a92dffb-cf78-4a45-a8e8-f48bacc6b61e', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3af0e188-9cea-4270-ae73-54d6c1dea02a', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'paperback', 'SKU-18-PA', 13000, null, 47, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('551d1eac-5b07-4587-a236-949839deb0a9', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'hardcover', 'SKU-18-HA', 10400, null, 25, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ae882850-29e8-4e63-ac1a-d11da72b0a5f', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', 'ebook', 'SKU-18-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '52376bad-b03f-460d-a87a-ec929c67ca14', 'the-anchor-year-19', 'The Anchor Year', null,
      'A compelling self-help title exploring anchor and life in Cairo.',
      'In this work, the author unfolds a narrative of anchor, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000018', 426, 'English', '2022-07-19',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help'],
      4.40, 74
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('52376bad-b03f-460d-a87a-ec929c67ca14', '226e7e1a-2410-4f6e-a522-0ef6a35b106e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('52376bad-b03f-460d-a87a-ec929c67ca14', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('ee50b62a-9ad9-4982-aed4-531b718b1506', '52376bad-b03f-460d-a87a-ec929c67ca14', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3a816a0a-62d7-446d-a6ac-13d33ed13222', '52376bad-b03f-460d-a87a-ec929c67ca14', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a379b465-dae9-4e85-a499-257b11342723', '52376bad-b03f-460d-a87a-ec929c67ca14', 'paperback', 'SKU-19-PA', 13500, 15000, 48, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('81aaa977-98f5-4b9f-a8b4-36ebdfe6d194', '52376bad-b03f-460d-a87a-ec929c67ca14', 'hardcover', 'SKU-19-HA', 11100, null, 26, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d187fa8a-1a90-4fb2-a38c-5da2b794d541', '52376bad-b03f-460d-a87a-ec929c67ca14', 'ebook', 'SKU-19-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'quiet-spark-20', 'Quiet Spark', null,
      'A compelling leadership title exploring spark and life in Kigali.',
      'In this work, the author unfolds a narrative of spark, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000019', 443, 'English', '2023-08-20',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership', 'Self-Help'],
      4.50, 77
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', '0ccbd4aa-c785-4dca-a7be-93bec6632a30', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9f90a085-5400-4e2d-a844-4cf61c259c3c', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4a0eae77-f762-47c4-a280-901060c8cd38', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a138e3e9-ddf4-4449-ad83-5be7ac17a778', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a4d98de1-2241-449d-a539-a372a9f20ac2', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'paperback', 'SKU-20-PA', 14000, null, 49, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6f2744e3-2193-48a2-a7ba-b230c0bf0dd2', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'hardcover', 'SKU-20-HA', 11800, null, 27, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b6e3502e-a24f-4a13-ab35-35838f8f0dad', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'ebook', 'SKU-20-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'life-of-ama-21', 'Life of Ama', 'A Books & You edition',
      'A compelling biography title exploring baobab and life in Accra.',
      'In this work, the author unfolds a narrative of baobab, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000020', 460, 'English', '2024-09-21',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography'],
      4.60, 80
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('f39e47e7-e01a-44e2-a290-c6526c8680bf', 'd686fe9e-024c-4a68-ac0c-1a4c73ccdd1e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('f39e47e7-e01a-44e2-a290-c6526c8680bf', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d2a35b13-0aef-4105-af99-4359c9fc74ae', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d9606e07-997e-4a11-a6cd-0bccd8cb27dc', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('709581f4-f577-4451-a419-17dd9ef288ca', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'paperback', 'SKU-21-PA', 4500, null, 50, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('706b26d3-c6f9-4f06-a8c8-481778dbf2f0', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'hardcover', 'SKU-21-HA', 12500, null, 8, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e125f92a-6673-437b-aa39-b183118b2ee2', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'ebook', 'SKU-21-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('963e6a13-7c31-4687-a6d9-f9db990e8269', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'audiobook', 'SKU-21-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '333b17fd-c668-49ac-a5e7-af935c358019', 'voices-of-kumasi-22', 'Voices of Kumasi', null,
      'A compelling biography title exploring market and life in Kumasi.',
      'In this work, the author unfolds a narrative of market, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000021', 477, 'English', '2025-10-22',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography', 'History'],
      4.70, 83
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('333b17fd-c668-49ac-a5e7-af935c358019', 'd6e834cd-a49d-4cb5-a152-6bfcc5de5dcf', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('333b17fd-c668-49ac-a5e7-af935c358019', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1241b1a4-0be7-480a-af35-7b26921ab2ab', '333b17fd-c668-49ac-a5e7-af935c358019', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('182a23de-f33c-48e9-aa39-4fcf445e1875', '333b17fd-c668-49ac-a5e7-af935c358019', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d38f917e-f65f-4627-a545-93733d01c635', '333b17fd-c668-49ac-a5e7-af935c358019', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0dd0b5e5-1e47-42f7-a68f-d839aa535cef', '333b17fd-c668-49ac-a5e7-af935c358019', 'paperback', 'SKU-22-PA', 5000, null, 51, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2f908c5b-374c-4e83-a16a-958e6b770c19', '333b17fd-c668-49ac-a5e7-af935c358019', 'hardcover', 'SKU-22-HA', 13200, null, 9, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('15efe347-a18e-4794-a014-3ec19cb71e2b', '333b17fd-c668-49ac-a5e7-af935c358019', 'ebook', 'SKU-22-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'poems-for-library-23', 'Poems for Library', null,
      'A compelling poetry title exploring library and life in Cape Coast.',
      'In this work, the author unfolds a narrative of library, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000022', 494, 'English', '2015-11-23',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.80, 86
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('14a26fbb-1cca-4022-a96d-4c0c368d70f3', '871d544a-0863-4619-aeae-b67b13430320', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('14a26fbb-1cca-4022-a96d-4c0c368d70f3', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('ff547c85-881d-4a0f-af49-31acf8caf54f', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1a71d4be-2263-4b9a-a85f-f840813ac65f', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('70570117-1025-46e4-ab69-d20530f9a53b', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'paperback', 'SKU-23-PA', 5500, null, 52, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d8dcd05a-6fc7-4af4-a04d-01f965b74f31', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'hardcover', 'SKU-23-HA', 13900, null, 10, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('66e6e7c1-a087-400e-a11e-ed38fe63208b', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 'ebook', 'SKU-23-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '7782aeb9-521d-47ae-a3dd-1594d309735e', 'harmattan-river-24', 'Harmattan River', null,
      'A compelling poetry title exploring river and life in Tamale.',
      'In this work, the author unfolds a narrative of river, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000023', 511, 'English', '2016-12-24',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.90, 89
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('7782aeb9-521d-47ae-a3dd-1594d309735e', '503b988f-6a31-4f28-a240-a77fc2a43ddc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('7782aeb9-521d-47ae-a3dd-1594d309735e', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('48b2c209-8df0-4b75-a236-342f93744702', '7782aeb9-521d-47ae-a3dd-1594d309735e', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f004e82c-4443-4365-a170-76eac4790277', '7782aeb9-521d-47ae-a3dd-1594d309735e', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7c3b94f7-37a9-4517-a475-fd411bc826f9', '7782aeb9-521d-47ae-a3dd-1594d309735e', 'paperback', 'SKU-24-PA', 6000, null, 53, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c135aac8-e89c-42e6-a1b5-8fe6d128d890', '7782aeb9-521d-47ae-a3dd-1594d309735e', 'hardcover', 'SKU-24-HA', 14600, null, 11, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2b7939b8-c89a-4f35-a333-b0570265445b', '7782aeb9-521d-47ae-a3dd-1594d309735e', 'ebook', 'SKU-24-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'df14d48d-0d72-42cf-a005-401ba47b9872', 'a-history-of-tema-25', 'A History of Tema', 'A Books & You edition',
      'A compelling history title exploring horizon and life in Tema.',
      'In this work, the author unfolds a narrative of horizon, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000024', 128, 'English', '2017-01-25',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      3.80, 92
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('df14d48d-0d72-42cf-a005-401ba47b9872', '2babd4bb-e159-457f-a40a-581c5d7af499', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('df14d48d-0d72-42cf-a005-401ba47b9872', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2354ee3d-b777-4417-abee-f2126cfc35ae', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c6c5a0d9-0f6c-4ac6-a046-c5b5f56db4da', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('06c25c4d-ad5b-4f09-a1d3-d84de20daab5', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'paperback', 'SKU-25-PA', 6500, 8000, 54, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('808e9d2b-750d-4843-aa77-e998dfa878b2', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'hardcover', 'SKU-25-HA', 15300, null, 12, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('621c8578-6587-4df1-aa90-0b6d89e09fb5', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'ebook', 'SKU-25-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('4d86a2a6-5761-4c75-aa03-3f41d12824aa', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'audiobook', 'SKU-25-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'coastal-drum-26', 'Coastal Drum', null,
      'A compelling history title exploring drum and life in Lagos.',
      'In this work, the author unfolds a narrative of drum, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000025', 145, 'English', '2018-02-26',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      3.90, 95
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'd573bf4a-8bd3-4975-a9a3-393340afacd3', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1bea9f56-4b09-4944-a6c8-71dfd958efdc', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e55a8928-39c8-436f-a3eb-4317bd11149f', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('06ee1a08-a544-4f48-a92b-c1b3fc1c4483', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'paperback', 'SKU-26-PA', 7000, null, 55, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('848ad7a2-ddf1-4f52-a8c6-ae407cf510f4', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'hardcover', 'SKU-26-HA', 16000, null, 13, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1eb62e19-ce4b-436b-ab67-32abe4251558', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'ebook', 'SKU-26-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'maps-of-nairobi-27', 'Maps of Nairobi', null,
      'A compelling non-fiction title exploring harbor and life in Nairobi.',
      'In this work, the author unfolds a narrative of harbor, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000026', 162, 'English', '2019-03-27',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.00, 98
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'b3eceb4c-ad0d-4199-a2fd-50dee6fac18b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a5d51893-0e29-4017-a237-db3b840af660', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('344725a2-531b-4648-ab86-de6d08e12d3c', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3c86a8c0-ecc7-4c88-a32d-d678bffed0af', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'paperback', 'SKU-27-PA', 7500, null, 56, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('03c36055-95b9-4ef5-a134-331e97a066d1', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'hardcover', 'SKU-27-HA', 16700, null, 14, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('9ed19abc-61da-47c2-aac4-94e63f6fd762', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', 'ebook', 'SKU-27-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'notes-on-archive-28', 'Notes on Archive', null,
      'A compelling non-fiction title exploring archive and life in Dakar.',
      'In this work, the author unfolds a narrative of archive, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000027', 179, 'English', '2020-04-01',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.10, 101
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('2f949a6f-c934-4e2a-a4ea-628503f4e243', '17c911e7-168d-40c5-a97c-f184cf65a6ce', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('2f949a6f-c934-4e2a-a4ea-628503f4e243', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('ca95e4dd-4bc1-4bd7-ac38-5171af40e354', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('578136e4-0785-4fc8-a645-404fa4f6e695', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6bdb1594-0ed5-41e5-a7db-1b3a21727db4', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'paperback', 'SKU-28-PA', 8000, null, 57, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('00629add-a407-4816-af8c-1909bf8e347a', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'hardcover', 'SKU-28-HA', 17400, null, 15, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('76c2aa37-d3ac-44b1-a76c-7102952f7507', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 'ebook', 'SKU-28-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'field-guide-to-garden-29', 'Field Guide to Garden', 'A Books & You edition',
      'A compelling non-fiction title exploring garden and life in Cairo.',
      'In this work, the author unfolds a narrative of garden, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000028', 196, 'English', '2021-05-02',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.20, 104
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('2e1b1243-9b09-4866-afce-94aeb31d3e87', 'bfccf5a0-d964-4008-a991-4593b44727f9', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('2e1b1243-9b09-4866-afce-94aeb31d3e87', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0307667d-8313-4177-a9bc-5d0703ffbd02', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('8b0db16e-25c7-4f6e-aa47-f9cfe6ef2e76', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6331d74d-e92f-4fea-a354-a5d92ffe8afd', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'paperback', 'SKU-29-PA', 8500, null, 58, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ae4d0d78-13ae-47d3-a9ff-8d91be9c322d', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'hardcover', 'SKU-29-HA', 18100, null, 16, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0911c572-1397-4bcd-abb3-be251c674048', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'ebook', 'SKU-29-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e3f8aba2-156e-45e1-a4ff-df87015cb4da', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 'audiobook', 'SKU-29-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'kigali-report-30', 'Kigali Report', null,
      'A compelling non-fiction title exploring signal and life in Kigali.',
      'In this work, the author unfolds a narrative of signal, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000029', 213, 'English', '2022-06-03',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.30, 107
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('dc93defd-86d8-4759-aacb-3a8f94429a3f', '46417788-10e5-4bb7-af0d-1bc435949515', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('dc93defd-86d8-4759-aacb-3a8f94429a3f', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a20d2e31-65a0-4404-adbd-7da3a139431b', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('ba1a7111-b805-47ad-afe4-18c2881f648d', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('524bdfaf-ecc1-4218-a120-037f37a57474', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'paperback', 'SKU-30-PA', 9000, null, 59, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a0824793-c010-4b0a-a40e-8766be37b494', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'hardcover', 'SKU-30-HA', 18800, null, 17, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ccbe82d5-3410-48e8-a744-c57b639e4fa4', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'ebook', 'SKU-30-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'the-accra-chronicle-31', 'The Accra Chronicle', null,
      'A compelling literary fiction title exploring ledger and life in Accra.',
      'In this work, the author unfolds a narrative of ledger, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000030', 230, 'English', '2023-07-04',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      4.40, 110
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('e0c0c286-55a4-4f2e-ab45-73741d8d3d54', '05863f3e-980d-44c8-af63-ab4fe4732859', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('e0c0c286-55a4-4f2e-ab45-73741d8d3d54', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e947d023-a8b0-4be0-a90a-f64f0bec7456', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9939f123-c856-48c7-a04c-a21a0aea443f', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('da49ff02-39f3-43a0-a222-541a14bf175f', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'paperback', 'SKU-31-PA', 9500, 11000, 60, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5ef011fd-d8f5-4344-ae0b-3b4d2b3a70ea', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'hardcover', 'SKU-31-HA', 9000, null, 18, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d4faf228-0b39-4877-acba-9a3c80c5f9e8', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 'ebook', 'SKU-31-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '51766f6e-e80a-48d0-a916-905e413aa5d4', 'letters-from-kumasi-32', 'Letters from Kumasi', null,
      'A compelling literary fiction title exploring lantern and life in Kumasi.',
      'In this work, the author unfolds a narrative of lantern, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000031', 247, 'English', '2024-08-05',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      4.50, 113
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('51766f6e-e80a-48d0-a916-905e413aa5d4', 'efe952d2-5cbd-4e6d-a704-aa5f6e519cd0', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('51766f6e-e80a-48d0-a916-905e413aa5d4', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('13ac5178-132c-45c7-a06c-5bb889b1f12d', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('61b6c439-be91-44d7-aa9c-1f57f1ce450a', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e8093e38-ef36-42c1-a392-f77f8e8b6fa7', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'paperback', 'SKU-32-PA', 10000, null, 61, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3951fdf4-c96b-42f1-a3c3-18e476699287', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'hardcover', 'SKU-32-HA', 9700, null, 19, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8a576ea4-bd39-4f8f-a58b-d358ec83bc37', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'ebook', 'SKU-32-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '91858170-c163-4389-ab1a-2a45132672e1', 'courier-at-dawn-33', 'Courier at Dawn', 'A Books & You edition',
      'A compelling contemporary fiction title exploring courier and life in Cape Coast.',
      'In this work, the author unfolds a narrative of courier, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000032', 264, 'English', '2025-09-06',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Contemporary Fiction'],
      4.60, 116
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('91858170-c163-4389-ab1a-2a45132672e1', 'a36bf591-edb4-4338-ab33-5e09e030cf9b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('91858170-c163-4389-ab1a-2a45132672e1', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('32b8ffd1-9c67-4381-a6a5-a051af17564d', '91858170-c163-4389-ab1a-2a45132672e1', 'contemporary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('bc603439-87c4-4203-ac0a-88ff6ea5999b', '91858170-c163-4389-ab1a-2a45132672e1', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('71780de6-2be4-4b9d-a9ce-9cd77fbb4030', '91858170-c163-4389-ab1a-2a45132672e1', 'paperback', 'SKU-33-PA', 10500, null, 62, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a8bc2931-698a-4cc3-af23-d2af0cef875f', '91858170-c163-4389-ab1a-2a45132672e1', 'hardcover', 'SKU-33-HA', 10400, null, 20, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('43cd04b2-5a82-401a-a9b8-281177d5d44e', '91858170-c163-4389-ab1a-2a45132672e1', 'ebook', 'SKU-33-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c62514a3-b809-475b-a4e2-5467cb715ccd', '91858170-c163-4389-ab1a-2a45132672e1', 'audiobook', 'SKU-33-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'midnight-threshold-34', 'Midnight Threshold', null,
      'A compelling mystery title exploring threshold and life in Tamale.',
      'In this work, the author unfolds a narrative of threshold, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000033', 281, 'English', '2015-10-07',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Mystery'],
      4.70, 119
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'bf7936bc-c806-433b-a9c6-6c6771e55343', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c46b588f-e492-4ddb-aecc-feb7eaeb059f', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3be6d8e9-4ecc-4220-a872-1a4b0fd771ad', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'mystery') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('331f50c2-a35c-4a19-a34c-9066186bf1d7', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a7fedb92-ac60-4062-a1f6-fe2cae663087', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'paperback', 'SKU-34-PA', 11000, null, 63, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c965810f-93fc-44e2-a8fd-08395beb95dd', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'hardcover', 'SKU-34-HA', 11100, null, 21, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('adf917a5-eb4f-4187-a568-b8b0c9bb2f6a', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 'ebook', 'SKU-34-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'e42860da-0b14-4164-a222-7e98c20618af', 'the-last-compass-35', 'The Last Compass', null,
      'A compelling historical fiction title exploring compass and life in Tema.',
      'In this work, the author unfolds a narrative of compass, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000034', 298, 'English', '2016-11-08',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Historical Fiction'],
      4.80, 122
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('e42860da-0b14-4164-a222-7e98c20618af', '91a19c52-3dcc-4cf3-a6a7-47fb31998590', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('e42860da-0b14-4164-a222-7e98c20618af', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9d487cd7-3ea4-4d28-a0dc-3561cc3c0a86', 'e42860da-0b14-4164-a222-7e98c20618af', 'historical-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1050ed3d-fd6d-4b2e-a1db-ed49e1ae347c', 'e42860da-0b14-4164-a222-7e98c20618af', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('66fed83e-c18f-4918-ae09-75b81972a3cd', 'e42860da-0b14-4164-a222-7e98c20618af', 'paperback', 'SKU-35-PA', 11500, null, 64, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('56a63c18-976d-4afd-a9ba-b5e9c6ff62a7', 'e42860da-0b14-4164-a222-7e98c20618af', 'hardcover', 'SKU-35-HA', 11800, null, 22, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e00c546e-962e-4012-a96c-1aa6da0082a6', 'e42860da-0b14-4164-a222-7e98c20618af', 'ebook', 'SKU-35-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '55314c69-b11e-4d26-acca-5d11a79f2bad', 'building-harvest-36', 'Building Harvest', null,
      'A compelling entrepreneurship title exploring harvest and life in Lagos.',
      'In this work, the author unfolds a narrative of harvest, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000035', 315, 'English', '2017-12-09',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      true, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Entrepreneurship', 'Business'],
      4.90, 125
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('55314c69-b11e-4d26-acca-5d11a79f2bad', 'b42a4e93-3580-4ea9-acb5-fd910f607b18', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('55314c69-b11e-4d26-acca-5d11a79f2bad', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4223c9b1-7b5e-4686-ac9b-20ce12867191', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'entrepreneurship') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9bfdc212-2bce-4204-a374-255d468e1a1b', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('98da7bf1-ce88-43d3-a239-c35a446f7267', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('9c4a66c5-44f6-491c-ac82-aa17cff00f9f', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'paperback', 'SKU-36-PA', 12000, null, 65, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('17365577-8fd1-4cda-aa5e-bdfe2f140754', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'hardcover', 'SKU-36-HA', 12500, null, 23, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3e27c3fd-5de9-4c6d-a09f-9398e5940876', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'ebook', 'SKU-36-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'capital-of-canvas-37', 'Capital of Canvas', 'A Books & You edition',
      'A compelling finance title exploring canvas and life in Nairobi.',
      'In this work, the author unfolds a narrative of canvas, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000036', 332, 'English', '2018-01-10',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Finance', 'Business'],
      3.80, 128
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', '5f649099-b47c-4411-a491-614e1c286713', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('58c070a2-6e33-4d82-add5-a41bb9936bb2', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'finance') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e156fd25-efa4-4f60-a029-203ae872e3da', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f420dcd2-d6b0-4131-a3b1-64b512df87b7', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('23fc1800-c437-4ae0-a2c3-ec800332fc9a', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'paperback', 'SKU-37-PA', 12500, 14000, 66, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b9234f90-c62c-46f5-a6a0-63684bb948e7', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'hardcover', 'SKU-37-HA', 13200, null, 24, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7c62f645-95b4-4a52-a12c-a285c4d88301', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'ebook', 'SKU-37-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d93c3459-f1d4-474c-a951-de51a8fc479c', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 'audiobook', 'SKU-37-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '75fdc27b-c7be-474c-ab92-96b601a191a5', 'lead-like-echo-38', 'Lead Like Echo', null,
      'A compelling leadership title exploring echo and life in Dakar.',
      'In this work, the author unfolds a narrative of echo, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000037', 349, 'English', '2019-02-11',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership'],
      3.90, 131
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('75fdc27b-c7be-474c-ab92-96b601a191a5', 'd8d33f2c-03bd-4ae2-add6-5e235e0e1e3a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('75fdc27b-c7be-474c-ab92-96b601a191a5', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('75747ea5-ae87-4939-a935-fcf1f0a97210', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9ae1a9ec-06a5-4ad6-affc-3acd214f8146', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a21cf450-3f76-44e7-a5f7-b039f5dfbf30', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'paperback', 'SKU-38-PA', 13000, null, 67, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e57c9b68-a07c-4349-aa1d-d06a09f7709c', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'hardcover', 'SKU-38-HA', 13900, null, 25, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3dd47c86-191f-4282-a95b-42e4023471f8', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'ebook', 'SKU-38-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'the-signal-of-anchor-39', 'The Signal of Anchor', null,
      'A compelling technology title exploring anchor and life in Cairo.',
      'In this work, the author unfolds a narrative of anchor, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000038', 366, 'English', '2020-03-12',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology', 'AI'],
      4.00, 134
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('4e9f6445-8290-4b81-ae96-7b525313e2b4', '40d13eff-de83-430e-a370-96e5d9468417', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('4e9f6445-8290-4b81-ae96-7b525313e2b4', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a53889d4-6bcd-499c-a312-8c39787d1bb1', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cc2f443a-b374-41c8-a3ab-e402fd2e6b79', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'ai') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7d25daba-e7af-4613-a162-3a2a88cee1fe', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('fa954c29-be79-4ba2-af23-1ec93d20f7c1', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'paperback', 'SKU-39-PA', 13500, null, 68, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6c191380-5a8d-441f-a694-ea6a222e1fe0', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'hardcover', 'SKU-39-HA', 14600, null, 26, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d0498f7c-dbdf-48f2-aca9-1588b503eb36', '4e9f6445-8290-4b81-ae96-7b525313e2b4', 'ebook', 'SKU-39-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'code-spark-40', 'Code & Spark', null,
      'A compelling technology title exploring spark and life in Kigali.',
      'In this work, the author unfolds a narrative of spark, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000039', 383, 'English', '2021-04-13',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.10, 137
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('34a1e633-9e9a-4b38-a928-c98ddfa307ae', '5c989d3c-d88d-40a0-a4c5-15b1305c461a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('34a1e633-9e9a-4b38-a928-c98ddfa307ae', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f6474cac-081e-4531-aeb9-c24c73a1fd16', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6185610f-185a-4372-ab16-5b2dcf88465c', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2cce054e-e8df-4307-a48b-af7a10d76a94', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'paperback', 'SKU-40-PA', 14000, null, 69, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('08388b55-5d0d-401c-a05f-df11ba01ea52', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'hardcover', 'SKU-40-HA', 15300, null, 27, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f48b49fa-2de3-466f-a79c-254c15061d53', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', 'ebook', 'SKU-40-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '2bba7e19-6bab-40ed-af57-60340298e5fc', 'cloud-over-accra-41', 'Cloud over Accra', 'A Books & You edition',
      'A compelling technology title exploring baobab and life in Accra.',
      'In this work, the author unfolds a narrative of baobab, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000040', 400, 'English', '2022-05-14',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, true, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.20, 140
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('2bba7e19-6bab-40ed-af57-60340298e5fc', 'f029cf83-27f5-4adb-a298-2ca6c3df12fc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('2bba7e19-6bab-40ed-af57-60340298e5fc', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('244a87ad-9eec-40d0-ae82-728501fc8833', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('94af9b37-0f02-4227-ace9-2f31f1321571', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6244c176-3ae0-4e4c-a962-0ef42865d2ff', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'paperback', 'SKU-41-PA', 4500, null, 30, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f68556c7-aad4-4863-a030-1664a7cfc263', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'hardcover', 'SKU-41-HA', 16000, null, 8, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b99d0c09-6b9f-458f-a8e4-94ee8971cd89', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'ebook', 'SKU-41-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2e2c1445-125a-4a5f-aa9c-f88c9f7e94c9', '2bba7e19-6bab-40ed-af57-60340298e5fc', 'audiobook', 'SKU-41-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'market-for-children-42', 'Market for Children', null,
      'A compelling children''s title exploring market and life in Kumasi.',
      'In this work, the author unfolds a narrative of market, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000041', 417, 'English', '2023-06-15',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      4.30, 143
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c42e9b86-6852-4740-a8c1-8e20af8b2466', 'a4153962-9975-4fc7-a7a6-bdf658aae36e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c42e9b86-6852-4740-a8c1-8e20af8b2466', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0fbe5640-ccf2-485e-a573-01dfc42c8801', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4e91f9d0-0577-4b78-ac0a-73e6a39b8699', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('88da3ce7-bc45-4924-ace8-df7c24017424', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'paperback', 'SKU-42-PA', 5000, null, 31, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3bb3138a-7013-4e3e-a49d-954f608bf1e5', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'hardcover', 'SKU-42-HA', 16700, null, 9, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3353afd2-c1dd-461b-a41b-935a2fca8d4f', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'ebook', 'SKU-42-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'ananse-and-the-library-43', 'Ananse and the Library', null,
      'A compelling children''s title exploring library and life in Cape Coast.',
      'In this work, the author unfolds a narrative of library, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000042', 434, 'English', '2024-07-16',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s', 'Folklore'],
      4.40, 146
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', '612736cb-3175-4d74-a1c1-85fd911b579c', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e7818c55-44a9-4712-ac49-1119649df319', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('49613c79-af79-4ff5-a97c-74c82b91e7f3', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'folklore') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3c7907e9-d4a9-49d8-ab82-3c3240556e7f', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('32596f6e-b65a-4784-aa50-afa83f2a583b', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'paperback', 'SKU-43-PA', 5500, 7000, 32, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7c21d982-40d6-4931-a257-5aa2c956bf02', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'hardcover', 'SKU-43-HA', 17400, null, 10, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2ac8c7b9-8814-491b-a844-796b0326f7df', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'ebook', 'SKU-43-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'little-river-44', 'Little River', null,
      'A compelling children''s title exploring river and life in Tamale.',
      'In this work, the author unfolds a narrative of river, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000043', 451, 'English', '2025-08-17',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      4.50, 149
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', '226e7e1a-2410-4f6e-a522-0ef6a35b106e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('014dafaf-9e93-4292-a56d-3af6904ff14f', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('76f87472-5f9e-4a7f-a25a-ef8508f40386', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6af0b2ee-5542-4cdd-a47a-f076b31d105f', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'paperback', 'SKU-44-PA', 6000, null, 33, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('4fa2857b-fa71-49c6-a9e3-58f1b0f951ba', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'hardcover', 'SKU-44-HA', 18100, null, 11, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0d641965-7b72-4cd8-a758-9bddf84746ec', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'ebook', 'SKU-44-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a48fa39c-8eed-4889-a649-6d7f35c61780', 'studies-in-horizon-45', 'Studies in Horizon', 'A Books & You edition',
      'A compelling academic title exploring horizon and life in Tema.',
      'In this work, the author unfolds a narrative of horizon, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000044', 468, 'English', '2015-09-18',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Academic'],
      4.60, 152
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a48fa39c-8eed-4889-a649-6d7f35c61780', '0ccbd4aa-c785-4dca-a7be-93bec6632a30', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a48fa39c-8eed-4889-a649-6d7f35c61780', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d22184c8-edc4-4f63-a765-ed9e49ff31da', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'academic') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a48c2a3a-16b4-4415-aa28-68c3684075df', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f964b4d8-0fe6-4cda-a2ce-29889463f27e', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'paperback', 'SKU-45-PA', 6500, null, 34, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('054c2990-c3bc-4374-a5a9-d4a025be6f10', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'hardcover', 'SKU-45-HA', 18800, null, 12, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e7ddc06d-a498-44a2-adfd-04ff783ce955', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'ebook', 'SKU-45-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3d8a122f-6488-4761-a005-cca0803a94a5', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 'audiobook', 'SKU-45-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'empire-of-drum-46', 'Empire of Drum', null,
      'A compelling history title exploring drum and life in Lagos.',
      'In this work, the author unfolds a narrative of drum, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000045', 485, 'English', '2016-10-19',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, true, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History', 'Education'],
      4.70, 155
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c9108123-8f76-4837-afb7-9a3585ff9ea1', 'd686fe9e-024c-4a68-ac0c-1a4c73ccdd1e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c9108123-8f76-4837-afb7-9a3585ff9ea1', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('84c75c48-a399-488c-a3c2-2d52e8e121de', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('13c221ad-186d-4b8e-a992-be222722440e', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'education') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0cb8ed97-06a5-4a4d-a340-418f692e925c', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6e02793f-fb63-4abd-ab87-afdba0f5460c', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'paperback', 'SKU-46-PA', 7000, null, 35, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('847e13f4-0de6-4ab0-a4df-525a50960059', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'hardcover', 'SKU-46-HA', 9000, null, 13, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3e2de017-188f-493c-a871-33d8ebee6d8f', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 'ebook', 'SKU-46-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'reading-nairobi-47', 'Reading Nairobi', null,
      'A compelling history title exploring harbor and life in Nairobi.',
      'In this work, the author unfolds a narrative of harbor, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000046', 502, 'English', '2017-11-20',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      4.80, 158
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'd6e834cd-a49d-4cb5-a152-6bfcc5de5dcf', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('1be22e0d-2fdb-453d-a0c4-100b7d884e0c', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cd5142e8-0fd1-41ff-a744-7914c4f93331', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('dd226488-7812-4cf5-af8d-8e495174f556', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a0528196-1228-45e6-af2c-47eed970852e', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'paperback', 'SKU-47-PA', 7500, null, 36, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('87917914-7ce8-4b10-a64a-1bad89d58ba4', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'hardcover', 'SKU-47-HA', 9700, null, 14, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7734ee8a-ee06-4866-a648-9a78dd912c51', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'ebook', 'SKU-47-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'habits-of-archive-48', 'Habits of Archive', null,
      'A compelling self-help title exploring archive and life in Dakar.',
      'In this work, the author unfolds a narrative of archive, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000047', 519, 'English', '2018-12-21',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, true, '2026-09-15',
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help', 'Productivity'],
      4.90, 161
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c77f6d49-9dea-4934-ae78-e378d43e4c0b', '871d544a-0863-4619-aeae-b67b13430320', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c77f6d49-9dea-4934-ae78-e378d43e4c0b', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0b9b8921-24c8-43f5-a4e2-6ec73f74edd1', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4cf96c75-3114-41cb-a404-fd1caa3d6386', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'productivity') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b5600582-b75b-4f7c-a682-e408600361e9', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('422c77b8-6cbc-44d7-aad5-4dfcb613575a', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'paperback', 'SKU-48-PA', 8000, null, 0, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('681e3bf1-78ea-4339-a681-9c4866ba1c7d', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'hardcover', 'SKU-48-HA', 10400, null, 15, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0092388b-e573-4e0d-aa52-3586efe904ba', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', 'ebook', 'SKU-48-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '1c32d96f-082b-4013-a299-d3ea833e769e', 'the-garden-year-49', 'The Garden Year', 'A Books & You edition',
      'A compelling self-help title exploring garden and life in Cairo.',
      'In this work, the author unfolds a narrative of garden, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000048', 136, 'English', '2019-01-22',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help'],
      3.80, 164
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('1c32d96f-082b-4013-a299-d3ea833e769e', '503b988f-6a31-4f28-a240-a77fc2a43ddc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('1c32d96f-082b-4013-a299-d3ea833e769e', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('50d5650c-59d6-41f1-a0c2-0e6dcb5e968b', '1c32d96f-082b-4013-a299-d3ea833e769e', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('33f82ea9-9102-4f73-a7c0-b30800fccffb', '1c32d96f-082b-4013-a299-d3ea833e769e', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5cc33e76-6908-4475-adec-44e6958d0b9b', '1c32d96f-082b-4013-a299-d3ea833e769e', 'paperback', 'SKU-49-PA', 8500, 10000, 38, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2f47bf12-d3e6-46c0-a1fa-b166328ee513', '1c32d96f-082b-4013-a299-d3ea833e769e', 'hardcover', 'SKU-49-HA', 11100, null, 16, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('27463207-6986-460b-a9df-fb7ad33c8e8f', '1c32d96f-082b-4013-a299-d3ea833e769e', 'ebook', 'SKU-49-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('66eae9a8-7814-4357-a1ce-c6c35d4f48cb', '1c32d96f-082b-4013-a299-d3ea833e769e', 'audiobook', 'SKU-49-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '85937a49-1376-4924-ae60-1a0e7f020554', 'quiet-signal-50', 'Quiet Signal', null,
      'A compelling leadership title exploring signal and life in Kigali.',
      'In this work, the author unfolds a narrative of signal, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000049', 153, 'English', '2020-02-23',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership', 'Self-Help'],
      3.90, 167
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('85937a49-1376-4924-ae60-1a0e7f020554', '2babd4bb-e159-457f-a40a-581c5d7af499', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('85937a49-1376-4924-ae60-1a0e7f020554', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('452ab1b0-a7f1-4237-a1a3-a5d56ad303b0', '85937a49-1376-4924-ae60-1a0e7f020554', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('5ea2e97d-459e-414d-a1d0-5125e082bb39', '85937a49-1376-4924-ae60-1a0e7f020554', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('862e6342-4fc9-495f-a133-9b8e9fe6b81a', '85937a49-1376-4924-ae60-1a0e7f020554', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('06c63797-29fc-4499-a60e-ba38594e3daf', '85937a49-1376-4924-ae60-1a0e7f020554', 'paperback', 'SKU-50-PA', 9000, null, 39, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7dc27183-9c8c-4ee6-a726-415bf3f00e9f', '85937a49-1376-4924-ae60-1a0e7f020554', 'hardcover', 'SKU-50-HA', 11800, null, 17, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2e8b60d1-f31b-4927-a2dd-8d266f3c1c7b', '85937a49-1376-4924-ae60-1a0e7f020554', 'ebook', 'SKU-50-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a3e36098-7c42-4047-a00a-10232af694cc', 'life-of-ama-51', 'Life of Ama', null,
      'A compelling biography title exploring ledger and life in Accra.',
      'In this work, the author unfolds a narrative of ledger, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000050', 170, 'English', '2021-03-24',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography'],
      4.00, 170
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a3e36098-7c42-4047-a00a-10232af694cc', 'd573bf4a-8bd3-4975-a9a3-393340afacd3', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a3e36098-7c42-4047-a00a-10232af694cc', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('86fc53a1-7e3b-4237-a4be-1578afcc79c5', 'a3e36098-7c42-4047-a00a-10232af694cc', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0262cdd0-4a84-48fb-aaed-79773ac98aa0', 'a3e36098-7c42-4047-a00a-10232af694cc', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('4ec1bdcc-0997-4f6c-aa9d-3f8c4bf5dfd3', 'a3e36098-7c42-4047-a00a-10232af694cc', 'paperback', 'SKU-51-PA', 9500, null, 40, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3a884ab3-2363-4fe3-a03d-37c94bd89b55', 'a3e36098-7c42-4047-a00a-10232af694cc', 'hardcover', 'SKU-51-HA', 12500, null, 18, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7cf13f59-5ed5-4f06-aca5-057b7bbab7b5', 'a3e36098-7c42-4047-a00a-10232af694cc', 'ebook', 'SKU-51-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'voices-of-kumasi-52', 'Voices of Kumasi', null,
      'A compelling biography title exploring lantern and life in Kumasi.',
      'In this work, the author unfolds a narrative of lantern, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000051', 187, 'English', '2022-04-25',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography', 'History'],
      4.10, 173
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'b3eceb4c-ad0d-4199-a2fd-50dee6fac18b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('b511cc50-9ba5-405f-a438-0b45a9cc2cca', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('85ec81b3-7972-4754-abc5-6ad0b30a4908', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('8980ac8c-1ec6-4b37-ab7e-4749c24b936a', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('24b9ed99-a609-446c-a260-cbf03ff4ce39', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ff60676e-075e-4291-a62a-3ed946bc7d58', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'paperback', 'SKU-52-PA', 10000, null, 41, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('82b4c40c-e119-4915-aaaa-bcad519263ab', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'hardcover', 'SKU-52-HA', 13200, null, 19, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3e795f1c-aadc-4c56-a844-f8d4f2af64c0', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'ebook', 'SKU-52-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'poems-for-courier-53', 'Poems for Courier', 'A Books & You edition',
      'A compelling poetry title exploring courier and life in Cape Coast.',
      'In this work, the author unfolds a narrative of courier, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000052', 204, 'English', '2023-05-26',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.20, 176
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', '17c911e7-168d-40c5-a97c-f184cf65a6ce', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('15b2737d-8fe8-4d3b-a9c2-d85e9e07090e', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b47625cb-b849-4efb-a2a8-13b0cc24bc18', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('068babae-edf8-4151-a0f2-cfcaf0d217a5', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'paperback', 'SKU-53-PA', 10500, null, 42, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('43d45539-5d45-4362-a9dd-abaf7dfd212d', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'hardcover', 'SKU-53-HA', 13900, null, 20, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('823a7b24-f024-4129-ae35-892f4aa9a962', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'ebook', 'SKU-53-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('fe1b7498-b461-4796-ad8f-53b30e39afd6', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'audiobook', 'SKU-53-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'harmattan-threshold-54', 'Harmattan Threshold', null,
      'A compelling poetry title exploring threshold and life in Tamale.',
      'In this work, the author unfolds a narrative of threshold, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000053', 221, 'English', '2024-06-27',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.30, 179
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'bfccf5a0-d964-4008-a991-4593b44727f9', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('f5e82e44-5c1d-4cb0-a321-eddef265f0f8', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9e18d75e-8614-4e49-a4e1-13927e955ad9', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7afdd6fa-658a-409f-ad04-62fffceac57b', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('995054a8-efc4-402b-a29e-145b128cf236', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'paperback', 'SKU-54-PA', 11000, null, 43, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('669eeaf6-5bee-4944-a6e8-3a08f46c62ca', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'hardcover', 'SKU-54-HA', 14600, null, 21, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('abbdeea4-ce2f-4521-a465-f6cbb39d1552', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'ebook', 'SKU-54-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '266a33fd-1947-485c-ab4c-23ce8fadb714', 'a-history-of-tema-55', 'A History of Tema', null,
      'A compelling history title exploring compass and life in Tema.',
      'In this work, the author unfolds a narrative of compass, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000054', 238, 'English', '2025-07-01',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      4.40, 182
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('266a33fd-1947-485c-ab4c-23ce8fadb714', '46417788-10e5-4bb7-af0d-1bc435949515', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('266a33fd-1947-485c-ab4c-23ce8fadb714', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9e7e4cd7-be5c-414a-a7d6-9e7a9f9ec37f', '266a33fd-1947-485c-ab4c-23ce8fadb714', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6b857f5d-812c-4b6d-a15d-8edd5e885f41', '266a33fd-1947-485c-ab4c-23ce8fadb714', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a86646e0-8a90-4436-a3bd-d8fa0acca95e', '266a33fd-1947-485c-ab4c-23ce8fadb714', 'paperback', 'SKU-55-PA', 11500, 13000, 44, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ffa574db-a667-4711-a8fb-70f0c35e00e8', '266a33fd-1947-485c-ab4c-23ce8fadb714', 'hardcover', 'SKU-55-HA', 15300, null, 22, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f718521d-6ab4-4772-aca0-cd81e20f9e4d', '266a33fd-1947-485c-ab4c-23ce8fadb714', 'ebook', 'SKU-55-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'coastal-harvest-56', 'Coastal Harvest', null,
      'A compelling history title exploring harvest and life in Lagos.',
      'In this work, the author unfolds a narrative of harvest, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000055', 255, 'English', '2015-08-02',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, true, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      4.50, 185
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', '05863f3e-980d-44c8-af63-ab4fe4732859', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2e09c0f5-61df-46aa-ac04-e9c4783c93d5', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f252a886-2b55-4910-a807-c26991fac022', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c463435c-78ff-4b6e-a8e9-650e945c1813', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'paperback', 'SKU-56-PA', 12000, null, 45, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2358de56-50eb-427a-a809-528ac5c84d6d', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'hardcover', 'SKU-56-HA', 16000, null, 23, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('392cd382-64aa-4c47-a6c0-b93935d5fab1', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 'ebook', 'SKU-56-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '8edc0a44-e90c-4357-accd-6c38659056bf', 'maps-of-nairobi-57', 'Maps of Nairobi', 'A Books & You edition',
      'A compelling non-fiction title exploring canvas and life in Nairobi.',
      'In this work, the author unfolds a narrative of canvas, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000056', 272, 'English', '2016-09-03',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      true, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.60, 188
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('8edc0a44-e90c-4357-accd-6c38659056bf', 'efe952d2-5cbd-4e6d-a704-aa5f6e519cd0', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('8edc0a44-e90c-4357-accd-6c38659056bf', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b7aee09e-2d14-49fa-a5bb-eeb534e0c463', '8edc0a44-e90c-4357-accd-6c38659056bf', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c50ddc36-41a4-422d-a174-978feac9a1fc', '8edc0a44-e90c-4357-accd-6c38659056bf', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1e525514-5ba7-4c88-a359-1017a732e471', '8edc0a44-e90c-4357-accd-6c38659056bf', 'paperback', 'SKU-57-PA', 12500, null, 46, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('180dfdd2-c780-42f3-af91-da6ca328ad5f', '8edc0a44-e90c-4357-accd-6c38659056bf', 'hardcover', 'SKU-57-HA', 16700, null, 24, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('14337d4e-4f87-4e29-a72f-25d1dd2cf596', '8edc0a44-e90c-4357-accd-6c38659056bf', 'ebook', 'SKU-57-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e3f46d0e-537e-4471-a279-d62ff6b10878', '8edc0a44-e90c-4357-accd-6c38659056bf', 'audiobook', 'SKU-57-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'd025c006-ee01-473d-acd4-55c33055dbec', 'notes-on-echo-58', 'Notes on Echo', null,
      'A compelling non-fiction title exploring echo and life in Dakar.',
      'In this work, the author unfolds a narrative of echo, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000057', 289, 'English', '2017-10-04',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.70, 191
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('d025c006-ee01-473d-acd4-55c33055dbec', 'a36bf591-edb4-4338-ab33-5e09e030cf9b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('d025c006-ee01-473d-acd4-55c33055dbec', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d04fab23-fa60-416d-aae5-6824bb8bb9fa', 'd025c006-ee01-473d-acd4-55c33055dbec', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e775042b-b8f9-4c90-a07c-1777a0331087', 'd025c006-ee01-473d-acd4-55c33055dbec', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1b8386b8-3196-4542-aff3-ddcd4b96cd37', 'd025c006-ee01-473d-acd4-55c33055dbec', 'paperback', 'SKU-58-PA', 13000, null, 47, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2c72deb8-021e-4182-a2d6-84af07771fc7', 'd025c006-ee01-473d-acd4-55c33055dbec', 'hardcover', 'SKU-58-HA', 17400, null, 25, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f6f88875-4f03-4c8e-a5e5-4ed1f60a0ec5', 'd025c006-ee01-473d-acd4-55c33055dbec', 'ebook', 'SKU-58-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'field-guide-to-anchor-59', 'Field Guide to Anchor', null,
      'A compelling non-fiction title exploring anchor and life in Cairo.',
      'In this work, the author unfolds a narrative of anchor, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000058', 306, 'English', '2018-11-05',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.80, 194
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'bf7936bc-c806-433b-a9c6-6c6771e55343', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('74854fcb-eed0-4c9d-a8c6-dbc1f31a5133', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3fb8daba-97a7-4067-ada5-29ae0e590404', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6353a47c-cb8f-48c6-a148-c3df27850df0', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'paperback', 'SKU-59-PA', 13500, null, 48, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ef4d4c59-6f2d-44cb-a640-88ed7db09872', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'hardcover', 'SKU-59-HA', 18100, null, 26, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('14805a17-1bcf-428b-a3dc-37b24ca634b8', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', 'ebook', 'SKU-59-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'kigali-report-60', 'Kigali Report', null,
      'A compelling non-fiction title exploring spark and life in Kigali.',
      'In this work, the author unfolds a narrative of spark, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000059', 323, 'English', '2019-12-06',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.90, 197
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('7d71adfa-5504-4c6a-a0c0-bad391258c52', '91a19c52-3dcc-4cf3-a6a7-47fb31998590', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('7d71adfa-5504-4c6a-a0c0-bad391258c52', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('838eea7c-66c2-4982-a548-cab6e8f187e8', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('58cc115d-5261-4d5a-acd8-35144737fcac', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ce86d8d5-b7b4-4464-a2a0-fd76a83a5d2a', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'paperback', 'SKU-60-PA', 14000, null, 49, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('bc9f899d-0e83-4fb3-a753-c914944d770b', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'hardcover', 'SKU-60-HA', 18800, null, 27, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e0924fde-638a-4642-a73a-69bdd93ffc71', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'ebook', 'SKU-60-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'the-accra-chronicle-61', 'The Accra Chronicle', 'A Books & You edition',
      'A compelling literary fiction title exploring baobab and life in Accra.',
      'In this work, the author unfolds a narrative of baobab, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000060', 340, 'English', '2020-01-07',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      3.80, 200
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('d35e5612-ac00-48c7-a3fe-c749b5909f54', 'b42a4e93-3580-4ea9-acb5-fd910f607b18', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('d35e5612-ac00-48c7-a3fe-c749b5909f54', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7385eeb5-4a95-4ed0-ab9a-87c92d2c36fe', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('ce798049-9a70-4516-aff7-08c9f2809b62', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c7fbfeaa-48ea-4646-a721-59430545e2ca', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'paperback', 'SKU-61-PA', 4500, 6000, 50, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('84307702-5beb-45b5-a169-d396852fe409', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'hardcover', 'SKU-61-HA', 9000, null, 8, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a6d06a93-4cc0-4722-a230-e4c402647d8f', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'ebook', 'SKU-61-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d2a308fc-7ab5-4f83-aae6-986e4b63708c', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', 'audiobook', 'SKU-61-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '6e045790-e13b-4a14-ab28-099ccd4231a0', 'letters-from-kumasi-62', 'Letters from Kumasi', null,
      'A compelling literary fiction title exploring market and life in Kumasi.',
      'In this work, the author unfolds a narrative of market, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000061', 357, 'English', '2021-02-08',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      3.90, 203
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('6e045790-e13b-4a14-ab28-099ccd4231a0', '5f649099-b47c-4411-a491-614e1c286713', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('6e045790-e13b-4a14-ab28-099ccd4231a0', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c84259a6-56d5-4076-a97d-5b5792c191f5', '6e045790-e13b-4a14-ab28-099ccd4231a0', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2bc9feff-d926-4af5-a8d1-70106cd574b5', '6e045790-e13b-4a14-ab28-099ccd4231a0', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3435d61a-562f-4d36-ab02-ee778535c222', '6e045790-e13b-4a14-ab28-099ccd4231a0', 'paperback', 'SKU-62-PA', 5000, null, 51, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('86ac802f-bd74-478b-ac1f-e5be5710ab37', '6e045790-e13b-4a14-ab28-099ccd4231a0', 'hardcover', 'SKU-62-HA', 9700, null, 9, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f7725b07-7794-4f8a-a4a4-2f739753bc75', '6e045790-e13b-4a14-ab28-099ccd4231a0', 'ebook', 'SKU-62-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'library-at-dawn-63', 'Library at Dawn', null,
      'A compelling contemporary fiction title exploring library and life in Cape Coast.',
      'In this work, the author unfolds a narrative of library, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000062', 374, 'English', '2022-03-09',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Contemporary Fiction'],
      4.00, 206
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'd8d33f2c-03bd-4ae2-add6-5e235e0e1e3a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('529034b6-c1c8-421f-acae-978d2e58dbb6', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'contemporary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('1dbe19a1-b3dc-46f8-a739-fd55de40f428', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('cd686489-be9c-416a-aadc-9ca056ffd440', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'paperback', 'SKU-63-PA', 5500, null, 52, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('52d07ce0-247c-44ad-af88-0e128d2ce7ff', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'hardcover', 'SKU-63-HA', 10400, null, 10, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('08b08fa1-c734-45fd-a81c-1a73866531af', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', 'ebook', 'SKU-63-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '8143b929-7294-4a5d-a41e-1361733db907', 'midnight-river-64', 'Midnight River', null,
      'A compelling mystery title exploring river and life in Tamale.',
      'In this work, the author unfolds a narrative of river, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000063', 391, 'English', '2023-04-10',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      true, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Mystery'],
      4.10, 209
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('8143b929-7294-4a5d-a41e-1361733db907', '40d13eff-de83-430e-a370-96e5d9468417', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('8143b929-7294-4a5d-a41e-1361733db907', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('262c5143-435c-4274-ad82-d1500d0f0c73', '8143b929-7294-4a5d-a41e-1361733db907', 'mystery') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f799c3f5-ac6a-4391-ad5e-8a0b982128e0', '8143b929-7294-4a5d-a41e-1361733db907', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('759bd496-9a83-4792-aca4-7c2ced098c1d', '8143b929-7294-4a5d-a41e-1361733db907', 'paperback', 'SKU-64-PA', 6000, null, 53, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('502e2e85-8632-4f1e-a2a1-ec4402ec620b', '8143b929-7294-4a5d-a41e-1361733db907', 'hardcover', 'SKU-64-HA', 11100, null, 11, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5a46b93c-7424-4129-abc7-a13ccbc621f4', '8143b929-7294-4a5d-a41e-1361733db907', 'ebook', 'SKU-64-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '04c67383-98bf-4915-a8ef-d662a2b4c756', 'the-last-horizon-65', 'The Last Horizon', 'A Books & You edition',
      'A compelling historical fiction title exploring horizon and life in Tema.',
      'In this work, the author unfolds a narrative of horizon, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000064', 408, 'English', '2024-05-11',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Historical Fiction'],
      4.20, 212
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('04c67383-98bf-4915-a8ef-d662a2b4c756', '5c989d3c-d88d-40a0-a4c5-15b1305c461a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('04c67383-98bf-4915-a8ef-d662a2b4c756', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9b76017b-d8fb-4583-a811-79715929cf1e', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'historical-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b393ebf8-ef9f-4484-aac5-58110e354ec0', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0e71990b-0b9e-4c02-a622-bd9d370d8939', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'paperback', 'SKU-65-PA', 6500, null, 54, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('42363643-ccfc-4a50-a01b-3c4798904db0', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'hardcover', 'SKU-65-HA', 11800, null, 12, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('253aee5a-e66a-49cf-ab1e-0f170bf2adf1', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'ebook', 'SKU-65-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('641a77d0-f816-4405-af62-7c84828f699f', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'audiobook', 'SKU-65-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'building-drum-66', 'Building Drum', null,
      'A compelling entrepreneurship title exploring drum and life in Lagos.',
      'In this work, the author unfolds a narrative of drum, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000065', 425, 'English', '2025-06-12',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Entrepreneurship', 'Business'],
      4.30, 215
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'f029cf83-27f5-4adb-a298-2ca6c3df12fc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6b6b8321-3685-4c64-a591-5d227d918797', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'entrepreneurship') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('39f25c72-3960-41d9-a88f-9d456fdd12eb', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('61d9b1e9-907e-485e-a9a1-fc857c3e460b', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('efcc6250-edd8-4735-a4dc-93e50018b916', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'paperback', 'SKU-66-PA', 7000, null, 55, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1d83a239-9c0d-486c-a475-3cdc63dffc32', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'hardcover', 'SKU-66-HA', 12500, null, 13, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('519ec2be-51a7-40b4-a9b8-9bc48ca98cea', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'ebook', 'SKU-66-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'capital-of-harbor-67', 'Capital of Harbor', null,
      'A compelling finance title exploring harbor and life in Nairobi.',
      'In this work, the author unfolds a narrative of harbor, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000066', 442, 'English', '2015-07-13',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Finance', 'Business'],
      4.40, 218
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('d1b3506f-e36b-4b95-a01e-8c592ddd0680', 'a4153962-9975-4fc7-a7a6-bdf658aae36e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('d1b3506f-e36b-4b95-a01e-8c592ddd0680', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('5c0dd7dc-0411-4c8a-a503-946b0dc29f24', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'finance') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('50218d7f-25b6-47fc-a67a-fa461e956e09', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('dd311237-b11f-4919-aef9-2d68a9e9be8c', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7473c4de-dbba-4c20-a9a6-06d18b85864d', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'paperback', 'SKU-67-PA', 7500, 9000, 56, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('64f2c702-fc67-45a0-a50f-0c66a10f683f', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'hardcover', 'SKU-67-HA', 13200, null, 14, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0c912baf-b59e-4a10-a880-745e7fb024d7', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'ebook', 'SKU-67-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '7c5a23c9-5994-4958-a1d3-015e1e051726', 'lead-like-archive-68', 'Lead Like Archive', null,
      'A compelling leadership title exploring archive and life in Dakar.',
      'In this work, the author unfolds a narrative of archive, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000067', 459, 'English', '2016-08-14',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership'],
      4.50, 221
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('7c5a23c9-5994-4958-a1d3-015e1e051726', '612736cb-3175-4d74-a1c1-85fd911b579c', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('7c5a23c9-5994-4958-a1d3-015e1e051726', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c963a25c-6b63-4a5a-a18c-3e72de8d632b', '7c5a23c9-5994-4958-a1d3-015e1e051726', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c8e32a4e-9edc-445a-a1a1-491fa6495d16', '7c5a23c9-5994-4958-a1d3-015e1e051726', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8d40a5ce-34fb-457c-a183-8d580ad9174a', '7c5a23c9-5994-4958-a1d3-015e1e051726', 'paperback', 'SKU-68-PA', 8000, null, 57, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2233ca9b-f0d8-402d-a0f6-592f4c3d02bf', '7c5a23c9-5994-4958-a1d3-015e1e051726', 'hardcover', 'SKU-68-HA', 13900, null, 15, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('819596f5-d7fa-40de-ad9a-a5133a393264', '7c5a23c9-5994-4958-a1d3-015e1e051726', 'ebook', 'SKU-68-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'the-signal-of-garden-69', 'The Signal of Garden', 'A Books & You edition',
      'A compelling technology title exploring garden and life in Cairo.',
      'In this work, the author unfolds a narrative of garden, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000068', 476, 'English', '2017-09-15',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology', 'AI'],
      4.60, 224
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('4015b55f-0d4b-49c3-a48b-51826c1b3fbd', '226e7e1a-2410-4f6e-a522-0ef6a35b106e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('4015b55f-0d4b-49c3-a48b-51826c1b3fbd', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('786806bb-489d-42ee-a783-2d0567a2a07f', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('70f2531e-0d04-43fe-a040-c6df53ae09bf', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'ai') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('82fa1bd8-3c07-4635-acd5-35ed60179770', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('50c35015-7322-4aa9-a85d-b990c0876e98', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'paperback', 'SKU-69-PA', 8500, null, 58, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6b0eecc5-ffbd-4420-ac82-1fe4bc874de1', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'hardcover', 'SKU-69-HA', 14600, null, 16, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2902db67-d9e1-4f35-a223-24f7560217a6', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'ebook', 'SKU-69-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ed09aaf4-1c2a-491b-aaab-546d3bb82629', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', 'audiobook', 'SKU-69-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'code-signal-70', 'Code & Signal', null,
      'A compelling technology title exploring signal and life in Kigali.',
      'In this work, the author unfolds a narrative of signal, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000069', 493, 'English', '2018-10-16',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.70, 227
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', '0ccbd4aa-c785-4dca-a7be-93bec6632a30', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('3db596aa-27a1-473d-aae5-e33795a71e1a', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('70273ba9-8097-4668-ad00-99a2851fc180', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('cbfa7072-65ee-4e2b-a1e2-898f89e8e9f3', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'paperback', 'SKU-70-PA', 9000, null, 59, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ba18b293-c57c-4e89-a40f-c314147555f1', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'hardcover', 'SKU-70-HA', 15300, null, 17, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6283f319-b1a8-4e73-ae0e-4a2613b7adad', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'ebook', 'SKU-70-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '21abe17a-751e-4dca-a6b0-98cea9741a92', 'cloud-over-accra-71', 'Cloud over Accra', null,
      'A compelling technology title exploring ledger and life in Accra.',
      'In this work, the author unfolds a narrative of ledger, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000070', 510, 'English', '2019-11-17',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      true, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.80, 230
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('21abe17a-751e-4dca-a6b0-98cea9741a92', 'd686fe9e-024c-4a68-ac0c-1a4c73ccdd1e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('21abe17a-751e-4dca-a6b0-98cea9741a92', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d3a12515-7146-4f61-a4bc-7f4672497c1d', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2141a6cf-bab8-432b-a2fc-7ef35aee5f36', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('648ba950-afcc-44c0-a969-35d900403012', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'paperback', 'SKU-71-PA', 9500, null, 60, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d63a57bb-b343-4acd-ac5b-56ff9b461e62', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'hardcover', 'SKU-71-HA', 16000, null, 18, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c85274eb-cfd0-4847-a61a-775a123593e7', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'ebook', 'SKU-71-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '70476425-3c3d-4516-a36c-2cbacd634d3b', 'lantern-for-children-72', 'Lantern for Children', null,
      'A compelling children''s title exploring lantern and life in Kumasi.',
      'In this work, the author unfolds a narrative of lantern, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000071', 127, 'English', '2020-12-18',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      4.90, 233
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('70476425-3c3d-4516-a36c-2cbacd634d3b', 'd6e834cd-a49d-4cb5-a152-6bfcc5de5dcf', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('70476425-3c3d-4516-a36c-2cbacd634d3b', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d6f605c4-fc2e-40cd-a92c-aad8b08e9a7f', '70476425-3c3d-4516-a36c-2cbacd634d3b', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d6c84703-08a2-455b-ab3b-f8bd5a127f5a', '70476425-3c3d-4516-a36c-2cbacd634d3b', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ddc102b9-24af-41e5-ab2f-e9bf647ffcf4', '70476425-3c3d-4516-a36c-2cbacd634d3b', 'paperback', 'SKU-72-PA', 10000, null, 61, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e41a0fd9-0d5b-4865-a69b-7243d6d5e7a9', '70476425-3c3d-4516-a36c-2cbacd634d3b', 'hardcover', 'SKU-72-HA', 16700, null, 19, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('230671a6-814f-46c5-ace4-5343de9b89b8', '70476425-3c3d-4516-a36c-2cbacd634d3b', 'ebook', 'SKU-72-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a54a7d2b-1278-485f-a53b-11d99797f646', 'ananse-and-the-courier-73', 'Ananse and the Courier', 'A Books & You edition',
      'A compelling children''s title exploring courier and life in Cape Coast.',
      'In this work, the author unfolds a narrative of courier, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000072', 144, 'English', '2021-01-19',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, true, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s', 'Folklore'],
      3.80, 236
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a54a7d2b-1278-485f-a53b-11d99797f646', '871d544a-0863-4619-aeae-b67b13430320', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a54a7d2b-1278-485f-a53b-11d99797f646', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('24a69f27-3350-4b8c-a28e-cb6e2dbc7bf8', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4ca4c7da-26c2-428d-aa6d-68c33b63e5dd', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'folklore') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('bccbd48f-fe54-49c2-a667-08194ce9a7f9', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7ed334fe-85af-40a6-af17-5124229b42c8', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'paperback', 'SKU-73-PA', 10500, 12000, 62, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0ea51495-f54a-4f2f-aefb-406f5c39c736', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'hardcover', 'SKU-73-HA', 17400, null, 20, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('12fb9035-b8a7-45e7-ab51-c76ff3d544ad', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'ebook', 'SKU-73-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f5713e2f-9e01-4fbd-acab-30aece1c6ea2', 'a54a7d2b-1278-485f-a53b-11d99797f646', 'audiobook', 'SKU-73-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'little-threshold-74', 'Little Threshold', null,
      'A compelling children''s title exploring threshold and life in Tamale.',
      'In this work, the author unfolds a narrative of threshold, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000073', 161, 'English', '2022-02-20',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Children''s'],
      3.90, 239
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('1396992a-9030-4c7d-a865-2ac1e4c6c240', '503b988f-6a31-4f28-a240-a77fc2a43ddc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('1396992a-9030-4c7d-a865-2ac1e4c6c240', '263fbd32-995f-45f3-a391-9165f4dcae10') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('778cf3c6-08df-48db-a9f6-44eeb10e3294', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'children''s') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d2ad5d08-394a-46c4-aa8e-3ef77b051e9a', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ee1fe012-7ff4-48c0-ad36-03bd92b35ac1', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'paperback', 'SKU-74-PA', 11000, null, 63, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d1b45bd4-f711-4f8e-a1fa-4177505cba3a', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'hardcover', 'SKU-74-HA', 18100, null, 21, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('741e333e-3a6b-41a2-a0da-3a0c70156ef2', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 'ebook', 'SKU-74-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'studies-in-compass-75', 'Studies in Compass', null,
      'A compelling academic title exploring compass and life in Tema.',
      'In this work, the author unfolds a narrative of compass, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000074', 178, 'English', '2023-03-21',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Academic'],
      4.00, 242
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a0a683b9-ff3e-405d-aa2e-06eb789d5f34', '2babd4bb-e159-457f-a40a-581c5d7af499', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a0a683b9-ff3e-405d-aa2e-06eb789d5f34', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2c4a94ba-3cbf-4232-a625-ab1b60b2c4f6', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'academic') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('17216ceb-8a79-4f69-a332-f836d961e39f', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8976aebd-80d8-4345-a4bb-784fa03a21e7', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'paperback', 'SKU-75-PA', 11500, null, 64, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('4e0ac91c-6284-47f3-a322-ebe25591fac6', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'hardcover', 'SKU-75-HA', 18800, null, 22, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('7badb8b0-8aeb-4415-abf2-6f27579e78ef', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'ebook', 'SKU-75-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '5cb35003-e928-4c2c-a380-33ab807a63ee', 'empire-of-harvest-76', 'Empire of Harvest', null,
      'A compelling history title exploring harvest and life in Lagos.',
      'In this work, the author unfolds a narrative of harvest, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000075', 195, 'English', '2024-04-22',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History', 'Education'],
      4.10, 245
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('5cb35003-e928-4c2c-a380-33ab807a63ee', 'd573bf4a-8bd3-4975-a9a3-393340afacd3', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('5cb35003-e928-4c2c-a380-33ab807a63ee', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7768fdc7-c5be-4455-adab-5a8a722fb7f9', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('87bd02e4-9a90-4855-a9ab-5e7c0f2d8db2', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'education') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9d526627-00c2-4a4c-ad05-20c80c46e173', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('035384bf-d2d7-4cf5-aa30-b68aef1cc1a0', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'paperback', 'SKU-76-PA', 12000, null, 65, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1afa3d5c-e279-4231-a892-24f29d560dde', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'hardcover', 'SKU-76-HA', 9000, null, 23, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2860d48c-7be9-492c-a380-f77d42dbcc70', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'ebook', 'SKU-76-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '153bb51e-2ede-4baa-ab58-52d75e65e145', 'reading-nairobi-77', 'Reading Nairobi', 'A Books & You edition',
      'A compelling history title exploring canvas and life in Nairobi.',
      'In this work, the author unfolds a narrative of canvas, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000076', 212, 'English', '2025-05-23',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      4.20, 248
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('153bb51e-2ede-4baa-ab58-52d75e65e145', 'b3eceb4c-ad0d-4199-a2fd-50dee6fac18b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('153bb51e-2ede-4baa-ab58-52d75e65e145', '9198798f-e943-4c0c-add5-ac61293b5b00') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('278aeb7e-bebf-498a-a760-b3b1fc0b4d74', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d2a15162-adee-4480-a3e4-7e8f29cd8fa1', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5c73c076-dd99-4e3b-a8cc-0544ca6554d2', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'paperback', 'SKU-77-PA', 12500, null, 66, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('643ecf65-ebdf-4278-a1be-3a6ffdc84823', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'hardcover', 'SKU-77-HA', 9700, null, 24, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('cf80225a-f5dc-415f-af16-8223ac565005', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'ebook', 'SKU-77-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f1af55e1-3f32-4418-a031-76787bb90b18', '153bb51e-2ede-4baa-ab58-52d75e65e145', 'audiobook', 'SKU-77-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a51d78b2-d23c-46d7-a586-b1e92054c736', 'habits-of-echo-78', 'Habits of Echo', null,
      'A compelling self-help title exploring echo and life in Dakar.',
      'In this work, the author unfolds a narrative of echo, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000077', 229, 'English', '2015-06-24',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      true, false, false, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help', 'Productivity'],
      4.30, 251
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a51d78b2-d23c-46d7-a586-b1e92054c736', '17c911e7-168d-40c5-a97c-f184cf65a6ce', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a51d78b2-d23c-46d7-a586-b1e92054c736', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('fd675a3d-a582-435d-a1a7-f371c019078c', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('dfc75f48-0f3a-46fe-af3b-1749c233a323', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'productivity') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('28196a15-200a-4604-a148-31f0578c881b', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2f293d7e-3968-4d2e-a80e-709f9dde2beb', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'paperback', 'SKU-78-PA', 13000, null, 67, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('263858bd-0f2b-4fb0-a4ce-9e34ea02710d', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'hardcover', 'SKU-78-HA', 10400, null, 25, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c85e39c1-4e19-4bd4-af74-6a0e0d37f439', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 'ebook', 'SKU-78-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'b9cea718-c651-4451-a786-8504aad88e1d', 'the-anchor-year-79', 'The Anchor Year', null,
      'A compelling self-help title exploring anchor and life in Cairo.',
      'In this work, the author unfolds a narrative of anchor, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000078', 246, 'English', '2016-07-25',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Self-Help'],
      4.40, 254
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('b9cea718-c651-4451-a786-8504aad88e1d', 'bfccf5a0-d964-4008-a991-4593b44727f9', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('b9cea718-c651-4451-a786-8504aad88e1d', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('710e7219-4b97-42e3-a5b5-beb493d9bc0d', 'b9cea718-c651-4451-a786-8504aad88e1d', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('105e333c-24c9-45cd-a450-34ebc121baea', 'b9cea718-c651-4451-a786-8504aad88e1d', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('84a96b4f-6a9a-4d2a-a383-f2566d318981', 'b9cea718-c651-4451-a786-8504aad88e1d', 'paperback', 'SKU-79-PA', 13500, 15000, 68, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('2dc5e20b-5c60-4d23-affe-1abc6dbf160e', 'b9cea718-c651-4451-a786-8504aad88e1d', 'hardcover', 'SKU-79-HA', 11100, null, 26, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('804a30e9-9462-4cb0-a97e-5df52021dac2', 'b9cea718-c651-4451-a786-8504aad88e1d', 'ebook', 'SKU-79-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'quiet-spark-80', 'Quiet Spark', null,
      'A compelling leadership title exploring spark and life in Kigali.',
      'In this work, the author unfolds a narrative of spark, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000079', 263, 'English', '2017-08-26',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership', 'Self-Help'],
      4.50, 257
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('efe27fc7-4554-407e-a61c-f6731ccd4c4e', '46417788-10e5-4bb7-af0d-1bc435949515', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('efe27fc7-4554-407e-a61c-f6731ccd4c4e', '477d75cc-492d-4eaf-a7e8-55199f98b349') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('08cc3ab3-fb52-460a-a071-06b1a5ebe3c1', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('64aa8cac-242b-4735-add0-40eb52851a9a', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'self-help') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cbe8f6db-7b0c-4d2c-a95c-bca4bb332205', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3b074e5e-79b5-41a1-aa31-a936f84e42b7', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'paperback', 'SKU-80-PA', 14000, null, 69, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('fa3fc370-d77a-4bc5-a5df-f73aa6a0dc8e', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'hardcover', 'SKU-80-HA', 11800, null, 27, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b942e11a-c9d7-4d2a-a30d-f9b2eca41525', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'ebook', 'SKU-80-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'life-of-ama-81', 'Life of Ama', 'A Books & You edition',
      'A compelling biography title exploring baobab and life in Accra.',
      'In this work, the author unfolds a narrative of baobab, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000080', 280, 'English', '2018-09-27',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, true, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography'],
      4.60, 260
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('074d7000-9e6b-49b2-ae1c-d19a7498363b', '05863f3e-980d-44c8-af63-ab4fe4732859', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('074d7000-9e6b-49b2-ae1c-d19a7498363b', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('431ed59d-82d7-49ca-a039-9107d8b12fdf', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('4f798a64-ebf4-40e9-a8ff-7b9b85544949', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('08fedd87-7e42-4783-af61-6d5135162292', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'paperback', 'SKU-81-PA', 4500, null, 30, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('022b7787-a58f-4800-a7d1-86bf7152ee21', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'hardcover', 'SKU-81-HA', 12500, null, 8, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('9d1a611a-4d07-49f9-a419-ab88bcf23077', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'ebook', 'SKU-81-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5de24249-89b8-4dbb-a352-6d9224964cd1', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 'audiobook', 'SKU-81-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'voices-of-kumasi-82', 'Voices of Kumasi', null,
      'A compelling biography title exploring market and life in Kumasi.',
      'In this work, the author unfolds a narrative of market, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000081', 297, 'English', '2019-10-01',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Biography', 'History'],
      4.70, 263
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('ce530cc5-2353-44b3-a776-3f6abcea38c7', 'efe952d2-5cbd-4e6d-a704-aa5f6e519cd0', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('ce530cc5-2353-44b3-a776-3f6abcea38c7', '875c2a1e-bb7c-4cea-a8da-06f0c3b16c96') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cca104c0-6917-4363-a2df-f4c9eff6af4a', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'biography') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('10cdce94-caa9-42e1-a98a-cb20d5318e2a', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('19950274-0ec3-49b6-ae8b-359676b58213', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('04554627-26ed-4bb8-a29a-26c8bd753149', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'paperback', 'SKU-82-PA', 5000, null, 31, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3ff798ec-54fb-40f0-a1da-1b63c805d18e', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'hardcover', 'SKU-82-HA', 13200, null, 9, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('14618cee-8454-4f9d-ab83-4b8b24a61c05', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 'ebook', 'SKU-82-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '92fab546-7add-4ae1-ab02-78439285083a', 'poems-for-library-83', 'Poems for Library', null,
      'A compelling poetry title exploring library and life in Cape Coast.',
      'In this work, the author unfolds a narrative of library, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000082', 314, 'English', '2020-11-02',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.80, 266
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('92fab546-7add-4ae1-ab02-78439285083a', 'a36bf591-edb4-4338-ab33-5e09e030cf9b', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('92fab546-7add-4ae1-ab02-78439285083a', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6cbc4afe-1bb3-4d40-adc5-33e39787168e', '92fab546-7add-4ae1-ab02-78439285083a', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('db6ff65c-3b93-4699-a121-6f9bdd916e4c', '92fab546-7add-4ae1-ab02-78439285083a', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f9e8252b-2cdb-4196-af07-709aab9c6c9e', '92fab546-7add-4ae1-ab02-78439285083a', 'paperback', 'SKU-83-PA', 5500, null, 32, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f98a28a6-85d9-4673-a2bf-4d967617224c', '92fab546-7add-4ae1-ab02-78439285083a', 'hardcover', 'SKU-83-HA', 13900, null, 10, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('51d45562-9735-4c74-a4d4-8cb1daccde67', '92fab546-7add-4ae1-ab02-78439285083a', 'ebook', 'SKU-83-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'harmattan-river-84', 'Harmattan River', null,
      'A compelling poetry title exploring river and life in Tamale.',
      'In this work, the author unfolds a narrative of river, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000083', 331, 'English', '2021-12-03',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Poetry'],
      4.90, 269
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'bf7936bc-c806-433b-a9c6-6c6771e55343', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', '0b6c9bf8-e863-43fd-a4a1-8c499eae859a') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('31b75bf7-0c05-4370-ad29-cf9a30bd3cbe', '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'poetry') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0c960cc6-af5c-4ecc-a70d-ff007398e347', '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ce18724a-fa05-4e10-af46-776990e304d5', '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'paperback', 'SKU-84-PA', 6000, null, 33, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('87e2141d-0b27-4094-a892-bada668aec89', '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'hardcover', 'SKU-84-HA', 14600, null, 11, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('583c7789-3e24-4e1e-a788-79731392c9fb', '9e6ef0eb-d732-4a4b-a19c-7e4d7855cc26', 'ebook', 'SKU-84-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'a-history-of-tema-85', 'A History of Tema', 'A Books & You edition',
      'A compelling history title exploring horizon and life in Tema.',
      'In this work, the author unfolds a narrative of horizon, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000084', 348, 'English', '2022-01-04',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      3.80, 272
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', '91a19c52-3dcc-4cf3-a6a7-47fb31998590', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0f4913f4-49d4-485d-af99-a45f2b5eb822', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('13fa2d67-af4e-4431-a6b4-c2979392c19a', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8848cc93-e3b8-4c44-a0e1-24fafea0e379', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'paperback', 'SKU-85-PA', 6500, 8000, 34, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a5d9594f-a722-4280-a4b2-db7887910c51', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'hardcover', 'SKU-85-HA', 15300, null, 12, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('389c0db9-47e4-496b-a7a6-8af8227c4b66', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'ebook', 'SKU-85-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('744f5fb6-783b-41a6-a099-b1f8f2496c6e', '21fcfc7c-a72a-49b4-a1e9-f7f51ced4e08', 'audiobook', 'SKU-85-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'coastal-drum-86', 'Coastal Drum', null,
      'A compelling history title exploring drum and life in Lagos.',
      'In this work, the author unfolds a narrative of drum, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000085', 365, 'English', '2023-02-05',
      '54d242a5-d81e-474f-a7f9-6ea8d4aead22', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['History'],
      3.90, 275
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'b42a4e93-3580-4ea9-acb5-fd910f607b18', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', '538daed6-ae09-4993-acc4-64ac35735ca0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('404a7b9f-af6c-4158-aaf8-2c2eee4733f8', 'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'history') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f248f8e0-bf62-4121-adc5-54d24b77802f', 'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('697ea7ec-4503-405c-ad0a-315daee09bf6', 'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'paperback', 'SKU-86-PA', 7000, null, 35, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8f615671-4f87-414e-ab19-f951681e7541', 'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'hardcover', 'SKU-86-HA', 16000, null, 13, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('3131898e-5475-4b3c-a765-9d4ec6c48bfd', 'fd6d55d8-b75b-4aba-ab86-e0bfa95c698d', 'ebook', 'SKU-86-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'maps-of-nairobi-87', 'Maps of Nairobi', null,
      'A compelling non-fiction title exploring harbor and life in Nairobi.',
      'In this work, the author unfolds a narrative of harbor, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000086', 382, 'English', '2024-03-06',
      'a73de719-f474-47b3-a869-87de7255a175', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.00, 278
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('a9d7b13d-9559-4f75-a986-aa9b082d5e57', '5f649099-b47c-4411-a491-614e1c286713', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e73a35bb-57cc-4acf-a524-510441a544d2', 'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('bd2f3661-972d-4198-a3b3-6e0fc00ddccf', 'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('982e0932-ea43-4a09-a450-bc634a9f6602', 'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'paperback', 'SKU-87-PA', 7500, null, 36, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('222ce77b-c620-47dd-a80b-21823a1ef9d2', 'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'hardcover', 'SKU-87-HA', 16700, null, 14, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('af83c22e-8e7e-48c8-af29-797c8312c826', 'a9d7b13d-9559-4f75-a986-aa9b082d5e57', 'ebook', 'SKU-87-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'notes-on-archive-88', 'Notes on Archive', null,
      'A compelling non-fiction title exploring archive and life in Dakar.',
      'In this work, the author unfolds a narrative of archive, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000087', 399, 'English', '2025-04-07',
      '251b66ad-4cc7-4af5-a62b-6f9f731e54c9', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.10, 281
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'd8d33f2c-03bd-4ae2-add6-5e235e0e1e3a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b9afa967-9193-4a60-af4d-5a31e5ebbc4b', '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('691c20dc-0e32-4d0b-a498-73185475a3e9', '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c3e67ee6-31aa-4928-afad-c6228b22900b', '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'paperback', 'SKU-88-PA', 8000, null, 37, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('6f9fd766-efa2-4677-a46e-bdb9a0988b7a', '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'hardcover', 'SKU-88-HA', 17400, null, 15, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d4ac6ac1-714b-44f4-aeda-4d24c0886d5b', '1c2366ce-65a3-4478-ae04-80bd7b5d69f3', 'ebook', 'SKU-88-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'field-guide-to-garden-89', 'Field Guide to Garden', 'A Books & You edition',
      'A compelling non-fiction title exploring garden and life in Cairo.',
      'In this work, the author unfolds a narrative of garden, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000088', 416, 'English', '2015-05-08',
      'c2b92780-f3ce-4f42-af6b-60aaac4559ec', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.20, 284
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('d7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', '40d13eff-de83-430e-a370-96e5d9468417', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('d7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('8fec7df2-c5c7-44ca-a67e-905a23614f88', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('443bc6d1-c199-4b4a-ab40-8aecc6c3ce44', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('5686b531-9a81-4fdc-abcc-d80630799bad', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'paperback', 'SKU-89-PA', 8500, null, 38, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('feabe359-5ef4-44d5-a9c7-cfee1b866b99', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'hardcover', 'SKU-89-HA', 18100, null, 16, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('86ccacef-a69d-439c-ab43-c261e0d8b0b9', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'ebook', 'SKU-89-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f252e60a-254e-4059-af13-274f3d5198cd', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 'audiobook', 'SKU-89-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '8267e3cb-0058-4511-a312-d6c439476a65', 'kigali-report-90', 'Kigali Report', null,
      'A compelling non-fiction title exploring signal and life in Kigali.',
      'In this work, the author unfolds a narrative of signal, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000089', 433, 'English', '2016-06-09',
      'e2af66e0-e1ba-4fcb-af24-a67afe617f4c', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Non-Fiction'],
      4.30, 287
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('8267e3cb-0058-4511-a312-d6c439476a65', '5c989d3c-d88d-40a0-a4c5-15b1305c461a', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('8267e3cb-0058-4511-a312-d6c439476a65', 'c59e4058-d6cb-4bf9-a912-dfca2c5d30ca') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('7dc6a66c-6eba-4d5c-a4da-27c09b193ad9', '8267e3cb-0058-4511-a312-d6c439476a65', 'non-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('93d51d50-4b84-48d2-ab41-4b304cccf7cc', '8267e3cb-0058-4511-a312-d6c439476a65', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d6432b57-ce32-4a32-a922-3bcaad72fc92', '8267e3cb-0058-4511-a312-d6c439476a65', 'paperback', 'SKU-90-PA', 9000, null, 39, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('87c2bd5f-01b8-4515-a386-ce04e7640d3c', '8267e3cb-0058-4511-a312-d6c439476a65', 'hardcover', 'SKU-90-HA', 18800, null, 17, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('1ba8c4bf-0331-4dc1-a882-c9b76e2a651d', '8267e3cb-0058-4511-a312-d6c439476a65', 'ebook', 'SKU-90-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'the-accra-chronicle-91', 'The Accra Chronicle', null,
      'A compelling literary fiction title exploring ledger and life in Accra.',
      'In this work, the author unfolds a narrative of ledger, memory, and belonging across Accra and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000090', 450, 'English', '2017-07-10',
      '4c4c291f-fde9-4fb0-a594-2088395b0d3e', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      false, true, true, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      4.40, 290
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('8ff09322-7fbd-48c9-a9a1-694f999154d0', 'f029cf83-27f5-4adb-a298-2ca6c3df12fc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('8ff09322-7fbd-48c9-a9a1-694f999154d0', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b39fc4a1-617e-410b-a091-9d602c88a088', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('26029d30-9152-46a6-a1de-ed37dd9cca7a', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'accra') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f2bf262f-d5b8-484e-af87-e293bb995dd4', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'paperback', 'SKU-91-PA', 9500, 11000, 40, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('899b72f8-52bf-4e94-ad5d-82bf7044bc94', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'hardcover', 'SKU-91-HA', 9000, null, 18, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8b2b1397-2197-4bd4-a836-2d95ecf9f192', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 'ebook', 'SKU-91-EB', 2500, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'letters-from-kumasi-92', 'Letters from Kumasi', null,
      'A compelling literary fiction title exploring lantern and life in Kumasi.',
      'In this work, the author unfolds a narrative of lantern, memory, and belonging across Kumasi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000091', 467, 'English', '2018-08-11',
      '998e188c-d29c-45b8-a74a-cf8390558c47', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Literary Fiction'],
      4.50, 293
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'a4153962-9975-4fc7-a7a6-bdf658aae36e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('54e073ca-e9d1-439c-a9b6-72d8caf63c75', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('c97cd727-904a-44fc-ab76-5760b5d94ce1', '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'literary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6611ce66-2f5d-4ecd-af52-94b547ba3df9', '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'kumasi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('cc4ec46b-f1e2-4b1c-a314-41f16667da0d', '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'paperback', 'SKU-92-PA', 10000, null, 41, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ee39fe4e-b225-46c8-a57d-3c503866f274', '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'hardcover', 'SKU-92-HA', 9700, null, 19, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('abeb1700-172b-4880-aa88-31ba62fccce7', '54e073ca-e9d1-439c-a9b6-72d8caf63c75', 'ebook', 'SKU-92-EB', 2800, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '5f975196-c886-4080-aab3-ba43ac2c10af', 'courier-at-dawn-93', 'Courier at Dawn', 'A Books & You edition',
      'A compelling contemporary fiction title exploring courier and life in Cape Coast.',
      'In this work, the author unfolds a narrative of courier, memory, and belonging across Cape Coast and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000092', 484, 'English', '2019-09-12',
      '07fd5cec-beb2-45d4-ab0f-ad2be65580d3', 'from-[#164E63] via-[#0E7490] to-[#14B8A6]', '#ECFEFF',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Contemporary Fiction'],
      4.60, 296
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('5f975196-c886-4080-aab3-ba43ac2c10af', '612736cb-3175-4d74-a1c1-85fd911b579c', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('5f975196-c886-4080-aab3-ba43ac2c10af', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('59e6609f-d45f-4990-ae30-4aaab6d45ceb', '5f975196-c886-4080-aab3-ba43ac2c10af', 'contemporary-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('a5831801-801c-4660-a6c4-560c9ee3c0a0', '5f975196-c886-4080-aab3-ba43ac2c10af', 'cape coast') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('28c6497f-25dc-4295-a86b-f43a4ccd946a', '5f975196-c886-4080-aab3-ba43ac2c10af', 'paperback', 'SKU-93-PA', 10500, null, 42, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('724dbf2c-8b9e-4287-a31c-a434f5e23d19', '5f975196-c886-4080-aab3-ba43ac2c10af', 'hardcover', 'SKU-93-HA', 10400, null, 20, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b3b49372-86e0-4d05-a5c9-db76f96dbe7b', '5f975196-c886-4080-aab3-ba43ac2c10af', 'ebook', 'SKU-93-EB', 3100, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('946596f6-a7ed-432e-ab85-71e2ab8ac37b', '5f975196-c886-4080-aab3-ba43ac2c10af', 'audiobook', 'SKU-93-AU', 6600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '457a1465-06f8-498b-accf-20595b9f4700', 'midnight-threshold-94', 'Midnight Threshold', null,
      'A compelling mystery title exploring threshold and life in Tamale.',
      'In this work, the author unfolds a narrative of threshold, memory, and belonging across Tamale and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000093', 501, 'English', '2020-10-13',
      '5f4f9543-7660-45d4-a99a-726bc98748f1', 'from-[#3F2E1E] via-[#78350F] to-[#A16207]', '#FEF9C3',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Mystery'],
      4.70, 299
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('457a1465-06f8-498b-accf-20595b9f4700', '226e7e1a-2410-4f6e-a522-0ef6a35b106e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('457a1465-06f8-498b-accf-20595b9f4700', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('f72bcdec-2e7d-43c0-a064-01b11c0b6815', '457a1465-06f8-498b-accf-20595b9f4700', 'mystery') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('8e7df326-196e-418d-a330-26480daf46e8', '457a1465-06f8-498b-accf-20595b9f4700', 'tamale') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('b214c15b-380d-423b-aac5-304f2c1d7048', '457a1465-06f8-498b-accf-20595b9f4700', 'paperback', 'SKU-94-PA', 11000, null, 43, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d970ea02-45d1-459c-a8f3-0e7803af6bbf', '457a1465-06f8-498b-accf-20595b9f4700', 'hardcover', 'SKU-94-HA', 11100, null, 21, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('51ee9d22-4525-4b6d-a06f-9bfc55d4abaa', '457a1465-06f8-498b-accf-20595b9f4700', 'ebook', 'SKU-94-EB', 3400, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'the-last-compass-95', 'The Last Compass', null,
      'A compelling historical fiction title exploring compass and life in Tema.',
      'In this work, the author unfolds a narrative of compass, memory, and belonging across Tema and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000094', 518, 'English', '2021-11-14',
      '02ae7c3c-b4b2-4478-a7e1-748be5a1428f', 'from-[#14532D] via-[#166534] to-[#0F766E]', '#BBF7D0',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Historical Fiction'],
      4.80, 302
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', '0ccbd4aa-c785-4dca-a7be-93bec6632a30', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', '0995a5fe-fd6c-4441-a50e-83d938bf97f9') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('069aa235-6bf1-42ad-a286-6baa65ef83d6', '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'historical-fiction') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('9e877bad-7d92-4c09-ab60-7cbbe1b7738d', '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'tema') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('922f423e-ebd5-4a19-a1a4-a4977f5fc12d', '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'paperback', 'SKU-95-PA', 11500, null, 44, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e8b3737b-1d37-4a52-a2ec-7eb9476fe9fb', '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'hardcover', 'SKU-95-HA', 11800, null, 22, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f88433d5-ff92-4999-a838-33df2acb7963', '9b5c08fb-5fa8-40bf-a679-a83a7a6fb020', 'ebook', 'SKU-95-EB', 3700, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'building-harvest-96', 'Building Harvest', null,
      'A compelling entrepreneurship title exploring harvest and life in Lagos.',
      'In this work, the author unfolds a narrative of harvest, memory, and belonging across Lagos and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000095', 135, 'English', '2022-12-15',
      '24cc4918-b75f-4e3b-a96f-4e696d0ff9f6', 'from-[#1C1917] via-[#44403C] to-[#0F766E]', '#D4A017',
      false, true, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Entrepreneurship', 'Business'],
      4.90, 305
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('b5f2ed13-b3e6-416e-a555-527e8cecb125', 'd686fe9e-024c-4a68-ac0c-1a4c73ccdd1e', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('b5f2ed13-b3e6-416e-a555-527e8cecb125', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('cc7537fc-1fe1-42bc-ac91-cafa59f6d4a3', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'entrepreneurship') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('366326da-222a-44a4-a556-2895de303075', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('34bdd998-209d-4830-a4b7-abbada781af0', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'lagos') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('49a44edd-dddf-4b98-a8b3-c976feadd9b7', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'paperback', 'SKU-96-PA', 12000, null, 45, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('d7e9bd03-6a2f-4bc8-a291-38ae7c23146d', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'hardcover', 'SKU-96-HA', 12500, null, 23, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('523aec5b-d837-457b-ae3a-f4bdb6d38ba3', 'b5f2ed13-b3e6-416e-a555-527e8cecb125', 'ebook', 'SKU-96-EB', 4000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '160a331d-d1f6-4213-ac24-f57f8df5a544', 'capital-of-canvas-97', 'Capital of Canvas', 'A Books & You edition',
      'A compelling finance title exploring canvas and life in Nairobi.',
      'In this work, the author unfolds a narrative of canvas, memory, and belonging across Nairobi and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000096', 152, 'English', '2023-01-16',
      '826b81ec-1c6a-4acd-a251-8aa287bfcdb2', 'from-[#0F766E] via-[#0D9488] to-[#134E4A]', '#D4A017',
      false, false, false, true, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Finance', 'Business'],
      3.80, 308
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('160a331d-d1f6-4213-ac24-f57f8df5a544', 'd6e834cd-a49d-4cb5-a152-6bfcc5de5dcf', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('160a331d-d1f6-4213-ac24-f57f8df5a544', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('23e2e827-2086-4be3-ad09-156b33e2ff2d', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'finance') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('d867d2fa-9842-4fec-ad19-2d61ee5e81c0', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'business') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('b632f91d-764a-4b81-a606-579f67d3c176', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'nairobi') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('40976344-648d-4a70-a18d-4449c9795fea', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'paperback', 'SKU-97-PA', 12500, 14000, 46, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('a25b4c4d-6e8e-49c4-a22e-fcb0513b46b0', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'hardcover', 'SKU-97-HA', 13200, null, 24, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('739471cc-8eaf-4109-a32b-af980b862d8a', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'ebook', 'SKU-97-EB', 4300, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8b1f4d0f-2c87-4b92-ac00-fb0c8235f390', '160a331d-d1f6-4213-ac24-f57f8df5a544', 'audiobook', 'SKU-97-AU', 5000, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'lead-like-echo-98', 'Lead Like Echo', null,
      'A compelling leadership title exploring echo and life in Dakar.',
      'In this work, the author unfolds a narrative of echo, memory, and belonging across Dakar and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000097', 169, 'English', '2024-02-17',
      '55e6a204-c370-46a1-a692-ff30de70289e', 'from-[#1E3A5F] via-[#0F766E] to-[#0B1220]', '#F5E6B8',
      false, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Leadership'],
      3.90, 311
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('c7d7f057-f104-48f6-aeb4-f16110c68dc1', '871d544a-0863-4619-aeae-b67b13430320', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'ef29be2a-5276-4102-ab1d-be3273dbe6a2') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('2d72ad6d-78bd-40e5-a772-679aec0e3678', 'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'leadership') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('6df429fe-affe-4ae2-ab6a-2a109269209f', 'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'dakar') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('81b4075b-62aa-44e6-a8e9-f3ac111408c8', 'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'paperback', 'SKU-98-PA', 13000, null, 47, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('0c807fea-15b4-4477-a01c-d03898d003f8', 'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'hardcover', 'SKU-98-HA', 13900, null, 25, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('c619cc68-e492-4e15-a7b8-5d8cb4ea0347', 'c7d7f057-f104-48f6-aeb4-f16110c68dc1', 'ebook', 'SKU-98-EB', 4600, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'the-signal-of-anchor-99', 'The Signal of Anchor', null,
      'A compelling technology title exploring anchor and life in Cairo.',
      'In this work, the author unfolds a narrative of anchor, memory, and belonging across Cairo and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000098', 186, 'English', '2025-03-18',
      'ed2d4b94-722c-4c72-a595-16c0d1a7be5c', 'from-[#7C2D12] via-[#B45309] to-[#D4A017]', '#FEF3C7',
      true, false, false, false, false, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology', 'AI'],
      4.00, 314
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', '503b988f-6a31-4f28-a240-a77fc2a43ddc', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('731804e9-89c9-4ac7-abc1-b20ec08ff9af', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('77e5eee0-63fc-4d09-a8df-e598a3ad97d6', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'ai') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('0c6da533-07a7-45b9-a215-7d55dc40e282', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'cairo') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('64332496-5d94-4f3f-a202-e7faa2e883cc', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'paperback', 'SKU-99-PA', 13500, null, 48, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('51d58639-a029-4f17-a27e-3aff4cd0ada4', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'hardcover', 'SKU-99-HA', 14600, null, 26, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('8195b6cd-583f-4ac0-a39e-5501fec5d705', '62e8ee25-6265-44bb-acad-1fc1a4c4ac5e', 'ebook', 'SKU-99-EB', 4900, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'code-spark-100', 'Code & Spark', null,
      'A compelling technology title exploring spark and life in Kigali.',
      'In this work, the author unfolds a narrative of spark, memory, and belonging across Kigali and beyond. Readers will find careful prose, vivid scenes, and lasting insight.',
      '9781000000099', 203, 'English', '2015-04-19',
      '5603d67e-fde0-4bd3-a3bc-47907b4fabc1', 'from-[#312E81] via-[#4338CA] to-[#0F766E]', '#C7D2FE',
      false, false, true, false, true, false, null,
      array['Part One', 'Part Two', 'Part Three', 'Epilogue'], array['Technology'],
      4.10, 317
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;
insert into public.book_authors (book_id, author_id, is_primary, sort_order) values ('3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', '2babd4bb-e159-457f-a40a-581c5d7af499', true, 0) on conflict do nothing;
insert into public.book_categories (book_id, category_id) values ('3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', '509363c1-d4ad-4848-a47f-6ff8b6e166a0') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('e39df9cd-02d3-409e-ac1b-8923c27167dc', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'technology') on conflict do nothing;
insert into public.book_tags (id, book_id, tag) values ('254e1a3d-413e-4ab9-a0a8-70a07da20604', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'kigali') on conflict do nothing;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('e72cda32-ff4a-48e1-ad86-863d435930dd', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'paperback', 'SKU-100-PA', 14000, null, 49, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('f6493ce1-ab1f-49fb-ac35-ccb641be3b6e', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'hardcover', 'SKU-100-HA', 15300, null, 27, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;
insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values ('ace77440-0aad-4b08-aee2-4ae7cfa00ffb', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 'ebook', 'SKU-100-EB', 5200, null, 999, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;

-- Collections
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'best-sellers', 'Best Sellers', 'What Ghana is reading right now.', true, 0) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '55314c69-b11e-4d26-acca-5d11a79f2bad', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', '2bba7e19-6bab-40ed-af57-60340298e5fc', 8) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 9) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'a3e36098-7c42-4047-a00a-10232af694cc', 10) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('de9fc1aa-56f1-48f4-a9ca-b241bbb68e71', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 11) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', 'new-arrivals', 'New Arrivals', 'Fresh pages, just shelved.', true, 1) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '52376bad-b03f-460d-a87a-ec929c67ca14', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '2f949a6f-c934-4e2a-a4ea-628503f4e243', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '266a33fd-1947-485c-ab4c-23ce8fadb714', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '8143b929-7294-4a5d-a41e-1361733db907', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', 'a54a7d2b-1278-485f-a53b-11d99797f646', 8) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', 'ce530cc5-2353-44b3-a776-3f6abcea38c7', 9) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '8ff09322-7fbd-48c9-a9a1-694f999154d0', 10) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('d9fadaa0-19ea-4a7f-a133-58cf5ec2974a', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 11) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'award-winners', 'Award Winners', 'Critically acclaimed and celebrated.', true, 2) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 8) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('1b8e411f-393d-4958-a67a-3c0a1a3c9795', '3dc8634d-a65b-46ad-a8a9-dc5b7e819ccb', 9) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', 'staff-picks', 'Staff Picks', 'Handpicked by our booksellers.', true, 3) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '5c4a3b12-c81a-4e42-a625-5b243203e01b', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', 'df14d48d-0d72-42cf-a005-401ba47b9872', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '91858170-c163-4389-ab1a-2a45132672e1', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '2bba7e19-6bab-40ed-af57-60340298e5fc', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '1c32d96f-082b-4013-a299-d3ea833e769e', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '8edc0a44-e90c-4357-accd-6c38659056bf', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '04c67383-98bf-4915-a8ef-d662a2b4c756', 8) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', 'a54a7d2b-1278-485f-a53b-11d99797f646', 9) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', '074d7000-9e6b-49b2-ae1c-d19a7498363b', 10) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('5ebf7d2b-500a-4f58-ad7a-bb06f5affe5c', 'd7d1aa08-64e2-47c8-ab9d-eff5cc6ef528', 11) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', 'trending-this-week', 'Trending This Week', 'Rising fast across the platform.', true, 4) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '333b17fd-c668-49ac-a5e7-af935c358019', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '2e1b1243-9b09-4866-afce-94aeb31d3e87', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '55314c69-b11e-4d26-acca-5d11a79f2bad', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '85937a49-1376-4924-ae60-1a0e7f020554', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '8edc0a44-e90c-4357-accd-6c38659056bf', 8) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '8143b929-7294-4a5d-a41e-1361733db907', 9) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', '21abe17a-751e-4dca-a6b0-98cea9741a92', 10) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('c7f974a0-26b9-4033-a750-bf03420547c6', 'a51d78b2-d23c-46d7-a586-b1e92054c736', 11) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'childrens-books', 'Children''s Books', 'Stories for curious young readers.', true, 5) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', '70476425-3c3d-4516-a36c-2cbacd634d3b', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', 'a54a7d2b-1278-485f-a53b-11d99797f646', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('38c13164-2e3a-4817-a021-4081ba49e3df', '1396992a-9030-4c7d-a865-2ac1e4c6c240', 8) on conflict do nothing;
insert into public.collections (id, slug, title, description, is_featured, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', 'academic-books', 'Academic Books', 'For classrooms, labs, and libraries.', true, 6) on conflict (slug) do update set title = excluded.title;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 0) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 1) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 2) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', 'a48fa39c-8eed-4889-a649-6d7f35c61780', 3) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', 4) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 5) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 6) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', '5cb35003-e928-4c2c-a380-33ab807a63ee', 7) on conflict do nothing;
insert into public.collection_books (collection_id, book_id, sort_order) values ('edb2299b-1947-4cbe-aeaf-c8fe3d2d35f8', '153bb51e-2ede-4baa-ab58-52d75e65e145', 8) on conflict do nothing;

-- Subscription plans
insert into public.plans (id, key, name, interval, price_cents, books_per_period, features, is_popular, sort_order)
     values ('df43e3da-a6a2-49ce-a0d1-e81e230f4df0', 'monthly', 'Monthly Reader', 'monthly', 14900, 1, array['1 curated physical book / month', 'Member pricing', 'Early access', 'Free Accra delivery'], false, 0)
     on conflict (key) do update set name = excluded.name, price_cents = excluded.price_cents, features = excluded.features;
insert into public.plans (id, key, name, interval, price_cents, books_per_period, features, is_popular, sort_order)
     values ('20809ec4-66d7-46d5-ae89-1b1f92ecef29', 'quarterly', 'Seasonal Stack', 'quarterly', 39900, 3, array['3 curated books / quarter', '1 bonus ebook', 'Priority support', 'Author events', 'Free nationwide delivery'], true, 1)
     on conflict (key) do update set name = excluded.name, price_cents = excluded.price_cents, features = excluded.features;
insert into public.plans (id, key, name, interval, price_cents, books_per_period, features, is_popular, sort_order)
     values ('3485c60b-d741-41b8-a2c3-d99ae19a6a8f', 'annual', 'Library Year', 'annual', 139900, 12, array['12 curated books / year', 'Unlimited ebook borrowing', 'Gift 2 friends', 'VIP preorders', 'Annual reading report'], false, 2)
     on conflict (key) do update set name = excluded.name, price_cents = excluded.price_cents, features = excluded.features;

-- Coupons & promotions
insert into public.coupons (id, code, description, discount_type, discount_value, min_order_cents, max_redemptions, is_active)
   values ('8878ada5-d9ef-482a-a5e1-b6a9bfc4187b', 'READMORE', 'GH₵30 off first orders', 'fixed', 3000, 5000, 1000, true)
   on conflict (code) do update set is_active = true;
insert into public.coupons (id, code, description, discount_type, discount_value, min_order_cents, is_active)
   values ('02d5b387-82e5-4cfe-a7fb-b5c347310c23', 'WELCOME10', '10% off', 'percent', 10, 0, true)
   on conflict (code) do update set is_active = true;
insert into public.promotions (id, title, description, is_active, starts_at, ends_at)
   values ('ef137d2d-8aa6-4961-a5e8-584e68a3dc59', 'July Reading Festival', 'Member extras and free delivery weekends', true, '2026-07-01', '2026-07-31')
   on conflict (id) do nothing;

-- Feature flags & site settings
insert into public.feature_flags (key, enabled, description) values ('ai_recommendations', true, 'Personalized recommendations') on conflict (key) do update set enabled = excluded.enabled;
insert into public.feature_flags (key, enabled, description) values ('preorders', true, 'Allow preorder checkout') on conflict (key) do update set enabled = excluded.enabled;
insert into public.feature_flags (key, enabled, description) values ('referrals', true, 'Referral rewards program') on conflict (key) do update set enabled = excluded.enabled;
insert into public.feature_flags (key, enabled, description) values ('subscriptions', true, 'Subscription box plans') on conflict (key) do update set enabled = excluded.enabled;
insert into public.feature_flags (key, enabled, description) values ('gift_cards', true, 'Gift card purchases') on conflict (key) do update set enabled = excluded.enabled;
insert into public.feature_flags (key, enabled, description) values ('live_inventory', true, 'Realtime stock updates') on conflict (key) do update set enabled = excluded.enabled;
insert into public.site_settings (key, value, description) values
    ('brand', '{"name":"Books & You","primary":"#0F766E","accent":"#D4A017"}'::jsonb, 'Brand tokens'),
    ('shipping', '{"free_delivery_threshold_cents":30000,"currency":"GHS","default_shipping_cents":2500}'::jsonb, 'Shipping rules'),
    ('payments', '{"providers":["moolre"]}'::jsonb, 'Enabled payment providers')
   on conflict (key) do update set value = excluded.value;
insert into public.notification_templates (id, key, channel, subject, body) values
    ('326abac7-674a-4ae2-ab65-89820a8a2ffd', 'order_confirmation', 'email', 'Your Books & You order {{order_number}}', 'Thanks for your order. Total: {{total}}.'),
    ('00ff517a-cfab-43b1-a0de-3a2243350224', 'order_shipped', 'email', 'Your order is on the way', 'Tracking: {{tracking_number}}'),
    ('079299f7-caf6-47f1-aad5-e487cf6135e7', 'welcome_sms', 'sms', null, 'Welcome to Books & You! Code {{referral_code}} earns credit.')
   on conflict (key) do update set body = excluded.body;

-- 50 customer accounts (auth.users + triggered profiles)
-- Password for all demo users: Password123!
create extension if not exists pgcrypto;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4',
  'authenticated',
  'authenticated',
  'reader01@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ama Mensah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4',
  '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4',
  jsonb_build_object('sub', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'email', 'reader01@booksandyou.test'),
  'email',
  '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'a860cd36-7618-4d62-a0fe-1dc621496580',
  'authenticated',
  'authenticated',
  'reader02@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kojo Owusu"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'a860cd36-7618-4d62-a0fe-1dc621496580',
  'a860cd36-7618-4d62-a0fe-1dc621496580',
  jsonb_build_object('sub', 'a860cd36-7618-4d62-a0fe-1dc621496580', 'email', 'reader02@booksandyou.test'),
  'email',
  'a860cd36-7618-4d62-a0fe-1dc621496580',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'e0483353-7c79-49ea-a32b-18b3e4aa4171',
  'authenticated',
  'authenticated',
  'reader03@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Efua Boateng"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'e0483353-7c79-49ea-a32b-18b3e4aa4171',
  'e0483353-7c79-49ea-a32b-18b3e4aa4171',
  jsonb_build_object('sub', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 'email', 'reader03@booksandyou.test'),
  'email',
  'e0483353-7c79-49ea-a32b-18b3e4aa4171',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'ce896854-6293-4f6b-a513-8f71c2d25089',
  'authenticated',
  'authenticated',
  'reader04@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Yaw Asante"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'ce896854-6293-4f6b-a513-8f71c2d25089',
  'ce896854-6293-4f6b-a513-8f71c2d25089',
  jsonb_build_object('sub', 'ce896854-6293-4f6b-a513-8f71c2d25089', 'email', 'reader04@booksandyou.test'),
  'email',
  'ce896854-6293-4f6b-a513-8f71c2d25089',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '24ab14b9-0027-4770-a16d-7d1c8bc27ddd',
  'authenticated',
  'authenticated',
  'reader05@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Adwoa Darko"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '24ab14b9-0027-4770-a16d-7d1c8bc27ddd',
  '24ab14b9-0027-4770-a16d-7d1c8bc27ddd',
  jsonb_build_object('sub', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 'email', 'reader05@booksandyou.test'),
  'email',
  '24ab14b9-0027-4770-a16d-7d1c8bc27ddd',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '756ce82b-29ae-4719-afd3-13988e7c2c75',
  'authenticated',
  'authenticated',
  'reader06@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kwesi Appiah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '756ce82b-29ae-4719-afd3-13988e7c2c75',
  '756ce82b-29ae-4719-afd3-13988e7c2c75',
  jsonb_build_object('sub', '756ce82b-29ae-4719-afd3-13988e7c2c75', 'email', 'reader06@booksandyou.test'),
  'email',
  '756ce82b-29ae-4719-afd3-13988e7c2c75',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '87b4f02d-6c3f-4998-a5c6-3a38a374032f',
  'authenticated',
  'authenticated',
  'reader07@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Abena Osei"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '87b4f02d-6c3f-4998-a5c6-3a38a374032f',
  '87b4f02d-6c3f-4998-a5c6-3a38a374032f',
  jsonb_build_object('sub', '87b4f02d-6c3f-4998-a5c6-3a38a374032f', 'email', 'reader07@booksandyou.test'),
  'email',
  '87b4f02d-6c3f-4998-a5c6-3a38a374032f',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '293e9607-12d5-4946-a2cd-900e9e219280',
  'authenticated',
  'authenticated',
  'reader08@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Nana Agyeman"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '293e9607-12d5-4946-a2cd-900e9e219280',
  '293e9607-12d5-4946-a2cd-900e9e219280',
  jsonb_build_object('sub', '293e9607-12d5-4946-a2cd-900e9e219280', 'email', 'reader08@booksandyou.test'),
  'email',
  '293e9607-12d5-4946-a2cd-900e9e219280',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '085ddeac-16a6-4fd4-a701-741e50966403',
  'authenticated',
  'authenticated',
  'reader09@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Akosua Addo"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '085ddeac-16a6-4fd4-a701-741e50966403',
  '085ddeac-16a6-4fd4-a701-741e50966403',
  jsonb_build_object('sub', '085ddeac-16a6-4fd4-a701-741e50966403', 'email', 'reader09@booksandyou.test'),
  'email',
  '085ddeac-16a6-4fd4-a701-741e50966403',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb',
  'authenticated',
  'authenticated',
  'reader10@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kofi Frimpong"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb',
  'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb',
  jsonb_build_object('sub', 'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb', 'email', 'reader10@booksandyou.test'),
  'email',
  'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226',
  'authenticated',
  'authenticated',
  'reader11@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Serena Quaye"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226',
  '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226',
  jsonb_build_object('sub', '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226', 'email', 'reader11@booksandyou.test'),
  'email',
  '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '94d53eba-1883-4b51-aca0-d855b5796288',
  'authenticated',
  'authenticated',
  'reader12@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Daniel Annor"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '94d53eba-1883-4b51-aca0-d855b5796288',
  '94d53eba-1883-4b51-aca0-d855b5796288',
  jsonb_build_object('sub', '94d53eba-1883-4b51-aca0-d855b5796288', 'email', 'reader12@booksandyou.test'),
  'email',
  '94d53eba-1883-4b51-aca0-d855b5796288',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '1c238405-8943-4e6e-a734-f76eab7d5108',
  'authenticated',
  'authenticated',
  'reader13@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Grace Sarpong"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '1c238405-8943-4e6e-a734-f76eab7d5108',
  '1c238405-8943-4e6e-a734-f76eab7d5108',
  jsonb_build_object('sub', '1c238405-8943-4e6e-a734-f76eab7d5108', 'email', 'reader13@booksandyou.test'),
  'email',
  '1c238405-8943-4e6e-a734-f76eab7d5108',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '89e3d276-7eb3-4fd8-a754-0a379124f867',
  'authenticated',
  'authenticated',
  'reader14@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Michael Tetteh"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '89e3d276-7eb3-4fd8-a754-0a379124f867',
  '89e3d276-7eb3-4fd8-a754-0a379124f867',
  jsonb_build_object('sub', '89e3d276-7eb3-4fd8-a754-0a379124f867', 'email', 'reader14@booksandyou.test'),
  'email',
  '89e3d276-7eb3-4fd8-a754-0a379124f867',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e',
  'authenticated',
  'authenticated',
  'reader15@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Linda Nyarko"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e',
  'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e',
  jsonb_build_object('sub', 'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e', 'email', 'reader15@booksandyou.test'),
  'email',
  'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'ba3d8eb1-190a-4500-a8dd-f27a195b3a06',
  'authenticated',
  'authenticated',
  'reader16@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Joseph Amoah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'ba3d8eb1-190a-4500-a8dd-f27a195b3a06',
  'ba3d8eb1-190a-4500-a8dd-f27a195b3a06',
  jsonb_build_object('sub', 'ba3d8eb1-190a-4500-a8dd-f27a195b3a06', 'email', 'reader16@booksandyou.test'),
  'email',
  'ba3d8eb1-190a-4500-a8dd-f27a195b3a06',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5',
  'authenticated',
  'authenticated',
  'reader17@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ruth Baah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5',
  'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5',
  jsonb_build_object('sub', 'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5', 'email', 'reader17@booksandyou.test'),
  'email',
  'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '8b76e379-0646-42e1-ae61-ba250d6923dc',
  'authenticated',
  'authenticated',
  'reader18@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Samuel Lamptey"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '8b76e379-0646-42e1-ae61-ba250d6923dc',
  '8b76e379-0646-42e1-ae61-ba250d6923dc',
  jsonb_build_object('sub', '8b76e379-0646-42e1-ae61-ba250d6923dc', 'email', 'reader18@booksandyou.test'),
  'email',
  '8b76e379-0646-42e1-ae61-ba250d6923dc',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '913a99eb-e175-4b98-af75-e48eb6db318e',
  'authenticated',
  'authenticated',
  'reader19@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Patricia Ofori"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '913a99eb-e175-4b98-af75-e48eb6db318e',
  '913a99eb-e175-4b98-af75-e48eb6db318e',
  jsonb_build_object('sub', '913a99eb-e175-4b98-af75-e48eb6db318e', 'email', 'reader19@booksandyou.test'),
  'email',
  '913a99eb-e175-4b98-af75-e48eb6db318e',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'd39afa4c-d54d-494b-ada3-b0216957e7ad',
  'authenticated',
  'authenticated',
  'reader20@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Emmanuel Adjei"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'd39afa4c-d54d-494b-ada3-b0216957e7ad',
  'd39afa4c-d54d-494b-ada3-b0216957e7ad',
  jsonb_build_object('sub', 'd39afa4c-d54d-494b-ada3-b0216957e7ad', 'email', 'reader20@booksandyou.test'),
  'email',
  'd39afa4c-d54d-494b-ada3-b0216957e7ad',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'fd3fe08f-762d-4706-a879-fbf079f41c99',
  'authenticated',
  'authenticated',
  'reader21@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ama Mensah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'fd3fe08f-762d-4706-a879-fbf079f41c99',
  'fd3fe08f-762d-4706-a879-fbf079f41c99',
  jsonb_build_object('sub', 'fd3fe08f-762d-4706-a879-fbf079f41c99', 'email', 'reader21@booksandyou.test'),
  'email',
  'fd3fe08f-762d-4706-a879-fbf079f41c99',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39',
  'authenticated',
  'authenticated',
  'reader22@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kojo Owusu"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39',
  '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39',
  jsonb_build_object('sub', '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39', 'email', 'reader22@booksandyou.test'),
  'email',
  '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '129970f7-760b-40b4-a8b4-9dd029313dab',
  'authenticated',
  'authenticated',
  'reader23@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Efua Boateng"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '129970f7-760b-40b4-a8b4-9dd029313dab',
  '129970f7-760b-40b4-a8b4-9dd029313dab',
  jsonb_build_object('sub', '129970f7-760b-40b4-a8b4-9dd029313dab', 'email', 'reader23@booksandyou.test'),
  'email',
  '129970f7-760b-40b4-a8b4-9dd029313dab',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '2ba81c1c-80cc-4c3e-a742-3a1edde82c67',
  'authenticated',
  'authenticated',
  'reader24@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Yaw Asante"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '2ba81c1c-80cc-4c3e-a742-3a1edde82c67',
  '2ba81c1c-80cc-4c3e-a742-3a1edde82c67',
  jsonb_build_object('sub', '2ba81c1c-80cc-4c3e-a742-3a1edde82c67', 'email', 'reader24@booksandyou.test'),
  'email',
  '2ba81c1c-80cc-4c3e-a742-3a1edde82c67',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b',
  'authenticated',
  'authenticated',
  'reader25@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Adwoa Darko"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b',
  'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b',
  jsonb_build_object('sub', 'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b', 'email', 'reader25@booksandyou.test'),
  'email',
  'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'd781899b-683c-4ba9-ac33-db48ed8c8c41',
  'authenticated',
  'authenticated',
  'reader26@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kwesi Appiah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'd781899b-683c-4ba9-ac33-db48ed8c8c41',
  'd781899b-683c-4ba9-ac33-db48ed8c8c41',
  jsonb_build_object('sub', 'd781899b-683c-4ba9-ac33-db48ed8c8c41', 'email', 'reader26@booksandyou.test'),
  'email',
  'd781899b-683c-4ba9-ac33-db48ed8c8c41',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '8dac8672-6580-4aa2-ae68-d474c67ae9e6',
  'authenticated',
  'authenticated',
  'reader27@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Abena Osei"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '8dac8672-6580-4aa2-ae68-d474c67ae9e6',
  '8dac8672-6580-4aa2-ae68-d474c67ae9e6',
  jsonb_build_object('sub', '8dac8672-6580-4aa2-ae68-d474c67ae9e6', 'email', 'reader27@booksandyou.test'),
  'email',
  '8dac8672-6580-4aa2-ae68-d474c67ae9e6',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '6a560736-b5ef-4900-adfa-b397f0224b94',
  'authenticated',
  'authenticated',
  'reader28@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Nana Agyeman"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '6a560736-b5ef-4900-adfa-b397f0224b94',
  '6a560736-b5ef-4900-adfa-b397f0224b94',
  jsonb_build_object('sub', '6a560736-b5ef-4900-adfa-b397f0224b94', 'email', 'reader28@booksandyou.test'),
  'email',
  '6a560736-b5ef-4900-adfa-b397f0224b94',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '564fa521-bd8c-4003-a92d-b6a7f8b39a4c',
  'authenticated',
  'authenticated',
  'reader29@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Akosua Addo"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '564fa521-bd8c-4003-a92d-b6a7f8b39a4c',
  '564fa521-bd8c-4003-a92d-b6a7f8b39a4c',
  jsonb_build_object('sub', '564fa521-bd8c-4003-a92d-b6a7f8b39a4c', 'email', 'reader29@booksandyou.test'),
  'email',
  '564fa521-bd8c-4003-a92d-b6a7f8b39a4c',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'ac2d320e-1cbd-4f1c-a354-4213cab35658',
  'authenticated',
  'authenticated',
  'reader30@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kofi Frimpong"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'ac2d320e-1cbd-4f1c-a354-4213cab35658',
  'ac2d320e-1cbd-4f1c-a354-4213cab35658',
  jsonb_build_object('sub', 'ac2d320e-1cbd-4f1c-a354-4213cab35658', 'email', 'reader30@booksandyou.test'),
  'email',
  'ac2d320e-1cbd-4f1c-a354-4213cab35658',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '1ae9245c-9d4c-4420-a4e9-d950c09c8d12',
  'authenticated',
  'authenticated',
  'reader31@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Serena Quaye"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '1ae9245c-9d4c-4420-a4e9-d950c09c8d12',
  '1ae9245c-9d4c-4420-a4e9-d950c09c8d12',
  jsonb_build_object('sub', '1ae9245c-9d4c-4420-a4e9-d950c09c8d12', 'email', 'reader31@booksandyou.test'),
  'email',
  '1ae9245c-9d4c-4420-a4e9-d950c09c8d12',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'c42c7824-79b9-4cce-afa3-51ed7b3ff168',
  'authenticated',
  'authenticated',
  'reader32@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Daniel Annor"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'c42c7824-79b9-4cce-afa3-51ed7b3ff168',
  'c42c7824-79b9-4cce-afa3-51ed7b3ff168',
  jsonb_build_object('sub', 'c42c7824-79b9-4cce-afa3-51ed7b3ff168', 'email', 'reader32@booksandyou.test'),
  'email',
  'c42c7824-79b9-4cce-afa3-51ed7b3ff168',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '25cc0e76-38d1-42e3-a27b-41e867d67ace',
  'authenticated',
  'authenticated',
  'reader33@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Grace Sarpong"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '25cc0e76-38d1-42e3-a27b-41e867d67ace',
  '25cc0e76-38d1-42e3-a27b-41e867d67ace',
  jsonb_build_object('sub', '25cc0e76-38d1-42e3-a27b-41e867d67ace', 'email', 'reader33@booksandyou.test'),
  'email',
  '25cc0e76-38d1-42e3-a27b-41e867d67ace',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '7a3ea308-246c-4322-af92-b37b65152794',
  'authenticated',
  'authenticated',
  'reader34@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Michael Tetteh"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '7a3ea308-246c-4322-af92-b37b65152794',
  '7a3ea308-246c-4322-af92-b37b65152794',
  jsonb_build_object('sub', '7a3ea308-246c-4322-af92-b37b65152794', 'email', 'reader34@booksandyou.test'),
  'email',
  '7a3ea308-246c-4322-af92-b37b65152794',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'f30a837c-d931-4b88-aece-216268a251c1',
  'authenticated',
  'authenticated',
  'reader35@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Linda Nyarko"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'f30a837c-d931-4b88-aece-216268a251c1',
  'f30a837c-d931-4b88-aece-216268a251c1',
  jsonb_build_object('sub', 'f30a837c-d931-4b88-aece-216268a251c1', 'email', 'reader35@booksandyou.test'),
  'email',
  'f30a837c-d931-4b88-aece-216268a251c1',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'bfc47afc-51a6-4343-a57f-d17de969a119',
  'authenticated',
  'authenticated',
  'reader36@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Joseph Amoah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'bfc47afc-51a6-4343-a57f-d17de969a119',
  'bfc47afc-51a6-4343-a57f-d17de969a119',
  jsonb_build_object('sub', 'bfc47afc-51a6-4343-a57f-d17de969a119', 'email', 'reader36@booksandyou.test'),
  'email',
  'bfc47afc-51a6-4343-a57f-d17de969a119',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '26a8e862-298d-4014-a30d-46336b9ee78a',
  'authenticated',
  'authenticated',
  'reader37@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ruth Baah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '26a8e862-298d-4014-a30d-46336b9ee78a',
  '26a8e862-298d-4014-a30d-46336b9ee78a',
  jsonb_build_object('sub', '26a8e862-298d-4014-a30d-46336b9ee78a', 'email', 'reader37@booksandyou.test'),
  'email',
  '26a8e862-298d-4014-a30d-46336b9ee78a',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'dd29609f-3eee-43f5-acf6-6c6c47f94dc9',
  'authenticated',
  'authenticated',
  'reader38@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Samuel Lamptey"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'dd29609f-3eee-43f5-acf6-6c6c47f94dc9',
  'dd29609f-3eee-43f5-acf6-6c6c47f94dc9',
  jsonb_build_object('sub', 'dd29609f-3eee-43f5-acf6-6c6c47f94dc9', 'email', 'reader38@booksandyou.test'),
  'email',
  'dd29609f-3eee-43f5-acf6-6c6c47f94dc9',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '813dc3f4-595e-4611-aaf8-0b89b2d7f833',
  'authenticated',
  'authenticated',
  'reader39@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Patricia Ofori"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '813dc3f4-595e-4611-aaf8-0b89b2d7f833',
  '813dc3f4-595e-4611-aaf8-0b89b2d7f833',
  jsonb_build_object('sub', '813dc3f4-595e-4611-aaf8-0b89b2d7f833', 'email', 'reader39@booksandyou.test'),
  'email',
  '813dc3f4-595e-4611-aaf8-0b89b2d7f833',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160',
  'authenticated',
  'authenticated',
  'reader40@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Emmanuel Adjei"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160',
  '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160',
  jsonb_build_object('sub', '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160', 'email', 'reader40@booksandyou.test'),
  'email',
  '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '193c69bc-4701-4ab5-a460-9193f5199fb2',
  'authenticated',
  'authenticated',
  'reader41@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ama Mensah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '193c69bc-4701-4ab5-a460-9193f5199fb2',
  '193c69bc-4701-4ab5-a460-9193f5199fb2',
  jsonb_build_object('sub', '193c69bc-4701-4ab5-a460-9193f5199fb2', 'email', 'reader41@booksandyou.test'),
  'email',
  '193c69bc-4701-4ab5-a460-9193f5199fb2',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca',
  'authenticated',
  'authenticated',
  'reader42@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kojo Owusu"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca',
  'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca',
  jsonb_build_object('sub', 'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca', 'email', 'reader42@booksandyou.test'),
  'email',
  'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'c9b663f8-f5a4-42af-a2ba-84aee799329a',
  'authenticated',
  'authenticated',
  'reader43@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Efua Boateng"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'c9b663f8-f5a4-42af-a2ba-84aee799329a',
  'c9b663f8-f5a4-42af-a2ba-84aee799329a',
  jsonb_build_object('sub', 'c9b663f8-f5a4-42af-a2ba-84aee799329a', 'email', 'reader43@booksandyou.test'),
  'email',
  'c9b663f8-f5a4-42af-a2ba-84aee799329a',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'ecbf80be-4b35-4916-ace9-f2ccab36f7bc',
  'authenticated',
  'authenticated',
  'reader44@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Yaw Asante"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'ecbf80be-4b35-4916-ace9-f2ccab36f7bc',
  'ecbf80be-4b35-4916-ace9-f2ccab36f7bc',
  jsonb_build_object('sub', 'ecbf80be-4b35-4916-ace9-f2ccab36f7bc', 'email', 'reader44@booksandyou.test'),
  'email',
  'ecbf80be-4b35-4916-ace9-f2ccab36f7bc',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530',
  'authenticated',
  'authenticated',
  'reader45@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Adwoa Darko"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530',
  '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530',
  jsonb_build_object('sub', '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530', 'email', 'reader45@booksandyou.test'),
  'email',
  '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '84a872da-29ae-4f7d-a0f3-aacfa283e08b',
  'authenticated',
  'authenticated',
  'reader46@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kwesi Appiah"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '84a872da-29ae-4f7d-a0f3-aacfa283e08b',
  '84a872da-29ae-4f7d-a0f3-aacfa283e08b',
  jsonb_build_object('sub', '84a872da-29ae-4f7d-a0f3-aacfa283e08b', 'email', 'reader46@booksandyou.test'),
  'email',
  '84a872da-29ae-4f7d-a0f3-aacfa283e08b',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf',
  'authenticated',
  'authenticated',
  'reader47@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Abena Osei"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf',
  'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf',
  jsonb_build_object('sub', 'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf', 'email', 'reader47@booksandyou.test'),
  'email',
  'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '90cb87d8-cbbf-4803-a878-34b5e3707ed3',
  'authenticated',
  'authenticated',
  'reader48@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Nana Agyeman"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  '90cb87d8-cbbf-4803-a878-34b5e3707ed3',
  '90cb87d8-cbbf-4803-a878-34b5e3707ed3',
  jsonb_build_object('sub', '90cb87d8-cbbf-4803-a878-34b5e3707ed3', 'email', 'reader48@booksandyou.test'),
  'email',
  '90cb87d8-cbbf-4803-a878-34b5e3707ed3',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'ece45172-2f6a-429b-a17c-97c5be009fa1',
  'authenticated',
  'authenticated',
  'reader49@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Akosua Addo"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'ece45172-2f6a-429b-a17c-97c5be009fa1',
  'ece45172-2f6a-429b-a17c-97c5be009fa1',
  jsonb_build_object('sub', 'ece45172-2f6a-429b-a17c-97c5be009fa1', 'email', 'reader49@booksandyou.test'),
  'email',
  'ece45172-2f6a-429b-a17c-97c5be009fa1',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'dbe7b7b0-531d-4898-a227-374efcc706d1',
  'authenticated',
  'authenticated',
  'reader50@booksandyou.test',
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Kofi Frimpong"}'::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  'dbe7b7b0-531d-4898-a227-374efcc706d1',
  'dbe7b7b0-531d-4898-a227-374efcc706d1',
  jsonb_build_object('sub', 'dbe7b7b0-531d-4898-a227-374efcc706d1', 'email', 'reader50@booksandyou.test'),
  'email',
  'dbe7b7b0-531d-4898-a227-374efcc706d1',
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '9d7570de-fe78-426a-a70d-46f5d9c073c2', 'authenticated', 'authenticated', 'superadmin@booksandyou.test',
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Super Admin"}'::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  '9d7570de-fe78-426a-a70d-46f5d9c073c2', '9d7570de-fe78-426a-a70d-46f5d9c073c2',
  jsonb_build_object('sub', '9d7570de-fe78-426a-a70d-46f5d9c073c2', 'email', 'superadmin@booksandyou.test'),
  'email', '9d7570de-fe78-426a-a70d-46f5d9c073c2', timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;
update public.profiles set role_id = '2ae17bac-b6f1-4a6e-a955-911e7808d370', full_name = 'Super Admin' where id = '9d7570de-fe78-426a-a70d-46f5d9c073c2';

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  '1b522f91-9514-4e48-a3d2-1120018b876c', 'authenticated', 'authenticated', 'inventory@booksandyou.test',
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Ivy Manager"}'::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  '1b522f91-9514-4e48-a3d2-1120018b876c', '1b522f91-9514-4e48-a3d2-1120018b876c',
  jsonb_build_object('sub', '1b522f91-9514-4e48-a3d2-1120018b876c', 'email', 'inventory@booksandyou.test'),
  'email', '1b522f91-9514-4e48-a3d2-1120018b876c', timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;
update public.profiles set role_id = 'd11354a9-0f9a-406a-a892-816918621bbd', full_name = 'Ivy Manager' where id = '1b522f91-9514-4e48-a3d2-1120018b876c';

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'a05b8e5a-52e0-436b-ae3b-15d729b2c3de', 'authenticated', 'authenticated', 'sales@booksandyou.test',
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Sam Sales"}'::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  'a05b8e5a-52e0-436b-ae3b-15d729b2c3de', 'a05b8e5a-52e0-436b-ae3b-15d729b2c3de',
  jsonb_build_object('sub', 'a05b8e5a-52e0-436b-ae3b-15d729b2c3de', 'email', 'sales@booksandyou.test'),
  'email', 'a05b8e5a-52e0-436b-ae3b-15d729b2c3de', timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;
update public.profiles set role_id = '948e5fdb-2414-44b1-a0e5-ce3315468459', full_name = 'Sam Sales' where id = 'a05b8e5a-52e0-436b-ae3b-15d729b2c3de';

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'a1c37afa-4681-44ea-a7f1-c92629994e67', 'authenticated', 'authenticated', 'support@booksandyou.test',
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Sue Support"}'::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  'a1c37afa-4681-44ea-a7f1-c92629994e67', 'a1c37afa-4681-44ea-a7f1-c92629994e67',
  jsonb_build_object('sub', 'a1c37afa-4681-44ea-a7f1-c92629994e67', 'email', 'support@booksandyou.test'),
  'email', 'a1c37afa-4681-44ea-a7f1-c92629994e67', timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;
update public.profiles set role_id = 'ae9eeb52-4371-4a2d-aca4-11d84a4c7b38', full_name = 'Sue Support' where id = 'a1c37afa-4681-44ea-a7f1-c92629994e67';

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  'a17a9a83-c644-49ad-a83b-f82609173966', 'authenticated', 'authenticated', 'finance@booksandyou.test',
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"full_name":"Fay Finance"}'::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;

insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  'a17a9a83-c644-49ad-a83b-f82609173966', 'a17a9a83-c644-49ad-a83b-f82609173966',
  jsonb_build_object('sub', 'a17a9a83-c644-49ad-a83b-f82609173966', 'email', 'finance@booksandyou.test'),
  'email', 'a17a9a83-c644-49ad-a83b-f82609173966', timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;
update public.profiles set role_id = '7d0b3a19-9aa0-4473-a63a-ce2eb494ae30', full_name = 'Fay Finance' where id = 'a17a9a83-c644-49ad-a83b-f82609173966';

-- Demo primary customer enrichment
update public.profiles set full_name = 'Ama Darko', referral_code = 'AMA-READS', reading_goal = 24, reading_streak = 12, favorite_genres = array['Literary Fiction', 'Business', 'Self-Help'] where id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4';
update public.wallets set balance_cents = 8500 where user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4';
-- Addresses
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('86d779b5-423c-4fd4-a16c-8b069427d777', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'Home', (select full_name from public.profiles where id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4'), '10 Liberation Rd', 'Accra', 'Greater Accra', 'GA-100-4567', 'Ghana', '+233241000100', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('640ca751-bf5b-4985-a97a-a476f8d6147f', 'a860cd36-7618-4d62-a0fe-1dc621496580', 'Home', (select full_name from public.profiles where id = 'a860cd36-7618-4d62-a0fe-1dc621496580'), '11 Liberation Rd', 'Accra', 'Greater Accra', 'GA-101-4567', 'Ghana', '+233241000101', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('1594300f-085b-4a6a-acb9-5d330e148a31', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 'Home', (select full_name from public.profiles where id = 'e0483353-7c79-49ea-a32b-18b3e4aa4171'), '12 Liberation Rd', 'Accra', 'Greater Accra', 'GA-102-4567', 'Ghana', '+233241000102', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('0c802086-ed81-4bcd-a851-08a4328b9f8f', 'ce896854-6293-4f6b-a513-8f71c2d25089', 'Home', (select full_name from public.profiles where id = 'ce896854-6293-4f6b-a513-8f71c2d25089'), '13 Liberation Rd', 'Accra', 'Greater Accra', 'GA-103-4567', 'Ghana', '+233241000103', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('ac52c5d4-96d8-48cf-a238-898eba3d4eb4', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 'Home', (select full_name from public.profiles where id = '24ab14b9-0027-4770-a16d-7d1c8bc27ddd'), '14 Liberation Rd', 'Accra', 'Greater Accra', 'GA-104-4567', 'Ghana', '+233241000104', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('5e3766f8-c48b-48a8-abaa-dec61b5e3952', '756ce82b-29ae-4719-afd3-13988e7c2c75', 'Home', (select full_name from public.profiles where id = '756ce82b-29ae-4719-afd3-13988e7c2c75'), '15 Liberation Rd', 'Accra', 'Greater Accra', 'GA-105-4567', 'Ghana', '+233241000105', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('5bfa8967-e93e-4f2f-acfa-325486ecdbfa', '87b4f02d-6c3f-4998-a5c6-3a38a374032f', 'Home', (select full_name from public.profiles where id = '87b4f02d-6c3f-4998-a5c6-3a38a374032f'), '16 Liberation Rd', 'Accra', 'Greater Accra', 'GA-106-4567', 'Ghana', '+233241000106', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('cd3e8c35-48c1-4009-ac18-ffb4452ddfcc', '293e9607-12d5-4946-a2cd-900e9e219280', 'Home', (select full_name from public.profiles where id = '293e9607-12d5-4946-a2cd-900e9e219280'), '17 Liberation Rd', 'Accra', 'Greater Accra', 'GA-107-4567', 'Ghana', '+233241000107', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('5237fb3e-25bb-41e7-a512-3759a4450470', '085ddeac-16a6-4fd4-a701-741e50966403', 'Home', (select full_name from public.profiles where id = '085ddeac-16a6-4fd4-a701-741e50966403'), '18 Liberation Rd', 'Accra', 'Greater Accra', 'GA-108-4567', 'Ghana', '+233241000108', true)
     on conflict (id) do nothing;
insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values ('4863dd83-c4fb-4d5a-a550-abac95c5514b', 'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb', 'Home', (select full_name from public.profiles where id = 'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb'), '19 Liberation Rd', 'Accra', 'Greater Accra', 'GA-109-4567', 'Ghana', '+233241000109', true)
     on conflict (id) do nothing;

-- Reviews
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('fb6fe29b-073d-4c90-a066-c46b96ad26cf', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('4cf416ae-62d5-4b12-a086-d70bb388dc31', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'a860cd36-7618-4d62-a0fe-1dc621496580', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('518e292f-c1ea-4fc2-a5f5-c6efed9d5077', '26a957f9-f793-4552-a8dc-072c7c310b0b', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7719b1d1-b715-4cae-a139-5106f29fdea4', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'ce896854-6293-4f6b-a513-8f71c2d25089', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('01e5b3d1-602a-43d6-addd-6002e7365c88', '63ba640e-3f35-402a-a71d-090dd09da19a', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('64c42a55-9ece-460c-a384-68d2901deea2', '804e4cde-8e97-48ff-a34c-423385a1ed6a', '756ce82b-29ae-4719-afd3-13988e7c2c75', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('4197433e-74f6-4bc8-a15d-07cf2ad9b1c7', 'c75949db-dcf0-4c30-aa62-20a893944def', '87b4f02d-6c3f-4998-a5c6-3a38a374032f', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('ea6e84c0-d914-4475-a1fc-632b558cb0e7', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', '293e9607-12d5-4946-a2cd-900e9e219280', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('141d1ca9-ee90-417f-ab45-68776f69464f', '5c4a3b12-c81a-4e42-a625-5b243203e01b', '085ddeac-16a6-4fd4-a701-741e50966403', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7748c087-fcb4-4ed3-a861-190b6b17ab21', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('fb8a09cc-f7b6-44e8-a459-4963dacca677', '7c3b85f9-fdf2-4b5f-ac3b-f190d3da67e5', '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('9023c7f4-7bf1-47a8-a622-a35817bf0682', 'a1ba7428-037e-4118-a9b6-ae5533c245fb', '94d53eba-1883-4b51-aca0-d855b5796288', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('ca9a7d78-89b8-4833-afe8-a1f0b99480a5', 'ce9828eb-e460-40d5-ae3d-764d345e9e5d', '1c238405-8943-4e6e-a734-f76eab7d5108', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('2a68a887-1047-493b-a132-982d27049d4a', 'f3b3c745-fb5d-4aae-ac0e-b5afddae1d0a', '89e3d276-7eb3-4fd8-a754-0a379124f867', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('8ec714de-8120-4aaf-a0e7-261eb94951b3', 'c22189cb-1ea5-4cf9-a73b-2e9dc84c95dd', 'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('240a98d5-6ba6-4217-a9ed-5e35b42d8f35', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'ba3d8eb1-190a-4500-a8dd-f27a195b3a06', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('61cf68f8-d6e6-494f-a162-9a3d2675d778', '7734f4c8-db29-4dcc-af8e-3f24ef8961ef', 'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('b7cad500-ff93-43b4-a2de-5f0ce785cd3d', '22352f97-96ef-4ccf-a5dd-e3e2d2332af3', '8b76e379-0646-42e1-ae61-ba250d6923dc', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('9fb6885b-cf54-4667-ab43-725c3933b66f', '52376bad-b03f-460d-a87a-ec929c67ca14', '913a99eb-e175-4b98-af75-e48eb6db318e', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7e1f5fd0-2d6e-4cdd-aa68-c56cca504e9f', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'd39afa4c-d54d-494b-ada3-b0216957e7ad', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('d66c498c-eedf-49aa-a8f1-44f87646ef92', 'f39e47e7-e01a-44e2-a290-c6526c8680bf', 'fd3fe08f-762d-4706-a879-fbf079f41c99', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('cb9413e3-bee3-477e-a9dc-bcdef9cd9cd0', '333b17fd-c668-49ac-a5e7-af935c358019', '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('08eceb28-4034-4074-ab43-0f2dea047d70', '14a26fbb-1cca-4022-a96d-4c0c368d70f3', '129970f7-760b-40b4-a8b4-9dd029313dab', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('320d59b9-862a-4562-adfe-ba6b5011eef0', '7782aeb9-521d-47ae-a3dd-1594d309735e', '2ba81c1c-80cc-4c3e-a742-3a1edde82c67', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7f487a8d-cc60-4eee-ab99-960eff6e398a', 'df14d48d-0d72-42cf-a005-401ba47b9872', 'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('fac6b2de-7b49-4a8e-ae1c-7dd92da0bb17', '10d3ac6d-bdf3-47bf-a4ac-6239c60e07ec', 'd781899b-683c-4ba9-ac33-db48ed8c8c41', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('faf8f111-f94f-40f5-a392-743a376517da', 'ccc9ac2e-62c8-4392-af8e-900f1884b2f3', '8dac8672-6580-4aa2-ae68-d474c67ae9e6', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('6595caf3-4f79-44a4-ab21-9c94d607c206', '2f949a6f-c934-4e2a-a4ea-628503f4e243', '6a560736-b5ef-4900-adfa-b397f0224b94', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('4f5a74b0-e980-4634-acd2-6e6f9436570c', '2e1b1243-9b09-4866-afce-94aeb31d3e87', '564fa521-bd8c-4003-a92d-b6a7f8b39a4c', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('a208ced1-f4f4-4e09-ad3e-252b4639da78', 'dc93defd-86d8-4759-aacb-3a8f94429a3f', 'ac2d320e-1cbd-4f1c-a354-4213cab35658', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('4e468240-46f2-47fc-a9f2-6836405d3df4', 'e0c0c286-55a4-4f2e-ab45-73741d8d3d54', '1ae9245c-9d4c-4420-a4e9-d950c09c8d12', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('863a6374-3c96-4f06-a396-d729b56414ee', '51766f6e-e80a-48d0-a916-905e413aa5d4', 'c42c7824-79b9-4cce-afa3-51ed7b3ff168', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('0007c23d-44cc-4d28-a760-1f18cfd90455', '91858170-c163-4389-ab1a-2a45132672e1', '25cc0e76-38d1-42e3-a27b-41e867d67ace', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('40ec57ad-ee9f-44d4-a906-c78f328476ca', 'c46b588f-e492-4ddb-aecc-feb7eaeb059f', '7a3ea308-246c-4322-af92-b37b65152794', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7bef23f3-9cac-4ab8-a54e-f576efbf3ad2', 'e42860da-0b14-4164-a222-7e98c20618af', 'f30a837c-d931-4b88-aece-216268a251c1', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('abb6941e-6449-40b1-a2cb-41ae6eb4484a', '55314c69-b11e-4d26-acca-5d11a79f2bad', 'bfc47afc-51a6-4343-a57f-d17de969a119', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('70e5d590-d8fe-48f3-aa96-3ea9ac415c55', '2d659bed-bb3d-40fb-aef2-4a2ad4c6afe3', '26a8e862-298d-4014-a30d-46336b9ee78a', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('1ed3776f-1c6b-4732-a32b-16be721eab68', '75fdc27b-c7be-474c-ab92-96b601a191a5', 'dd29609f-3eee-43f5-acf6-6c6c47f94dc9', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('0b1e583e-d65b-4edc-ab01-dbbd232738a8', '4e9f6445-8290-4b81-ae96-7b525313e2b4', '813dc3f4-595e-4611-aaf8-0b89b2d7f833', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7c7e3e7a-30ca-42f1-a578-2d3d679c0228', '34a1e633-9e9a-4b38-a928-c98ddfa307ae', '6c8529ab-6aa7-4ad1-a5af-b4cf98fd0160', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('df411dbd-afd8-40eb-ade3-d9a417e3ca9c', '2bba7e19-6bab-40ed-af57-60340298e5fc', '193c69bc-4701-4ab5-a460-9193f5199fb2', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('a8b490cc-ab06-4943-ae01-355f470dfafa', 'c42e9b86-6852-4740-a8c1-8e20af8b2466', 'e43a2ffe-ba7b-4ce4-aefa-aaa5b01538ca', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('f256babc-96ad-437e-a866-ed3564b7c303', 'e6d870ba-07a7-46e4-a3fb-da4e75fb6eb2', 'c9b663f8-f5a4-42af-a2ba-84aee799329a', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('581d291d-9d78-4af1-a9ac-9a8572c0289b', 'c1bf8a31-78a1-4268-aa3b-9a7ea96e1f50', 'ecbf80be-4b35-4916-ace9-f2ccab36f7bc', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('2034b106-eea9-4c1b-ad35-6605ed209e8f', 'a48fa39c-8eed-4889-a649-6d7f35c61780', '2b0b3e1b-9aff-4464-ad8e-c45bae5c0530', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('a766918c-a85a-460b-a7fa-e6cc593ab3b0', 'c9108123-8f76-4837-afb7-9a3585ff9ea1', '84a872da-29ae-4f7d-a0f3-aacfa283e08b', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('aa53feeb-3d08-4ab2-a2a0-cc9cc5d18c21', '1be22e0d-2fdb-453d-a0c4-100b7d884e0c', 'd7f10c29-5374-4d29-a8ca-0bbe7c72cbbf', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('2bd01579-5d64-4dec-ae48-14555997480c', 'c77f6d49-9dea-4934-ae78-e378d43e4c0b', '90cb87d8-cbbf-4803-a878-34b5e3707ed3', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('351c5da2-1010-46cc-aece-c91b6e14ad7d', '1c32d96f-082b-4013-a299-d3ea833e769e', 'ece45172-2f6a-429b-a17c-97c5be009fa1', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('fecd199f-9012-4cfd-a163-7c2979111f66', '85937a49-1376-4924-ae60-1a0e7f020554', 'dbe7b7b0-531d-4898-a227-374efcc706d1', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('5fb6eab9-77e6-4048-a440-745066deabf9', 'a3e36098-7c42-4047-a00a-10232af694cc', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('3449eeea-3db5-49f3-a378-16e388908971', 'b511cc50-9ba5-405f-a438-0b45a9cc2cca', 'a860cd36-7618-4d62-a0fe-1dc621496580', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('b3e01414-5961-4fc6-a9df-fe23a14dad16', 'ea62bbb3-aa94-4879-aeb0-b0a3c206cdad', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('b853dde6-a2c8-4039-aec7-ee25c2740b49', 'f5e82e44-5c1d-4cb0-a321-eddef265f0f8', 'ce896854-6293-4f6b-a513-8f71c2d25089', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('185226bd-aa31-4ec4-a959-e49fdb65fbb6', '266a33fd-1947-485c-ab4c-23ce8fadb714', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('ac3ce112-294f-445b-a469-a20746755a75', 'ccb7526c-b3be-46be-a37b-1fa9b3e4ff0b', '756ce82b-29ae-4719-afd3-13988e7c2c75', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('a9f7b20a-a0f6-4e38-a0d7-420b9190833d', '8edc0a44-e90c-4357-accd-6c38659056bf', '87b4f02d-6c3f-4998-a5c6-3a38a374032f', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('8f45fcdb-b50d-47a3-ab2f-a27e406c2224', 'd025c006-ee01-473d-acd4-55c33055dbec', '293e9607-12d5-4946-a2cd-900e9e219280', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('14ea88c9-abb5-47f7-a224-fff4d4ee4e88', '2c6a61c0-c908-4713-a0a8-834bbd6f14ff', '085ddeac-16a6-4fd4-a701-741e50966403', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('7b503a30-0d9e-45ba-a215-a5f123ac7b92', '7d71adfa-5504-4c6a-a0c0-bad391258c52', 'a29b8fe0-8a1c-47c6-ac34-633c188bd6bb', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('0e03118c-efd9-4624-a75a-43d41a2db533', 'd35e5612-ac00-48c7-a3fe-c749b5909f54', '273b6492-c5c5-4b1a-a6ce-7c1aac7f3226', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('c973068b-d051-4c73-ad8f-d76ded7892a1', '6e045790-e13b-4a14-ab28-099ccd4231a0', '94d53eba-1883-4b51-aca0-d855b5796288', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('64176e7b-0059-465c-afd9-a86e4995d7be', 'fc1b72d5-42f2-4052-ac70-8b0d6e0215ad', '1c238405-8943-4e6e-a734-f76eab7d5108', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('a57b4aad-ed92-4e65-ab96-b4f1ea58d6bc', '8143b929-7294-4a5d-a41e-1361733db907', '89e3d276-7eb3-4fd8-a754-0a379124f867', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('73873669-4ab9-4ee3-a835-151177b2a46d', '04c67383-98bf-4915-a8ef-d662a2b4c756', 'd9ac8cd8-2dec-4672-a2a5-d99aae63dd5e', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('fd67b24d-3b45-4741-a084-84e398f966a0', 'ddae6b19-f3b2-423a-a07c-81c6df1c064a', 'ba3d8eb1-190a-4500-a8dd-f27a195b3a06', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('35681adf-429b-4bff-a82d-1a19baa6a5d8', 'd1b3506f-e36b-4b95-a01e-8c592ddd0680', 'd1d679bd-ca2a-49b3-a8a9-56b587cc3ff5', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('df747107-80c9-472a-a159-c3586fb0400a', '7c5a23c9-5994-4958-a1d3-015e1e051726', '8b76e379-0646-42e1-ae61-ba250d6923dc', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('637f8283-2dea-4fa9-a436-3a4c913fe6ac', '4015b55f-0d4b-49c3-a48b-51826c1b3fbd', '913a99eb-e175-4b98-af75-e48eb6db318e', 5, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('d9e920f9-7c22-48d1-a01d-97ae670718af', 'dd5bc05e-67d4-48e3-ac9d-ad8e1a249ae5', 'd39afa4c-d54d-494b-ada3-b0216957e7ad', 3, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('59f29504-60a8-4b00-a815-41fe4a59dd2f', '21abe17a-751e-4dca-a6b0-98cea9741a92', 'fd3fe08f-762d-4706-a879-fbf079f41c99', 4, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('8c314249-4049-4087-a4d4-c484021b4a1d', '70476425-3c3d-4516-a36c-2cbacd634d3b', '54a4ed7e-7aff-4a52-ae47-0848f3c4ff39', 5, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('5f00e44d-f8a8-491f-a54b-bf4714749258', 'a54a7d2b-1278-485f-a53b-11d99797f646', '129970f7-760b-40b4-a8b4-9dd029313dab', 3, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('56e3f69a-a5cc-450f-a3d0-04845a96a02f', '1396992a-9030-4c7d-a865-2ac1e4c6c240', '2ba81c1c-80cc-4c3e-a742-3a1edde82c67', 4, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('e91575da-3349-4e82-af2d-bdf00b0a7a76', 'a0a683b9-ff3e-405d-aa2e-06eb789d5f34', 'b2289bf3-daba-45dc-a8b8-d7bc25dcde6b', 5, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('789b795f-d3c4-4d11-ab68-8e1e79d4e293', '5cb35003-e928-4c2c-a380-33ab807a63ee', 'd781899b-683c-4ba9-ac33-db48ed8c8c41', 3, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('09d5947c-f899-4894-aded-f1224a221192', '153bb51e-2ede-4baa-ab58-52d75e65e145', '8dac8672-6580-4aa2-ae68-d474c67ae9e6', 4, 'Loved it', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('70e787db-443e-4fa8-a921-5b905819ca0c', 'a51d78b2-d23c-46d7-a586-b1e92054c736', '6a560736-b5ef-4900-adfa-b397f0224b94', 5, 'Worth reading', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('1294d78f-51c0-4016-a009-ab848fd845d3', 'b9cea718-c651-4451-a786-8504aad88e1d', '564fa521-bd8c-4003-a92d-b6a7f8b39a4c', 3, 'Beautiful edition', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;
insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values ('6066b261-7ca2-4429-a163-7c7840f54efb', 'efe27fc7-4554-407e-a61c-f6731ccd4c4e', 'ac2d320e-1cbd-4f1c-a354-4213cab35658', 4, 'Insightful', 'A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.', true, true)
     on conflict (book_id, user_id) do nothing;

-- Wishlist / favorites / reading history for demo user
insert into public.wishlist_items (id, wishlist_id, book_id)
   select 'a286bc48-f5c4-4dc4-a116-c3c18cce6f44', w.id, '1851e7ae-8958-4db1-a9bc-6e0742c60ac7'
   from public.wishlists w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4' and w.is_default
   on conflict do nothing;
insert into public.wishlist_items (id, wishlist_id, book_id)
     select '32aff6f8-5d3f-44cb-ae41-fb8a470312d5', w.id, 'cd79e247-f43a-4682-a833-1a059a8d9793'
     from public.wishlists w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4' and w.is_default
     on conflict do nothing;
insert into public.wishlist_items (id, wishlist_id, book_id)
     select '868b59d0-9bbf-4a1d-a72a-7e4cc807943b', w.id, 'c75949db-dcf0-4c30-aa62-20a893944def'
     from public.wishlists w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4' and w.is_default
     on conflict do nothing;
insert into public.wishlist_items (id, wishlist_id, book_id)
     select 'ebdd2677-08f6-4559-af8a-19328c481dfc', w.id, 'cd425aac-19fc-4d6d-a57f-553f83a50c65'
     from public.wishlists w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4' and w.is_default
     on conflict do nothing;
insert into public.wishlist_items (id, wishlist_id, book_id)
     select '260b1e03-de13-4d38-adf2-33a8065b4e84', w.id, 'ce9828eb-e460-40d5-ae3d-764d345e9e5d'
     from public.wishlists w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4' and w.is_default
     on conflict do nothing;
insert into public.favorites (user_id, author_id) values ('56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'd573bf4a-8bd3-4975-a9a3-393340afacd3') on conflict do nothing;
insert into public.favorites (user_id, author_id) values ('56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'b3eceb4c-ad0d-4199-a2fd-50dee6fac18b') on conflict do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('bd126ff6-6699-4b15-a69c-cd6e0edceb24', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', timezone('utc', now()) - interval '0 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('a8376554-f993-473f-acfc-0741bf64aea2', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', timezone('utc', now()) - interval '1 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('e4828485-4bac-4be6-a9e4-d0f423f24d52', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '26a957f9-f793-4552-a8dc-072c7c310b0b', timezone('utc', now()) - interval '2 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('fae88744-7fee-4c0e-a33c-79e6bffa98c3', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'cd79e247-f43a-4682-a833-1a059a8d9793', timezone('utc', now()) - interval '3 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('ff9a72b7-cb31-44a4-aa76-bcd675905a1f', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '63ba640e-3f35-402a-a71d-090dd09da19a', timezone('utc', now()) - interval '4 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('b9570625-9cac-48b4-a377-c891ff104816', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '804e4cde-8e97-48ff-a34c-423385a1ed6a', timezone('utc', now()) - interval '5 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('6a206180-91e6-4af6-af13-67215bcd0eb0', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'c75949db-dcf0-4c30-aa62-20a893944def', timezone('utc', now()) - interval '6 days', 'web')
     on conflict (id) do nothing;
insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values ('85397df1-95a0-4652-a128-92ff46f992ee', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', timezone('utc', now()) - interval '7 days', 'web')
     on conflict (id) do nothing;

-- Sample orders
insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', 'BY-10400', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'shipped', 'GHS', 25500, 2500, 0, 28000,
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '0 days'
     ) on conflict (order_number) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('4e27c93f-6055-42ae-a489-b10608496604', 'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'The Accra Chronicle', 'paperback', 1, 7000, 7000)
       on conflict (id) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('3e9a642b-00fc-4a28-ac35-af34e6da5a5d', 'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'Lead Like Archive', 'paperback', 1, 7700, 7700)
       on conflict (id) do nothing;
insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values ('a1979ac0-6076-4641-ac21-f7882e00bcf0', 'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'paystack', 'PSK_BY-10400', 25500, 'GHS', 'succeeded')
     on conflict (id) do nothing;
insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values ('2676e2f3-ce84-445a-aa57-1dfea6fc2ed0', 'a1979ac0-6076-4641-ac21-f7882e00bcf0', 'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', 25500, 'GHS', 'succeeded', timezone('utc', now()) - interval '0 days')
     on conflict (id) do nothing;
insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values ('0f27479a-a5f3-404d-a509-85cc02c43fdf', 'c8bd6987-4287-4dec-a1cf-ca9f7020bd88', 'Books & You Logistics', 'GH-BY-880000', 'shipped', timezone('utc', now()) - interval '-1 days')
     on conflict (order_id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('551cbbba-297a-4df9-a3ba-7e40e1da721a', '0f27479a-a5f3-404d-a509-85cc02c43fdf', 'ordered', 'ordered update', timezone('utc', now()) - interval '0 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('dbf52cdd-2ca8-477c-ae3e-d34800ae4933', '0f27479a-a5f3-404d-a509-85cc02c43fdf', 'packed', 'packed update', timezone('utc', now()) - interval '-1 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('0a8e27b5-3a30-4974-a845-e3c70692f1f9', '0f27479a-a5f3-404d-a509-85cc02c43fdf', 'shipped', 'shipped update', timezone('utc', now()) - interval '-2 days')
         on conflict (id) do nothing;
insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       '4b1a45c1-b849-45fe-a86e-ff0b0484de5b', 'BY-10401', 'a860cd36-7618-4d62-a0fe-1dc621496580', 'delivered', 'GHS', 14500, 2500, 0, 17000,
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '5 days'
     ) on conflict (order_number) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('858fd964-ea5c-4f12-a74c-bb3fdccff8cc', '4b1a45c1-b849-45fe-a86e-ff0b0484de5b', '3429ce3c-66b9-47f7-a001-a0bdd46fd72e', 'Letters from Kumasi', 'paperback', 1, 7100, 7100)
       on conflict (id) do nothing;
insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values ('500ad5cf-9c25-48f2-a3a5-212a24fe796d', '4b1a45c1-b849-45fe-a86e-ff0b0484de5b', 'a860cd36-7618-4d62-a0fe-1dc621496580', 'paystack', 'PSK_BY-10401', 14500, 'GHS', 'succeeded')
     on conflict (id) do nothing;
insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values ('1c411af8-0d1e-44e0-a421-f8cbad244ff9', '500ad5cf-9c25-48f2-a3a5-212a24fe796d', '4b1a45c1-b849-45fe-a86e-ff0b0484de5b', 14500, 'GHS', 'succeeded', timezone('utc', now()) - interval '5 days')
     on conflict (id) do nothing;
insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values ('a374d4da-3abd-4d97-a4eb-d274f26dcf8b', '4b1a45c1-b849-45fe-a86e-ff0b0484de5b', 'Books & You Logistics', 'GH-BY-880001', 'delivered', timezone('utc', now()) - interval '4 days')
     on conflict (order_id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('f167ecdb-6d75-4be6-aeb6-8489a87aeada', 'a374d4da-3abd-4d97-a4eb-d274f26dcf8b', 'ordered', 'ordered update', timezone('utc', now()) - interval '5 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('06f3652f-50d4-49e2-ac38-ce43815fce4d', 'a374d4da-3abd-4d97-a4eb-d274f26dcf8b', 'packed', 'packed update', timezone('utc', now()) - interval '4 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('72b84461-2162-4a82-a386-4421397c1f36', 'a374d4da-3abd-4d97-a4eb-d274f26dcf8b', 'shipped', 'shipped update', timezone('utc', now()) - interval '3 days')
         on conflict (id) do nothing;
insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       '065f61cc-0170-4139-a734-a402f3c278eb', 'BY-10402', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 'completed', 'GHS', 7000, 2500, 0, 9500,
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '10 days'
     ) on conflict (order_number) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('ba34fc94-453d-491d-a8c0-ba7e8ff1cb91', '065f61cc-0170-4139-a734-a402f3c278eb', '804e4cde-8e97-48ff-a34c-423385a1ed6a', 'Building Drum', 'paperback', 1, 7500, 7500)
       on conflict (id) do nothing;
insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values ('60eb9025-2b68-4033-a109-7c64fabfee71', '065f61cc-0170-4139-a734-a402f3c278eb', 'e0483353-7c79-49ea-a32b-18b3e4aa4171', 'paystack', 'PSK_BY-10402', 7000, 'GHS', 'succeeded')
     on conflict (id) do nothing;
insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values ('f4695120-9fd1-43bf-a465-f42b6835717c', '60eb9025-2b68-4033-a109-7c64fabfee71', '065f61cc-0170-4139-a734-a402f3c278eb', 7000, 'GHS', 'succeeded', timezone('utc', now()) - interval '10 days')
     on conflict (id) do nothing;
insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values ('1e71a45f-735c-488a-a9fe-b9fe9fae4c99', '065f61cc-0170-4139-a734-a402f3c278eb', 'Books & You Logistics', 'GH-BY-880002', 'completed', timezone('utc', now()) - interval '9 days')
     on conflict (order_id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('cb5802fd-5544-4bbe-a62d-56b1fc936d2f', '1e71a45f-735c-488a-a9fe-b9fe9fae4c99', 'ordered', 'ordered update', timezone('utc', now()) - interval '10 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('f7c90f78-57f0-4c3a-a68c-f4bbebe8e4df', '1e71a45f-735c-488a-a9fe-b9fe9fae4c99', 'packed', 'packed update', timezone('utc', now()) - interval '9 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('77210334-69ec-4bcc-abd4-a7b5e57acdfc', '1e71a45f-735c-488a-a9fe-b9fe9fae4c99', 'shipped', 'shipped update', timezone('utc', now()) - interval '8 days')
         on conflict (id) do nothing;
insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       '22347e33-f708-48f9-a5d5-685bfe01b256', 'BY-10403', 'ce896854-6293-4f6b-a513-8f71c2d25089', 'ordered', 'GHS', 21000, 2500, 0, 23500,
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '15 days'
     ) on conflict (order_number) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('5c279f6b-d506-426e-a794-070e86a1a9cf', '22347e33-f708-48f9-a5d5-685bfe01b256', 'cd79e247-f43a-4682-a833-1a059a8d9793', 'Midnight River', 'paperback', 1, 7300, 7300)
       on conflict (id) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('fc7085f1-2f4e-40ed-a3a4-cb50bae6c266', '22347e33-f708-48f9-a5d5-685bfe01b256', '0ac21ac9-0f1f-44f0-a1bb-9675729770cf', 'Empire of Harvest', 'paperback', 1, 8500, 8500)
       on conflict (id) do nothing;
insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values ('c2933ca0-5d68-4dac-aaaf-121db0103c99', '22347e33-f708-48f9-a5d5-685bfe01b256', 'ce896854-6293-4f6b-a513-8f71c2d25089', 'paystack', 'PSK_BY-10403', 21000, 'GHS', 'succeeded')
     on conflict (id) do nothing;
insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values ('a613e764-1fa9-4334-a54f-085b0054829f', 'c2933ca0-5d68-4dac-aaaf-121db0103c99', '22347e33-f708-48f9-a5d5-685bfe01b256', 21000, 'GHS', 'succeeded', timezone('utc', now()) - interval '15 days')
     on conflict (id) do nothing;
insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values ('9fe53a06-7778-4cde-a930-902680db1cdb', '22347e33-f708-48f9-a5d5-685bfe01b256', 'Books & You Logistics', 'GH-BY-880003', 'ordered', timezone('utc', now()) - interval '14 days')
     on conflict (order_id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('919720af-5e10-40ec-ae21-4456b7fd81cb', '9fe53a06-7778-4cde-a930-902680db1cdb', 'ordered', 'ordered update', timezone('utc', now()) - interval '15 days')
         on conflict (id) do nothing;
insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       '8e916cdd-9a55-4aa6-ab70-0a39069c5504', 'BY-10404', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 'packed', 'GHS', 11000, 2500, 0, 13500,
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '20 days'
     ) on conflict (order_number) do nothing;
insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values ('0a1a61ed-62bf-41a1-a850-cf01d69caaf2', '8e916cdd-9a55-4aa6-ab70-0a39069c5504', 'bb8a6a03-bfc3-4948-ad26-a811f8f18c0a', 'Quiet Spark', 'paperback', 1, 8900, 8900)
       on conflict (id) do nothing;
insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values ('c8840f98-9c78-45e8-a50a-b4dc4fb903c4', '8e916cdd-9a55-4aa6-ab70-0a39069c5504', '24ab14b9-0027-4770-a16d-7d1c8bc27ddd', 'paystack', 'PSK_BY-10404', 11000, 'GHS', 'succeeded')
     on conflict (id) do nothing;
insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values ('327b7f2f-8fa9-422f-aceb-f066bcd636a3', 'c8840f98-9c78-45e8-a50a-b4dc4fb903c4', '8e916cdd-9a55-4aa6-ab70-0a39069c5504', 11000, 'GHS', 'succeeded', timezone('utc', now()) - interval '20 days')
     on conflict (id) do nothing;
insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values ('45e269d1-da72-4151-ae77-c28d5f4c0e83', '8e916cdd-9a55-4aa6-ab70-0a39069c5504', 'Books & You Logistics', 'GH-BY-880004', 'packed', timezone('utc', now()) - interval '19 days')
     on conflict (order_id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('b5633497-851e-4171-a857-9febde6a0c81', '45e269d1-da72-4151-ae77-c28d5f4c0e83', 'ordered', 'ordered update', timezone('utc', now()) - interval '20 days')
         on conflict (id) do nothing;
insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values ('87f30777-da23-4596-ae91-b3321402efd8', '45e269d1-da72-4151-ae77-c28d5f4c0e83', 'packed', 'packed update', timezone('utc', now()) - interval '19 days')
         on conflict (id) do nothing;

-- Digital library
insert into public.library_items (id, user_id, book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count)
     values ('eb609378-b726-4124-a24e-faa69da8f5dc', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '1851e7ae-8958-4db1-a9bc-6e0742c60ac7', 'ebook', 100, timezone('utc', now()) - interval '0 days', 1, 2)
     on conflict (user_id, book_id, format) do nothing;
insert into public.library_items (id, user_id, book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count)
     values ('995f3e6e-e9fe-4888-a007-1423cc76caab', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '63ba640e-3f35-402a-a71d-090dd09da19a', 'ebook', 62, timezone('utc', now()) - interval '1 days', 2, 5)
     on conflict (user_id, book_id, format) do nothing;
insert into public.library_items (id, user_id, book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count)
     values ('ccd4b072-87a2-405d-ae0e-fbfe66f1197a', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'cd425aac-19fc-4d6d-a57f-553f83a50c65', 'ebook', 91, timezone('utc', now()) - interval '2 days', 3, 8)
     on conflict (user_id, book_id, format) do nothing;
insert into public.library_items (id, user_id, book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count)
     values ('de596486-64ac-4040-a3fe-394e615c9aa5', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '6780c7ce-5909-43bb-a6ef-cf913dc7f853', 'ebook', 28, timezone('utc', now()) - interval '3 days', 4, 11)
     on conflict (user_id, book_id, format) do nothing;

-- Referrals, subscription, gift card
insert into public.referrals (id, referrer_id, referred_id, referral_code, status, qualified_at)
   values ('b428ae55-0d65-4968-a159-a7d16e04a532', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'a860cd36-7618-4d62-a0fe-1dc621496580', 'AMA-READS', 'rewarded', timezone('utc', now()) - interval '20 days')
   on conflict (referred_id) do nothing;
insert into public.wallet_transactions (id, wallet_id, type, amount_cents, balance_after_cents, description)
   select '9f31c2a3-c54a-4d59-a874-71080c66a038', w.id, 'referral_reward', 5000, 8500, 'Referral reward for reader02'
   from public.wallets w where w.user_id = '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4'
   on conflict (id) do nothing;
insert into public.referral_rewards (id, referral_id, amount_cents, status)
   values ('4e1e0f02-721a-4a39-afca-ac937cad00be', 'b428ae55-0d65-4968-a159-a7d16e04a532', 5000, 'paid')
   on conflict (id) do nothing;
insert into public.subscriptions (id, user_id, plan_id, status, current_period_start, current_period_end)
   values ('aab1e058-f2f4-4f01-aa10-d2b7fbd8e68c', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', '20809ec4-66d7-46d5-ae89-1b1f92ecef29', 'active', timezone('utc', now()) - interval '10 days', timezone('utc', now()) + interval '80 days')
   on conflict (id) do nothing;
insert into public.gift_cards (id, code, initial_balance_cents, balance_cents, purchased_by, is_active)
   values ('e9c96c95-e9d5-40ac-a9e9-1886914e42b2', 'GIFT-BY-2026', 20000, 20000, '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', true)
   on conflict (code) do nothing;

-- Support ticket
insert into public.tickets (id, ticket_number, user_id, subject, status, priority)
   values ('9fd6ea63-a005-41f5-a8ed-a252903dc4a5', 'TCK-DEMO0001', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'Question about delivery to East Legon', 'open', 'medium')
   on conflict (ticket_number) do nothing;
insert into public.ticket_messages (id, ticket_id, sender_id, body, is_staff)
   values ('3f2b4860-2aed-4ebd-ab41-5c7fdff7fa7d', '9fd6ea63-a005-41f5-a8ed-a252903dc4a5', '56b2a0e9-1e3f-4f19-a53f-29aa7fa85ff4', 'Hi, can I change my delivery window for BY-10400?', false)
   on conflict (id) do nothing;

commit;

-- Seed summary expectations:
-- categories: 10 | authors: 25 | publishers: 15 | books: 100
-- customers: 50 | staff: 5 | reviews: ~80 | plans: 3