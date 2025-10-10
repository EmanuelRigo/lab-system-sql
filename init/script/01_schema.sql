-- ==========================================================
-- ✅ CREACIÓN DE BASE DE DATOS
-- ==========================================================
CREATE DATABASE IF NOT EXISTS lab_db_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE lab_db_sql;


-- ==========================================================
-- ✅ TABLAS PRINCIPALES
-- ==========================================================

-- 1. Tabla LabStaff
CREATE TABLE LabStaff (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    secondname VARCHAR(100),
    lastname VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'receptionist', 'biochemist', 'labTechnician') NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    is_online BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Tabla Patient
CREATE TABLE Patient (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    secondname VARCHAR(100),
    lastname VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(20),
    address VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Tabla MedicalStudy
CREATE TABLE MedicalStudy (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    duration INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. Tabla Talon
CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    receptionist_id VARCHAR(24) NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 5. Tabla DoctorAppointment
CREATE TABLE DoctorAppointment (
    _id VARCHAR(24) PRIMARY KEY,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    talon_id VARCHAR(24),
    patient_id VARCHAR(24) NOT NULL,
    receptionist_id VARCHAR(24) NOT NULL,
    date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 6. Tabla intermedia DoctorAppointment_MedicalStudy (muchos a muchos)
CREATE TABLE DoctorAppointment_MedicalStudy (
    doctor_appointment_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    PRIMARY KEY (doctor_appointment_id, medical_study_id),
    FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id)
      ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id)
      ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Tabla Orden
CREATE TABLE Orden (
    _id VARCHAR(24) PRIMARY KEY,
    doctor_appointment_id VARCHAR(24) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id)
);

-- 8. Tabla intermedia Orden_MedicalStudy (muchos a muchos)
CREATE TABLE Orden_MedicalStudy (
    orden_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    PRIMARY KEY (orden_id, medical_study_id),
    FOREIGN KEY (orden_id) REFERENCES Orden(_id),
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id)
);

-- 9. Tabla Result
CREATE TABLE Result (
    _id VARCHAR(24) PRIMARY KEY,
    orden_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    labtechnician_id VARCHAR(24),
    biochemist_id VARCHAR(24),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    result VARCHAR(255),
    description TEXT,
    extraction_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (orden_id) REFERENCES Orden(_id),
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id),
    FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (labtechnician_id) REFERENCES LabStaff(_id)
);

-- 10. Tabla PaymentMethod
CREATE TABLE PaymentMethod (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 11. Tabla Payment
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
