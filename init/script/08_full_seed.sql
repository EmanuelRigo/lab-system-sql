USE lab_db_sql;

-- MedicalStudy
INSERT INTO MedicalStudy (_id, name, price, description, duration) VALUES
('64a1f0a9b1234567890abc01', 'Hemograma', 2000.00, 'No necesita ayuno. Evalúa glóbulos rojos, glóbulos blancos y plaquetas, ayudando a detectar anemias, infecciones y trastornos hematológicos.', 24),
('64a1f0a9b1234567890abc02', 'Hepatograma', 5000.00, '12hs de ayuno. Evalúa el funcionamiento del hígado mediante enzimas y otras sustancias como TGO, TGP, bilirrubina y fosfatasa alcalina. Detecta daños o enfermedades hepáticas.', 24),
('64a1f0a9b1234567890abc03', 'Ionograma', 8000.00, '8hs de ayuno. Mide los electrolitos como sodio, potasio, cloro y calcio. Evalúa el equilibrio ácido-base, la hidratación y la función renal.', 74),
('64a1f0a9b1234567890abc04', 'Vitamina D', 20000.00, '8hs de ayuno. Mide los niveles de vitamina D en sangre, principalmente la forma 25(OH)D. Sirve para evaluar la salud ósea, la absorción de calcio y posibles deficiencias o excesos.', 74);

-- PaymentMethod
INSERT INTO PaymentMethod (_id, name, description, is_active) VALUES
('663d55e86673791244de12c1', 'Efectivo', 'Pago en efectivo', 1),
('663d55e86673791244de12c2', 'Tarjeta de Crédito', 'Pago con tarjeta de crédito', 1),
('663d55e86673791244de12c3', 'Tarjeta de Débito', 'Pago con tarjeta de débito', 1);

-- LabStaff
INSERT INTO LabStaff (_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at) VALUES
('94e8892f7265c287c8af987f', 'Emanuel', 'antonio', 'Rigo', 'emanuelrecep', '$2b$10$ekrz1onD5fmbAcYeN.2fEOho5Opb/9K33z.0qwc0ZLGVqZf6dzx5e', 'receptionist', 'emanuel1@rigo.com', '+1-555-234-5678', 1, '2025-09-20 15:39:07', '2025-09-20 15:39:10');

