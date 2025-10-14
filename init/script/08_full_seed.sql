USE lab_db_sql;

-- ==========================================================
-- 🧪 MedicalStudy
-- ==========================================================
INSERT INTO MedicalStudy (_id, name, price, description, duration) VALUES
('64a1f0a9b1234567890abc01', 'Hemograma', 2000.00, 'No necesita ayuno. Evalúa glóbulos rojos, glóbulos blancos y plaquetas, ayudando a detectar anemias, infecciones y trastornos hematológicos.', 24),
('64a1f0a9b1234567890abc02', 'Hepatograma', 5000.00, '12hs de ayuno. Evalúa el funcionamiento del hígado mediante enzimas y otras sustancias como TGO, TGP, bilirrubina y fosfatasa alcalina. Detecta daños o enfermedades hepáticas.', 24),
('64a1f0a9b1234567890abc03', 'Ionograma', 8000.00, '8hs de ayuno. Mide los electrolitos como sodio, potasio, cloro y calcio. Evalúa el equilibrio ácido-base, la hidratación y la función renal.', 74),
('64a1f0a9b1234567890abc04', 'Vitamina D', 20000.00, '8hs de ayuno. Mide los niveles de vitamina D en sangre, principalmente la forma 25(OH)D. Sirve para evaluar la salud ósea, la absorción de calcio y posibles deficiencias o excesos.', 74);

-- ==========================================================
-- 💳 PaymentMethod
-- ==========================================================
INSERT INTO PaymentMethod (_id, name, description, is_active) VALUES
('663d55e86673791244de12c1', 'Efectivo', 'Pago en efectivo', 1),
('663d55e86673791244de12c2', 'Tarjeta de Crédito', 'Pago con tarjeta de crédito', 1),
('663d55e86673791244de12c3', 'Tarjeta de Débito', 'Pago con tarjeta de débito', 1);

-- ==========================================================
-- 👨‍💼 LabStaff
-- ==========================================================
INSERT INTO LabStaff (_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at) VALUES
('94e8892f7265c287c8af987f', 'Emanuel', 'Antonio', 'Rigo', 'emanuelrecep', '$2b$10$ekrz1onD5fmbAcYeN.2fEOho5Opb/9K33z.0qwc0ZLGVqZf6dzx5e', 'receptionist', 'emanuel1@rigo.com', '+1-555-234-5678', 1, '2025-09-20 15:39:07', '2025-09-20 15:39:10');

-- ==========================================================
-- 🧍‍♂️ Patient
-- ==========================================================
INSERT INTO Patient (_id, firstname, secondname, lastname, birth_date, dni, email, phone, address) VALUES
('66452b9c79213525b81391aa', 'Carlos', 'Alberto', 'Gonzalez', '1985-03-12', '30123456', 'carlos.gonzalez@example.com', '1123456789', 'Avenida Siempreviva 742'),
('66452b9c79213525b81391ab', 'Ana', 'Maria', 'Lopez', '1992-07-21', '36987654', 'ana.lopez@example.com', '1134567890', 'Calle Falsa 123');

-- ==========================================================
-- 📅 DoctorAppointment
-- ==========================================================
INSERT INTO DoctorAppointment (_id, is_paid, talon_id, patient_id, receptionist_id, date, reason, status)
VALUES
('da0000000000000000000001', 0, NULL, '66452b9c79213525b81391aa', '94e8892f7265c287c8af987f', '2025-10-11 10:00:00', 'Control de rutina', 'scheduled'),
('da0000000000000000000002', 0, NULL, '66452b9c79213525b81391ab', '94e8892f7265c287c8af987f', '2025-10-11 11:00:00', 'Chequeo anual', 'scheduled');

-- ==========================================================
-- 🧩 DoctorAppointment_MedicalStudy
-- ==========================================================
INSERT INTO DoctorAppointment_MedicalStudy (doctor_appointment_id, medical_study_id) VALUES
('da0000000000000000000001', '64a1f0a9b1234567890abc01'),
('da0000000000000000000001', '64a1f0a9b1234567890abc03'),
('da0000000000000000000002', '64a1f0a9b1234567890abc02'),
('da0000000000000000000002', '64a1f0a9b1234567890abc04');

-- ==========================================================
-- 🧾 Talon
-- ==========================================================
INSERT INTO Talon (_id, receptionist_id, is_paid, total_amount)
VALUES 
('ta0000000000000000000001', '94e8892f7265c287c8af987f', 0, 0.00);

-- ==========================================================
-- 🔄 Vincular el talon a las citas (esto activa triggers de cálculo)
-- ==========================================================
UPDATE DoctorAppointment
SET talon_id = 'ta0000000000000000000001'
WHERE _id IN ('da0000000000000000000001', 'da0000000000000000000002');

-- ==========================================================
-- 💰 Payment
-- ==========================================================
-- (Este insert activa el trigger para marcar pagado el talón y las citas)
INSERT INTO Payment (_id, amount, talon_id, payment_method_id)
VALUES 
('pa0000000000000000000001', 0, 'ta0000000000000000000001', '663d55e86673791244de12c1');


INSERT INTO DoctorAppointment_MedicalStudy (doctor_appointment_id, medical_study_id) VALUES
('da0000000000000000000001', '64a1f0a9b1234567890abc04');

UPDATE DoctorAppointment SET talon_id='ta0000000000000000000001' WHERE _id='da0000000000000000000001';

INSERT INTO Payment (_id, talon_id, payment_method_id, amount)
VALUES (
    'pa6000000000000000000001', 
    'ta0000000000000000000001', 
    '663d55e86673791244de12c1', 
    NULL
);


INSERT INTO Result (_id, orden_id, medical_study_id, labtechnician_id, result)
VALUES (
    'res600000000000000000002', -- ID único del resultado
    '7b4b6362-a92d-11f0-997a-', -- ID de la Orden que se generó previamente
    '64a1f0a9b1234567890abc01', -- ID del estudio asociado a la orden
    '94e8892f7265c287c8af987f', -- ID del staff (ej: Laboratorista)
    'Resultado: Todo normal. Glucosa: 85 mg/dL.' -- Datos del resultado
);