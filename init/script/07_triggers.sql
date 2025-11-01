USE lab_db_sql;

DELIMITER $$

-- ==========================================================
-- 1. TRIGGERS DE CÁLCULO (Recalculan el total del talón)
-- ==========================================================

/* 1.1. TRIGGER: Cuando se actualiza una cita (cambio o asignación de talón) */
DROP TRIGGER IF EXISTS trg_update_talon_total_amount$$
CREATE TRIGGER trg_update_talon_total_amount
AFTER UPDATE ON DoctorAppointment
FOR EACH ROW
BEGIN
  IF NEW.talon_id IS NOT NULL AND (OLD.talon_id IS NULL OR OLD.talon_id <> NEW.talon_id) THEN
    CALL recalc_talon_total(NEW.talon_id);
  END IF;

  IF OLD.talon_id IS NOT NULL AND OLD.talon_id <> NEW.talon_id THEN
    CALL recalc_talon_total(OLD.talon_id);
  END IF;
END$$


/* 1.2. TRIGGER: Cuando se AGREGA un estudio a una cita */
DROP TRIGGER IF EXISTS trg_dam_after_insert$$
CREATE TRIGGER trg_dam_after_insert
AFTER INSERT ON DoctorAppointment_MedicalStudy
FOR EACH ROW
BEGIN
  DECLARE v_talon_id VARCHAR(24);

  SELECT talon_id INTO v_talon_id
  FROM DoctorAppointment
  WHERE _id = NEW.doctor_appointment_id
  LIMIT 1;

  IF v_talon_id IS NOT NULL THEN
    CALL recalc_talon_total(v_talon_id);
  END IF;
END$$


/* 1.3. TRIGGER: Cuando se ELIMINA un estudio de una cita */
DROP TRIGGER IF EXISTS trg_dam_after_delete$$
CREATE TRIGGER trg_dam_after_delete
AFTER DELETE ON DoctorAppointment_MedicalStudy
FOR EACH ROW
BEGIN
  DECLARE v_talon_id VARCHAR(24);

  SELECT talon_id INTO v_talon_id
  FROM DoctorAppointment
  WHERE _id = OLD.doctor_appointment_id
  LIMIT 1;

  IF v_talon_id IS NOT NULL THEN
    CALL recalc_talon_total(v_talon_id);
  END IF;
END$$

-- ==========================================================
-- 2. TRIGGERS DE PAGO (Disparan la lógica de pago y orden)
-- ==========================================================

/* 2.1. TRIGGER BEFORE INSERT (Garantiza que el monto es correcto) */
DROP TRIGGER IF EXISTS trg_payment_before_insert$$

CREATE TRIGGER trg_payment_before_insert
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE v_total_amount DECIMAL(10,2);
    
    IF NEW.talon_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El pago debe estar asociado a un talon (talon_id no puede ser NULL).';
    END IF;

    -- Obtener el total_amount del Talon asociado
    SELECT total_amount
    INTO v_total_amount
    FROM Talon
    WHERE _id = NEW.talon_id
    LIMIT 1;

    -- Asignar (o forzar) el monto del pago al total del talón.
    SET NEW.amount = v_total_amount;
    
END$$


/* 2.2. TRIGGER AFTER INSERT (Dispara el procesamiento de la orden) */
DROP TRIGGER IF EXISTS trg_payment_after_insert$$

CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    CALL process_payment_and_generate_order(NEW._id);
END$$

-- ==========================================================
-- 3. TRIGGER DE RESULTADOS (Dispara el cambio de estado de la cita)
-- ==========================================================

DROP TRIGGER IF EXISTS trg_result_after_insert$$

CREATE TRIGGER trg_result_after_insert
AFTER INSERT ON Result
FOR EACH ROW
BEGIN
    -- Llama al procedimiento que verifica si todos los estudios de la cita
    -- asociada a esta orden están completos.
    CALL check_and_complete_appointment(NEW.orden_id);
END$$

-- Volver al delimitador por defecto (;)
DELIMITER ;