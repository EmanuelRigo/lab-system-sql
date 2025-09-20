CREATE DATABASE IF NOT EXISTS lab_db_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE lab_db_sql;

-- 1. Tabla LabStaff
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

-- 2. Tabla Patient
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

-- 3. Tabla MedicalStudy
CREATE TABLE MedicalStudy (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    duration INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. Tabla Result
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

-- 5. Tabla Talon
CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    receptionist_id VARCHAR(24) NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 6. Tabla DoctorAppointment
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

-- 7. Tabla PaymentMethod
CREATE TABLE PaymentMethod (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL UNIQUE,
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 8. Tabla Payment
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

-- Foreign key adicional
ALTER TABLE Result  
ADD CONSTRAINT fk_result_medical_study  
FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id);

ALTER TABLE Result  
ADD CONSTRAINT fk_result_doctor_appointment
FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id);