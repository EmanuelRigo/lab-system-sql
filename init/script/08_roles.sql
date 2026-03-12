-- ==========================================================
-- 08_roles.sql - PostgreSQL
-- 🎭 Creación del rol opcional para referencia
-- ==========================================================

DROP ROLE IF EXISTS backend_role;
CREATE ROLE backend_role;

-- Nota: En PostgreSQL, los roles son globales a toda la instancia,
-- no específicos de una base de datos. Los permisos se otorgan con GRANT.
