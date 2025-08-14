-- Crear base de datos
CREATE DATABASE IF NOT EXISTS lab_db_sql;
USE lab_db_sql;

-- =========================
-- 1. Tabla LabStaff
-- =========================
CREATE TABLE LabStaff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Receptionist', 'Biochemist', 'LabTechnician') NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    isOnline BOOLEAN DEFAULT FALSE,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- 2. Tabla Patient
-- =========================
CREATE TABLE Patient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    birthDate DATE NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    dni VARCHAR(20) UNIQUE,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- 3. Tabla MedicalStudy
-- =========================
CREATE TABLE MedicalStudy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    duration INT NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- 4. Tabla Result
-- =========================
CREATE TABLE Result (
    id INT AUTO_INCREMENT PRIMARY KEY,
    biochemistID INT NOT NULL,
    description TEXT,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (biochemistID) REFERENCES LabStaff(id)
);

-- =========================
-- 5. Tabla DoctorAppointment (sin FK a Talon aún)
-- =========================
CREATE TABLE DoctorAppointment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isPaid BOOLEAN DEFAULT FALSE,
    talonID INT, -- FK se agrega luego
    resultID INT,
    patientID INT NOT NULL,
    medicalStudyID INT NOT NULL,
    date DATETIME NOT NULL,
    ReceptionistID INT,
    reason TEXT,
    status VARCHAR(50),
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (resultID) REFERENCES Result(id),
    FOREIGN KEY (patientID) REFERENCES Patient(id),
    FOREIGN KEY (medicalStudyID) REFERENCES MedicalStudy(id),
    FOREIGN KEY (ReceptionistID) REFERENCES LabStaff(id)
);

-- =========================
-- 6. Tabla Talon (sin FK a DoctorAppointment aún)
-- =========================
CREATE TABLE Talon (
    id INT AUTO_INCREMENT PRIMARY KEY,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    DAppointmentID INT, -- FK se agrega luego
    ReceptionistID INT NOT NULL,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ReceptionistID) REFERENCES LabStaff(id)
);

-- =========================
-- 7. Tabla Payment
-- =========================
CREATE TABLE Payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    TalonID INT NOT NULL,
    ReceptionistID INT NOT NULL,
    method VARCHAR(50) NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (TalonID) REFERENCES Talon(id),
    FOREIGN KEY (ReceptionistID) REFERENCES LabStaff(id)
);

-- =========================
-- 8. Añadir las FKs circulares
-- =========================
ALTER TABLE DoctorAppointment
ADD CONSTRAINT fk_doctorappointment_talon
FOREIGN KEY (talonID) REFERENCES Talon(id);

ALTER TABLE Talon
ADD CONSTRAINT fk_talon_doctorappointment
FOREIGN KEY (DAppointmentID) REFERENCES DoctorAppointment(id);
