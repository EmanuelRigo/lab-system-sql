-- ==========================================================
-- 08_roles.sql
-- 🎭 Creación de roles y usuarios del sistema
-- ==========================================================

USE lab_db_sql;

-- Eliminación de roles existentes
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS receptionist;
DROP ROLE IF EXISTS lab_technician;
DROP ROLE IF EXISTS biochemist;

-- Creación de roles principales
CREATE ROLE admin;
CREATE ROLE receptionist;
CREATE ROLE lab_technician;
CREATE ROLE biochemist;

-- Creación de usuarios ejemplo
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER IF NOT EXISTS 'receptionist_user'@'localhost' IDENTIFIED BY 'recep123';
CREATE USER IF NOT EXISTS 'lab_user'@'localhost' IDENTIFIED BY 'lab123';
CREATE USER IF NOT EXISTS 'biochemist_user'@'localhost' IDENTIFIED BY 'bio123';
