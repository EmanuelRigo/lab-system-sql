CREATE DATABASE IF NOT EXISTS lab_db_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE lab_db_sql;

CREATE TABLE LabStaff (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    secondname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    lastname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    username VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL UNIQUE,
    password VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    role ENUM('admin', 'receptionist', 'biochemist', 'labTechnician') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    email VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci UNIQUE,
    phone VARCHAR(20),
    is_online BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Patient (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    secondname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    lastname VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    birth_date DATE NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    phone VARCHAR(20),
    address VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE MedicalStudy (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    duration INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Result (
    _id VARCHAR(24) PRIMARY KEY,
    medical_study_id VARCHAR(24) NOT NULL,
    doctor_appointment_id VARCHAR(24) NOT NULL,
    labtechnician_id VARCHAR(24),
    biochemist_id VARCHAR(24),
    status ENUM('pending', 'completed', 'failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
    result VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    extraction_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (labtechnician_id) REFERENCES LabStaff(_id)
);

CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    receptionist_id VARCHAR(24) NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

CREATE TABLE DoctorAppointment (
    _id VARCHAR(24) PRIMARY KEY,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    talon_id VARCHAR(24),
    patient_id VARCHAR(24) NOT NULL,
    receptionist_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    date DATETIME NOT NULL,
    reason TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    status ENUM('scheduled', 'completed', 'cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id)
);

CREATE TABLE PaymentMethod (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL UNIQUE,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Payment (
    _id VARCHAR(24) PRIMARY KEY,
    amount DECIMAL(10,2),
    talon_id VARCHAR(24),
    payment_method_id VARCHAR(24) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(_id)
);

ALTER TABLE Result  
ADD CONSTRAINT fk_result_medical_study  
FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id);

ALTER TABLE Result  
ADD CONSTRAINT fk_result_doctor_appointment
FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id);

CREATE INDEX idx_result_biochemistID ON Result(biochemist_id);
CREATE INDEX idx_da_patientID        ON DoctorAppointment(patient_id);
CREATE INDEX idx_da_medicalStudyID   ON DoctorAppointment(medical_study_id);
CREATE INDEX idx_da_receptionistID   ON DoctorAppointment(receptionist_id);
CREATE INDEX idx_da_talonID          ON DoctorAppointment(talon_id);
CREATE INDEX idx_da_date             ON DoctorAppointment(date);
CREATE INDEX idx_talon_receptionistID ON Talon(receptionist_id);
CREATE INDEX idx_pay_talonID         ON Payment(talon_id);

CREATE VIEW TalonWithReceptionistAndPatient AS
SELECT
  t._id,          
  t.is_paid,
  t.total_amount,
  t.created_at   AS talon_created_at,
  t.updated_at   AS talon_updated_at,
  r.firstname    AS receptionist_firstname,
  r.lastname     AS receptionist_lastname,
  p.firstname    AS patient_firstname,
  p.lastname     AS patient_lastname,
  p.phone        AS patient_phone
FROM Talon t
JOIN LabStaff r ON t.receptionist_id = r._id
JOIN DoctorAppointment da ON da.talon_id = t._id
JOIN Patient p ON da.patient_id = p._id;

CREATE VIEW DoctorAppointmentWithDetails AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id;

CREATE VIEW DoctorAppointmentWithReceptionist AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name,
    r.firstname AS receptionist_firstname,
    r.lastname AS receptionist_lastname
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id
JOIN LabStaff r
    ON da.receptionist_id = r._id;

CREATE VIEW PaidDoctorAppointments AS
SELECT 
    da._id AS doctor_appointment_id,
    da.date,
    da.status,
    da.is_paid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.phone AS patient_phone,
    ms.name AS medical_study_name
FROM DoctorAppointment da
JOIN Patient p 
    ON da.patient_id = p._id
JOIN MedicalStudy ms 
    ON da.medical_study_id = ms._id
WHERE da.is_paid = TRUE;

DELIMITER $$
CREATE TRIGGER trg_after_payment_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
  UPDATE Talon
  SET is_paid = TRUE
  WHERE _id = NEW.talon_id;
  UPDATE DoctorAppointment
  SET is_paid = TRUE
  WHERE talon_id = NEW.talon_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_before_payment_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE talonTotal DECIMAL(10,2);
    SELECT total_amount
    INTO talonTotal
    FROM Talon
    WHERE _id = NEW.talon_id;
    SET NEW.amount = talonTotal;
    UPDATE DoctorAppointment
    SET talon_id = NEW.talon_id
    WHERE talon_id IS NULL
      AND patient_id = (
          SELECT patient_id
          FROM Talon
          WHERE _id = NEW.talon_id
      );
END$$
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_result_after_insert
AFTER INSERT ON Result
FOR EACH ROW
BEGIN
  UPDATE doctorAppointment
  SET status = 'completed'
  WHERE _id = NEW.doctor_appointment_id;
END //
DELIMITER ;

INSERT INTO MedicalStudy (_id, name, price, description, duration) VALUES
('64a1f0a9b1234567890abc01', 'Hemograma', 2000.00, 'No necesita ayuno. Evalúa glóbulos rojos, glóbulos blancos y plaquetas, ayudando a detectar anemias, infecciones y trastornos hematológicos.', 24),
('64a1f0a9b1234567890abc02', 'Hepatograma', 5000.00, '12hs de ayuno. Evalúa el funcionamiento del hígado mediante enzimas y otras sustancias como TGO, TGP, bilirrubina y fosfatasa alcalina. Detecta daños o enfermedades hepáticas.', 24),
('64a1f0a9b1234567890abc03', 'Ionograma', 8000.00, '8hs de ayuno. Mide los electrolitos como sodio, potasio, cloro y calcio. Evalúa el equilibrio ácido-base, la hidratación y la función renal.', 74),
('64a1f0a9b1234567890abc04', 'Vitamina D', 20000.00, '8hs de ayuno. Mide los niveles de vitamina D en sangre, principalmente la forma 25(OH)D. Sirve para evaluar la salud ósea, la absorción de calcio y posibles deficiencias o excesos.', 74);

INSERT INTO PaymentMethod (_id, name, description, is_active) VALUES
('663d55e86673791244de12c1', 'Efectivo', 'Pago en efectivo', 1),
('663d55e86673791244de12c2', 'Tarjeta de Crédito', 'Pago con tarjeta de crédito', 1),
('663d55e86673791244de12c3', 'Tarjeta de Débito', 'Pago con tarjeta de débito', 1);

INSERT INTO LabStaff (_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at) VALUES
('94e8892f7265c287c8af987f', 'Emanuel', 'antonio', 'Rigo', 'emanuelrecep', '$2b$10$ekrz1onD5fmbAcYeN.2fEOho5Opb/9K33z.0qwc0ZLGVqZf6dzx5e', 'receptionist', 'emanuel1@rigo.com', '+1-555-234-5678', 1, '2025-09-20 15:39:07', '2025-09-20 15:39:10');

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

INSERT INTO DoctorAppointment (_id, is_paid, talon_id, patient_id, receptionist_id, medical_study_id, date, reason, status) VALUES
('da0000000000000000000001', 0, NULL, '66452b9c79213525b81391aa', '94e8892f7265c287c8af987f', '64a1f0a9b1234567890abc01', '2025-10-01 10:00:00', 'Control de rutina', 'scheduled'),
('da0000000000000000000002', 0, NULL, '66452b9c79213525b81391ab', '94e8892f7265c287c8af987f', '64a1f0a9b1234567890abc02', '2025-10-01 11:00:00', 'Chequeo anual', 'scheduled');

INSERT INTO Talon (_id, receptionist_id, is_paid, total_amount) VALUES
('ta0000000000000000000001', '94e8892f7265c287c8af987f', 0, 7000.00);

INSERT INTO Payment (_id, amount, talon_id, payment_method_id) VALUES
('pa0000000000000000000001', 7000.00, 'ta0000000000000000000001', '663d55e86673791244de12c1');

UPDATE DoctorAppointment SET talon_id = 'ta0000000000000000000001' WHERE _id IN ('da0000000000000000000001', 'da0000000000000000000002');
