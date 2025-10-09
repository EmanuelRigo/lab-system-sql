USE lab_db_sql;

-- ==========================================================
-- ✅ TRIGGERS
-- ==========================================================

-- ==========================================================
-- 1️⃣ Actualizar Talon.is_paid y DoctorAppointment.is_paid después de un pago
-- ----------------------------------------------------------
-- Este trigger se ejecuta automáticamente después de insertar un pago.
-- Marca el Talon como pagado y todas las DoctorAppointments relacionadas
-- con ese Talon también se actualizan como pagadas.
-- ==========================================================

DELIMITER $$

CREATE TRIGGER trg_after_payment_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
  -- 1. Marcar el Talon como pagado
  UPDATE Talon
  SET is_paid = TRUE
  WHERE _id = NEW.talon_id;

  -- 2. Marcar las DoctorAppointments asociadas como pagadas
  UPDATE DoctorAppointment
  SET is_paid = TRUE
  WHERE talon_id = NEW.talon_id;
END$$

DELIMITER ;


-- ==========================================================
-- 2️⃣ Asignar automáticamente el monto del Payment al total del Talon
-- ----------------------------------------------------------
-- Este trigger se ejecuta antes de insertar un pago y:
--   - Copia el total_amount del Talon al campo amount del Payment.
--   - Garantiza que el talon_id esté correctamente asignado a las citas del paciente.
-- ==========================================================

DELIMITER $$

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
-- 3️⃣ Actualizar DoctorAppointment.status a 'completed' tras insertar un Result
-- ----------------------------------------------------------
-- Como el Result está vinculado a una Orden y la Orden pertenece
-- a un DoctorAppointment, el trigger debe hacer un JOIN con Orden.
-- ==========================================================

DELIMITER $$

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

