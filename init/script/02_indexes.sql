USE lab_db_sql;

-- ==========================================================
-- INDEXES para optimización de consultas
-- ==========================================================

-- ==========================================================
-- Tabla: Result
-- ==========================================================
-- Mejora las consultas que buscan resultados por bioquímico o técnico.
CREATE INDEX idx_result_biochemist_id   ON Result(biochemist_id);
CREATE INDEX idx_result_labtechnician_id ON Result(labtechnician_id);
CREATE INDEX idx_result_orden_id        ON Result(orden_id);
CREATE INDEX idx_result_medical_study_id ON Result(medical_study_id);


-- ==========================================================
-- Tabla: DoctorAppointment
-- ==========================================================
-- Índices clave para filtrar y unir por paciente, recepcionista o talón.
CREATE INDEX idx_da_patient_id        ON DoctorAppointment(patient_id);
CREATE INDEX idx_da_receptionist_id   ON DoctorAppointment(receptionist_id);
CREATE INDEX idx_da_talon_id          ON DoctorAppointment(talon_id);
CREATE INDEX idx_da_date              ON DoctorAppointment(date);
CREATE INDEX idx_da_status            ON DoctorAppointment(status);


-- ==========================================================
-- Tabla: Talon
-- ==========================================================
-- Permite búsquedas rápidas de talones por recepcionista o estado de pago.
CREATE INDEX idx_talon_receptionist_id ON Talon(receptionist_id);
CREATE INDEX idx_talon_is_paid         ON Talon(is_paid);


-- ==========================================================
-- Tabla: Payment
-- ==========================================================
-- Mejora el rendimiento en consultas sobre pagos por talón o método.
CREATE INDEX idx_payment_talon_id          ON Payment(talon_id);
CREATE INDEX idx_payment_payment_method_id ON Payment(payment_method_id);


-- ==========================================================
-- Tabla: Orden
-- ==========================================================
-- Facilita las consultas por turno médico (doctor_appointment_id).
CREATE INDEX idx_orden_doctor_appointment_id ON Orden(doctor_appointment_id);


-- ==========================================================
-- Tabla: Orden_MedicalStudy (relación muchos a muchos)
-- ==========================================================
-- Mejora las búsquedas de estudios por orden o viceversa.
CREATE INDEX idx_oms_orden_id          ON Orden_MedicalStudy(orden_id);
CREATE INDEX idx_oms_medical_study_id  ON Orden_MedicalStudy(medical_study_id);


-- ==========================================================
-- Tabla: Patient
-- ==========================================================
-- Útil para búsquedas rápidas por DNI o nombre.
CREATE INDEX idx_patient_dni           ON Patient(dni);
CREATE INDEX idx_patient_lastname      ON Patient(lastname);


-- ==========================================================
-- Tabla: LabStaff
-- ==========================================================
-- Acelera las búsquedas por rol, nombre o estado en línea.
CREATE INDEX idx_labstaff_role         ON LabStaff(role);
CREATE INDEX idx_labstaff_is_online    ON LabStaff(is_online);
