# PostgreSQL Migration Guide

## Overview

This document details all changes made during the migration from **MySQL** to **PostgreSQL**.

---

## 📋 Summary of Changes

### 1. **Database Initialization** (`00_init.sql`)

#### MySQL

```sql
CREATE DATABASE lab_db_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE lab_db_sql;
SET FOREIGN_KEY_CHECKS = 0;
```

#### PostgreSQL

```sql
CREATE DATABASE lab_db_sql
  ENCODING 'UTF8'
  LC_COLLATE 'en_US.UTF-8'
  LC_CTYPE 'en_US.UTF-8';
```

**Changes:**

- Removed `USE` statement (not needed in PostgreSQL)
- Changed character set config to PostgreSQL encoding syntax
- Removed `SET FOREIGN_KEY_CHECKS` (not applicable in PostgreSQL)

---

### 2. **Schema Creation** (`01_schema.sql`)

#### Data Type Changes

| MySQL           | PostgreSQL                        |
| --------------- | --------------------------------- |
| `DATETIME`      | `TIMESTAMP`                       |
| `ENUM('a','b')` | `CREATE TYPE` + column definition |
| `BOOLEAN`       | `BOOLEAN` (same, works natively)  |
| `VARCHAR(24)`   | `VARCHAR(24)` (same)              |
| `DECIMAL(10,2)` | `DECIMAL(10,2)` (same)            |

#### ENUM Handling

MySQL inline ENUM:

```sql
role ENUM('admin', 'receptionist', 'biochemist', 'labTechnician') NOT NULL
```

PostgreSQL with custom types:

```sql
CREATE TYPE staff_role_enum AS ENUM ('admin', 'receptionist', 'biochemist', 'labTechnician');

CREATE TABLE LabStaff (
    role staff_role_enum NOT NULL
);
```

**Advantages:**

- Types are reusable across multiple tables
- Better type checking
- More portable and standards-compliant

#### Timestamp Management

MySQL auto-update:

```sql
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

PostgreSQL with triggers:

```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- Trigger handles updates
```

**New trigger function:**

```sql
CREATE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

### 3. **Constraints** (`03_constraints.sql`)

#### MySQL

```sql
FOREIGN KEY (id) REFERENCES table(_id)
  ON DELETE CASCADE ON UPDATE CASCADE
```

#### PostgreSQL

```sql
FOREIGN KEY (id) REFERENCES table(_id)
  ON DELETE CASCADE
```

**Note:** PostgreSQL doesn't support `ON UPDATE CASCADE`. Use triggers if needed.

---

### 4. **Views** (`04_views.sql`)

#### String Concatenation

MySQL:

```sql
CONCAT(p.firstname, ' ', p.lastname) AS patient_name
```

PostgreSQL:

```sql
p.firstname || ' ' || p.lastname AS patient_name
```

#### Date Functions

MySQL:

```sql
YEAR(da.date) AS year,
MONTH(da.date) AS month
```

PostgreSQL:

```sql
EXTRACT(YEAR FROM da.date)::INT AS year,
EXTRACT(MONTH FROM da.date)::INT AS month
```

---

### 5. **Procedures** (`06_procedures.sql`)

#### Architecture Change

MySQL uses `PROCEDURES`, PostgreSQL uses `FUNCTIONS`.

##### MySQL Syntax

```sql
DELIMITER $$
CREATE PROCEDURE recalc_talon_total(IN p_talon_id VARCHAR(24))
BEGIN
    DECLARE v_total DECIMAL(10,2);
    -- ...
END$$
DELIMITER ;
```

##### PostgreSQL Syntax

```sql
CREATE OR REPLACE FUNCTION recalc_talon_total(p_talon_id VARCHAR)
RETURNS VOID AS $$
DECLARE
    v_total DECIMAL(10,2);
BEGIN
    -- ...
END;
$$ LANGUAGE plpgsql;
```

#### Key Differences

| Aspect               | MySQL                   | PostgreSQL                          |
| -------------------- | ----------------------- | ----------------------------------- |
| Delimiter            | `DELIMITER $$`          | `$$ ... $$`                         |
| Variable declaration | `DECLARE var TYPE`      | `DECLARE var TYPE;`                 |
| NULL coalescing      | `IFNULL(expr, default)` | `COALESCE(expr, default)`           |
| UUID generation      | `LEFT(UUID(), 24)`      | `LEFT(gen_random_uuid()::TEXT, 24)` |
| Control flow exit    | `LEAVE label`           | `RETURN` or exception               |
| Stored procedures    | `CALL proc()`           | `PERFORM func()` or `SELECT func()` |

