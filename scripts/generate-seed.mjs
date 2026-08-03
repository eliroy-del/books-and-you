/**
 * Generates supabase/seed.sql with:
 * - RBAC roles/permissions
 * - 10 categories, 25 authors, 15 publishers, 100 books
 * - inventory, collections, reviews, plans, coupons
 * - 50 customer auth users + profiles sample commerce data
 *
 * Run: node scripts/generate-seed.mjs
 */

import { writeFileSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { createHash, randomUUID } from "node:crypto";

const __dirname = dirname(fileURLToPath(import.meta.url));
const outPath = resolve(__dirname, "../supabase/seed.sql");

function uuidFrom(seed) {
  const h = createHash("sha256").update(String(seed)).digest("hex");
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-4${h.slice(13, 16)}-a${h.slice(17, 20)}-${h.slice(20, 32)}`;
}

function esc(s) {
  return String(s).replace(/'/g, "''");
}

function sqlStr(s) {
  if (s == null) return "null";
  return `'${esc(s)}'`;
}

function sqlArr(arr) {
  if (!arr?.length) return "'{}'";
  return `array[${arr.map((x) => sqlStr(x)).join(", ")}]`;
}

const palettes = [
  { gradient: "from-[#0F766E] via-[#0D9488] to-[#134E4A]", accent: "#D4A017" },
  { gradient: "from-[#1E3A5F] via-[#0F766E] to-[#0B1220]", accent: "#F5E6B8" },
  { gradient: "from-[#7C2D12] via-[#B45309] to-[#D4A017]", accent: "#FEF3C7" },
  { gradient: "from-[#312E81] via-[#4338CA] to-[#0F766E]", accent: "#C7D2FE" },
  { gradient: "from-[#164E63] via-[#0E7490] to-[#14B8A6]", accent: "#ECFEFF" },
  { gradient: "from-[#3F2E1E] via-[#78350F] to-[#A16207]", accent: "#FEF9C3" },
  { gradient: "from-[#14532D] via-[#166534] to-[#0F766E]", accent: "#BBF7D0" },
  { gradient: "from-[#1C1917] via-[#44403C] to-[#0F766E]", accent: "#D4A017" },
];

const categories = [
  ["fiction", "Fiction", "Immersive stories that transport and transform.", "from-teal-700 to-emerald-500"],
  ["non-fiction", "Non-Fiction", "Ideas and narratives from the real world.", "from-slate-700 to-slate-500"],
  ["business", "Business", "Strategy, leadership, and entrepreneurship.", "from-amber-700 to-yellow-500"],
  ["technology", "Technology", "Computing, AI, and the digital frontier.", "from-cyan-700 to-teal-400"],
  ["childrens", "Children's", "Wonder-filled reads for young minds.", "from-rose-600 to-orange-400"],
  ["academic", "Academic", "Scholarly works for schools and research.", "from-indigo-700 to-blue-500"],
  ["self-help", "Self-Help", "Growth, habits, and personal mastery.", "from-emerald-700 to-lime-500"],
  ["biographies", "Biographies", "Lives that shaped history and culture.", "from-stone-700 to-stone-500"],
  ["poetry", "Poetry", "Verse from Ghana and the wider world.", "from-fuchsia-700 to-pink-500"],
  ["history", "History", "Past worlds, present insights.", "from-orange-800 to-amber-600"],
];

const publishers = [
  ["sub-saharan", "Sub-Saharan Publishers", "Ghana"],
  ["heinemann", "Heinemann", "UK"],
  ["cassava", "Cassava Republic", "Nigeria"],
  ["penguin", "Penguin Random House", "USA"],
  ["knopf", "Alfred A. Knopf", "USA"],
  ["harvard", "Harvard University Press", "USA"],
  ["woeli", "Woeli Publishing", "Ghana"],
  ["afram", "Afram Publications", "Ghana"],
  ["vintage", "Vintage Books", "UK"],
  ["faber", "Faber & Faber", "UK"],
  ["oxford", "Oxford University Press", "UK"],
  ["macmillan", "Macmillan", "USA"],
  ["bloomsbury", "Bloomsbury", "UK"],
  ["spectacle", "Spectacle Press Accra", "Ghana"],
  ["sahara", "Sahara Books", "Ghana"],
];

const authorSeeds = [
  ["ama-ata-aidoo", "Ama Ata Aidoo", "Ghana", "#0F766E"],
  ["chimamanda-adichie", "Chimamanda Ngozi Adichie", "Nigeria", "#D4A017"],
  ["kwame-gyasi", "Kwame Gyasi", "Ghana", "#134E4A"],
  ["maya-okoro", "Maya Okoro", "Ghana", "#B45309"],
  ["james-mensah", "James Mensah", "Ghana", "#0E7490"],
  ["elena-boateng", "Elena Boateng", "Ghana", "#BE123C"],
  ["dr-akosua-frimpong", "Dr. Akosua Frimpong", "Ghana", "#4338CA"],
  ["nathan-quaye", "Nathan Quaye", "Ghana", "#047857"],
  ["yaw-asante", "Yaw Asante", "Ghana", "#0F766E"],
  ["fatima-diallo", "Fatima Diallo", "Senegal", "#7C2D12"],
  ["ibrahim-toure", "Ibrahim Touré", "Mali", "#1E3A5F"],
  ["nina-okeke", "Nina Okeke", "Nigeria", "#BE185D"],
  ["samuel-owusu", "Samuel Owusu", "Ghana", "#365314"],
  ["leila-hassan", "Leila Hassan", "Egypt", "#9A3412"],
  ["kojo-annor", "Kojo Annor", "Ghana", "#155E75"],
  ["amara-cole", "Amara Cole", "Ghana", "#831843"],
  ["benedict-darko", "Benedict Darko", "Ghana", "#1C1917"],
  ["zainab-musa", "Zainab Musa", "Nigeria", "#713F12"],
  ["efua-sutherland", "Efua Sutherland", "Ghana", "#14532D"],
  ["ayo-adebayo", "Ayo Adebayo", "Nigeria", "#1E40AF"],
  ["nadia-mensah", "Nadia Mensah", "Ghana", "#9F1239"],
  ["kofi-agyeman", "Kofi Agyeman", "Ghana", "#115E59"],
  ["sarah-nkrumah", "Sarah Nkrumah", "Ghana", "#854D0E"],
  ["daniel-boateng", "Daniel Boateng", "Ghana", "#312E81"],
  ["precious-adjei", "Precious Adjei", "Ghana", "#064E3B"],
];

const titleTemplates = [
  ["The {place} Chronicle", "fiction", ["Literary Fiction"]],
  ["Letters from {place}", "fiction", ["Literary Fiction"]],
  ["{noun} at Dawn", "fiction", ["Contemporary Fiction"]],
  ["Midnight {noun}", "fiction", ["Mystery"]],
  ["The Last {noun}", "fiction", ["Historical Fiction"]],
  ["Building {noun}", "business", ["Entrepreneurship", "Business"]],
  ["Capital of {noun}", "business", ["Finance", "Business"]],
  ["Lead Like {noun}", "business", ["Leadership"]],
  ["The Signal of {noun}", "technology", ["Technology", "AI"]],
  ["Code & {noun}", "technology", ["Technology"]],
  ["Cloud over {place}", "technology", ["Technology"]],
  ["{noun} for Children", "childrens", ["Children's"]],
  ["Ananse and the {noun}", "childrens", ["Children's", "Folklore"]],
  ["Little {noun}", "childrens", ["Children's"]],
  ["Studies in {noun}", "academic", ["Academic"]],
  ["Empire of {noun}", "academic", ["History", "Education"]],
  ["Reading {place}", "academic", ["History"]],
  ["Habits of {noun}", "self-help", ["Self-Help", "Productivity"]],
  ["The {noun} Year", "self-help", ["Self-Help"]],
  ["Quiet {noun}", "self-help", ["Leadership", "Self-Help"]],
  ["Life of {name}", "biographies", ["Biography"]],
  ["Voices of {place}", "biographies", ["Biography", "History"]],
  ["Poems for {noun}", "poetry", ["Poetry"]],
  ["Harmattan {noun}", "poetry", ["Poetry"]],
  ["A History of {place}", "history", ["History"]],
  ["Coastal {noun}", "history", ["History"]],
  ["Maps of {place}", "non-fiction", ["Non-Fiction"]],
  ["Notes on {noun}", "non-fiction", ["Non-Fiction"]],
  ["Field Guide to {noun}", "non-fiction", ["Non-Fiction"]],
  ["{place} Report", "non-fiction", ["Non-Fiction"]],
];

const places = [
  "Accra", "Kumasi", "Cape Coast", "Tamale", "Tema", "Lagos", "Nairobi", "Dakar", "Cairo", "Kigali",
];
const nouns = [
  "Baobab", "Market", "Library", "River", "Horizon", "Drum", "Harbor", "Archive", "Garden", "Signal",
  "Ledger", "Lantern", "Courier", "Threshold", "Compass", "Harvest", "Canvas", "Echo", "Anchor", "Spark",
];
const names = [
  "Ama", "Kofi", "Efua", "Yaw", "Adwoa", "Kwesi", "Abena", "Kojo", "Akosua", "Nana",
];

const firstNames = [
  "Ama", "Kojo", "Efua", "Yaw", "Adwoa", "Kwesi", "Abena", "Nana", "Akosua", "Kofi",
  "Serena", "Daniel", "Grace", "Michael", "Linda", "Joseph", "Ruth", "Samuel", "Patricia", "Emmanuel",
];
const lastNames = [
  "Mensah", "Owusu", "Boateng", "Asante", "Darko", "Appiah", "Osei", "Agyeman", "Addo", "Frimpong",
  "Quaye", "Annor", "Sarpong", "Tetteh", "Nyarko", "Amoah", "Baah", "Lamptey", "Ofori", "Adjei",
];

const permissionDefs = [
  ["catalog.read", "Catalog", "Read catalog"],
  ["catalog.write", "Catalog", "Manage catalog"],
  ["authors.write", "Catalog", "Manage authors"],
  ["publishers.write", "Catalog", "Manage publishers"],
  ["inventory.read", "Inventory", "View inventory"],
  ["inventory.write", "Inventory", "Manage inventory"],
  ["orders.read", "Orders", "View orders"],
  ["orders.write", "Orders", "Manage orders"],
  ["customers.read", "Customers", "View customers"],
  ["customers.write", "Customers", "Manage customers"],
  ["finance.read", "Finance", "View finance"],
  ["finance.write", "Finance", "Manage finance"],
  ["marketing.read", "Marketing", "View marketing"],
  ["marketing.write", "Marketing", "Manage marketing"],
  ["support.read", "Support", "View support"],
  ["support.write", "Support", "Manage support"],
  ["reviews.moderate", "Reviews", "Moderate reviews"],
  ["subscriptions.read", "Subscriptions", "View subscriptions"],
  ["subscriptions.write", "Subscriptions", "Manage subscriptions"],
  ["settings.write", "System", "Edit settings"],
  ["audit.read", "System", "Read audit logs"],
];

const roleKeys = [
  ["super_admin", "Super Admin", true],
  ["inventory_manager", "Inventory Manager", true],
  ["sales_manager", "Sales Manager", true],
  ["support_agent", "Support Agent", true],
  ["finance", "Finance", true],
  ["marketing_manager", "Marketing Manager", true],
  ["publisher_manager", "Publisher Manager", true],
  ["customer", "Customer", true],
];

const rolePermMap = {
  inventory_manager: ["catalog.read", "catalog.write", "inventory.read", "inventory.write", "orders.read"],
  sales_manager: ["catalog.read", "orders.read", "orders.write", "customers.read", "marketing.read"],
  support_agent: ["support.read", "support.write", "orders.read", "customers.read"],
  finance: ["finance.read", "finance.write", "orders.read", "subscriptions.read"],
  marketing_manager: ["marketing.read", "marketing.write", "catalog.read", "reviews.moderate"],
  publisher_manager: ["catalog.read", "catalog.write", "authors.write", "publishers.write", "inventory.read"],
  customer: [],
};

const lines = [];
function w(s = "") {
  lines.push(s);
}

w(`-- Books & You seed data (generated ${new Date().toISOString()})`);
w(`-- Do not edit by hand; regenerate with: node scripts/generate-seed.mjs`);
w(`begin;`);
w(``);
w(`-- Clear dependent demo data carefully (local/dev only)`);
w(`-- Catalog + system seed is idempotent via fixed UUIDs / upserts`);
w(``);

// Roles
w(`-- Roles`);
for (const [key, name, isSystem] of roleKeys) {
  const id = uuidFrom(`role:${key}`);
  w(
    `insert into public.roles (id, key, name, description, is_system) values (${sqlStr(id)}, ${sqlStr(key)}, ${sqlStr(name)}, ${sqlStr(name + " role")}, ${isSystem}) on conflict (key) do update set name = excluded.name;`
  );
}
w(``);

// Permissions
w(`-- Permissions`);
for (const [key, module, name] of permissionDefs) {
  const id = uuidFrom(`perm:${key}`);
  w(
    `insert into public.permissions (id, key, name, module, description) values (${sqlStr(id)}, ${sqlStr(key)}, ${sqlStr(name)}, ${sqlStr(module)}, ${sqlStr(name)}) on conflict (key) do update set name = excluded.name;`
  );
}
w(``);

w(`-- Role permissions`);
w(`delete from public.role_permissions;`);
for (const [roleKey, perms] of Object.entries(rolePermMap)) {
  const roleId = uuidFrom(`role:${roleKey}`);
  for (const p of perms) {
    w(
      `insert into public.role_permissions (role_id, permission_id) values (${sqlStr(roleId)}, ${sqlStr(uuidFrom(`perm:${p}`))}) on conflict do nothing;`
    );
  }
}
// super_admin gets all via is_superadmin(); still attach all for clarity
const superId = uuidFrom("role:super_admin");
for (const [key] of permissionDefs) {
  w(
    `insert into public.role_permissions (role_id, permission_id) values (${sqlStr(superId)}, ${sqlStr(uuidFrom(`perm:${key}`))}) on conflict do nothing;`
  );
}
w(``);

// Categories
w(`-- Categories`);
const categoryIds = {};
categories.forEach(([slug, name, desc, accent], i) => {
  const id = uuidFrom(`cat:${slug}`);
  categoryIds[slug] = id;
  w(
    `insert into public.categories (id, slug, name, description, accent, sort_order, is_featured) values (${sqlStr(id)}, ${sqlStr(slug)}, ${sqlStr(name)}, ${sqlStr(desc)}, ${sqlStr(accent)}, ${i}, ${i < 6}) on conflict (slug) do update set name = excluded.name, description = excluded.description;`
  );
});
w(``);

// Publishers
w(`-- Publishers`);
const publisherIds = {};
publishers.forEach(([slug, name, country], i) => {
  const id = uuidFrom(`pub:${slug}`);
  publisherIds[slug] = id;
  w(
    `insert into public.publishers (id, slug, name, country, description) values (${sqlStr(id)}, ${sqlStr(slug)}, ${sqlStr(name)}, ${sqlStr(country)}, ${sqlStr(`${name} — trusted publisher`)}) on conflict (slug) do update set name = excluded.name;`
  );
});
w(``);

// Authors
w(`-- Authors`);
const authorIds = [];
authorSeeds.forEach(([slug, name, nationality, color], i) => {
  const id = uuidFrom(`auth:${slug}`);
  authorIds.push({ id, slug, name });
  w(
    `insert into public.authors (id, slug, name, bio, nationality, avatar_color, followers_count, is_verified) values (${sqlStr(id)}, ${sqlStr(slug)}, ${sqlStr(name)}, ${sqlStr(`${name} is a celebrated author contributing to African and global literature.`)}, ${sqlStr(nationality)}, ${sqlStr(color)}, ${(i + 1) * 137 * 17}, ${i < 10}) on conflict (slug) do update set name = excluded.name, bio = excluded.bio;`
  );
});
w(``);

// Books
w(`-- Books (100)`);
const bookIds = [];
for (let i = 0; i < 100; i++) {
  const tmpl = titleTemplates[i % titleTemplates.length];
  const [pattern, catSlug, genres] = tmpl;
  const place = places[i % places.length];
  const noun = nouns[i % nouns.length];
  const person = names[i % names.length];
  const title = pattern
    .replace("{place}", place)
    .replace("{noun}", noun)
    .replace("{name}", person);
  const slug = `${title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "")}-${i + 1}`;
  const id = uuidFrom(`book:${slug}`);
  bookIds.push({ id, slug, title, catSlug, genres, i });
  const author = authorIds[i % authorIds.length];
  const publisher = publishers[i % publishers.length];
  const palette = palettes[i % palettes.length];
  const isbn = `978${String(1000000000 + i).padStart(10, "0")}`;
  const pages = 120 + ((i * 17) % 400);
  const year = 2015 + (i % 11);
  const month = String((i % 12) + 1).padStart(2, "0");
  const day = String((i % 27) + 1).padStart(2, "0");
  const published = `${year}-${month}-${day}`;
  const featured = i % 7 === 0;
  const bestseller = i % 5 === 0;
  const newArrival = i % 9 === 0;
  const staffPick = i % 8 === 0;
  const award = i % 11 === 0;
  const preorder = i === 11 || i === 47;
  const release = preorder ? "2026-09-15" : null;

  w(
    `insert into public.books (
      id, slug, title, subtitle, description, synopsis, isbn, pages, language, published_at,
      publisher_id, cover_gradient, cover_accent, is_featured, is_bestseller, is_new_arrival,
      is_staff_pick, is_award_winner, is_preorder, release_date, table_of_contents, genres, rating_avg, review_count
    ) values (
      ${sqlStr(id)}, ${sqlStr(slug)}, ${sqlStr(title)}, ${i % 4 === 0 ? sqlStr("A Books & You edition") : "null"},
      ${sqlStr(`A compelling ${genres[0].toLowerCase()} title exploring ${noun.toLowerCase()} and life in ${place}.`)},
      ${sqlStr(`In this work, the author unfolds a narrative of ${noun.toLowerCase()}, memory, and belonging across ${place} and beyond. Readers will find careful prose, vivid scenes, and lasting insight.`)},
      ${sqlStr(isbn)}, ${pages}, 'English', ${sqlStr(published)},
      ${sqlStr(publisherIds[publisher[0]])}, ${sqlStr(palette.gradient)}, ${sqlStr(palette.accent)},
      ${featured}, ${bestseller}, ${newArrival}, ${staffPick}, ${award}, ${preorder}, ${release ? sqlStr(release) : "null"},
      ${sqlArr(["Part One", "Part Two", "Part Three", "Epilogue"])}, ${sqlArr(genres)},
      ${(3.8 + (i % 12) * 0.1).toFixed(2)}, ${(20 + i * 3) % 900}
    ) on conflict (slug) do update set title = excluded.title, description = excluded.description;`
  );

  w(
    `insert into public.book_authors (book_id, author_id, is_primary, sort_order) values (${sqlStr(id)}, ${sqlStr(author.id)}, true, 0) on conflict do nothing;`
  );
  w(
    `insert into public.book_categories (book_id, category_id) values (${sqlStr(id)}, ${sqlStr(categoryIds[catSlug])}) on conflict do nothing;`
  );

  // tags
  for (const tag of [...genres.map((g) => g.toLowerCase().replace(/\s+/g, "-")), place.toLowerCase()].slice(0, 3)) {
    w(
      `insert into public.book_tags (id, book_id, tag) values (${sqlStr(uuidFrom(`tag:${slug}:${tag}`))}, ${sqlStr(id)}, ${sqlStr(tag)}) on conflict do nothing;`
    );
  }

  // inventory formats
  const formats = [
    ["paperback", 4500 + (i % 20) * 500, 30 + (i % 40)],
    ["hardcover", 9000 + (i % 15) * 700, 8 + (i % 20)],
    ["ebook", 2500 + (i % 10) * 300, 999],
  ];
  if (i % 4 === 0) formats.push(["audiobook", 5000 + (i % 8) * 400, 999]);

  for (const [format, price, qty] of formats) {
    const invId = uuidFrom(`inv:${slug}:${format}`);
    const compare = format === "paperback" && i % 6 === 0 ? price + 1500 : null;
    w(
      `insert into public.book_inventory (id, book_id, format, sku, price_cents, compare_at_cents, quantity_on_hand, is_active)
       values (${sqlStr(invId)}, ${sqlStr(id)}, '${format}', ${sqlStr(`SKU-${i + 1}-${format.slice(0, 2).toUpperCase()}`)}, ${price}, ${compare ?? "null"}, ${preorder && format === "paperback" ? 0 : qty}, true)
       on conflict (book_id, format) do update set price_cents = excluded.price_cents, quantity_on_hand = excluded.quantity_on_hand;`
    );
  }
}
w(``);

// Collections
w(`-- Collections`);
const collections = [
  ["best-sellers", "Best Sellers", "What Ghana is reading right now."],
  ["new-arrivals", "New Arrivals", "Fresh pages, just shelved."],
  ["award-winners", "Award Winners", "Critically acclaimed and celebrated."],
  ["staff-picks", "Staff Picks", "Handpicked by our booksellers."],
  ["trending-this-week", "Trending This Week", "Rising fast across the platform."],
  ["childrens-books", "Children's Books", "Stories for curious young readers."],
  ["academic-books", "Academic Books", "For classrooms, labs, and libraries."],
];
collections.forEach(([slug, title, desc], i) => {
  const id = uuidFrom(`col:${slug}`);
  w(
    `insert into public.collections (id, slug, title, description, is_featured, sort_order) values (${sqlStr(id)}, ${sqlStr(slug)}, ${sqlStr(title)}, ${sqlStr(desc)}, true, ${i}) on conflict (slug) do update set title = excluded.title;`
  );
  const picks = bookIds.filter((_, idx) => {
    if (slug === "best-sellers") return idx % 5 === 0;
    if (slug === "new-arrivals") return idx % 9 === 0;
    if (slug === "award-winners") return idx % 11 === 0;
    if (slug === "staff-picks") return idx % 8 === 0;
    if (slug === "trending-this-week") return idx % 7 === 0;
    if (slug === "childrens-books") return bookIds[idx].catSlug === "childrens";
    if (slug === "academic-books") return bookIds[idx].catSlug === "academic";
    return false;
  }).slice(0, 12);
  picks.forEach((b, j) => {
    w(
      `insert into public.collection_books (collection_id, book_id, sort_order) values (${sqlStr(id)}, ${sqlStr(b.id)}, ${j}) on conflict do nothing;`
    );
  });
});
w(``);

// Plans
w(`-- Subscription plans`);
const plans = [
  ["monthly", "Monthly Reader", "monthly", 14900, 1, false, ["1 curated physical book / month", "Member pricing", "Early access", "Free Accra delivery"]],
  ["quarterly", "Seasonal Stack", "quarterly", 39900, 3, true, ["3 curated books / quarter", "1 bonus ebook", "Priority support", "Author events", "Free nationwide delivery"]],
  ["annual", "Library Year", "annual", 139900, 12, false, ["12 curated books / year", "Unlimited ebook borrowing", "Gift 2 friends", "VIP preorders", "Annual reading report"]],
];
plans.forEach(([key, name, interval, price, books, popular, features], i) => {
  w(
    `insert into public.plans (id, key, name, interval, price_cents, books_per_period, features, is_popular, sort_order)
     values (${sqlStr(uuidFrom(`plan:${key}`))}, ${sqlStr(key)}, ${sqlStr(name)}, '${interval}', ${price}, ${books}, ${sqlArr(features)}, ${popular}, ${i})
     on conflict (key) do update set name = excluded.name, price_cents = excluded.price_cents, features = excluded.features;`
  );
});
w(``);

// Coupons & promotions
w(`-- Coupons & promotions`);
w(
  `insert into public.coupons (id, code, description, discount_type, discount_value, min_order_cents, max_redemptions, is_active)
   values (${sqlStr(uuidFrom("coupon:READMORE"))}, 'READMORE', 'GH₵30 off first orders', 'fixed', 3000, 5000, 1000, true)
   on conflict (code) do update set is_active = true;`
);
w(
  `insert into public.coupons (id, code, description, discount_type, discount_value, min_order_cents, is_active)
   values (${sqlStr(uuidFrom("coupon:WELCOME10"))}, 'WELCOME10', '10% off', 'percent', 10, 0, true)
   on conflict (code) do update set is_active = true;`
);
w(
  `insert into public.promotions (id, title, description, is_active, starts_at, ends_at)
   values (${sqlStr(uuidFrom("promo:july"))}, 'July Reading Festival', 'Member extras and free delivery weekends', true, '2026-07-01', '2026-07-31')
   on conflict (id) do nothing;`
);
w(``);

// Feature flags & settings
w(`-- Feature flags & site settings`);
const flags = [
  ["ai_recommendations", true, "Personalized recommendations"],
  ["preorders", true, "Allow preorder checkout"],
  ["referrals", true, "Referral rewards program"],
  ["subscriptions", true, "Subscription box plans"],
  ["gift_cards", true, "Gift card purchases"],
  ["live_inventory", true, "Realtime stock updates"],
];
for (const [key, enabled, description] of flags) {
  w(
    `insert into public.feature_flags (key, enabled, description) values (${sqlStr(key)}, ${enabled}, ${sqlStr(description)}) on conflict (key) do update set enabled = excluded.enabled;`
  );
}

w(
  `insert into public.site_settings (key, value, description) values
    ('brand', '{"name":"Books & You","primary":"#0F766E","accent":"#D4A017"}'::jsonb, 'Brand tokens'),
    ('shipping', '{"free_delivery_threshold_cents":30000,"currency":"GHS","default_shipping_cents":2500}'::jsonb, 'Shipping rules'),
    ('payments', '{"providers":["moolre"]}'::jsonb, 'Enabled payment providers')
   on conflict (key) do update set value = excluded.value;`
);

w(
  `insert into public.notification_templates (id, key, channel, subject, body) values
    (${sqlStr(uuidFrom("tpl:order-confirm"))}, 'order_confirmation', 'email', 'Your Books & You order {{order_number}}', 'Thanks for your order. Total: {{total}}.'),
    (${sqlStr(uuidFrom("tpl:shipped"))}, 'order_shipped', 'email', 'Your order is on the way', 'Tracking: {{tracking_number}}'),
    (${sqlStr(uuidFrom("tpl:welcome-sms"))}, 'welcome_sms', 'sms', null, 'Welcome to Books & You! Code {{referral_code}} earns credit.')
   on conflict (key) do update set body = excluded.body;`
);
w(``);

// Customers (50) via auth.users
w(`-- 50 customer accounts (auth.users + triggered profiles)`);
w(`-- Password for all demo users: Password123!`);
const demoPasswordHash =
  "$2a$10$rQZ5K5Z5Z5Z5Z5Z5Z5Z5ZuGKxGxGxGxGxGxGxGxGxGxGxGxGxGxGx"; // placeholder — use supabase auth admin in real envs

// For local supabase, insert with encrypted_password using crypt if pgcrypto available
w(`create extension if not exists pgcrypto;`);

const customerIds = [];
for (let i = 0; i < 50; i++) {
  const id = uuidFrom(`user:customer:${i + 1}`);
  customerIds.push(id);
  const fn = firstNames[i % firstNames.length];
  const ln = lastNames[i % lastNames.length];
  const email = `reader${String(i + 1).padStart(2, "0")}@booksandyou.test`;
  // Use supabase-compatible auth.users insert
  w(`
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  ${sqlStr(id)},
  'authenticated',
  'authenticated',
  ${sqlStr(email)},
  crypt('Password123!', gen_salt('bf')),
  timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  ${sqlStr(JSON.stringify({ full_name: `${fn} ${ln}` }))}::jsonb,
  timezone('utc', now()),
  timezone('utc', now()),
  '', '', '', ''
) on conflict (id) do nothing;`);

  w(`
