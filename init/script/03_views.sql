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


