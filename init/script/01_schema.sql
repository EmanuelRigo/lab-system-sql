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

-- 4. Tabla Result
CREATE TABLE Result (
    _id VARCHAR(24) PRIMARY KEY,
    labtechnician_id VARCHAR(24),
    biochemist_id VARCHAR(24),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    description TEXT,
    extraction_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (biochemist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (labtechnician_id) REFERENCES LabStaff(_id)
);

-- 5. Tabla Talon (se crea antes de DoctorAppointment y Payment)
CREATE TABLE Talon (
    _id VARCHAR(24) PRIMARY KEY,
    receptionist_id VARCHAR(24) NOT NULL,
    payment_id VARCHAR(24),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id)
);

-- 6. Tabla DoctorAppointment
CREATE TABLE DoctorAppointment (
    _id VARCHAR(24) PRIMARY KEY,
    is_paid BOOLEAN DEFAULT FALSE NOT NULL,
    talon_id VARCHAR(24),
    result_id VARCHAR(24),
    patient_id VARCHAR(24) NOT NULL,
    receptionist_id VARCHAR(24) NOT NULL,
    medical_study_id VARCHAR(24) NOT NULL,
    date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (talon_id) REFERENCES Talon(_id),
    FOREIGN KEY (result_id) REFERENCES Result(_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(_id),
    FOREIGN KEY (receptionist_id) REFERENCES LabStaff(_id),
    FOREIGN KEY (medical_study_id) REFERENCES MedicalStudy(_id)
);

-- 7. Tabla PaymentMethod (opcional, para métodos de pago personalizados)
CREATE TABLE PaymentMethod (
    _id VARCHAR(24) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 8. Tabla Payment
CREATE TABLE Payment (
    _id VARCHAR(24) PRIMARY KEY,
    amount DECIMAL(10,2),
    payment_method_id VARCHAR(24) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(_id)
);



-- ARREGLAR ESTO 

-- 1. Quitar FK y columna payment_id en Talon
--ALTER TABLE Talon DROP FOREIGN KEY fk_payment;
ALTER TABLE Talon DROP COLUMN payment_id;

-- 2. Agregar talon_id en Payment
ALTER TABLE Payment ADD COLUMN talon_id VARCHAR(24);

-- 3. Crear FK de Payment.talon_id hacia Talon._id
ALTER TABLE Payment 
ADD CONSTRAINT fk_payment_talon
FOREIGN KEY (talon_id) REFERENCES Talon(_id);

--

-- ALTER TABLE Talon ADD CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES Payment(_id);