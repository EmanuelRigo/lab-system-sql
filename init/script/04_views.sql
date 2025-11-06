USE lab_db_sql;

-- 1. Asegúrate de que el delimitador por defecto (;) esté activo.
-- Si has ejecutado procedimientos o triggers antes, deberías tener: DELIMITER ;

DROP VIEW IF EXISTS vw_patient_results;

CREATE VIEW vw_patient_results AS
SELECT
    -- Información del Paciente
    p._id AS patient_id,
    p.dni,
    p.firstname,
    p.lastname,
    p.birth_date,
    p.phone,

    -- Información de la Cita
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.status AS appointment_status,

    -- Información de la Orden
    o._id AS orden_id,

    -- Información del Estudio y el Resultado
    ms.name AS study_name,
    ms._id AS study_id,
    
    r._id AS result_id,
    r.status AS result_status,
    r.result AS result_value,
    r.description AS result_description,
    r.extraction_date,
    
    -- Personal involucrado (opcional)
    r.labtechnician_id,
    r.biochemist_id
    
    
    
FROM Patient p
JOIN DoctorAppointment da ON da.patient_id = p._id
JOIN Orden o ON o.doctor_appointment_id = da._id
JOIN Result r ON r.orden_id = o._id
JOIN MedicalStudy ms ON ms._id = r.medical_study_id
ORDER BY p.lastname, da.date DESC, ms.name; -- El ORDER BY dentro de una VIEW es ignorado por algunas versiones de MySQL, pero es válido.



USE lab_db_sql;

DROP VIEW IF EXISTS vw_patient_appointments;

CREATE VIEW vw_patient_appointments AS
SELECT
    -- Información de la Cita (El foco principal)
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.status AS appointment_status,
    da.reason,
    da.is_paid,
    
    -- Información del Paciente
    p.dni,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    
    -- Información del Estudio
    ms.name AS study_name,
    ms.price AS study_price,
    
    -- Información del Talón
    t._id AS talon_id,
    t.total_amount,
    
    -- Información del Personal
    ls.firstname AS receptionist_firstname,
    ls.lastname AS receptionist_lastname
    
FROM Patient p
JOIN DoctorAppointment da ON da.patient_id = p._id -- Une Paciente con Cita
JOIN LabStaff ls ON da.receptionist_id = ls._id -- Une con Recepcionista
LEFT JOIN Talon t ON da.talon_id = t._id -- Une con Talón (puede ser NULL si no está asignado)
LEFT JOIN DoctorAppointment_MedicalStudy dams ON da._id = dams.doctor_appointment_id -- Une con Estudios
LEFT JOIN MedicalStudy ms ON dams.medical_study_id = ms._id -- Obtiene el nombre del Estudio
ORDER BY p.lastname, da.date DESC;


-- ==========================================================
-- 04. VISTAS (Views)
-- ==========================================================
DROP VIEW IF EXISTS vw_patient_results_summary;

CREATE VIEW vw_patient_results_summary AS
SELECT
    p._id AS patient_id,
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    ms.name AS medical_study_name,
    r.extraction_date,
    r.result,
    r.status
FROM Patient p
JOIN DoctorAppointment da ON da.patient_id = p._id
JOIN Orden o ON o.doctor_appointment_id = da._id
JOIN Result r ON r.orden_id = o._id
JOIN MedicalStudy ms ON ms._id = r.medical_study_id;


-- --==========================================================
-- -- 05. VISTAS (Views)

DROP VIEW IF EXISTS vw_patient_appointments_summary;

CREATE VIEW vw_patient_appointments_summary AS
SELECT
    p._id AS patient_id,
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.reason,
    da.status AS appointment_status,
    da.is_paid,
    ms.name AS medical_study_name,
    ms.price AS study_price,
    t._id AS talon_id,
    t.total_amount
FROM Patient p
JOIN DoctorAppointment da ON da.patient_id = p._id
LEFT JOIN Talon t ON da.talon_id = t._id
LEFT JOIN DoctorAppointment_MedicalStudy dams ON da._id = dams.doctor_appointment_id
LEFT JOIN MedicalStudy ms ON ms._id = dams.medical_study_id
ORDER BY da.date DESC;


-- ==========================================================
-- 06. VISTAS (Views)

DROP VIEW IF EXISTS vw_doctorappointments_by_day;
CREATE VIEW vw_doctorappointments_by_day AS
SELECT
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.reason,
    da.status AS appointment_status,
    da.is_paid,
    p._id AS patient_id,
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    p.dni,
    p.phone,
    ls._id AS receptionist_id,
    CONCAT(ls.firstname, ' ', ls.lastname) AS receptionist_name,
    ms.name AS medical_study_name,
    ms.price AS study_price,
    t._id AS talon_id,
    t.total_amount
