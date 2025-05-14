-- Clinic Booking System Database
-- A comprehensive database for managing a medical clinic's operations including
-- patient information, doctor schedules, appointments, medical records, and billing.

-- Drop database if it exists (for clean setup)
DROP DATABASE IF EXISTS clinic_booking_system;

-- Create the database
CREATE DATABASE clinic_booking_system;

-- Use the database
USE clinic_booking_system;

-- USERS TABLE
-- Stores authentication and basic user information
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    role ENUM('admin', 'doctor', 'nurse', 'receptionist', 'patient') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PATIENTS TABLE
-- Stores detailed information about patients
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    insurance_provider VARCHAR(100),
    insurance_policy_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- MEDICAL_SPECIALTIES TABLE
-- Stores different medical specialties
CREATE TABLE medical_specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- DOCTORS TABLE
-- Stores information about doctors
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty_id INT,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    years_of_experience INT,
    biography TEXT,
    consultation_fee DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (specialty_id) REFERENCES medical_specialties(specialty_id)
);

-- DOCTOR_AVAILABILITY TABLE
-- Stores the working hours and availability of doctors
CREATE TABLE doctor_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_schedule (doctor_id, day_of_week, start_time, end_time)
);

-- APPOINTMENT_STATUS TABLE
-- Reference table for appointment statuses
CREATE TABLE appointment_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- APPOINTMENTS TABLE
-- Stores information about patient appointments
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status_id INT NOT NULL,
    appointment_type ENUM('Regular Checkup', 'Follow-up', 'Emergency', 'Consultation', 'Procedure') NOT NULL,
    reason_for_visit TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES appointment_status(status_id),
    UNIQUE KEY unique_appointment (doctor_id, appointment_date, start_time)
);

-- MEDICAL_RECORDS TABLE
-- Stores patient medical records
CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    diagnosis TEXT,
    treatment_plan TEXT,
    prescription TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL
);

-- MEDICATIONS TABLE
-- Reference table for medications
CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    description TEXT,
    dosage_form VARCHAR(50),
    manufacturer VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PRESCRIPTIONS TABLE
-- Detailed prescription information
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    medical_record_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (medical_record_id) REFERENCES medical_records(record_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
);

-- ALLERGIES TABLE
-- Reference table for types of allergies
CREATE TABLE allergies (
    allergy_id INT AUTO_INCREMENT PRIMARY KEY,
    allergy_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- PATIENT_ALLERGIES TABLE
-- Many-to-many relationship between patients and allergies
CREATE TABLE patient_allergies (
    patient_id INT NOT NULL,
    allergy_id INT NOT NULL,
    severity ENUM('Mild', 'Moderate', 'Severe') NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (patient_id, allergy_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (allergy_id) REFERENCES allergies(allergy_id) ON DELETE CASCADE
);

-- MEDICAL_TESTS TABLE
-- Reference table for types of medical tests
CREATE TABLE medical_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    normal_range VARCHAR(100),
    cost DECIMAL(10, 2)
);

-- PATIENT_TESTS TABLE
-- Stores test results for patients
CREATE TABLE patient_tests (
    patient_test_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    test_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    test_date DATE NOT NULL,
    result TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES medical_tests(test_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL
);

-- BILLING TABLE
-- Stores billing information for services
CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_status ENUM('Unpaid', 'Partially Paid', 'Paid', 'Insurance Processing') DEFAULT 'Unpaid',
    payment_method ENUM('Cash', 'Credit Card', 'Insurance', 'Bank Transfer') NULL,
    payment_date DATE NULL,
    invoice_number VARCHAR(50) UNIQUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL
);

-- SERVICES TABLE
-- Reference table for clinic services
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    cost DECIMAL(10, 2) NOT NULL,
    duration_minutes INT
);

-- BILL_SERVICES TABLE
-- Many-to-many relationship between bills and services
CREATE TABLE bill_services (
    bill_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00,
    total_price DECIMAL(10, 2) NOT NULL,
    notes TEXT,
    PRIMARY KEY (bill_id, service_id),
    FOREIGN KEY (bill_id) REFERENCES billing(bill_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- INSURANCE_PROVIDERS TABLE
-- Reference table for insurance providers
CREATE TABLE insurance_providers (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL UNIQUE,
    contact_person VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    notes TEXT
);

-- PATIENT_INSURANCE TABLE
-- Detailed patient insurance information
CREATE TABLE patient_insurance (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    provider_id INT NOT NULL,
    policy_number VARCHAR(50) NOT NULL,
    group_number VARCHAR(50),
    coverage_start_date DATE NOT NULL,
    coverage_end_date DATE,
    primary_holder_name VARCHAR(100),
    relationship_to_patient VARCHAR(50),
    coverage_details TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES insurance_providers(provider_id),
    UNIQUE KEY unique_patient_policy (patient_id, provider_id, policy_number)
);

-- DEPARTMENTS TABLE
-- Reference table for clinic departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    location VARCHAR(100)
);

-- STAFF TABLE
-- Stores information about non-doctor staff members
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT,
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- DOCTOR_DEPARTMENTS TABLE
-- Many-to-many relationship between doctors and departments
CREATE TABLE doctor_departments (
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- ROOMS TABLE
-- Information about clinic rooms
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20) NOT NULL UNIQUE,
    room_type ENUM('Examination', 'Operating', 'Consultation', 'Waiting', 'Laboratory') NOT NULL,
    capacity INT,
    department_id INT,
    is_available BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ROOM_ASSIGNMENTS TABLE
-- Links appointments to specific rooms
CREATE TABLE room_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    room_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);

-- NOTIFICATIONS TABLE
-- Stores notification messages
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('Appointment', 'Lab Result', 'Bill', 'General', 'Reminder') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- FEEDBACK TABLE
-- Stores patient feedback
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    doctor_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
);

-- Initialize Appointment Status
INSERT INTO appointment_status (status_name, description) VALUES
('Scheduled', 'Appointment has been scheduled'),
('Confirmed', 'Appointment has been confirmed'),
('Completed', 'Appointment has been completed'),
('Cancelled', 'Appointment has been cancelled'),
('No-Show', 'Patient did not show up for the appointment'),
('Rescheduled', 'Appointment has been rescheduled');

-- Initialize some Medical Specialties
INSERT INTO medical_specialties (specialty_name, description) VALUES
('Cardiology', 'Diagnosis and treatment of heart disorders'),
('Dermatology', 'Diagnosis and treatment of skin disorders'),
('Orthopedics', 'Diagnosis and treatment of musculoskeletal disorders'),
('Pediatrics', 'Medical care of infants, children, and adolescents'),
('Neurology', 'Diagnosis and treatment of disorders of the nervous system'),
('General Medicine', 'Comprehensive healthcare for adults'),
('Gynecology', 'Medical care of the female reproductive system'),
('Ophthalmology', 'Diagnosis and treatment of eye disorders');

-- Initialize Departments
INSERT INTO departments (department_name, description, location) VALUES
('Cardiology Department', 'Heart treatment and care', 'Building A, Floor 2'),
('Dermatology Department', 'Skin care and treatment', 'Building A, Floor 1'),
('Orthopedics Department', 'Bone and joint care', 'Building B, Floor 1'),
('Pediatrics Department', 'Child healthcare', 'Building C, Floor 1'),
('Neurology Department', 'Brain and nervous system care', 'Building B, Floor 2'),
('Emergency Department', '24/7 emergency care services', 'Building D, Ground Floor'),
('Laboratory', 'Medical testing and diagnostics', 'Building E, Ground Floor'),
('Radiology', 'Imaging services', 'Building E, Floor 1');
