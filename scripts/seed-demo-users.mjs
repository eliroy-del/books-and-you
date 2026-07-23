/**
 * Creates demo Auth users + assigns roles via service role.
 * Run: node --env-file=.env.local scripts/seed-demo-users.mjs
 */
import { createClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!url || !serviceKey) {
  console.error("Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const supabase = createClient(url, serviceKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const users = [
  ["superadmin@booksandyou.test", "Super Admin", "super_admin"],
  ["inventory@booksandyou.test", "Ivy Manager", "inventory_manager"],
  ["sales@booksandyou.test", "Sam Sales", "sales_manager"],
  ["support@booksandyou.test", "Sue Support", "support_agent"],
  ["finance@booksandyou.test", "Fay Finance", "finance"],
  ["reader01@booksandyou.test", "Ama Darko", "customer"],
];

const password = "Password123!";

async function main() {
  const { data: roles, error: rolesErr } = await supabase.from("roles").select("id, key");
  if (rolesErr) throw rolesErr;
  const roleMap = Object.fromEntries((roles || []).map((r) => [r.key, r.id]));

  for (const [email, fullName, roleKey] of users) {
    const { data: created, error } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { full_name: fullName },
    });

    let userId = created?.user?.id;
    if (error) {
      // Already exists — look up
      const { data: list } = await supabase.auth.admin.listUsers({ page: 1, perPage: 200 });
      const existing = list?.users?.find((u) => u.email === email);
      if (!existing) {
        console.warn("skip", email, error.message);
        continue;
      }
      userId = existing.id;
      console.log("exists", email);
    } else {
      console.log("created", email);
    }

    const roleId = roleMap[roleKey] || roleMap.customer;
    const { error: profileErr } = await supabase
      .from("profiles")
      .update({
        full_name: fullName,
        email,
        role_id: roleId,
        referral_code: roleKey === "customer" ? "AMA-READS" : undefined,
      })
      .eq("id", userId);

    if (profileErr) {
      console.warn("profile update", email, profileErr.message);
    } else {
      console.log("role assigned", email, "->", roleKey);
    }
  }

  console.log("\nDemo password for all:", password);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
