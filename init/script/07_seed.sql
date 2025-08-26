INSERT INTO MedicalStudy (_id, name, price, description, duration)
VALUES
('64a1f0a9b1234567890abc01', 'Hemograma', 2000.00, 'Evalúa glóbulos rojos, blancos y plaquetas. Ayuda a detectar anemias, infecciones y trastornos hematológicos. No necesita ayuno.', 24),
('64a1f0a9b1234567890abc02', 'Hepatograma', 5000.00, 'Evalúa el funcionamiento del hígado mediante enzimas y otras sustancias como TGO, TGP, bilirrubina y fosfatasa alcalina. Requiere 12 hs de ayuno.', 24),
('64a1f0a9b1234567890abc03', 'Ionograma', 8000.00, 'Mide electrolitos como sodio, potasio, cloro y calcio. Evalúa el equilibrio ácido-base, hidratación y función renal. Requiere 8 hs de ayuno.', 74),
('64a1f0a9b1234567890abc04', 'Vitamina D', 20000.00, 'Mide los niveles en sangre de 25(OH)D. Sirve para evaluar la salud ósea, absorción de calcio y posibles deficiencias o excesos. Requiere 8 hs de ayuno.', 74)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  price = VALUES(price),
  description = VALUES(description),
  duration = VALUES(duration);



-- LOAD DATA LOCAL INFILE '/var/lib/mysql-files/medical_studies.csv'
-- INTO TABLE MedicalStudy
-- FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES
-- (_id, name, price, description, duration);