insert into auth.identities (
  id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
) values (
  ${sqlStr(id)},
  ${sqlStr(id)},
  jsonb_build_object('sub', ${sqlStr(id)}, 'email', ${sqlStr(email)}),
  'email',
  ${sqlStr(id)},
  timezone('utc', now()),
  timezone('utc', now()),
  timezone('utc', now())
) on conflict do nothing;`);
}

// Staff users
const staffUsers = [
  ["superadmin@booksandyou.test", "Super Admin", "super_admin"],
  ["inventory@booksandyou.test", "Ivy Manager", "inventory_manager"],
  ["sales@booksandyou.test", "Sam Sales", "sales_manager"],
  ["support@booksandyou.test", "Sue Support", "support_agent"],
  ["finance@booksandyou.test", "Fay Finance", "finance"],
];
staffUsers.forEach(([email, name, role], i) => {
  const id = uuidFrom(`user:staff:${role}`);
  w(`
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) values (
  '00000000-0000-0000-0000-000000000000',
  ${sqlStr(id)}, 'authenticated', 'authenticated', ${sqlStr(email)},
  crypt('Password123!', gen_salt('bf')), timezone('utc', now()),
  '{"provider":"email","providers":["email"]}'::jsonb,
  ${sqlStr(JSON.stringify({ full_name: name }))}::jsonb,
  timezone('utc', now()), timezone('utc', now()), '', '', '', ''
) on conflict (id) do nothing;`);
  w(`
