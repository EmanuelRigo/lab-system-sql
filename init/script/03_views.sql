
USE lab_db_sql;

CREATE VIEW TalonWithReceptionistAndPatient AS
SELECT
  t._id,          
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
JOIN LabStaff r ON t.receptionist_id = r._id
JOIN DoctorAppointment da ON da.talon_id = t._id
JOIN Patient p ON da.patient_id = p._id;

--

CREATE VIEW DoctorAppointmentWithDetails AS
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
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id;

--


CREATE VIEW DoctorAppointmentWithReceptionist AS
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
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id
JOIN LabStaff r
    ON da.receptionist_id = r._id;

--

CREATE VIEW PaidDoctorAppointments AS
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
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id
WHERE da.is_paid = TRUE;


-- SELECT * 
-- FROM PaidDoctorAppointments
-- WHERE medical_study_name = 'Hemograma';

--


-- -- Citas con datos del paciente y estudio
-- CREATE OR REPLACE VIEW v_appointments_full AS
-- SELECT
--   da.id              AS appointment_id,
--   da.date,
--   da.status,
--   da.isPaid,
--   p.id               AS patient_id,
--   CONCAT(p.firstname,' ',p.lastname) AS patient_name,
--   ms.id              AS study_id,
--   ms.name            AS study_name,
--   da.talonID,
--   da.resultID
-- FROM DoctorAppointment da
-- JOIN Patient p      ON p.id = da.patientID
-- JOIN MedicalStudy ms ON ms.id = da.medicalStudyID;

-- -- Historial por paciente
-- CREATE OR REPLACE VIEW v_patient_history AS
-- SELECT
--   p.id AS patient_id,
--   CONCAT(p.firstname,' ',p.lastname) AS patient_name,
--   da.id AS appointment_id,
--   da.date,
--   ms.name AS study_name,
--   da.status,
--   da.isPaid
-- FROM Patient p
-- JOIN DoctorAppointment da ON da.patientID = p.id
-- JOIN MedicalStudy ms ON ms.id = da.medicalStudyID
-- ORDER BY da.date DESC;

-- -- Resultados listos con bioquímico
-- CREATE OR REPLACE VIEW v_results_full AS
-- SELECT
--   r.id AS result_id,
--   r.created_at,
--   r.description,
--   ls.id AS biochemist_id,
--   CONCAT(ls.firstname,' ',ls.lastname) AS biochemist_name
-- FROM Result r
-- JOIN LabStaff ls ON ls.id = r.biochemistID;
