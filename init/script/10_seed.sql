-- ==========================================================
-- ✅ FILE: 10_seed.sql
-- ==========================================================
-- 📄 Descripción:
-- Este script carga datos iniciales (seed) en las tablas de la base de datos
-- utilizando archivos CSV ubicados en la carpeta segura de MySQL:
--     /var/lib/mysql-files/
-- Asegúrate de que los archivos existan en esa ruta dentro del contenedor.
-- ==========================================================

USE lab_db_sql;

-- ==========================================================
-- 🧪 MedicalStudy
-- ==========================================================
-- Carga la lista de estudios médicos ofrecidos por el laboratorio.
-- Incluye nombre, precio, descripción y duración estimada.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/medical_studies.csv'
INTO TABLE MedicalStudy
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, name, price, description, duration);

-- ==========================================================
-- 💳 PaymentMethod
-- ==========================================================
-- Carga los métodos de pago disponibles (efectivo, tarjeta, etc.)
-- e indica si cada método se encuentra activo o no.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/payment_methods.csv'
INTO TABLE PaymentMethod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, name, description, is_active);

-- ==========================================================
-- 🧍‍♂️ Patient
-- ==========================================================
-- Carga la información demográfica de los pacientes, incluyendo
-- datos personales y de contacto.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/patients.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, firstname, secondname, lastname, birth_date, dni, email, phone, address);

-- ==========================================================
-- 👨‍🔬 LabStaff
-- ==========================================================
-- Carga la información del personal de laboratorio, incluyendo
-- su rol, nombre de usuario y datos de contacto.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/LabStaff.csv'
INTO TABLE LabStaff
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at);

-- ==========================================================
-- 📅 DoctorAppointment
-- ==========================================================
-- Carga las citas médicas, vinculando pacientes, recepcionistas
-- y opcionalmente los talones. Se maneja talon_id como NULL
-- cuando el valor está vacío.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/DoctorAppointment.csv'
INTO TABLE DoctorAppointment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, is_paid, patient_id, receptionist_id, date, reason, status)
SET talon_id = NULLIF(talon_id, '');

-- ==========================================================
-- 🎟️ Talon
-- ==========================================================
-- Carga los registros de talones (vouchers), los cuales
-- relacionan al recepcionista con los pagos o pacientes.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/Talon.csv'
INTO TABLE Talon
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, receptionist_id, is_paid);

 -- ==========================================================
 -- 📦 Orden
 -- ==========================================================
 -- Carga las órdenes (relación entre cita y estudio, creadas por personal)
 -- Ajusta campos NULL cuando corresponda.
 -- ----------------------------------------------------------
--  LOAD DATA INFILE '/var/lib/mysql-files/Orden.csv'
--  INTO TABLE Orden
--  FIELDS TERMINATED BY ','
--  ENCLOSED BY '"'
--  LINES TERMINATED BY '\r\n'
--  IGNORE 1 LINES
--  (_id, doctor_appointment_id, medical_study_id, created_by, status, created_at, updated_at, @notes)
--  SET notes = NULLIF(@notes, '');

-- ==========================================================
-- 🔗 DoctorAppointment_MedicalStudy
-- ==========================================================
-- Carga la relación muchos a muchos entre las citas médicas
-- y los estudios solicitados por el médico.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/DoctorAppointment_MedicalStudy.csv'
INTO TABLE DoctorAppointment_MedicalStudy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(doctor_appointment_id, medical_study_id);

-- Ajuste opcional para mantener integridad de los datos de ejemplo
UPDATE DoctorAppointment 
SET talon_id='f81bf30d39efa8bf45ff7586' 
WHERE _id='4a6d083eae25ecf58917f24d';

-- ==========================================================
-- 💰 Payment
-- ==========================================================
-- Carga los registros de pagos, vinculándolos con los talones
-- y los métodos de pago correspondientes.
-- ----------------------------------------------------------
LOAD DATA INFILE '/var/lib/mysql-files/Payment.csv'
INTO TABLE Payment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, amount, talon_id, payment_method_id, created_at, updated_at);

-- ==========================================================
-- 🧾 Result
-- ==========================================================
-- Carga los resultados de los estudios, incluyendo el técnico
-- y bioquímico responsable, estado y descripción del resultado.
-- El campo biochemist_id se establece como NULL si está vacío.
-- ----------------------------------------------------------
-- LOAD DATA INFILE '/var/lib/mysql-files/Result.csv'
-- INTO TABLE Result
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (_id, medical_study_id, labtechnician_id, @biochemist_id, status, result, description, extraction_date, created_at, updated_at)
-- SET biochemist_id = NULLIF(@biochemist_id, '');

-- ==========================================================
-- ✅ Fin del archivo
-- ==========================================================