-- Patient
INSERT INTO Patient (_id, firstname, secondname, lastname, birth_date, dni, email, phone, address) VALUES
('66452b9c79213525b81391aa', 'Carlos', 'Alberto', 'Gonzalez', '1985-03-12', '30123456', 'carlos.gonzalez@example.com', '1123456789', 'Avenida Siempreviva 742'),
('66452b9c79213525b81391ab', 'Ana', 'Maria', 'Lopez', '1992-07-21', '36987654', 'ana.lopez@example.com', '1134567890', 'Calle Falsa 123'),
('66452b9c79213525b81391ac', 'Jorge', 'Luis', 'Martinez', '1978-11-05', '26789012', 'jorge.martinez@example.com', '1145678901', 'Boulevard de los Sueños Rotos 456'),
('66452b9c79213525b81391ad', 'Maria', 'Eugenia', 'Rodriguez', '1995-01-30', '38456789', 'maria.rodriguez@example.com', '1156789012', 'Pasaje del Olvido 789'),
('66452b9c79213525b81391ae', 'Luis', 'Miguel', 'Sanchez', '1980-09-15', '28345678', 'luis.sanchez@example.com', '1167890123', 'Avenida de la Luz 101'),
('66452b9c79213525b81391af', 'Laura', 'Beatriz', 'Gomez', '1988-04-25', '33567890', 'laura.gomez@example.com', '1178901234', 'Calle del Sol 202'),
('66452b9c79213525b81391b0', 'Ricardo', 'Andres', 'Diaz', '1975-12-01', '24890123', 'ricardo.diaz@example.com', '1189012345', 'Plaza de la Luna 303'),
('66452b9c79213525b81391b1', 'Sofia', 'Isabel', 'Perez', '2000-02-20', '42345678', 'sofia.perez@example.com', '1190123456', 'Rincon de las Estrellas 404'),
('66452b9c79213525b81391b2', 'Matias', 'Ezequiel', 'Fernandez', '1993-06-10', '37890123', 'matias.fernandez@example.com', '1101234567', 'Camino del Viento 505'),
('66452b9c79213525b81391b3', 'Valentina', 'Camila', 'Alvarez', '1998-10-18', '40567890', 'valentina.alvarez@example.com', '1112345678', 'Puente de los Suspiros 606'),
('66452b9c79213525b81391b4', 'Diego', 'Alejandro', 'Moreno', '1982-08-08', '29456789', 'diego.moreno@example.com', '1123456789', 'Bosque de los Secretos 707'),
('66452b9c79213525b81391b5', 'Julieta', 'Agustina', 'Romero', '1991-05-14', '35789012', 'julieta.romero@example.com', '1134567890', 'Valle de las Sombras 808'),
('66452b9c79213525b81391b6', 'Martin', 'Nicolas', 'Gimenez', '1979-03-22', '27234567', 'martin.gimenez@example.com', '1145678901', 'Montaña del Silencio 909'),
('66452b9c79213525b81391b7', 'Lucia', 'Victoria', 'Ruiz', '1996-12-03', '39890123', 'lucia.ruiz@example.com', '1156789012', 'Mar de la Tranquilidad 111'),
('66452b9c79213525b81391b8', 'Facundo', 'Joaquin', 'Torres', '1987-07-07', '32678901', 'facundo.torres@example.com', '1167890123', 'Rio de la Vida 222'),
('66452b9c79213525b81391b9', 'Camila', 'Florencia', 'Dominguez', '1994-09-09', '38123456', 'camila.dominguez@example.com', '1178901234', 'Lago de los Recuerdos 333'),
('66452b9c79213525b81391ba', 'Sebastian', 'David', 'Sosa', '1984-02-17', '30987654', 'sebastian.sosa@example.com', '1189012345', 'Isla de la Fantasia 444'),
('66452b9c79213525b81391bb', 'Paula', 'Andrea', 'Vega', '1990-11-11', '34567890', 'paula.vega@example.com', '1190123456', 'Desierto de la Soledad 555'),
('66452b9c79213525b81391bc', 'Agustin', 'Ignacio', 'Rojas', '1997-04-04', '40234567', 'agustin.rojas@example.com', '1101234567', 'Ciudad de los Milagros 666'),
('66452b9c79213525b81391bd', 'Florencia', 'Micaela', 'Castro', '1989-08-28', '34123456', 'florencia.castro@example.com', '1112345678', 'Pueblo de la Esperanza 777');

-- DoctorAppointment
INSERT INTO DoctorAppointment (_id, is_paid, talon_id, patient_id, receptionist_id, medical_study_id, date, reason, status) VALUES
('da0000000000000000000001', 0, NULL, '66452b9c79213525b81391aa', '94e8892f7265c287c8af987f', '64a1f0a9b1234567890abc01', '2025-10-01 10:00:00', 'Control de rutina', 'scheduled'),
('da0000000000000000000002', 0, NULL, '66452b9c79213525b81391ab', '94e8892f7265c287c8af987f', '64a1f0a9b1234567890abc02', '2025-10-01 11:00:00', 'Chequeo anual', 'scheduled');

-- Talon
INSERT INTO Talon (_id, receptionist_id, is_paid, total_amount) VALUES
('ta0000000000000000000001', '94e8892f7265c287c8af987f', 0, 7000.00);

-- Payment
INSERT INTO Payment (_id, amount, talon_id, payment_method_id) VALUES
('pa0000000000000000000001', 7000.00, 'ta0000000000000000000001', '663d55e86673791244de12c1');

-- Update DoctorAppointment with talon_id
UPDATE DoctorAppointment SET talon_id = 'ta0000000000000000000001' WHERE _id IN ('da0000000000000000000001', 'da0000000000000000000002');
