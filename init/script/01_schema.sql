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
    role ENUM('role_admin', 'role_receptionist', 'role_biochemist', 'role_labTechnician') NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    isOnline BOOLEAN DEFAULT FALSE,
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
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    dni VARCHAR(20) UNIQUE,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Tabla MedicalStudy
CREATE TABLE MedicalStudy (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    duration INT NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. Tabla Result
CREATE TABLE Result (
    _id VARCHAR(24) PRIMARY KEY,
    biochemist_id VARCHAR(24) NOT NULL,
    description TEXT,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id)
);

-- 5. Tabla DoctorAppointment
CREATE TABLE DoctorAppointment (
    _id VARCHAR(24) PRIMARY KEY,
    isPaid BOOLEAN DEFAULT FALSE NOT NULL,
    talon_id VARCHAR(24),
    result_id VARCHAR(24),
    patient_id VARCHAR(24) NOT NULL,
    medicalStudy_id VARCHAR(24) NOT NULL,
    date DATETIME NOT NULL,
    receptionist_id VARCHAR(24),
    reason TEXT,
    status ENUM('status_scheduled', 'status_completed', 'status_cancelled') DEFAULT 'status_pending',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (result_id) REFERENCES Result(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id),
    FOREIGN KEY (medicalStudy_id) REFERENCES MedicalStudy(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 6. Tabla Talon
CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    doctorAppointment_id VARCHAR(24),
    receptionist_id VARCHAR(24) NOT NULL,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 7. Tabla Payment
CREATE TABLE Payment (
    _id VARCHAR(24) PRIMARY KEY,
    talon_id VARCHAR(24) NOT NULL,
    receptionist_id VARCHAR(24) NOT NULL,
    method VARCHAR(50) NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 8. FKs circulares
ALTER TABLE DoctorAppointment
    ADD CONSTRAINT fk_doctorappointment_talon
    FOREIGN KEY (talon_id) REFERENCES Talon(_id);

ALTER TABLE Talon
    ADD CONSTRAINT fk_talon_doctorappointment
    FOREIGN KEY (doctorAppointment_id) REFERENCES DoctorAppointment(_id);
