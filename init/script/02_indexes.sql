-- ==========================================================
-- ✅ FILE: 02_indexes.sql
-- ==========================================================
-- 📄 Description:
-- This script creates indexes to improve query performance
-- for frequently used fields and foreign keys.
-- ==========================================================

-- ==========================================================
-- 🧍‍♂️ LabStaff
-- ==========================================================
CREATE INDEX idx_labstaff_username ON LabStaff(username);
CREATE INDEX idx_labstaff_role ON LabStaff(role);
CREATE INDEX idx_labstaff_email ON LabStaff(email);

-- ==========================================================
-- 🧑‍⚕️ Patient
-- ==========================================================
CREATE INDEX idx_patient_dni ON Patient(dni);
CREATE INDEX idx_patient_lastname ON Patient(lastname);

-- ==========================================================
-- 🧪 MedicalStudy
-- ==========================================================
CREATE INDEX idx_medicalstudy_name ON MedicalStudy(name);
CREATE INDEX idx_medicalstudy_price ON MedicalStudy(price);

-- ==========================================================
-- 🎟️ Talon
-- ==========================================================
CREATE INDEX idx_talon_receptionist ON Talon(receptionist_id);
CREATE INDEX idx_talon_is_paid ON Talon(is_paid);

-- ==========================================================
-- 🩺 DoctorAppointment
-- ==========================================================
CREATE INDEX idx_doctorappointment_patient ON DoctorAppointment(patient_id);
CREATE INDEX idx_doctorappointment_receptionist ON DoctorAppointment(receptionist_id);
CREATE INDEX idx_doctorappointment_talon ON DoctorAppointment(talon_id);
CREATE INDEX idx_doctorappointment_status ON DoctorAppointment(status);
CREATE INDEX idx_doctorappointment_date ON DoctorAppointment(date);

-- ==========================================================
-- 🔗 DoctorAppointment_MedicalStudy (junction table)
-- ==========================================================
CREATE INDEX idx_dams_appointment ON DoctorAppointment_MedicalStudy(doctor_appointment_id);
CREATE INDEX idx_dams_study ON DoctorAppointment_MedicalStudy(medical_study_id);

-- ==========================================================
-- 📋 Orden
-- ==========================================================
CREATE INDEX idx_orden_appointment ON Orden(doctor_appointment_id);

-- ==========================================================
-- 🔗 Orden_MedicalStudy (junction table)
-- ==========================================================
CREATE INDEX idx_oms_orden ON Orden_MedicalStudy(orden_id);
CREATE INDEX idx_oms_study ON Orden_MedicalStudy(medical_study_id);

-- ==========================================================
-- 🧾 Result
-- ==========================================================
CREATE INDEX idx_result_orden ON Result(orden_id);
CREATE INDEX idx_result_study ON Result(medical_study_id);
CREATE INDEX idx_result_labtechnician ON Result(labtechnician_id);
CREATE INDEX idx_result_biochemist ON Result(biochemist_id);
CREATE INDEX idx_result_status ON Result(status);

-- ==========================================================
-- 💳 PaymentMethod
-- ==========================================================
CREATE INDEX idx_paymentmethod_name ON PaymentMethod(name);
CREATE INDEX idx_paymentmethod_active ON PaymentMethod(is_active);

-- ==========================================================
-- 💰 Payment
-- ==========================================================
CREATE INDEX idx_payment_talon ON Payment(talon_id);
CREATE INDEX idx_payment_method ON Payment(payment_method_id);
CREATE INDEX idx_payment_amount ON Payment(amount);

-- ==========================================================
-- ✅ End of file
-- ==========================================================
