-- ==========================================================
-- ✅ FILE: 00_init.sql
-- ==========================================================
-- 📄 Description:
-- Initializes the database environment for the LAB SYSTEM.
-- Creates the main database and sets base configurations.
-- ==========================================================

-- ==========================================================
-- ⚙️ Database Setup
-- ==========================================================

-- Optional: remove old database (use only in dev environments)
DROP DATABASE IF EXISTS lab_db_sql;

-- Create new database with proper encoding
CREATE DATABASE lab_db_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

-- Select database
USE lab_db_sql;

-- ==========================================================
-- ⚙️ Optional Configurations
-- ==========================================================
-- Disable foreign key checks during initial setup
SET FOREIGN_KEY_CHECKS = 0;

-- Set SQL mode for consistent behavior
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- ==========================================================
-- ✅ End of file
-- ==========================================================
