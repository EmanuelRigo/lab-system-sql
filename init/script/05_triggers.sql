USE lab_db_sql;

-- ==========================================================
-- ✅ TRIGGERS COMPLETOS
-- ==========================================================

-- ==========================================================
-- 1️⃣ Asignar automáticamente el monto del Payment al total del Talon
-- ==========================================================
DELIMITER $$

DROP TRIGGER IF EXISTS trg_before_payment_insert$$
CREATE TRIGGER trg_before_payment_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
  DECLARE talonTotal DECIMAL(10,2);
  DECLARE patientId VARCHAR(24);

  -- Obtener el total_amount y patient_id del Talon
  SELECT t.total_amount, da.patient_id
  INTO talonTotal, patientId
  FROM Talon t
  JOIN DoctorAppointment da ON da.talon_id = t._id
  WHERE t._id = NEW.talon_id
  LIMIT 1;

  -- Asignar automáticamente el total del Talon al Payment
  SET NEW.amount = talonTotal;

  -- Enlazar las citas del paciente con el mismo talón (si aún no lo están)
  UPDATE DoctorAppointment
  SET talon_id = NEW.talon_id
  WHERE talon_id IS NULL AND patient_id = patientId;
END$$

DELIMITER ;

-- ==========================================================
-- 2️⃣ Crear Orden y actualizar Talon tras el pago
-- ==========================================================
DELIMITER $$

DROP TRIGGER IF EXISTS trg_after_payment_insert$$
CREATE TRIGGER trg_after_payment_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
  DECLARE newOrderId VARCHAR(24);
  DECLARE totalAmount DECIMAL(10,2);
  DECLARE done INT DEFAULT FALSE;
  DECLARE da_id VARCHAR(24);

  -- Cursor y handler deben declararse antes de cualquier otra sentencia
  DECLARE da_cursor CURSOR FOR
    SELECT _id FROM DoctorAppointment WHERE talon_id = NEW.talon_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  -- 1️⃣ Marcar el Talon como pagado
  UPDATE Talon
  SET is_paid = TRUE
  WHERE _id = NEW.talon_id;

  -- 2️⃣ Marcar las DoctorAppointments asociadas como pagadas
  UPDATE DoctorAppointment
  SET is_paid = TRUE
  WHERE talon_id = NEW.talon_id;

  -- 3️⃣ Crear una nueva Orden para cada DoctorAppointment pagado
  OPEN da_cursor;

  read_loop: LOOP
    FETCH da_cursor INTO da_id;
    IF done THEN
      LEAVE read_loop;
    END IF;

    SET newOrderId = UUID();

    -- Crear la orden
    INSERT INTO Orden (_id, doctor_appointment_id, created_at, updated_at)
    VALUES (newOrderId, da_id, NOW(), NOW());

    -- Vincular estudios a la orden
    INSERT INTO Orden_MedicalStudy (orden_id, medical_study_id)
    SELECT newOrderId, dam.medical_study_id
    FROM DoctorAppointment_MedicalStudy dam
    WHERE dam.doctor_appointment_id = da_id;

    -- Calcular total de la orden
    SELECT SUM(ms.price)
    INTO totalAmount
    FROM Orden_MedicalStudy oms
    JOIN MedicalStudy ms ON ms._id = oms.medical_study_id
    WHERE oms.orden_id = newOrderId;

    -- Actualizar el total del Talon
    UPDATE Talon
    SET total_amount = total_amount + IFNULL(totalAmount, 0)
    WHERE _id = NEW.talon_id;

  END LOOP;

  CLOSE da_cursor;
END$$

DELIMITER ;


-- ==========================================================
-- 3️⃣ Actualizar DoctorAppointment.status a 'completed' tras insertar un Result
-- ==========================================================
DELIMITER $$

DROP TRIGGER IF EXISTS trg_result_after_insert$$
CREATE TRIGGER trg_result_after_insert
AFTER INSERT ON Result
FOR EACH ROW
BEGIN
  DECLARE appointmentId VARCHAR(24);

  -- Buscar el doctor_appointment_id asociado a la Orden del resultado
  SELECT o.doctor_appointment_id
  INTO appointmentId
  FROM Orden o
  WHERE o._id = NEW.orden_id
  LIMIT 1;

  -- Si encontramos la cita, la marcamos como completada
  IF appointmentId IS NOT NULL THEN
    UPDATE DoctorAppointment
    SET status = 'completed'
    WHERE _id = appointmentId;
  END IF;
END$$

DELIMITER ;
