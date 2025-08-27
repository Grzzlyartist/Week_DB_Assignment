-- Library Management System Database
-- Created by: Database Management System
-- Date: 2024

DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- 1. Members Table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE NOT NULL,
    membership_type ENUM('Student', 'Faculty', 'Staff', 'Public') NOT NULL DEFAULT 'Public',
    membership_status ENUM('Active', 'Suspended', 'Expired') NOT NULL DEFAULT 'Active',
    date_joined DATE NOT NULL,
    expiration_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_membership_status (membership_status),
    INDEX idx_expiration_date (expiration_date)
);

-- 2. Authors Table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_author_name (last_name, first_name)
);

-- 3. Publishers Table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(200),
    established_year YEAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_publisher_name (name)
);

-- 4. Books Table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    edition VARCHAR(20),
    publication_year YEAR,
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(30) NOT NULL DEFAULT 'English',
    page_count INT,
    description TEXT,
    publisher_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE CASCADE,
    
    INDEX idx_title (title),
    INDEX idx_genre (genre),
    INDEX idx_isbn (isbn),
    INDEX idx_publication_year (publication_year)
);

-- 5. Book-Author Relationship Table (Many-to-Many)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    role ENUM('Primary', 'Co-Author', 'Editor', 'Translator') DEFAULT 'Primary',
    
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
    
    INDEX idx_author_book (author_id, book_id)
);

-- 6. Book Copies Table
CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    copy_number INT NOT NULL,
    acquisition_date DATE NOT NULL,
    acquisition_price DECIMAL(10,2),
    condition ENUM('New', 'Good', 'Fair', 'Poor', 'Damaged') NOT NULL DEFAULT 'Good',
    status ENUM('Available', 'Checked Out', 'Reserved', 'Lost', 'Under Repair') NOT NULL DEFAULT 'Available',
    location VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_book_copy (book_id, copy_number),
    INDEX idx_status (status),
    INDEX idx_book_status (book_id, status)
);

-- 7. Loans Table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    
    INDEX idx_member_loans (member_id, status),
    INDEX idx_due_date (due_date),
    INDEX idx_checkout_date (checkout_date)
);

-- 8. Reservations Table
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') NOT NULL DEFAULT 'Pending',
    priority INT NOT NULL,
    expiry_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_active_reservation (book_id, member_id, status),
    INDEX idx_reservation_status (status),
    INDEX idx_reservation_date (reservation_date)
);

-- 9. Fines Table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    reason ENUM('Late Return', 'Lost Book', 'Damage', 'Other') NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Unpaid', 'Paid', 'Waived') NOT NULL DEFAULT 'Unpaid',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE SET NULL,
    
    INDEX idx_fine_status (status),
    INDEX idx_member_fines (member_id, status)
);

-- 10. Staff Table
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position ENUM('Librarian', 'Assistant', 'Administrator', 'IT Support') NOT NULL,
    department VARCHAR(50),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'On Leave', 'Terminated') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_staff_email (email),
    INDEX idx_staff_position (position)
);

-- 11. Library Branches Table
CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    manager_id INT,
    opening_hours TEXT,
    established_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (manager_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
    
    INDEX idx_branch_name (name)
);

-- 12. Book Locations Table (Links books to branches)
CREATE TABLE book_locations (
    copy_id INT NOT NULL,
    branch_id INT NOT NULL,
    shelf_number VARCHAR(20),
    aisle_number VARCHAR(20),
    floor INT,
    date_placed DATE NOT NULL,
    
    PRIMARY KEY (copy_id, branch_id),
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,
    
    INDEX idx_branch_location (branch_id, shelf_number, aisle_number)
);

-- 13. Transactions Table (Financial transactions)
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    staff_id INT NOT NULL,
    transaction_type ENUM('Fine Payment', 'Membership Fee', 'Donation', 'Other') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Online') NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    receipt_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_transaction_type (transaction_type)
);

-- 14. Audit Log Table
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    changed_by INT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (changed_by) REFERENCES staff(staff_id) ON DELETE CASCADE,
    
    INDEX idx_audit_table (table_name),
    INDEX idx_audit_date (changed_at),
    INDEX idx_audit_action (action_type)
);

-- 15. System Settings Table
CREATE TABLE system_settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) UNIQUE NOT NULL,
    setting_value VARCHAR(255) NOT NULL,
    description TEXT,
    last_modified_by INT,
    last_modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (last_modified_by) REFERENCES staff(staff_id) ON DELETE SET NULL,
    
    INDEX idx_setting_key (setting_key)
);

-- Insert default system settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('loan_period_days', '14', 'Default loan period in days'),
('max_books_per_member', '5', 'Maximum number of books a member can borrow at once'),
('late_fee_per_day', '0.25', 'Late fee charged per day for overdue books'),
('reservation_expiry_days', '3', 'Number of days a reservation remains valid'),
('membership_fee', '25.00', 'Annual membership fee for public members');

-- Create indexes for better performance
CREATE INDEX idx_members_full_name ON members (last_name, first_name);
CREATE INDEX idx_books_full_title ON books (title);
CREATE INDEX idx_loans_active_status ON loans (status);
CREATE INDEX idx_fines_unpaid ON fines (status, due_date);
CREATE INDEX idx_reservations_pending ON reservations (status, reservation_date);