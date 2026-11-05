-- ============================================================
-- TECNIFUTURO & TOKIO STORE · Supabase Setup
-- Pegar en: Supabase → SQL Editor → New Query → Run
-- ============================================================

CREATE TABLE IF NOT EXISTS ep_store (
  path       TEXT PRIMARY KEY,
  data       JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ep_store_path ON ep_store (path);
CREATE INDEX IF NOT EXISTS idx_ep_store_updated ON ep_store (updated_at DESC);

ALTER TABLE ep_store ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública catálogo" ON ep_store FOR SELECT USING (path LIKE 'public/%');
CREATE POLICY "Auth lee todo" ON ep_store FOR SELECT TO authenticated USING (true);
CREATE POLICY "Auth inserta" ON ep_store FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Auth actualiza" ON ep_store FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Auth elimina" ON ep_store FOR DELETE TO authenticated USING (true);

CREATE OR REPLACE FUNCTION update_updated_at() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_ep_store_updated BEFORE UPDATE ON ep_store
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- Luego: Authentication → Users → Add User:
--   Email:    meneses78904@gmail.com
--   Password: Tecnifuturo2026
-- ============================================================