insert into auth.identities (id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at)
values (
  ${sqlStr(id)}, ${sqlStr(id)},
  jsonb_build_object('sub', ${sqlStr(id)}, 'email', ${sqlStr(email)}),
  'email', ${sqlStr(id)}, timezone('utc', now()), timezone('utc', now()), timezone('utc', now())
) on conflict do nothing;`);
  w(
    `update public.profiles set role_id = ${sqlStr(uuidFrom(`role:${role}`))}, full_name = ${sqlStr(name)} where id = ${sqlStr(id)};`
  );
});
w(``);

// Enrich first customer as Ama Darko demo
const amaId = customerIds[0];
w(`-- Demo primary customer enrichment`);
w(
  `update public.profiles set full_name = 'Ama Darko', referral_code = 'AMA-READS', reading_goal = 24, reading_streak = 12, favorite_genres = ${sqlArr(["Literary Fiction", "Business", "Self-Help"])} where id = ${sqlStr(amaId)};`
);
w(
  `update public.wallets set balance_cents = 8500 where user_id = ${sqlStr(amaId)};`
);

// Addresses for first 10 customers
w(`-- Addresses`);
for (let i = 0; i < 10; i++) {
  const uid = customerIds[i];
  w(
    `insert into public.addresses (id, user_id, label, full_name, line1, city, region, postal_code, country, phone, is_default)
     values (${sqlStr(uuidFrom(`addr:${i}:home`))}, ${sqlStr(uid)}, 'Home', (select full_name from public.profiles where id = ${sqlStr(uid)}), ${sqlStr(`${10 + i} Liberation Rd`)}, 'Accra', 'Greater Accra', ${sqlStr(`GA-${100 + i}-4567`)}, 'Ghana', '+233241000${String(100 + i).slice(-3)}', true)
     on conflict (id) do nothing;`
  );
}
w(``);

// Reviews (~80)
w(`-- Reviews`);
for (let i = 0; i < 80; i++) {
  const book = bookIds[i % bookIds.length];
  const user = customerIds[i % customerIds.length];
  const rating = 3 + (i % 3);
  w(
    `insert into public.book_reviews (id, book_id, user_id, rating, title, body, is_verified_purchase, is_published)
     values (${sqlStr(uuidFrom(`rev:${book.slug}:${i}`))}, ${sqlStr(book.id)}, ${sqlStr(user)}, ${rating}, ${sqlStr(["Loved it", "Worth reading", "Beautiful edition", "Insightful"][i % 4])}, ${sqlStr("A thoughtful and well-produced title from Books & You. Delivery was prompt and packaging excellent.")}, true, true)
     on conflict (book_id, user_id) do nothing;`
  );
}
w(``);

// Wishlists & favorites for Ama
w(`-- Wishlist / favorites / reading history for demo user`);
w(
  `insert into public.wishlist_items (id, wishlist_id, book_id)
   select ${sqlStr(uuidFrom("wi:1"))}, w.id, ${sqlStr(bookIds[0].id)}
   from public.wishlists w where w.user_id = ${sqlStr(amaId)} and w.is_default
   on conflict do nothing;`
);
for (let i = 1; i < 5; i++) {
  w(
    `insert into public.wishlist_items (id, wishlist_id, book_id)
     select ${sqlStr(uuidFrom(`wi:${i + 1}`))}, w.id, ${sqlStr(bookIds[i * 3].id)}
     from public.wishlists w where w.user_id = ${sqlStr(amaId)} and w.is_default
     on conflict do nothing;`
  );
}
w(
  `insert into public.favorites (user_id, author_id) values (${sqlStr(amaId)}, ${sqlStr(authorIds[0].id)}) on conflict do nothing;`
);
w(
  `insert into public.favorites (user_id, author_id) values (${sqlStr(amaId)}, ${sqlStr(authorIds[1].id)}) on conflict do nothing;`
);
for (let i = 0; i < 8; i++) {
  w(
    `insert into public.reading_history (id, user_id, book_id, viewed_at, source)
     values (${sqlStr(uuidFrom(`rh:${i}`))}, ${sqlStr(amaId)}, ${sqlStr(bookIds[i].id)}, timezone('utc', now()) - interval '${i} days', 'web')
     on conflict (id) do nothing;`
  );
}
w(``);

// Sample orders & transactions
w(`-- Sample orders`);
const orderSpecs = [
  { idx: 0, status: "shipped", items: [0, 7], total: 25500 },
  { idx: 1, status: "delivered", items: [1], total: 14500 },
  { idx: 2, status: "completed", items: [5], total: 7000 },
  { idx: 3, status: "ordered", items: [3, 15], total: 21000 },
  { idx: 4, status: "packed", items: [19], total: 11000 },
];
orderSpecs.forEach((spec, oi) => {
  const orderId = uuidFrom(`order:${oi + 1}`);
  const userId = customerIds[oi];
  const number = `BY-10${400 + oi}`;
  w(
    `insert into public.orders (id, order_number, user_id, status, currency, subtotal_cents, shipping_cents, discount_cents, total_cents, shipping_address, placed_at)
     values (
       ${sqlStr(orderId)}, ${sqlStr(number)}, ${sqlStr(userId)}, '${spec.status}', 'GHS', ${spec.total}, ${spec.total >= 30000 ? 0 : 2500}, 0, ${spec.total + (spec.total >= 30000 ? 0 : 2500)},
       '{"line1":"12 Liberation Rd","city":"Accra","country":"Ghana"}'::jsonb,
       timezone('utc', now()) - interval '${oi * 5} days'
     ) on conflict (order_number) do nothing;`
  );
  spec.items.forEach((bi, j) => {
    const book = bookIds[bi];
    const price = 7000 + bi * 100;
    w(
      `insert into public.order_items (id, order_id, book_id, title, format, quantity, unit_price_cents, total_cents)
       values (${sqlStr(uuidFrom(`oi:${oi}:${j}`))}, ${sqlStr(orderId)}, ${sqlStr(book.id)}, ${sqlStr(book.title)}, 'paperback', 1, ${price}, ${price})
       on conflict (id) do nothing;`
    );
  });
  const txId = uuidFrom(`tx:${oi + 1}`);
  w(
    `insert into public.transactions (id, order_id, user_id, provider, provider_reference, amount_cents, currency, status)
     values (${sqlStr(txId)}, ${sqlStr(orderId)}, ${sqlStr(userId)}, 'moolre', ${sqlStr(`MLR_${number}`)}, ${spec.total}, 'GHS', 'succeeded')
     on conflict (id) do nothing;`
  );
  w(
    `insert into public.payments (id, transaction_id, order_id, amount_cents, currency, status, paid_at)
     values (${sqlStr(uuidFrom(`pay:${oi + 1}`))}, ${sqlStr(txId)}, ${sqlStr(orderId)}, ${spec.total}, 'GHS', 'succeeded', timezone('utc', now()) - interval '${oi * 5} days')
     on conflict (id) do nothing;`
  );
  const shipId = uuidFrom(`ship:${oi + 1}`);
  w(
    `insert into public.shipping (id, order_id, carrier, tracking_number, status, shipped_at)
     values (${sqlStr(shipId)}, ${sqlStr(orderId)}, 'Books & You Logistics', ${sqlStr(`GH-BY-${880000 + oi}`)}, '${spec.status}', timezone('utc', now()) - interval '${oi * 5 - 1} days')
     on conflict (order_id) do nothing;`
  );
  ["ordered", "packed", "shipped"].forEach((st, si) => {
    if (["ordered", "packed", "shipped", "delivered", "completed"].indexOf(spec.status) >= si) {
      w(
        `insert into public.tracking_events (id, shipping_id, status, note, occurred_at)
         values (${sqlStr(uuidFrom(`te:${oi}:${si}`))}, ${sqlStr(shipId)}, '${st}', ${sqlStr(`${st} update`)}, timezone('utc', now()) - interval '${oi * 5 - si} days')
         on conflict (id) do nothing;`
      );
    }
  });
});
w(``);

// Library items for Ama (ebooks from purchased)
w(`-- Digital library`);
[0, 4, 9, 7].forEach((bi, i) => {
  w(
    `insert into public.library_items (id, user_id, book_id, format, progress_percent, last_opened_at, bookmarks_count, highlights_count)
     values (${sqlStr(uuidFrom(`lib:${i}`))}, ${sqlStr(amaId)}, ${sqlStr(bookIds[bi].id)}, 'ebook', ${[100, 62, 91, 28][i]}, timezone('utc', now()) - interval '${i} days', ${i + 1}, ${i * 3 + 2})
     on conflict (user_id, book_id, format) do nothing;`
  );
});
w(``);

// Referrals & subscription for Ama
w(`-- Referrals, subscription, gift card`);
w(
  `insert into public.referrals (id, referrer_id, referred_id, referral_code, status, qualified_at)
   values (${sqlStr(uuidFrom("ref:1"))}, ${sqlStr(amaId)}, ${sqlStr(customerIds[1])}, 'AMA-READS', 'rewarded', timezone('utc', now()) - interval '20 days')
   on conflict (referred_id) do nothing;`
);
w(
  `insert into public.wallet_transactions (id, wallet_id, type, amount_cents, balance_after_cents, description)
   select ${sqlStr(uuidFrom("wtx:1"))}, w.id, 'referral_reward', 5000, 8500, 'Referral reward for reader02'
   from public.wallets w where w.user_id = ${sqlStr(amaId)}
   on conflict (id) do nothing;`
);
w(
  `insert into public.referral_rewards (id, referral_id, amount_cents, status)
   values (${sqlStr(uuidFrom("rr:1"))}, ${sqlStr(uuidFrom("ref:1"))}, 5000, 'paid')
   on conflict (id) do nothing;`
);
w(
  `insert into public.subscriptions (id, user_id, plan_id, status, current_period_start, current_period_end)
   values (${sqlStr(uuidFrom("sub:ama"))}, ${sqlStr(amaId)}, ${sqlStr(uuidFrom("plan:quarterly"))}, 'active', timezone('utc', now()) - interval '10 days', timezone('utc', now()) + interval '80 days')
   on conflict (id) do nothing;`
);
w(
  `insert into public.gift_cards (id, code, initial_balance_cents, balance_cents, purchased_by, is_active)
   values (${sqlStr(uuidFrom("gc:1"))}, 'GIFT-BY-2026', 20000, 20000, ${sqlStr(amaId)}, true)
   on conflict (code) do nothing;`
);
w(``);

// Support ticket
w(`-- Support ticket`);
w(
  `insert into public.tickets (id, ticket_number, user_id, subject, status, priority)
   values (${sqlStr(uuidFrom("tck:1"))}, 'TCK-DEMO0001', ${sqlStr(amaId)}, 'Question about delivery to East Legon', 'open', 'medium')
   on conflict (ticket_number) do nothing;`
);
w(
  `insert into public.ticket_messages (id, ticket_id, sender_id, body, is_staff)
   values (${sqlStr(uuidFrom("tm:1"))}, ${sqlStr(uuidFrom("tck:1"))}, ${sqlStr(amaId)}, 'Hi, can I change my delivery window for BY-10400?', false)
   on conflict (id) do nothing;`
);
w(``);

w(`commit;`);
w(``);
w(`-- Seed summary expectations:`);
w(`-- categories: 10 | authors: 25 | publishers: 15 | books: 100`);
w(`-- customers: 50 | staff: 5 | reviews: ~80 | plans: 3`);

writeFileSync(outPath, lines.join("\n"));
console.log(`Wrote ${outPath}`);
console.log(`Lines: ${lines.length}`);
console.log(`Books: ${bookIds.length}, Authors: ${authorIds.length}, Customers: ${customerIds.length}`);
