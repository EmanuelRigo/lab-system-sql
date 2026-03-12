-- ==========================================================
-- 09_grants.sql - PostgreSQL
-- 🔐 Asignación de privilegios al rol del backend
-- ==========================================================

-- Otorgar privilegios sobre esquema public al rol backend_role
GRANT CONNECT ON DATABASE lab_db_sql TO backend_role;
GRANT USAGE ON SCHEMA public TO backend_role;

-- Otorgar privilegios sobre todas las tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO backend_role;

-- Otorgar privilegios sobre todas las secuencias (para IDs autogenerados)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO backend_role;

-- Otorgar privilegios de ejecución sobre todas las funciones
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO backend_role;

-- Configurar privilegios por defecto para futuras tablas/funciones
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO backend_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO backend_role;
