USE lab_db_sql;

-- Result
CREATE INDEX idx_result_biochemistID ON Result(biochemistID);

-- DoctorAppointment
CREATE INDEX idx_da_patientID        ON DoctorAppointment(patientID);
CREATE INDEX idx_da_medicalStudyID   ON DoctorAppointment(medicalStudyID);
CREATE INDEX idx_da_resultID         ON DoctorAppointment(resultID);
CREATE INDEX idx_da_receptionistID   ON DoctorAppointment(ReceptionistID);
CREATE INDEX idx_da_talonID          ON DoctorAppointment(talonID);
CREATE INDEX idx_da_date             ON DoctorAppointment(date);

-- Talon
CREATE INDEX idx_talon_dappointmentID ON Talon(DAppointmentID);
CREATE INDEX idx_talon_receptionistID ON Talon(ReceptionistID);

-- Payment
CREATE INDEX idx_pay_talonID         ON Payment(TalonID);
CREATE INDEX idx_pay_receptionistID  ON Payment(ReceptionistID);
