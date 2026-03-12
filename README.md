# 🧪 PostgreSQL Database Initialization Guide

**Project:** Laboratory System  
**Date:** 2025-03-12
**Author:** Migrated from MySQL to PostgreSQL

---

## 📘 Overview

This document explains the full process for creating and initializing the **PostgreSQL database** for the laboratory management system.  
It includes the structure, order of execution, and setup instructions to ensure a clean and efficient initialization.

---

## 🧱 1️⃣ Database Schema (`01_schema.sql`)

### ✅ Description

This file creates all **main tables** and **ENUM types** required by the system.

```sql
-- Create ENUM types for PostgreSQL
CREATE TYPE staff_role_enum AS ENUM ('admin', 'receptionist', 'biochemist', 'labTechnician');
CREATE TYPE appointment_status_enum AS ENUM ('scheduled', 'waiting', 'completed', 'cancelled');
CREATE TYPE result_status_enum AS ENUM ('pending', 'in_progress', 'completed', 'failed');

-- Create tables using TIMESTAMP and native types
CREATE TABLE LabStaff (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    -- ... additional columns
);
```

### 🧩 Tables Created

1. LabStaff
2. Patient
3. MedicalStudy
4. Talon
5. DoctorAppointment
6. DoctorAppointment_MedicalStudy
7. Orden
8. Orden_MedicalStudy
9. Result
10. PaymentMethod
11. Payment

Each table includes foreign key constraints, timestamps, and type definitions for consistent data control.

---

## 💡 2️⃣ Key Differences from MySQL

### A) ENUM Types

PostgreSQL requires explicit type creation:

```sql
CREATE TYPE staff_role_enum AS ENUM ('admin', 'receptionist', 'biochemist', 'labTechnician');
```

### B) Timestamps

- MySQL: `DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`
- PostgreSQL: `TIMESTAMP DEFAULT CURRENT_TIMESTAMP` + triggers for updates

### C) Procedures & Functions

- PostgreSQL uses `LANGUAGE plpgsql` with different syntax
- Functions are used instead of procedures
- Triggers require function definitions

### D) String Concatenation

- MySQL: `CONCAT(a, ' ', b)`
- PostgreSQL: `a || ' ' || b`

---

## ⚙️ 3️⃣ Execution Order

| Order | File                 | Description                       |
| :---: | :------------------- | :-------------------------------- |
|  1️⃣   | `00_init.sql`        | Initialize database               |
|  2️⃣   | `01_schema.sql`      | Create types and tables           |
|  3️⃣   | `02_indexes.sql`     | Create indexes for performance    |
|  4️⃣   | `03_constraints.sql` | Add foreign key constraints       |
|  5️⃣   | `04_views.sql`       | Create views                      |
|  6️⃣   | `05_functions.sql`   | (Empty - optional for future use) |
|  7️⃣   | `06_procedures.sql`  | Create functions/procedures       |
|  8️⃣   | `07_triggers.sql`    | Create triggers                   |
|  9️⃣   | `08_roles.sql`       | Create roles                      |
|  🔟   | `09_grants.sql`      | Grant permissions                 |
| 1️⃣1️⃣  | `10_seed.sql`        | Load seed data from CSV files     |

---

## 🐳 4️⃣ Docker Integration

### Running with Docker Compose

```bash
docker-compose up -d
```

The `docker-compose.yml` automatically:

- Creates a PostgreSQL 16 container
- Initializes the database with scripts from `init/script/`
- Sets up volumes for data persistence

### Environment Variables

Create a `.env` file:

```env
POSTGRES_DB=lab_db_sql
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password
POSTGRES_PORT=5432
```

---

## 🔧 5️⃣ Manual Setup (Without Docker)

If running PostgreSQL locally:

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE lab_db_sql ENCODING 'UTF8';

# Connect to database
\c lab_db_sql

# Execute initialization scripts in order
\i init/script/00_init.sql
\i init/script/01_schema.sql
\i init/script/02_indexes.sql
\i init/script/03_constraints.sql
\i init/script/04_views.sql
\i init/script/06_procedures.sql
\i init/script/07_triggers.sql
\i init/script/08_roles.sql
\i init/script/09_grants.sql
\i init/script/10_seed.sql
```

---

## 📊 6️⃣ Database Views

The following views are available for common queries:

- `vw_patient_results` - Patient results with appointment and study info
- `vw_patient_appointments` - Patient appointments with study details
- `vw_patient_results_summary` - Quick view of patient results
- `vw_patient_appointments_summary` - Quick view of appointments
- `vw_doctorappointments_by_day` - Appointments organized by date
- `vw_doctorappointments_by_medicalstudy` - Appointments grouped by study
- `vw_pending_doctorappointments` - Incomplete appointments
- `vw_medical_study_monthly_income` - Monthly income by study
- `vw_results_by_status` - Results grouped by status

---

## 🔐 7️⃣ Security & Roles

### Backend Role

A `backend_role` is created with standard permissions:

- SELECT, INSERT, UPDATE, DELETE on all tables
- EXECUTE on all functions
- Usage on sequences

### Granting Access

```bash
# Create a backend user and assign role
CREATE USER backend_user WITH PASSWORD 'secure_password';
GRANT backend_role TO backend_user;
```

---

## 🧾 8️⃣ CSV Data Files

Seed data files should be placed in `init/data/`:

- `medical_studies.csv` - Medical studies catalog
- `payment_methods.csv` - Payment methods
- `patients.csv` - Patient records
- `LabStaff.csv` - Laboratory staff
- `DoctorAppointment.csv` - Appointments
- `Talon.csv` - Vouchers
- `DoctorAppointment_MedicalStudy.csv` - Appointment-study relationships
- `Payment.csv` - Payment records

**CSV Encoding:** UTF-8 without BOM  
**Format:** Header row required, comma-separated values

---

## ✅ Summary

This PostgreSQL setup provides a **modular and production-ready** initialization workflow for your lab management database, ensuring:

- ✅ Consistent structure and data types
- ✅ Data integrity through constraints and triggers
- ✅ Automatic timestamp management
- ✅ Easy Docker deployment
- ✅ Clear role-based access control

---

## 📝 Notes

- All scripts are idempotent (safe to run multiple times)
- Foreign key constraints are enforced
- Triggers automatically update `updated_at` timestamps
- ENUM types are database-level, not application-level
- Views simplify complex queries

---

© 2025 Laboratory System PostgreSQL Database Setup Guide
# Lab-System-PostgreSQL
