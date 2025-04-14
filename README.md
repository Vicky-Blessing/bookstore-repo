📚 Bookstore Database System
OVERVIEW.
This repository contains a comprehensive SQL script for creating a relational database for a bookstore management system. The database is designed to handle all aspects of bookstore operations including inventory management, customer orders, shipping, and order tracking.

🌟Features
a)Complete Book Management: Track books, authors, publishers, and languages
b)Customer Relationship Management: Store customer details and addresses
c)Order Processing: Handle orders, order history, and shipping methods
d)Advanced Querying: Powerful reporting capabilities for business insights
e)Normalized Structure: Optimized 3NF database design for efficiency

🗄️ DATABASE SCHEMA.
The database consists of 15 tables that model the bookstore's operations:

🔧Core Entities:

a)publisher - Stores book publisher information 
b)author - Contains author details
c)book - Main book information
d)book_language - Language information for books
e)customer - Customer details
f)Order Management:
g)cust_order - Customer orders
h)order_line - Individual items within orders
i)order_status - Status options for orders
j)order_history - Tracking order status changes
k)Shipping & Addresses:
l)country - Country reference data
m)address - Physical address information
n)address_status - Status of addresses
o)customer_address - Linking customers to addresses
p)shipping_method - Available shipping options

🛠️ Setup Instructions
Create the database:

CREATE DATABASE bookstore;
USE bookstore;
Execute the SQL script:

mysql -u username -p bookstore < bookstore_schema.sql
Verify installation:

SELECT 'publisher' AS table_name, COUNT(*) AS record_count FROM publisher
UNION ALL SELECT 'author', COUNT(*) FROM author
UNION ALL SELECT 'book', COUNT(*) FROM book;

📈 Database Statistics
Table	Record Count
Publisher	5
Author	5
Book	5
Customer	5
Order	5
Order Line	5

🚀 Performance Features

Optimized indexes on frequently queried columns
Proper foreign key constraints for data integrity
Normalized structure to minimize redundancy
Sample analytical queries for business reporting

*Installation: Execute the entire SQL script in a MySQL environment, MySQL Workbench.

The script will:

a)Create the bookstore database
b)Create all tables with proper constraints
c)Insert sample data
d)Create necessary indexes
e)Sample Queries

The script includes several useful queries for testing and demonstration:

a)Count records in each table
b)Show books with their authors
c)Find books published after 1950
d)Display all orders with customer details
e)Show order line items
f)View customer addresses with country information
g)Track order status history
h)Calculate total sales by book
i)Analyze sales by customer
j)Check for unused indexes
k)Identify books without authors
l)Find customers without orders

📊Sample Queries.
Find Books by Author

SELECT b.title, b.isbn13, a.author_name 
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;
Track Order Status

SELECT o.order_id, c.first_name, c.last_name, 
       os.status_value, oh.status_date
FROM order_history oh
JOIN cust_order o ON oh.order_id = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_status os ON oh.status_id = os.status_id
ORDER BY o.order_id, oh.status_date;
Sales Analysis

SELECT b.title, SUM(ol.price) AS total_sales, COUNT(*) AS units_sold
FROM order_line ol
JOIN book b ON ol.book_id = b.book_id
GROUP BY b.title
ORDER BY total_sales DESC;

📝 License
MIT License - Free for educational and commercial use

Happy querying! 🎉 For any questions, please open an issue in our repository.

Database Documentation
SQL Examples

