USE lab_db_sql;

-- Citas con datos del paciente y estudio
CREATE OR REPLACE VIEW v_appointments_full AS
SELECT
  da.id              AS appointment_id,
  da.date,
  da.status,
  da.isPaid,
  p.id               AS patient_id,
  CONCAT(p.firstname,' ',p.lastname) AS patient_name,
  ms.id              AS study_id,
  ms.name            AS study_name,
  da.talonID,
  da.resultID
FROM DoctorAppointment da
JOIN Patient p      ON p.id = da.patientID
JOIN MedicalStudy ms ON ms.id = da.medicalStudyID;

-- Historial por paciente
CREATE OR REPLACE VIEW v_patient_history AS
SELECT
  p.id AS patient_id,
  CONCAT(p.firstname,' ',p.lastname) AS patient_name,
  da.id AS appointment_id,
  da.date,
  ms.name AS study_name,
  da.status,
  da.isPaid
FROM Patient p
JOIN DoctorAppointment da ON da.patientID = p.id
JOIN MedicalStudy ms ON ms.id = da.medicalStudyID
ORDER BY da.date DESC;

-- Resultados listos con bioquímico
CREATE OR REPLACE VIEW v_results_full AS
SELECT
  r.id AS result_id,
  r.created_at,
  r.description,
  ls.id AS biochemist_id,
  CONCAT(ls.firstname,' ',ls.lastname) AS biochemist_name
FROM Result r
JOIN LabStaff ls ON ls.id = r.biochemistID;
