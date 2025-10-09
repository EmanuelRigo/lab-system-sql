USE lab_db_sql;

-- ==========================================================
-- VIEW 1: TalonWithReceptionistAndPatient
-- Descripción:
-- Muestra información de cada Talon junto con los datos del 
-- recepcionista que lo creó y el paciente asociado al turno 
-- (DoctorAppointment) vinculado.
-- ==========================================================
CREATE OR REPLACE VIEW TalonWithReceptionistAndPatient AS
SELECT
  t._id AS talon_id,          
  t.is_paid,
  t.total_amount,
  t.created_at   AS talon_created_at,
  t.updated_at   AS talon_updated_at,
  r.firstname    AS receptionist_firstname,
  r.lastname     AS receptionist_lastname,
  p.firstname    AS patient_firstname,
  p.lastname     AS patient_lastname,
  p.phone        AS patient_phone
FROM Talon t
JOIN LabStaff r 
  ON t.receptionist_id = r._id
JOIN DoctorAppointment da 
  ON da.talon_id = t._id
JOIN Patient p 
  ON da.patient_id = p._id;


-- ==========================================================
-- VIEW 2: DoctorAppointmentWithDetails
-- Descripción:
-- Muestra los turnos médicos con datos del paciente y los 
-- estudios médicos vinculados a través de las tablas 
-- Orden y Orden_MedicalStudy.
-- ==========================================================
CREATE OR REPLACE VIEW DoctorAppointmentWithDetails AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN Orden o 
    ON o.doctor_appointment_id = da._id
JOIN Orden_MedicalStudy oms 
    ON oms.orden_id = o._id
JOIN MedicalStudy ms 
    ON ms._id = oms.medical_study_id;


-- ==========================================================
-- VIEW 3: DoctorAppointmentWithReceptionist
-- Descripción:
-- Muestra los turnos médicos junto con el paciente, 
-- los estudios asociados y el recepcionista que registró el turno.
-- ==========================================================
CREATE OR REPLACE VIEW DoctorAppointmentWithReceptionist AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name,
    r.firstname AS receptionist_firstname,
    r.lastname AS receptionist_lastname
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN Orden o 
    ON o.doctor_appointment_id = da._id
JOIN Orden_MedicalStudy oms 
    ON oms.orden_id = o._id
JOIN MedicalStudy ms 
    ON ms._id = oms.medical_study_id
JOIN LabStaff r
    ON da.receptionist_id = r._id;


-- ==========================================================
-- VIEW 4: PaidDoctorAppointments
-- Descripción:
-- Lista únicamente los turnos médicos que han sido pagados,
-- junto con la información del paciente y los estudios asociados.
-- ==========================================================
CREATE OR REPLACE VIEW PaidDoctorAppointments AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN Orden o 
    ON o.doctor_appointment_id = da._id
JOIN Orden_MedicalStudy oms 
    ON oms.orden_id = o._id
JOIN MedicalStudy ms 
    ON ms._id = oms.medical_study_id
WHERE da.is_paid = TRUE;

-- Ejemplo de consulta:
-- SELECT * FROM PaidDoctorAppointments WHERE medical_study_name = 'Hemograma';
