use lab_db_sql;

LOAD DATA INFILE '/var/lib/mysql-files/medical_studies.csv'
INTO TABLE MedicalStudy
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, name, price, description, duration);

LOAD DATA INFILE '/var/lib/mysql-files/payment_methods.csv'
INTO TABLE PaymentMethod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, name, description, is_active);

LOAD DATA INFILE '/var/lib/mysql-files/patients.csv'
INTO TABLE Patient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, firstname, secondname, lastname, birth_date, dni, email, phone, address);

LOAD DATA INFILE '/var/lib/mysql-files/LabStaff.csv'
INTO TABLE LabStaff
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, firstname, secondname, lastname, username, password, role, email, phone, is_online, created_at, updated_at);

LOAD DATA INFILE '/var/lib/mysql-files/DoctorAppointment.csv'
INTO TABLE DoctorAppointment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, is_paid, patient_id, receptionist_id, date, reason, status)
SET talon_id = NULLIF(talon_id, '');

LOAD DATA INFILE '/var/lib/mysql-files/Talon.csv'
INTO TABLE Talon
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, receptionist_id, is_paid);

LOAD DATA INFILE '/var/lib/mysql-files/DoctorAppointment_MedicalStudy.csv'
INTO TABLE DoctorAppointment_MedicalStudy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(doctor_appointment_id, medical_study_id);

UPDATE DoctorAppointment SET talon_id='f81bf30d39efa8bf45ff7586' WHERE _id='4a6d083eae25ecf58917f24d';


LOAD DATA INFILE '/var/lib/mysql-files/Payment.csv'
INTO TABLE Payment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, amount, talon_id, payment_method_id, created_at, updated_at);

LOAD DATA INFILE '/var/lib/mysql-files/Result_202509201606.csv'
INTO TABLE Result
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(_id, medical_study_id, doctor_appointment_id, labtechnician_id, @biochemist_id, status, result, description, extraction_date, created_at, updated_at)
SET biochemist_id = NULLIF(@biochemist_id, '');
