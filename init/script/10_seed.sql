-- ==========================================================
-- ✅ FILE: 10_seed.sql - PostgreSQL
-- ==========================================================
-- 📄 Descripción:
-- Este script carga datos iniciales (seed) en las tablas de la base de datos
-- utilizando archivos CSV ubicados en la carpeta init/data:
--     /docker-entrypoint-initdb.d/data/ (en el contenedor)
-- Asegúrate de que los archivos existan en esa ruta dentro del contenedor.
-- ==========================================================

-- ==========================================================
-- 🧪 MedicalStudy
-- ==========================================================
-- Carga la lista de estudios médicos ofrecidos por el laboratorio.
-- Incluye nombre, precio, descripción y duración estimada.
-- ----------------------------------------------------------
COPY MedicalStudy (_id, name, price, description, duration)
FROM '/docker-entrypoint-initdb.d/data/medical_studies.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 💳 PaymentMethod
-- ==========================================================
-- Carga los métodos de pago disponibles (efectivo, tarjeta, etc.)
-- e indica si cada método se encuentra activo o no.
-- ----------------------------------------------------------
COPY PaymentMethod (_id, name, description, is_active)
FROM '/docker-entrypoint-initdb.d/data/payment_methods.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 🧍‍♂️ Patient
-- ==========================================================
-- Carga la información demográfica de los pacientes, incluyendo
-- datos personales y de contacto.
-- ----------------------------------------------------------
COPY Patient (_id, firstname, secondname, lastname, birth_date, dni, email, phone, address)
FROM '/docker-entrypoint-initdb.d/data/patients.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 👨‍🔬 LabStaff
-- ==========================================================
-- Carga la información del personal de laboratorio, incluyendo
-- su rol, nombre de usuario y datos de contacto.
-- ----------------------------------------------------------
COPY LabStaff (_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at)
FROM '/docker-entrypoint-initdb.d/data/LabStaff.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 📅 DoctorAppointment
-- ==========================================================
-- Carga las citas médicas, vinculando pacientes, recepcionistas
-- y opcionalmente los talones. Los campos vacíos se interpretan como NULL.
-- ----------------------------------------------------------
COPY DoctorAppointment (_id, is_paid, talon_id, patient_id, receptionist_id, date, reason, status)
FROM '/docker-entrypoint-initdb.d/data/DoctorAppointment.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 🎟️ Talon
-- ==========================================================
-- Carga los registros de talones (vouchers), los cuales
-- relacionan al recepcionista con los pagos o pacientes.
-- ----------------------------------------------------------
COPY Talon (_id, receptionist_id, is_paid, total_amount)
FROM '/docker-entrypoint-initdb.d/data/Talon.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 🔗 DoctorAppointment_MedicalStudy
-- ==========================================================
-- Carga la relación muchos a muchos entre las citas médicas
-- y los estudios solicitados por el médico.
-- ----------------------------------------------------------
COPY DoctorAppointment_MedicalStudy (doctor_appointment_id, medical_study_id)
FROM '/docker-entrypoint-initdb.d/data/DoctorAppointment_MedicalStudy.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 📦 Orden
-- ==========================================================
-- Carga las órdenes (relación entre cita y estudio)
-- ----------------------------------------------------------
-- COPY Orden (_id, doctor_appointment_id)
-- FROM '/docker-entrypoint-initdb.d/data/Orden.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 🔗 Orden_MedicalStudy
-- ==========================================================
-- Carga la relación muchos a muchos entre órdenes y estudios médicos.
-- ----------------------------------------------------------
-- COPY Orden_MedicalStudy (orden_id, medical_study_id)
-- FROM '/docker-entrypoint-initdb.d/data/Orden_MedicalStudy.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 🧾 Result
-- ==========================================================
-- Carga los resultados de los estudios, incluyendo el técnico
-- y bioquímico responsable, estado y descripción del resultado.
-- ----------------------------------------------------------
-- COPY Result (_id, orden_id, medical_study_id, labtechnician_id, biochemist_id, status, result, description, extraction_date, created_at, updated_at)
-- FROM '/docker-entrypoint-initdb.d/data/Result.csv'
-- WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 💰 Payment
-- ==========================================================
-- Carga los registros de pagos, vinculándolos con los talones
-- y los métodos de pago correspondientes.
-- ----------------------------------------------------------
COPY Payment (_id, amount, talon_id, payment_method_id, created_at, updated_at)
FROM '/docker-entrypoint-initdb.d/data/Payment.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"', NULL '');

-- ==========================================================
-- 📝 Ajustes de integridad
-- ==========================================================
-- Ajuste opcional para mantener integridad de los datos de ejemplo (si es necesario)
-- UPDATE DoctorAppointment 
-- SET talon_id='f81bf30d39efa8bf45ff7586' 
-- WHERE _id='4a6d083eae25ecf58917f24d';

-- ==========================================================
-- ✅ Fin del archivo
-- ==========================================================
