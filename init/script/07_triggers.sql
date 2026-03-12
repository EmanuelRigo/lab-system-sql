-- ==========================================================
-- 🎯 TRIGGERS - PostgreSQL
-- ==========================================================

-- ==========================================================
-- 1. FUNCIONES TRIGGER: Recalcular total_amount del talón
-- ==========================================================

-- Función para cuando se actualiza DoctorAppointment
CREATE OR REPLACE FUNCTION trg_update_talon_total_amount_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.talon_id IS NOT NULL AND (OLD.talon_id IS NULL OR OLD.talon_id <> NEW.talon_id) THEN
        PERFORM recalc_talon_total(NEW.talon_id);
    END IF;

    IF OLD.talon_id IS NOT NULL AND OLD.talon_id <> NEW.talon_id THEN
        PERFORM recalc_talon_total(OLD.talon_id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_talon_total_amount ON DoctorAppointment;
CREATE TRIGGER trg_update_talon_total_amount
AFTER UPDATE ON DoctorAppointment
FOR EACH ROW
EXECUTE FUNCTION trg_update_talon_total_amount_func();


-- Función para cuando se agrega un estudio a una cita
CREATE OR REPLACE FUNCTION trg_dam_after_insert_func()
RETURNS TRIGGER AS $$
DECLARE
    v_talon_id VARCHAR(24);
BEGIN
    SELECT talon_id INTO v_talon_id
    FROM DoctorAppointment
    WHERE _id = NEW.doctor_appointment_id
    LIMIT 1;

    IF v_talon_id IS NOT NULL THEN
        PERFORM recalc_talon_total(v_talon_id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_dam_after_insert ON DoctorAppointment_MedicalStudy;
CREATE TRIGGER trg_dam_after_insert
AFTER INSERT ON DoctorAppointment_MedicalStudy
FOR EACH ROW
EXECUTE FUNCTION trg_dam_after_insert_func();


-- Función para cuando se elimina un estudio de una cita
CREATE OR REPLACE FUNCTION trg_dam_after_delete_func()
RETURNS TRIGGER AS $$
DECLARE
    v_talon_id VARCHAR(24);
BEGIN
    SELECT talon_id INTO v_talon_id
    FROM DoctorAppointment
    WHERE _id = OLD.doctor_appointment_id
    LIMIT 1;

    IF v_talon_id IS NOT NULL THEN
        PERFORM recalc_talon_total(v_talon_id);
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_dam_after_delete ON DoctorAppointment_MedicalStudy;
CREATE TRIGGER trg_dam_after_delete
AFTER DELETE ON DoctorAppointment_MedicalStudy
FOR EACH ROW
EXECUTE FUNCTION trg_dam_after_delete_func();

-- ==========================================================
-- 2. FUNCIONES TRIGGER: Validación de pago
-- ==========================================================

-- Función BEFORE INSERT para validar y asignar monto del pago
CREATE OR REPLACE FUNCTION trg_payment_before_insert_func()
RETURNS TRIGGER AS $$
DECLARE
    v_total_amount DECIMAL(10,2);
BEGIN
    IF NEW.talon_id IS NULL THEN
        RAISE EXCEPTION 'El pago debe estar asociado a un talon (talon_id no puede ser NULL).';
    END IF;

    -- Obtener el total_amount del Talon asociado
    SELECT total_amount INTO v_total_amount
    FROM Talon
    WHERE _id = NEW.talon_id
    LIMIT 1;

    IF v_total_amount IS NULL THEN
        RAISE EXCEPTION 'El talon_id no existe en la tabla Talon';
    END IF;

    IF v_total_amount = 0 THEN
        RAISE EXCEPTION 'El monto del talon no puede ser cero';
    END IF;

    IF NEW.amount IS NULL OR NEW.amount <> v_total_amount THEN
        RAISE EXCEPTION 'El monto del pago no coincide con el monto del talon';
    END IF;

    -- Asignar (o forzar) el monto del pago al total del talón.
    NEW.amount := v_total_amount;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_payment_before_insert ON Payment;
CREATE TRIGGER trg_payment_before_insert
BEFORE INSERT ON Payment
FOR EACH ROW
EXECUTE FUNCTION trg_payment_before_insert_func();


-- Función AFTER INSERT para disparar el procesamiento de la orden
CREATE OR REPLACE FUNCTION trg_payment_after_insert_func()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM process_payment_and_generate_order(NEW._id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_payment_after_insert ON Payment;
CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON Payment
FOR EACH ROW
EXECUTE FUNCTION trg_payment_after_insert_func();

-- ==========================================================
-- 3. FUNCIÓN TRIGGER: Resultados (cambio de estado de cita)
-- ==========================================================

CREATE OR REPLACE FUNCTION trg_result_after_insert_func()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM check_and_complete_appointment(NEW.orden_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_result_after_insert ON Result;
CREATE TRIGGER trg_result_after_insert
AFTER INSERT ON Result
FOR EACH ROW
EXECUTE FUNCTION trg_result_after_insert_func();

-- ==========================================================
-- 4. FUNCIONES TRIGGER: Actualización automática de updated_at
-- ==========================================================

-- Función genérica para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar a todas las tablas con updated_at
DROP TRIGGER IF EXISTS trg_update_labstaff_updated_at ON LabStaff;
CREATE TRIGGER trg_update_labstaff_updated_at
BEFORE UPDATE ON LabStaff
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_patient_updated_at ON Patient;
CREATE TRIGGER trg_update_patient_updated_at
BEFORE UPDATE ON Patient
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_medicalstudy_updated_at ON MedicalStudy;
CREATE TRIGGER trg_update_medicalstudy_updated_at
BEFORE UPDATE ON MedicalStudy
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_talon_updated_at ON Talon;
CREATE TRIGGER trg_update_talon_updated_at
BEFORE UPDATE ON Talon
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_doctorappointment_updated_at ON DoctorAppointment;
CREATE TRIGGER trg_update_doctorappointment_updated_at
BEFORE UPDATE ON DoctorAppointment
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_orden_updated_at ON Orden;
CREATE TRIGGER trg_update_orden_updated_at
BEFORE UPDATE ON Orden
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_result_updated_at ON Result;
CREATE TRIGGER trg_update_result_updated_at
BEFORE UPDATE ON Result
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_paymentmethod_updated_at ON PaymentMethod;
CREATE TRIGGER trg_update_paymentmethod_updated_at
BEFORE UPDATE ON PaymentMethod
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_payment_updated_at ON Payment;
CREATE TRIGGER trg_update_payment_updated_at
BEFORE UPDATE ON Payment
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();