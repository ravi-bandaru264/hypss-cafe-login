import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ message: "Method not allowed" }, 405);

  try {
    const { username, password } = await req.json();
    const normalized = String(username ?? "").trim().toLowerCase();
    if (!normalized || !password) return json({ message: "Enter username and password." }, 400);

    const projectUrl = Deno.env.get("SUPABASE_URL")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    // Service-role lookup stays server-side only. The service key is never sent to the browser.
    const profileResponse = await fetch(
      `${projectUrl}/rest/v1/M_User?username=eq.${encodeURIComponent(normalized)}&select=email,active&limit=1`,
      { headers: { apikey: serviceKey, Authorization: `Bearer ${serviceKey}` } },
    );
    if (!profileResponse.ok) throw new Error("Unable to verify account. Check Edge Function configuration.");
    const rows = await profileResponse.json();
    const profile = rows?.[0];
    if (!profile || profile.active !== true) return json({ message: "Invalid username or password, or account inactive." }, 401);

    // Supabase Auth validates the password. Passwords are not stored in M_User.
    const authResponse = await fetch(`${projectUrl}/auth/v1/token?grant_type=password`, {
      method: "POST",
      headers: { apikey: anonKey, "Content-Type": "application/json" },
      body: JSON.stringify({ email: profile.email, password }),
    });
    const authResult = await authResponse.json();
    if (!authResponse.ok) return json({ message: "Invalid username or password." }, 401);

    return json({ session: authResult }, 200);
  } catch (error) {
    return json({ message: error?.message ?? "Login failed." }, 400);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
