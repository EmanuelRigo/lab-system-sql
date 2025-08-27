CREATE DATABASE IF NOT EXISTS lab_db_sql;
USE lab_db_sql;

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
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Tabla Patient
CREATE TABLE Patient (
    _id VARCHAR(24) PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    secondname VARCHAR(100),
    lastname VARCHAR(100) NOT NULL,
    birthDate DATE NOT NULL,
    dni INT UNIQUE,
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

-- 4. Tabla Result
CREATE TABLE Result (
    _id VARCHAR(24) PRIMARY KEY,
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    labtechnician_id VARCHAR(24),
    biochemist_id VARCHAR(24),
    description TEXT,
    extraction_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (labtechnician_id) REFERENCES LabStaff(_id)
);

-- 5. Tabla DoctorAppointment
CREATE TABLE DoctorAppointment (
    _id VARCHAR(24) PRIMARY KEY,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    result_id VARCHAR(24),
    patient_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    date DATETIME NOT NULL,
    receptionist_id VARCHAR(24),
    reason TEXT,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (result_id) REFERENCES Result(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id),
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 6. Tabla Talon (sin doctor_appointment_id)
CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    receptionist_id VARCHAR(24) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 7. Tabla intermedia TalonDoctorAppointment
CREATE TABLE TalonDoctorAppointment (
    talon_id VARCHAR(24) NOT NULL,
    doctor_appointment_id VARCHAR(24) NOT NULL,
    PRIMARY KEY (talon_id, doctor_appointment_id),
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (doctor_appointment_id) REFERENCES DoctorAppointment(_id)
);

-- 8. Tabla Payment
CREATE TABLE Payment (
    _id VARCHAR(24) PRIMARY KEY,
    patient_id VARCHAR(24) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    talon_id VARCHAR(24) NOT NULL,
    receptionist_id VARCHAR(24) NOT NULL,
    method ENUM('credit_card', 'debit_card', 'cash', 'bank_transfer') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id)
);

