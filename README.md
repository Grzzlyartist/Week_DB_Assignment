# Week8_DB_Assignment
📚 Library Management System Database
A complete and well-structured MySQL database for managing library operations efficiently. This system handles books, members, loans, reservations, and more!

🗂️ Database Overview
📊 Tables Included:
📖 members - Library member information

✍️ authors - Book authors details

🏢 publishers - Publishing companies

📗 books - Book catalog and metadata

👥 book_authors - Many-to-many relationship between books and authors

📋 book_copies - Individual physical copies of books

🔄 loans - Book borrowing transactions

⏰ reservations - Book reservation system

💰 fines - Late fees and penalty tracking

👨‍💼 staff - Library employees

🏬 branches - Library branch locations

📍 book_locations - Physical book placement in branches

💳 transactions - Financial transactions

📝 audit_log - Change tracking and system audits

⚙️ system_settings - Configurable library parameters

🚀 Features
✅ Relational Integrity with proper PK/FK relationships

✅ Data Validation through constraints and ENUM types

✅ Performance Optimization with comprehensive indexing

✅ Audit Trail for tracking system changes

✅ Multi-branch Support for library networks

✅ Flexible Configuration through system settings

🛠️ Installation
Create the database:

sql
mysql -u your_username -p < library_management.sql
Or execute in MySQL client:

sql
SOURCE library_management.sql;
📋 Default Settings
The system includes pre-configured settings:

📅 Loan period: 14 days

📚 Max books per member: 5

⏳ Late fee: $0.25 per day

🎫 Reservation expiry: 3 days

💵 Membership fee: $25.00

🔄 Relationships
1-to-Many: Publishers→Books, Members→Loans, Books→Book Copies

Many-to-Many: Books↔Authors

1-to-1: Staff→Branch Managers (optional)

📈 Performance
The database includes optimized indexes on:

Frequently searched fields (titles, names, emails)

Status fields for filtering

Date fields for reporting

Composite indexes for common query patterns

🎯 Use Cases
This database supports:

📖 Book lending and returns

👥 Member management

⏰ Reservation system

💰 Fine collection

📊 Reporting and analytics

🏢 Multi-branch operations

📝 Audit and compliance

