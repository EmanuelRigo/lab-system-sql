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
