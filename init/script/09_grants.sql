-- ==========================================================
-- 09_grants.sql
-- 🔐 Asignación de privilegios al rol del backend
-- ==========================================================

USE lab_db_sql;

-- Otorgar privilegios necesarios al rol del backend
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON lab_db_sql.* TO backend_role;

-- Asignar el rol al usuario backend
GRANT backend_role TO 'backend_user'@'%';

-- Configurar el rol por defecto para el usuario backend
SET DEFAULT ROLE backend_role TO 'backend_user'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;
