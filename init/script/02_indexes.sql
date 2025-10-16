-- USE lab_db_sql;

-- -- ==========================================================
-- -- ✅ Script de Índices Optimizado
-- -- ==========================================================

-- -- ==========================================================
-- -- Tabla: Result
-- -- NOTA: El UNIQUE KEY (orden_id, medical_study_id) ya crea un índice eficiente para orden_id.
-- -- ==========================================================
-- CREATE INDEX idx_result_biochemist_id   ON Result(biochemist_id);
-- CREATE INDEX idx_result_labtechnician_id ON Result(labtechnician_id);
-- -- El índice en (orden_id, medical_study_id) no se añade ya que el UNIQUE KEY lo cubre.


-- -- ==========================================================
-- -- Tabla: DoctorAppointment
-- -- ==========================================================
-- CREATE INDEX idx_da_patient_id        ON DoctorAppointment(patient_id);
-- CREATE INDEX idx_da_receptionist_id   ON DoctorAppointment(receptionist_id);
-- CREATE INDEX idx_da_talon_id          ON DoctorAppointment(talon_id);
-- CREATE INDEX idx_da_date              ON DoctorAppointment(date);
-- CREATE INDEX idx_da_status            ON DoctorAppointment(status);


-- -- ==========================================================
-- -- Tabla: Talon
-- -- ==========================================================
-- CREATE INDEX idx_talon_receptionist_id ON Talon(receptionist_id);
-- CREATE INDEX idx_talon_is_paid         ON Talon(is_paid);


-- -- ==========================================================
-- -- Tabla: Payment
-- -- ==========================================================
-- CREATE INDEX idx_payment_talon_id          ON Payment(talon_id);
-- CREATE INDEX idx_payment_payment_method_id ON Payment(payment_method_id);


-- -- ==========================================================
-- -- Tabla: Orden
-- -- ==========================================================
-- CREATE INDEX idx_orden_doctor_appointment_id ON Orden(doctor_appointment_id);


-- -- ==========================================================
-- -- Tabla: Orden_MedicalStudy (relación muchos a muchos)
-- -- NOTA: La PK (orden_id, medical_study_id) ya cubre la búsqueda por orden_id.
-- -- ==========================================================
-- -- CREATE INDEX idx_oms_orden_id ON Orden_MedicalStudy(orden_id); <-- REDUNDANTE CON PK
-- CREATE INDEX idx_oms_medical_study_id  ON Orden_MedicalStudy(medical_study_id);


-- -- ==========================================================
-- -- Tabla: Patient
-- -- ==========================================================
-- CREATE UNIQUE INDEX idx_patient_dni           ON Patient(dni); -- DNI ya es UNIQUE en el CREATE TABLE, pero forzar el índice explícito es bueno.
-- CREATE INDEX idx_patient_lastname      ON Patient(lastname);


-- -- ==========================================================
-- -- Tabla: LabStaff
-- -- ==========================================================
-- CREATE INDEX idx_labstaff_role         ON LabStaff(role);
-- CREATE INDEX idx_labstaff_is_online    ON LabStaff(is_online);