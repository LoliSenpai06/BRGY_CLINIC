DELIMITER $$
CREATE TRIGGER `validate_appointment_update` BEFORE UPDATE ON `appointments` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1 FROM appointments
        WHERE doctor_id = NEW.doctor_id
          AND date = NEW.date
          AND time = NEW.time
          AND id != OLD.id
          AND status IN ('Pending','Confirmed')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor already booked for this schedule.';
    END IF;
END
$$
DELIMITER ;
