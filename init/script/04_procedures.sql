USE lab_db_sql;

DELIMITER $$

-- ==========================================================
-- 1. PROCEDIMIENTO AUXILIAR: recalcula total_amount de un talon
-- ==========================================================
DROP PROCEDURE IF EXISTS recalc_talon_total$$

CREATE PROCEDURE recalc_talon_total(IN p_talon_id VARCHAR(24))
proc_block: BEGIN
  DECLARE v_total DECIMAL(10,2); 

  IF p_talon_id IS NULL THEN
    LEAVE proc_block;
  END IF;

  SELECT IFNULL(SUM(ms.price), 0)
  INTO v_total
  FROM DoctorAppointment da
  JOIN DoctorAppointment_MedicalStudy dam ON dam.doctor_appointment_id = da._id
  JOIN MedicalStudy ms ON ms._id = dam.medical_study_id
  WHERE da.talon_id = p_talon_id;

  UPDATE Talon
  SET total_amount = v_total
  WHERE _id = p_talon_id;
  
END proc_block$$

-- ==========================================================
-- 2. PROCEDIMIENTO DE PAGO: process_payment_and_generate_order
-- ==========================================================
DROP PROCEDURE IF EXISTS process_payment_and_generate_order$$

CREATE PROCEDURE process_payment_and_generate_order(IN p_payment_id VARCHAR(24))
proc_block: BEGIN
    DECLARE v_talon_id VARCHAR(24);
    DECLARE v_orden_id VARCHAR(24);
    DECLARE v_doctor_appointment_id VARCHAR(24);

    -- 1. Obtener el talon_id del pago
    SELECT talon_id INTO v_talon_id
    FROM Payment
    WHERE _id = p_payment_id
    LIMIT 1;

    IF v_talon_id IS NULL THEN
        LEAVE proc_block;
    END IF;

    -- 2. Actualizar Talon y DoctorAppointment (lógica de pago)
    UPDATE Talon
    SET is_paid = TRUE
    WHERE _id = v_talon_id;

    UPDATE DoctorAppointment
    SET is_paid = TRUE
    WHERE talon_id = v_talon_id;

    -- 3. Generar Orden y Orden_MedicalStudy
    BEGIN
        DECLARE done INT DEFAULT FALSE;
        DECLARE cur_appointment CURSOR FOR 
            SELECT _id
            FROM DoctorAppointment
            WHERE talon_id = v_talon_id;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        OPEN cur_appointment;

        read_loop: LOOP
            FETCH cur_appointment INTO v_doctor_appointment_id;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Usando LEFT(UUID(), 24)
            SET v_orden_id = LEFT(UUID(), 24); 

            -- Insertar la nueva Orden
            INSERT INTO Orden (_id, doctor_appointment_id)
            VALUES (v_orden_id, v_doctor_appointment_id);

            -- Copiar MedicalStudies
            INSERT INTO Orden_MedicalStudy (orden_id, medical_study_id)
            SELECT v_orden_id, medical_study_id
            FROM DoctorAppointment_MedicalStudy
            WHERE doctor_appointment_id = v_doctor_appointment_id;

        END LOOP;

        CLOSE cur_appointment;
    END;

END proc_block$$

-- ==========================================================
-- 3. PROCEDIMIENTO DE RESULTADOS: check_and_complete_appointment
-- ==========================================================
DROP PROCEDURE IF EXISTS check_and_complete_appointment$$

CREATE PROCEDURE check_and_complete_appointment(IN p_orden_id VARCHAR(24))
proc_block: BEGIN
    DECLARE v_doctor_appointment_id VARCHAR(24);
    DECLARE v_total_studies INT;
    DECLARE v_completed_results INT;

    -- 1. Obtener el ID de la cita asociada a esta orden
    SELECT doctor_appointment_id INTO v_doctor_appointment_id
    FROM Orden
    WHERE _id = p_orden_id
    LIMIT 1;

    IF v_doctor_appointment_id IS NULL THEN
        LEAVE proc_block;
    END IF;

    -- 2. Contar el número TOTAL de estudios que se ordenaron para esta cita
    SELECT COUNT(*) INTO v_total_studies
    FROM DoctorAppointment_MedicalStudy
    WHERE doctor_appointment_id = v_doctor_appointment_id;

    -- 3. Contar el número de estudios que YA tienen un RESULTADO
    SELECT COUNT(DISTINCT r.medical_study_id) INTO v_completed_results
    FROM Result r
    JOIN Orden o ON r.orden_id = o._id
    WHERE o.doctor_appointment_id = v_doctor_appointment_id;

    -- 4. Verificar si todos los resultados están completos y actualizar el estado
    IF v_total_studies > 0 AND v_total_studies = v_completed_results THEN
        UPDATE DoctorAppointment
        SET status = 'completed'
        WHERE _id = v_doctor_appointment_id
        AND status <> 'completed';
    END IF;

END proc_block$$

DELIMITER ;