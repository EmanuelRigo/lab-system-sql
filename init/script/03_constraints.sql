USE lab_db_sql;

-- ==========================================================
-- 🔗 RELACIONES ENTRE TABLAS (FOREIGN KEYS)
-- ==========================================================

-- Talon → LabStaff
ALTER TABLE Talon
ADD CONSTRAINT fk_talon_receptionist
FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id);

-- DoctorAppointment → Talon, Patient, LabStaff
ALTER TABLE DoctorAppointment
ADD CONSTRAINT fk_appointment_talon FOREIGN KEY (talon_id) REFERENCES Talon(_id),
ADD CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES Patient(_id),
ADD CONSTRAINT fk_appointment_receptionist FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id);

-- DoctorAppointment_MedicalStudy
ALTER TABLE DoctorAppointment_MedicalStudy
ADD CONSTRAINT fk_doctorstudy_appointment FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id)
  ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT fk_doctorstudy_study FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Orden → DoctorAppointment
ALTER TABLE Orden
ADD CONSTRAINT fk_orden_appointment FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id);

-- Orden_MedicalStudy
ALTER TABLE Orden_MedicalStudy
ADD CONSTRAINT fk_ordenstudy_orden FOREIGN KEY (orden_id) REFERENCES Orden(_id),
ADD CONSTRAINT fk_ordenstudy_study FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id);

-- Result → Orden, MedicalStudy, LabStaff
ALTER TABLE Result
ADD CONSTRAINT fk_result_orden FOREIGN KEY (orden_id) REFERENCES Orden(_id),
ADD CONSTRAINT fk_result_study FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id),
ADD CONSTRAINT fk_result_biochemist FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id),
ADD CONSTRAINT fk_result_labtech FOREIGN KEY (labtechnician_id) REFERENCES LabStaff(_id);

-- Payment → Talon, PaymentMethod
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_talon FOREIGN KEY (talon_id) REFERENCES Talon(_id),
ADD CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(_id);

-- ==========================================================
-- 🧩 CLAVES ÚNICAS ADICIONALES
-- ==========================================================
ALTER TABLE Result
ADD UNIQUE KEY uk_orden_study (orden_id, medical_study_id);