FROM DoctorAppointment da
JOIN Patient p ON da.patient_id = p._id
LEFT JOIN LabStaff ls ON da.receptionist_id = ls._id
LEFT JOIN Talon t ON da.talon_id = t._id
LEFT JOIN DoctorAppointment_MedicalStudy dams ON da._id = dams.doctor_appointment_id
LEFT JOIN MedicalStudy ms ON ms._id = dams.medical_study_id;

-- ==========================================================
-- 07. VISTAS (Views)

DROP VIEW IF EXISTS vw_doctorappointments_by_medicalstudy;
CREATE VIEW vw_doctorappointments_by_medicalstudy AS
SELECT
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.reason,
    da.status AS appointment_status,
    da.is_paid,
    p._id AS patient_id,
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    p.dni,
    p.phone,
    ms._id AS medical_study_id,
    ms.name AS medical_study_name,
    ms.price AS study_price,
    ls._id AS receptionist_id,
    CONCAT(ls.firstname, ' ', ls.lastname) AS receptionist_name,
    t._id AS talon_id,
    t.total_amount
FROM DoctorAppointment da
JOIN Patient p ON da.patient_id = p._id
LEFT JOIN LabStaff ls ON da.receptionist_id = ls._id
LEFT JOIN Talon t ON da.talon_id = t._id
LEFT JOIN DoctorAppointment_MedicalStudy dams ON da._id = dams.doctor_appointment_id
LEFT JOIN MedicalStudy ms ON ms._id = dams.medical_study_id;

-- ==========================================================
-- 08. VISTAS (Views)

DROP VIEW IF EXISTS vw_pending_doctorappointments;

CREATE VIEW vw_pending_doctorappointments AS
SELECT
    da._id AS appointment_id,
    da.date AS appointment_date,
    da.status AS appointment_status,
    da.reason,
    da.is_paid,
    p._id AS patient_id,
    p.dni,
    CONCAT(p.firstname, ' ', p.lastname) AS patient_name,
    p.phone,
    ls._id AS receptionist_id,
    CONCAT(ls.firstname, ' ', ls.lastname) AS receptionist_name,
    ms._id AS medical_study_id,
    ms.name AS medical_study_name,
    t._id AS talon_id,
    t.total_amount
FROM DoctorAppointment da
JOIN Patient p ON da.patient_id = p._id
LEFT JOIN LabStaff ls ON da.receptionist_id = ls._id
LEFT JOIN Talon t ON da.talon_id = t._id
LEFT JOIN DoctorAppointment_MedicalStudy dams ON da._id = dams.doctor_appointment_id
LEFT JOIN MedicalStudy ms ON ms._id = dams.medical_study_id
WHERE da.status <> 'completed';

-- ==========================================================
-- 09. VISTAS (Views)

DROP VIEW IF EXISTS vw_medical_study_monthly_income;

CREATE VIEW vw_medical_study_monthly_income AS
SELECT
  ms._id AS medical_study_id,
  ms.name AS medical_study_name,
  YEAR(da.`date`) AS year,
  MONTH(da.`date`) AS month,
  SUM(ms.price) AS total_income
FROM DoctorAppointment da
JOIN DoctorAppointment_MedicalStudy dam 
  ON da._id = dam.doctor_appointment_id
JOIN MedicalStudy ms 
  ON ms._id = dam.medical_study_id
GROUP BY
  ms._id,
  ms.name,
  YEAR(da.`date`),
  MONTH(da.`date`);

--
-- ==========================================================
-- 10. VISTAS (Views)

DROP VIEW IF EXISTS vw_results_by_status;

CREATE VIEW vw_results_by_status AS
SELECT
  r._id AS result_id,
  r.status,
  r.result,
  r.description,
  r.extraction_date,
  r.created_at,
  r.updated_at,
  ms._id AS medical_study_id,
  ms.name AS medical_study_name,
  CONCAT(lt.firstname, ' ', lt.lastname) AS labtechnician_name,
  CONCAT(bc.firstname, ' ', bc.lastname) AS biochemist_name
FROM Result r
JOIN MedicalStudy ms ON r.medical_study_id = ms._id
LEFT JOIN LabStaff lt ON r.labtechnician_id = lt._id
LEFT JOIN LabStaff bc ON r.biochemist_id = bc._id;

