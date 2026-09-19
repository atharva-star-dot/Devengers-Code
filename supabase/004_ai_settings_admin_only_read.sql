-- Restrict ai_settings SELECT to admins only.
-- Previously any signed-in user in the company could read this table directly
-- (e.g. via supabase.from('ai_settings').select('*') in the browser), which
-- exposed the company's plaintext AI provider API key to non-admin staff.
-- The UI already hides Company Settings from non-admins, but RLS is the real
-- enforcement layer for direct database/API access — this migration aligns
-- the SELECT policy with the existing admin-only INSERT/UPDATE policies.
--
-- Run this in the Supabase SQL editor if you already ran schema.sql before
-- this fix existed. Fresh installs get this automatically via schema.sql.

drop policy if exists ai_settings_select on public.ai_settings;
create policy ai_settings_select on public.ai_settings
  for select using (
    company_id = public.current_company_id()
    and public.current_role() = 'admin'
  );
