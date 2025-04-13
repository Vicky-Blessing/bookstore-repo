Overview
This repository contains a comprehensive SQL script for creating a relational database for a bookstore management system. The database is designed to handle all aspects of bookstore operations including inventory management, customer orders, shipping, and order tracking.

Database Schema
The database consists of 15 tables that model the bookstore's operations:

Core Entities:

publisher - Stores book publisher information

author - Contains author details

book - Main book information

book_language - Language information for books

customer - Customer details

Order Management:

cust_order - Customer orders

order_line - Individual items within orders

order_status - Status options for orders

order_history - Tracking order status changes

Shipping & Addresses:

country - Country reference data

address - Physical address information

address_status - Status of addresses

customer_address - Linking customers to addresses

shipping_method - Available shipping options

Relationships:

book_author - Many-to-many relationship between books and authors

Key Features
Comprehensive Data Model: Covers all aspects of bookstore operations

Performance Optimized: Includes appropriate indexes for faster queries

Sample Data: Populated with realistic sample data for testing

Referential Integrity: Proper foreign key constraints maintain data consistency

Normalized Design: Follows database normalization principles

Installation
Execute the entire SQL script in a MySQL environment

The script will:

Create the bookstore database

Create all tables with proper constraints

Insert sample data

Create necessary indexes

Sample Queries
The script includes several useful queries for testing and demonstration:

Count records in each table

Show books with their authors

Find books published after 1950

Display all orders with customer details

Show order line items

View customer addresses with country information

Track order status history

Calculate total sales by book

Analyze sales by customer

Check for unused indexes

Identify books without authors

Find customers without orders

Usage Examples
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


