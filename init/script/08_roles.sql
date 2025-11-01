-- Eliminación de roles existentes si los hay
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS receptionist;
DROP ROLE IF EXISTS lab_technician;
DROP ROLE IF EXISTS biochemist;

-- Creación de roles principales
-- ADMIN
CREATE ROLE admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.LabStaff TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.MedicalStudy TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.PaymentMethod TO admin;
GRANT SELECT ON lab_system.Result TO admin;
GRANT SELECT, INSERT, UPDATE ON lab_system.Patient TO admin;
GRANT SELECT ON lab_system.Orden TO admin;
GRANT SELECT ON lab_system.DoctorAppointment TO admin;
GRANT SELECT ON lab_system.Talon TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.Payment TO admin;


CREATE ROLE receptionist;
GRANT SELECT, INSERT, UPDATE ON lab_system.Patient TO receptionist;
GRANT SELECT, INSERT, UPDATE ON lab_system.Appointment TO receptionist;
GRANT SELECT ON lab_system.TestType TO receptionist;
GRANT SELECT ON lab_system.Price TO receptionist;
GRANT SELECT, INSERT ON lab_system.Payment TO receptionist;
GRANT SELECT, INSERT ON lab_system.Invoice TO receptionist;
GRANT SELECT ON lab_system.v_appointments_full TO receptionist;

CREATE ROLE lab_technician;
GRANT SELECT ON lab_system.Patient TO lab_technician;
GRANT SELECT, UPDATE ON lab_system.Sample TO lab_technician;
GRANT SELECT, INSERT ON lab_system.Result TO lab_technician;
GRANT SELECT ON lab_system.TestType TO lab_technician;
GRANT SELECT, UPDATE ON lab_system.Inventory TO lab_technician;
GRANT SELECT ON lab_system.Appointment TO lab_technician;

CREATE ROLE biochemist;
GRANT SELECT ON lab_system.Patient TO biochemist;
GRANT SELECT, UPDATE ON lab_system.Result TO biochemist;
GRANT SELECT ON lab_system.Sample TO biochemist;
GRANT SELECT ON lab_system.TestType TO biochemist;
GRANT INSERT, UPDATE ON lab_system.ReferenceValues TO biochemist;
GRANT SELECT ON lab_system.Appointment TO biochemist;

-- Creación de usuarios ejemplo
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER IF NOT EXISTS 'receptionist_user'@'localhost' IDENTIFIED BY 'recep123';
CREATE USER IF NOT EXISTS 'lab_user'@'localhost' IDENTIFIED BY 'lab123';
CREATE USER IF NOT EXISTS 'biochemist_user'@'localhost' IDENTIFIED BY 'bio123';

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