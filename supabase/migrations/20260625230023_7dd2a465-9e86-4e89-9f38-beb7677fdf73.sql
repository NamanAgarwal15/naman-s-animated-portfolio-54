
-- Allow anonymous entries
ALTER TABLE public.guestbook_entries ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE public.guestbook_entries ADD COLUMN IF NOT EXISTS email text;

-- Length safety
ALTER TABLE public.guestbook_entries
  ADD CONSTRAINT guestbook_message_len CHECK (char_length(message) BETWEEN 1 AND 140),
  ADD CONSTRAINT guestbook_name_len CHECK (char_length(display_name) BETWEEN 1 AND 60);

-- Replace insert policy: anyone may post
DROP POLICY IF EXISTS "Auth users can insert their own entry" ON public.guestbook_entries;
CREATE POLICY "Anyone can post a guestbook entry"
  ON public.guestbook_entries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (
    user_id IS NULL
    OR auth.uid() = user_id
  );

-- Hide email column from public reads via a view
DROP VIEW IF EXISTS public.guestbook_public;
CREATE VIEW public.guestbook_public
WITH (security_invoker = on) AS
  SELECT id, user_id, display_name, avatar_url, message, hidden, created_at
  FROM public.guestbook_entries;

GRANT SELECT ON public.guestbook_public TO anon, authenticated;
GRANT INSERT ON public.guestbook_entries TO anon;
