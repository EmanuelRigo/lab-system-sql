USE lab_db_sql;

-- Result
CREATE INDEX idx_result_biochemistID ON Result(biochemist_id);

-- DoctorAppointment
CREATE INDEX idx_da_patientID        ON DoctorAppointment(patient_id);
CREATE INDEX idx_da_medicalStudyID   ON DoctorAppointment(medical_study_id);
CREATE INDEX idx_da_receptionistID   ON DoctorAppointment(receptionist_id);
CREATE INDEX idx_da_talonID          ON DoctorAppointment(talon_id);
CREATE INDEX idx_da_date             ON DoctorAppointment(date);

-- Talon
CREATE INDEX idx_talon_receptionistID ON Talon(receptionist_id);

-- Payment
CREATE INDEX idx_pay_talonID         ON Payment(talon_id);
