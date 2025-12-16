# Barangay Clinic Appointment Management System  
**Sustainable Development Goal (SDG): SDG 3 – Good Health and Well-Being**

---

## Project Title and SDG Goal

**Barangay Clinic Appointment Management System using MySQL**

This project supports **Sustainable Development Goal 3 (Good Health and Well-Being)** by improving the efficiency, reliability, and organization of healthcare appointment management at the barangay clinic level. The system addresses common issues such as manual scheduling errors, data inconsistency, and inefficient reporting through a database-driven solution.

---

## Project Description

The Barangay Clinic Appointment Management System is a MySQL-based database application designed to manage patient records, doctors, services, and clinic appointments in a structured and reliable manner. The system applies core **Database Management System (DBMS) concepts** to ensure data integrity, automation, and accurate reporting.

### Core DBMS Concepts Used:
- **Stored Procedure** – Centralizes and standardizes the appointment booking process.
- **Trigger** – Automatically enforces business rules such as preventing past appointments, invalid doctor-service combinations, and double bookings.
- **Foreign Key** – Maintains referential integrity between patients, doctors, services, and appointments.
- **View** – Simplifies reporting by presenting summarized and joined data (e.g., elderly appointments and service summaries).
- **Constraints** – Ensures valid and consistent data using primary keys, unique constraints, check conditions, and not-null rules.

These concepts were chosen to ensure that the system is **robust, maintainable, and compliant with real-world clinic operations**.

---

## Installation / Setup

### Requirements
- MySQL Server (via XAMPP or similar)
- phpMyAdmin or MySQL CLI

### Setup Steps
1. Start **Apache** and **MySQL** in XAMPP.
2. Open **phpMyAdmin**.
3. Create a new database (e.g., `brgy_clinic`).
4. Import the provided SQL file:
   - Click **Import**
   - Select the `.sql` file
   - Click **Go**
5. Ensure all tables, procedures, triggers, views, and constraints are created successfully.

---

## Usage Instructions

### Booking an Appointment
1. Open phpMyAdmin or MySQL CLI.
2. Use the stored procedure to book an appointment:
   ```sql
   CALL book_appointment(patient_id, doctor_id, service_id, date, time, reason);

