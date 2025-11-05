-- ==========================================================
-- 08_roles.sql
-- 🎭 Creación del rol opcional para referencia (sin asignar)
-- ==========================================================

USE lab_db_sql;

DROP ROLE IF EXISTS backend_role;
CREATE ROLE backend_role;

-- No se asigna al usuario, porque Docker no permite GRANT desde scripts automáticos
