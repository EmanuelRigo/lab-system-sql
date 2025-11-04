-- ==========================================================
-- 09_grants.sql
-- 🔐 Asignación de privilegios y roles a usuarios
-- ==========================================================

USE lab_db_sql;

-- ADMIN
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.LabStaff TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.MedicalStudy TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.PaymentMethod TO admin;
GRANT SELECT ON lab_db_sql.Result TO admin;
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Patient TO admin;
GRANT SELECT ON lab_db_sql.Orden TO admin;
GRANT SELECT ON lab_db_sql.DoctorAppointment TO admin;
GRANT SELECT ON lab_db_sql.Talon TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Payment TO admin;

-- RECEPTIONIST
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Patient TO receptionist;
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.DoctorAppointment TO receptionist;
GRANT SELECT ON lab_db_sql.MedicalStudy TO receptionist;
GRANT SELECT, INSERT ON lab_db_sql.Payment TO receptionist;
-- GRANT SELECT ON lab_db_sql.v_appointments_full TO receptionist;

-- LAB TECHNICIAN
GRANT SELECT ON lab_db_sql.Patient TO lab_technician;
GRANT SELECT, UPDATE ON lab_db_sql.Result TO lab_technician;
GRANT SELECT ON lab_db_sql.MedicalStudy TO lab_technician;
GRANT SELECT ON lab_db_sql.DoctorAppointment TO lab_technician;

-- BIOCHEMIST
GRANT SELECT ON lab_db_sql.Patient TO biochemist;
GRANT SELECT, UPDATE ON lab_db_sql.Result TO biochemist;
GRANT SELECT ON lab_db_sql.MedicalStudy TO biochemist;
GRANT SELECT ON lab_db_sql.DoctorAppointment TO biochemist;

-- Asignación de roles a usuarios
GRANT admin TO 'admin_user'@'localhost';
GRANT receptionist TO 'receptionist_user'@'localhost';
GRANT lab_technician TO 'lab_user'@'localhost';
GRANT biochemist TO 'biochemist_user'@'localhost';

-- Configurar roles por defecto
SET DEFAULT ROLE admin TO 'admin_user'@'localhost';
SET DEFAULT ROLE receptionist TO 'receptionist_user'@'localhost';
SET DEFAULT ROLE lab_technician TO 'lab_user'@'localhost';
SET DEFAULT ROLE biochemist TO 'biochemist_user'@'localhost';

-- Aplicar cambios
FLUSH PRIVILEGES;
