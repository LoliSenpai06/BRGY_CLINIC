TRIGGER-- Triggers `appointments`
--
DELIMITER $$
CREATE TRIGGER `after_appointment_complete` AFTER UPDATE ON `appointments` FOR EACH ROW BEGIN
    IF NEW.status = 'Completed' AND OLD.status != 'Completed' THEN
        INSERT INTO health_records (patient_id, date, details)
        VALUES (
            NEW.patient_id,
            NEW.date,
            CONCAT('Appointment completed: ', NEW.reason)
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validate_appointment_time` BEFORE INSERT ON `appointments` FOR EACH ROW BEGIN
    DECLARE day_name VARCHAR(10);

    SET day_name = DAYNAME(NEW.date);

    -- Past date
    IF NEW.date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Appointment date cannot be in the past.';
    END IF;

    -- Patient exists
    IF NOT EXISTS (SELECT 1 FROM patients WHERE id = NEW.patient_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient does not exist.';
    END IF;

    -- Doctor exists
    IF NOT EXISTS (SELECT 1 FROM doctors WHERE id = NEW.doctor_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor does not exist.';
    END IF;

    -- Service exists
    IF NOT EXISTS (SELECT 1 FROM services WHERE id = NEW.service_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Service does not exist.';
    END IF;

    -- Doctor-Service rule
    IF NEW.doctor_id = 1 AND NEW.service_id != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'GP can only do General Checkup.';
    END IF;

    IF NEW.doctor_id = 2 AND NEW.service_id != 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OB can only do Prenatal.';
    END IF;

    IF NEW.doctor_id = 3 AND NEW.service_id != 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pediatrician can only do Pediatric.';
    END IF;

    -- Double booking protection
    IF EXISTS (
        SELECT 1 FROM appointments
        WHERE doctor_id = NEW.doctor_id
          AND date = NEW.date
          AND time = NEW.time
          AND status IN ('Pending','Confirmed')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor already booked at this time.';
    END IF;

    -- Doctor schedules
    IF NEW.doctor_id = 1 AND (
        day_name NOT IN ('Monday','Tuesday','Wednesday','Thursday','Friday')
        OR NEW.time < '09:00:00'
        OR NEW.time > '17:00:00'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'GP available Mon–Fri, 9AM–5PM only.';
    END IF;

    IF NEW.doctor_id = 2 AND (
        day_name NOT IN ('Tuesday','Wednesday','Thursday')
        OR NEW.time < '10:00:00'
        OR NEW.time > '16:00:00'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OB available Tue–Thu, 10AM–4PM only.';
    END IF;

    IF NEW.doctor_id = 3 AND (
        day_name NOT IN ('Monday','Tuesday','Wednesday')
        OR NEW.time < '08:00:00'
        OR NEW.time > '15:00:00'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pediatrician available Mon–Wed, 8AM–3PM only.';
    END IF;

END