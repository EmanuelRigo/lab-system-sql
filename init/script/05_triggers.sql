USE lab_db_sql;

-- -- Roles (MySQL 8+)
-- CREATE ROLE IF NOT EXISTS role_admin;
-- CREATE ROLE IF NOT EXISTS role_receptionist;
-- CREATE ROLE IF NOT EXISTS role_biochemist;

-- -- Permisos por rol
-- -- Admin: todo
-- GRANT ALL PRIVILEGES ON lab_db_sql.* TO role_admin;

-- -- Receptionist: pacientes, citas, talones, pagos (CRUD básico)
-- GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Patient            TO role_receptionist;
-- GRANT SELECT, INSERT, UPDATE ON lab_db_sql.DoctorAppointment  TO role_receptionist;
-- GRANT SELECT, INSERT, UPDATE ON lab_db_sql.Talon              TO role_receptionist;
-- GRANT SELECT, INSERT        ON lab_db_sql.Payment            TO role_receptionist;
-- GRANT SELECT                ON lab_db_sql.MedicalStudy       TO role_receptionist;

-- -- Biochemist: resultados (crear/editar) y lectura de lo demás
-- GRANT SELECT                          ON lab_db_sql.Patient           TO role_biochemist;
-- GRANT SELECT                          ON lab_db_sql.DoctorAppointment TO role_biochemist;
-- GRANT SELECT, INSERT, UPDATE          ON lab_db_sql.Result            TO role_biochemist;

-- -- Usuarios de ejemplo (cámbiales la contraseña)
-- CREATE USER IF NOT EXISTS 'app_admin'@'%' IDENTIFIED BY 'ChangeMe_admin!';
-- CREATE USER IF NOT EXISTS 'app_frontdesk'@'%' IDENTIFIED BY 'ChangeMe_frontdesk!';
-- CREATE USER IF NOT EXISTS 'app_biochem'@'%' IDENTIFIED BY 'ChangeMe_biochem!';

-- GRANT role_admin        TO 'app_admin'@'%';
-- GRANT role_receptionist TO 'app_frontdesk'@'%';
-- GRANT role_biochemist   TO 'app_biochem'@'%';

-- -- Que los roles queden activos por defecto
-- SET DEFAULT ROLE role_admin        FOR 'app_admin'@'%';
-- SET DEFAULT ROLE role_receptionist FOR 'app_frontdesk'@'%';
-- SET DEFAULT ROLE role_biochemist   FOR 'app_biochem'@'%';


-- Triggers

-- Actualizar Talon.is_paid a TRUE tras insertar un pago
DELIMITER $$

CREATE TRIGGER trg_after_payment_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
  -- 1. Actualizar Talon como pagado
  UPDATE Talon
  SET is_paid = TRUE
  WHERE _id = NEW.talon_id;

  -- 2. Actualizar DoctorAppointment como pagado
  UPDATE DoctorAppointment
  SET is_paid = TRUE
  WHERE talon_id = NEW.talon_id;
END$$

DELIMITER ;

-- Asignar automáticamente el campo Payment.amount al total_amount del Talon relacionado
DELIMITER $$

CREATE TRIGGER trg_before_payment_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE talonTotal DECIMAL(10,2);

    -- Buscar el total_amount del talon relacionado
    SELECT total_amount
    INTO talonTotal
    FROM Talon
    WHERE _id = NEW.talon_id;

    -- Asignar el valor automáticamente al campo amount del pago
    SET NEW.amount = talonTotal;

    -- Actualizar DoctorAppointment: asignar el talon_id a todas las citas que correspondan
    UPDATE DoctorAppointment
    SET talon_id = NEW.talon_id
    WHERE talon_id IS NULL
      AND patient_id = (
          SELECT patient_id
          FROM Talon
          WHERE _id = NEW.talon_id
      );
END$$


--
DELIMITER ;


-- Actualizar DoctorAppointment.status a 'completed' tras insertar un resultado

DELIMITER //

CREATE TRIGGER trg_result_after_insert
AFTER INSERT ON result
FOR EACH ROW
BEGIN
  -- Actualizamos el status del doctor_appointment relacionado
  UPDATE doctorAppointment
  SET status = 'completed'
  WHERE _id = NEW.doctor_appointment_id;
END //

DELIMITER ;


