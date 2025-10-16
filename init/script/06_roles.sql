-- USE lab_db_sql;

-- -- Roles (MySQL 8+)
-- CREATE ROLE IF NOT EXISTS admin;
-- CREATE ROLE IF NOT EXISTS receptionist;
-- CREATE ROLE IF NOT EXISTS lab_technician;
-- CREATE ROLE IF NOT EXISTS biochemist;

-- -- Permisos por rol

-- -- Admin: todo
-- GRANT SELECT, INSERT, UPDATE         ON lab_db_sql.MedicalStudy        TO admin;
-- GRANT SELECT                         ON lab_db_sql.Result              TO admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.LabStaff            TO admin;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON lab_db_sql.Patient             TO admin;
-- GRANT SELECT,         UPDATE         ON lab_db_sql.DoctorAppointment   TO admin;
-- GRANT SELECT,                        ON lab_db_sql.Payment             TO admin;
-- GRANT SELECT,                        ON lab_db_sql.Talon               TO admin;

-- -- Receptionist: pacientes, citas, talones, pagos (CRUD básico)
-- GRANT SELECT                         ON lab_db_sql.MedicalStudy        TO receptionist;
-- GRANT SELECT                         ON lab_db_sql.Result              TO receptionist;
-- GRANT SELECT, INSERT, UPDATE         ON lab_db_sql.Patient             TO receptionist;
-- GRANT SELECT, INSERT, UPDATE         ON lab_db_sql.DoctorAppointment   TO receptionist;
-- GRANT SELECT, INSERT                 ON lab_db_sql.Payment             TO receptionist;
-- GRANT SELECT, INSERT                 ON lab_db_sql.Talon               TO receptionist;
-- -- GRANT SELECT                      ON lab_db_sql.v_appointments_full TO receptionist;

-- -- LabTechnician: pacientes, citas, talones, pagos (CRUD básico)
-- GRANT SELECT                         ON lab_db_sql.MedicalStudy        TO receptionist;
-- GRANT SELECT, INSERT, UPDATE         ON lab_db_sql.Result              TO receptionist;
-- GRANT SELECT,         UPDATE         ON lab_db_sql.DoctorAppointment   TO receptionist;

-- -- Biochemist: resultados (crear/editar) y lectura de lo demás
-- GRANT SELECT, INSERT, UPDATE         ON lab_db_sql.Result              TO biochemist;

-- -- Usuarios de ejemplo (cámbiales la contraseña)
-- CREATE USER IF NOT EXISTS 'app_admin'@'%' IDENTIFIED BY 'ChangeMe_admin!';
-- CREATE USER IF NOT EXISTS 'app_frontdesk'@'%' IDENTIFIED BY 'ChangeMe_frontdesk!';
-- CREATE USER IF NOT EXISTS 'app_biochem'@'%' IDENTIFIED BY 'ChangeMe_biochem!';

-- GRANT admin        TO 'app_admin'@'%';
-- GRANT receptionist TO 'app_frontdesk'@'%';
-- GRANT biochemist   TO 'app_biochem'@'%';

-- -- Que los roles queden activos por defecto
-- SET DEFAULT ROLE admin        TO 'app_admin'@'%';
-- SET DEFAULT ROLE receptionist TO 'app_frontdesk'@'%';
-- SET DEFAULT ROLE biochemist   TO 'app_biochem'@'%';
