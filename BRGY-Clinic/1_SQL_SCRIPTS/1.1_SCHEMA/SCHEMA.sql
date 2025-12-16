 Database: `brgy_clinic`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_appointment` (IN `p_patient_id` INT, IN `p_doctor_id` INT, IN `p_service_id` INT, IN `p_date` DATE, IN `p_time` TIME, IN `p_reason` TEXT)   BEGIN
    INSERT INTO appointments
        (patient_id, doctor_id, service_id, date, time, reason)
    VALUES
        (p_patient_id, p_doctor_id, p_service_id, p_date, p_time, p_reason);
END$$


CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `name`) VALUES
(1, 'General Checkup'),
(2, 'Prenatal'),
(3, 'Pediatric');


CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `specialization` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `name`, `specialization`) VALUES
(1, 'Dr. Santos', 'General Practitioner'),
(2, 'Dr. Reyes', 'Obstetrician'),
(3, 'Dr. Cruz', 'Pediatrician');

-- --------------------------------------------------------

--
-- Stand-in structure for view `elderly_appointments`
-- (See below for the actual view)
--
CREATE TABLE `elderly_appointments` (
`name` varchar(100)
,`age` int(11)
,`date` date
,`status` enum('Pending','Confirmed','Completed','Cancelled')
,`specialization` varchar(100)
);


CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('Pending','Confirmed','Completed','Cancelled') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



INSERT INTO `appointments` (`id`, `patient_id`, `doctor_id`, `service_id`, `date`, `time`, `reason`, `status`) VALUES
(1, 1, 1, 1, '2025-12-15', '10:00:00', 'General checkup', 'Completed'),
(2, 2, 1, 1, '2025-12-19', '10:00:00', 'Test appointment', 'Confirmed'),
(3, 5, 3, 3, '2025-12-22', '09:00:00', 'Pediatric checkup', 'Pending'),
(5, 10, 1, 1, '2025-12-22', '11:00:00', 'Pediatric checkup', 'Pending'),
(6, 41, 1, 1, '2025-12-30', '09:30:00', 'checkup', 'Pending'),
(7, 41, 1, 1, '2026-01-06', '09:30:00', 'checkup', 'Pending'),
(8, 41, 1, 1, '2025-12-25', '09:30:00', 'checkup', 'Pending');