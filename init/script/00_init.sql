-- ==========================================================
-- ✅ FILE: 00_init.sql
-- ==========================================================
-- 📄 Description:
-- Initializes the database environment for the LAB SYSTEM (PostgreSQL).
-- Creates the main database and sets base configurations.
-- ==========================================================

-- ==========================================================
-- ⚙️ Database Setup
-- ==========================================================

-- Optional: remove old database (use only in dev environments)
DROP DATABASE IF EXISTS lab_db_sql;

-- Create new database with UTF-8 encoding (PostgreSQL default)
CREATE DATABASE lab_db_sql
  ENCODING 'UTF8'
  LC_COLLATE 'en_US.UTF-8'
  LC_CTYPE 'en_US.UTF-8';

-- ==========================================================
-- ⚙️ Optional Configurations
-- ==========================================================
-- PostgreSQL doesn't need explicit foreign key checks disabling
-- Constraints are enforced by default

-- ==========================================================
-- ✅ End of file
-- ==========================================================
