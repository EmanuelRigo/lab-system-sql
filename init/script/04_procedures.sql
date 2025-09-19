-- USE lab_db_sql;

-- -- ==========================================================
-- -- 1. Crear roles (si no existen)
-- -- ==========================================================
-- CREATE ROLE IF NOT EXISTS role_admin;
-- CREATE ROLE IF NOT EXISTS role_receptionist;
-- CREATE ROLE IF NOT EXISTS role_lab_technician;
-- CREATE ROLE IF NOT EXISTS role_biochemist;

-- -- ==========================================================
-- -- 2. Permisos por rol
-- -- ==========================================================

-- -- Admin: acceso amplio
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.MedicalStudy      TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Result            TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.LabStaff          TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Patient           TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.DoctorAppointment TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Payment           TO role_admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Talon             TO role_admin;

-- -- Receptionist: gestión de pacientes, citas, talones y pagos
-- GRANT SELECT                                 ON lab_db_sql.MedicalStudy      TO role_receptionist;
-- GRANT SELECT                                 ON lab_db_sql.Result            TO role_receptionist;
-- GRANT SELECT, INSERT, UPDATE                 ON lab_db_sql.Patient           TO role_receptionist;
-- GRANT SELECT, INSERT, UPDATE                 ON lab_db_sql.DoctorAppointment TO role_receptionist;
-- GRANT SELECT, INSERT                         ON lab_db_sql.Payment           TO role_receptionist;
-- GRANT SELECT, INSERT                         ON lab_db_sql.Talon             TO role_receptionist;

-- -- Lab Technician: resultados y citas
-- GRANT SELECT                                 ON lab_db_sql.MedicalStudy      TO role_lab_technician;
-- GRANT SELECT, INSERT, UPDATE                 ON lab_db_sql.Result            TO role_lab_technician;
-- GRANT SELECT, UPDATE                         ON lab_db_sql.DoctorAppointment TO role_lab_technician;

-- -- Biochemist: resultados
-- GRANT SELECT, INSERT, UPDATE                 ON lab_db_sql.Result            TO role_biochemist;

-- -- ==========================================================
-- -- 3. Crear usuarios de aplicación
-- -- ==========================================================
-- CREATE USER IF NOT EXISTS 'app_admin'@'%'     IDENTIFIED BY 'ChangeMe_admin!';
-- CREATE USER IF NOT EXISTS 'app_frontdesk'@'%' IDENTIFIED BY 'ChangeMe_frontdesk!';
-- CREATE USER IF NOT EXISTS 'app_biochem'@'%'   IDENTIFIED BY 'ChangeMe_biochem!';

-- -- ==========================================================
-- -- 4. Asignar roles a los usuarios
-- -- ==========================================================
-- GRANT role_admin       TO 'app_admin'@'%';
-- GRANT role_receptionist TO 'app_frontdesk'@'%';
-- GRANT role_biochemist   TO 'app_biochem'@'%';

-- -- ==========================================================
-- -- 5. Aplicar cambios
-- -- ==========================================================
-- FLUSH PRIVILEGES;