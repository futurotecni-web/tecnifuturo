-- ============================================================
-- TECNIFUTURO & TOKIO STORE · Supabase Setup
-- Pegar en: Supabase → SQL Editor → New Query → Run
-- ============================================================

-- 1. Tabla principal (key-value store para el ERP)
CREATE TABLE IF NOT EXISTS ep_store (
  path       TEXT PRIMARY KEY,
  data       JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Índice para búsquedas por prefijo (store/*, public/*)
CREATE INDEX IF NOT EXISTS idx_ep_store_path ON ep_store (path);
CREATE INDEX IF NOT EXISTS idx_ep_store_updated ON ep_store (updated_at DESC);

-- 3. Habilitar RLS
ALTER TABLE ep_store ENABLE ROW LEVEL SECURITY;

-- 4. Políticas de seguridad

-- Lectura pública del catálogo (para la tienda / index.html)
CREATE POLICY "Lectura pública del catálogo"
  ON ep_store FOR SELECT
  USING (path LIKE 'public/%');

-- Usuarios autenticados pueden leer todo
CREATE POLICY "Usuarios autenticados leen todo"
  ON ep_store FOR SELECT
  TO authenticated
  USING (true);

-- Usuarios autenticados pueden insertar
CREATE POLICY "Usuarios autenticados insertan"
  ON ep_store FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Usuarios autenticados pueden actualizar
CREATE POLICY "Usuarios autenticados actualizan"
  ON ep_store FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Usuarios autenticados pueden eliminar
CREATE POLICY "Usuarios autenticados eliminan"
  ON ep_store FOR DELETE
  TO authenticated
  USING (true);

-- 5. Función para auto-actualizar el timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_ep_store_updated
  BEFORE UPDATE ON ep_store
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- LISTO. Ahora ve a Authentication → Users → Add User:
--   Email:    meneses78904@gmail.com
--   Password: Tecnifuturo2026
-- ============================================================