---

### 6. **Triggers** (`07_triggers.sql`)

#### Architecture Change

MySQL triggers execute SQL directly. PostgreSQL requires a trigger function.

##### MySQL

```sql
CREATE TRIGGER trg_update_total
AFTER UPDATE ON DoctorAppointment
FOR EACH ROW
BEGIN
    CALL recalc_talon_total(NEW.talon_id);
END$$
```

##### PostgreSQL

```sql
CREATE FUNCTION trg_update_total_func()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM recalc_talon_total(NEW.talon_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_total
AFTER UPDATE ON DoctorAppointment
FOR EACH ROW
EXECUTE FUNCTION trg_update_total_func();
```

#### Error Handling

MySQL:

```sql
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Error message';
```

PostgreSQL:

```sql
RAISE EXCEPTION 'Error message';
```

---

### 7. **Roles & Permissions** (`08_roles.sql`, `09_grants.sql`)

#### MySQL

```sql
CREATE ROLE backend_role;
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON lab_db_sql.* TO backend_role;
GRANT backend_role TO 'backend_user'@'%';
SET DEFAULT ROLE backend_role TO 'backend_user'@'%';
```

#### PostgreSQL

```sql
CREATE ROLE backend_role;
GRANT CONNECT ON DATABASE lab_db_sql TO backend_role;
GRANT USAGE ON SCHEMA public TO backend_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO backend_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO backend_role;

-- Set defaults for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_role;
```

---

### 8. **Data Loading** (`10_seed.sql`)

#### MySQL

```sql
LOAD DATA INFILE '/var/lib/mysql-files/medical_studies.csv'
INTO TABLE MedicalStudy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, name, price, description, duration);
```

#### PostgreSQL

```sql
COPY MedicalStudy (_id, name, price, description, duration)
FROM '/docker-entrypoint-initdb.d/data/medical_studies.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', NULL '');
```

**Advantages:**

- `COPY` is faster than INSERT for bulk data
- More standard SQL
- Better error reporting

---

### 9. **Docker Compose** (`docker-compose.yml`)

#### MySQL Service

```yaml
services:
  mysql:
    image: mysql:8.0
    ports:
      - "3307:3306"
    volumes:
      - ./mysql_data:/var/lib/mysql
```

#### PostgreSQL Service

```yaml
services:
  postgres:
    image: postgres:16-alpine
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres}"]
```

**Changes:**

- Updated image to PostgreSQL
- Changed port mapping
- Updated volume naming
- Added health check
- Used environment variables with defaults

---

## ✅ Migration Checklist

- [x] Update database initialization scripts
- [x] Convert data types (DATETIME → TIMESTAMP, ENUM handling)
- [x] Remove MySQL-specific features (ON UPDATE CASCADE, DELIMITER)
- [x] Rewrite stored procedures/functions for PL/pgSQL
- [x] Refactor triggers to use trigger functions
- [x] Update string concatenation (CONCAT → ||)
- [x] Convert date/time functions (YEAR/MONTH → EXTRACT)
- [x] Update NULL handling (IFNULL → COALESCE)
- [x] Rewrite data loading scripts (LOAD DATA INFILE → COPY)
- [x] Update Docker Compose configuration
- [x] Update documentation
- [x] Create environment example file

---

## 🧪 Testing Recommendations

1. **Test Schema Creation**

   ```bash
   docker-compose up
   docker-compose exec postgres psql -U postgres -d lab_db_sql -c "\dt"
   ```

2. **Test Functions**

   ```sql
   SELECT recalc_talon_total('test-id');
   ```

3. **Test Views**

   ```sql
   SELECT * FROM vw_patient_results LIMIT 1;
   ```

4. **Test Data Loading**
   - Ensure CSV files are in `init/data/`
   - Run `10_seed.sql` and verify record counts

5. **Test Triggers**
   - Insert test data and verify automatic updates

---

## 📌 Notes

- PostgreSQL ENUM types are database-level objects
- PL/pgSQL is case-insensitive for keywords but case-sensitive for identifiers
- Use `::type` for explicit type casting in PostgreSQL
- PostgreSQL uses zero-based indexing for arrays
- Always quote identifiers that might conflict with reserved words

---

## 🔗 References

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL vs MySQL Differences](https://www.postgresql.org/docs/current/differences.html)
- [PL/pgSQL Language](https://www.postgresql.org/docs/current/plpgsql.html)

---

**Last Updated:** March 12, 2025
