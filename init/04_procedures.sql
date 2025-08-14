USE lab_db_sql;

-- Roles (MySQL 8+)
CREATE ROLE IF NOT EXISTS role_admin;
CREATE ROLE IF NOT EXISTS role_receptionist;
CREATE ROLE IF NOT EXISTS role_biochemist;

-- Permisos por rol
-- Admin: todo
GRANT ALL PRIVILEGES ON lab_db_sql.* TO role_admin;

-- Receptionist: pacientes, citas, talones, pagos (CRUD básico)
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Patient            TO role_receptionist;
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.DoctorAppointment  TO role_receptionist;
GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Talon              TO role_receptionist;
GRANT SELECT, INSERT        ON lab_db_sql.Payment            TO role_receptionist;
GRANT SELECT                ON lab_db_sql.MedicalStudy       TO role_receptionist;
GRANT SELECT                ON lab_db_sql.v_appointments_full TO role_receptionist;

-- Biochemist: resultados (crear/editar) y lectura de lo demás
GRANT SELECT                          ON lab_db_sql.Patient           TO role_biochemist;
GRANT SELECT                          ON lab_db_sql.DoctorAppointment TO role_biochemist;
GRANT SELECT, INSERT, UPDATE          ON lab_db_sql.Result            TO role_biochemist;
GRANT SELECT                          ON lab_db_sql.v_results_full    TO role_biochemist;

-- Usuarios de ejemplo (cámbiales la contraseña)
CREATE USER IF NOT EXISTS 'app_admin'@'%' IDENTIFIED BY 'ChangeMe_admin!';
CREATE USER IF NOT EXISTS 'app_frontdesk'@'%' IDENTIFIED BY 'ChangeMe_frontdesk!';
CREATE USER IF NOT EXISTS 'app_biochem'@'%' IDENTIFIED BY 'ChangeMe_biochem!';

GRANT role_admin        TO 'app_admin'@'%';
GRANT role_receptionist TO 'app_frontdesk'@'%';
GRANT role_biochemist   TO 'app_biochem'@'%';

-- Que los roles queden activos por defecto
SET DEFAULT ROLE role_admin        FOR 'app_admin'@'%';
SET DEFAULT ROLE role_receptionist FOR 'app_frontdesk'@'%';
SET DEFAULT ROLE role_biochemist   FOR 'app_biochem'@'%';
