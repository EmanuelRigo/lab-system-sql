-- Eliminación de roles existentes si los hay
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS patient;
DROP ROLE IF EXISTS doctor;

-- Creación de roles principales
CREATE ROLE admin;
-- Permisos específicos para admin
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.LabStaff TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.MedicalStudy TO admin;
GRANT SELECT ON lab_system.Result TO admin;
GRANT SELECT, INSERT, UPDATE ON lab_system.Patient TO admin;
-- Otros permisos generales necesarios
GRANT SELECT ON lab_system.* TO admin;

-- Resto de roles
CREATE ROLE patient;
-- Permisos específicos para patient
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.LabStaff TO patient;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.MedicalStudy TO patient;
GRANT SELECT ON lab_system.Result TO patient;
GRANT SELECT, INSERT, UPDATE ON lab_system.Patient TO patient;
-- Otros permisos generales necesarios
GRANT SELECT ON lab_system.* TO patient;

CREATE ROLE doctor;
-- Permisos específicos para doctor
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.LabStaff TO doctor;
GRANT SELECT, INSERT, UPDATE, DELETE ON lab_system.MedicalStudy TO doctor;
GRANT SELECT ON lab_system.Result TO doctor;
GRANT SELECT, INSERT, UPDATE ON lab_system.Patient TO doctor;
-- Otros permisos generales necesarios
GRANT SELECT ON lab_system.* TO doctor;