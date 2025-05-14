# Clinic Booking System

A comprehensive MySQL database system designed to manage medical clinic operations including appointment scheduling, patient records, doctor management, and billing.

## Project Overview

The Clinic Booking System is a robust relational database solution designed to address the core operational needs of modern medical clinics. The system handles everything from user authentication to medical records management, with a focus on data integrity and efficient relationship modeling.

### Key Features

- **User Management**: Role-based access control for staff and patients
- **Appointment Scheduling**: Comprehensive booking system with availability tracking
- **Patient Records**: Secure storage of medical histories and test results
- **Billing & Insurance**: Complete financial tracking with insurance integration
- **Prescription Management**: Digital prescription creation and tracking
- **Feedback System**: Patient satisfaction monitoring
### Core Entities
- Users (authentication)
- Patients (demographic information)
- Doctors (professional information)
- Appointments (scheduling)

### Support Tables
- Medical specialties
- Departments
- Rooms
- Services
- Medications
- Insurance providers

### Many-to-Many Relationships
- Patient allergies
- Doctor departments
- Bill services

## Entity Relationship Diagram

![Clinic Booking System ERD](https://i.imgur.com/aBcXyZ0.png)

*Note: This is a placeholder image URL. Replace with your actual ERD image link or path.*

## Installation and Setup

### Prerequisites

- MySQL Server 5.7+ or MariaDB 10.2+
- MySQL Client or interface (like MySQL Workbench, phpMyAdmin, etc.)

### Import Steps

1. **Clone the repository**
   ```
   git clone https://github.com/yourusername/clinic-booking-system.git
   cd clinic-booking-system
   ```

2. **Using MySQL Command Line**
   ```
   mysql -u username -p < clinic_booking_system.sql
   ```

3. **Using MySQL Workbench**
   - Open MySQL Workbench
   - Connect to your MySQL server
   - Go to Server > Data Import
   - Choose "Import from Self-Contained File" and select the `clinic_booking_system.sql` file
   - Start Import

4. **Verify Installation**
   ```sql
   SHOW DATABASES;
   USE clinic_booking_system;
   SHOW TABLES;
   ```

## Database Usage Examples

### Schedule a New Appointment

```sql
INSERT INTO appointments (
    patient_id, doctor_id, appointment_date, 
    start_time, end_time, status_id, 
    appointment_type, reason_for_visit
) VALUES (
    1, 3, '2025-06-01', 
    '14:00:00', '14:30:00', 1, 
    'Regular Checkup', 'Annual physical examination'
);
```

### Find Available Doctors by Specialty

```sql
SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
       ms.specialty_name, da.day_of_week, da.start_time, da.end_time
FROM doctors d
JOIN medical_specialties ms ON d.specialty_id = ms.specialty_id
JOIN doctor_availability da ON d.doctor_id = da.doctor_id
WHERE ms.specialty_name = 'Cardiology' 
AND da.is_available = TRUE
AND da.day_of_week = 'Monday';
```

### View Patient Medical History

```sql
SELECT mr.record_id, mr.diagnosis, mr.treatment_plan,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       a.appointment_date
FROM medical_records mr
JOIN doctors d ON mr.doctor_id = d.doctor_id
JOIN appointments a ON mr.appointment_id = a.appointment_id
WHERE mr.patient_id = 2
ORDER BY a.appointment_date DESC;
```

## Future Enhancements

- Data archiving system for old records
- Integration with laboratory information systems
- Enhanced reporting capabilities
- Telemedicine support
- Patient portal functionality
