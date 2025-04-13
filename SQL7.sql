-- Create database
CREATE DATABASE bookstore;
USE bookstore;

-- Create publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL
);

-- Create author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

-- Create book_language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_code VARCHAR(10) NOT NULL,
    language_name VARCHAR(50) NOT NULL
);

-- Create country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Create address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_number VARCHAR(20) NOT NULL,
    street_name VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Create address_status table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    address_status VARCHAR(50) NOT NULL
);

-- Create book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn13 VARCHAR(13),
    language_id INT,
    num_pages INT,
    publication_date DATE,
    publisher_id INT,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Create book_author junction table for many-to-many relationship
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Create customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Create shipping_method table
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    cost INT NOT NULL
);

-- Create order_status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_value VARCHAR(50) NOT NULL
);

-- Create customer_address junction table
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Create cust_order table (renamed from order to avoid reserved keyword)
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL,
    customer_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    dest_address_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (dest_address_id) REFERENCES address(address_id)
);

-- Create order_line table
CREATE TABLE order_line (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Create order_history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Add indexes for better performance
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_book_isbn ON book(isbn13);
CREATE INDEX idx_customer_email ON customer(email);
CREATE INDEX idx_order_date ON cust_order(order_date);
CREATE INDEX idx_address_city ON address(city);

-- Insert publishers
INSERT INTO publisher (publisher_name) VALUES 
('Penguin Random House'),
('HarperCollins'),
('Macmillan'),
('Simon & Schuster'),
('Hachette Livre');

-- Insert authors
INSERT INTO author (author_name) VALUES 
('J.K. Rowling'),
('George R.R. Martin'),
('J.R.R. Tolkien'),
('Agatha Christie'),
('Stephen King');

-- Insert languages
INSERT INTO book_language (language_code, language_name) VALUES 
('EN', 'English'),
('ES', 'Spanish'),
('FR', 'French'),
('DE', 'German'),
('IT', 'Italian');

-- Insert countries
INSERT INTO country (country_name) VALUES 
('United States'),
('United Kingdom'),
('Canada'),
('Australia'),
('Germany');

-- Insert address status
INSERT INTO address_status (address_status) VALUES 
('Active'),
('Inactive'),
('Pending'),
('Verified'),
('Archived');

-- Insert shipping methods
INSERT INTO shipping_method (method_name, cost) VALUES 
('Standard Shipping', 5),
('Expedited Shipping', 10),
('Overnight Shipping', 20),
('International Shipping', 15),
('Two-Day Shipping', 12);

-- Insert order status
INSERT INTO order_status (status_value) VALUES 
('Pending'),
('Shipped'),
('Delivered'),
('Returned'),
('Cancelled');

-- Insert addresses
INSERT INTO address (street_number, street_name, city, country_id) VALUES 
('221', 'Baker Street', 'London', 2),
('742', 'Evergreen Terrace', 'Springfield', 1),
('12', 'Grimmauld Place', 'London', 2),
('11', 'Wall Street', 'New York', 1),
('1600', 'Pennsylvania Ave NW', 'Washington D.C.', 1);

-- Insert customers
INSERT INTO customer (first_name, last_name, email) VALUES 
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Mary', 'Johnson', 'mary.johnson@example.com'),
('James', 'Williams', 'james.williams@example.com'),
('Patricia', 'Brown', 'patricia.brown@example.com');

-- Insert books
INSERT INTO book (title, isbn13, language_id, num_pages, publication_date, publisher_id) VALUES 
('Harry Potter and the Sorcerer\'s Stone', '9780747532699', 1, 309, '1997-06-26', 1),
('A Game of Thrones', '9780553103540', 1, 694, '1996-08-06', 2),
('The Hobbit', '9780261103344', 1, 310, '1937-09-21', 3),
('Murder on the Orient Express', '9780062073501', 1, 256, '1934-01-01', 4),
('The Shining', '9780307743657', 1, 659, '1977-01-28', 5);

-- Insert book_author relationships using subqueries to ensure correct IDs
INSERT INTO book_author (book_id, author_id) 
VALUES (
    (SELECT book_id FROM book WHERE title = 'Harry Potter and the Sorcerer\'s Stone' LIMIT 1),
    (SELECT author_id FROM author WHERE author_name = 'J.K. Rowling' LIMIT 1)
);

INSERT INTO book_author (book_id, author_id) 
VALUES (
    (SELECT book_id FROM book WHERE title = 'A Game of Thrones' LIMIT 1),
    (SELECT author_id FROM author WHERE author_name = 'George R.R. Martin' LIMIT 1)
);

INSERT INTO book_author (book_id, author_id) 
VALUES (
    (SELECT book_id FROM book WHERE title = 'The Hobbit' LIMIT 1),
    (SELECT author_id FROM author WHERE author_name = 'J.R.R. Tolkien' LIMIT 1)
);

INSERT INTO book_author (book_id, author_id) 
VALUES (
    (SELECT book_id FROM book WHERE title = 'Murder on the Orient Express' LIMIT 1),
    (SELECT author_id FROM author WHERE author_name = 'Agatha Christie' LIMIT 1)
);

INSERT INTO book_author (book_id, author_id) 
VALUES (
    (SELECT book_id FROM book WHERE title = 'The Shining' LIMIT 1),
    (SELECT author_id FROM author WHERE author_name = 'Stephen King' LIMIT 1)
);

-- Insert customer_address using subqueries for correct IDs
INSERT INTO customer_address (customer_id, address_id, status_id) 
VALUES 
(1, 1, (SELECT status_id FROM address_status WHERE address_status = 'Active' LIMIT 1)),
(2, 2, (SELECT status_id FROM address_status WHERE address_status = 'Active' LIMIT 1)),
(3, 3, (SELECT status_id FROM address_status WHERE address_status = 'Active' LIMIT 1)),
(4, 4, (SELECT status_id FROM address_status WHERE address_status = 'Active' LIMIT 1)),
(5, 5, (SELECT status_id FROM address_status WHERE address_status = 'Active' LIMIT 1));

-- Insert orders
INSERT INTO cust_order (order_date, customer_id, shipping_method_id, dest_address_id) VALUES 
('2024-04-10 12:34:00', 1, 1, 1),
('2024-04-11 15:22:00', 2, 2, 2),
('2024-04-12 10:11:00', 3, 3, 3),
('2024-04-13 09:00:00', 4, 4, 4),
('2024-04-14 16:45:00', 5, 5, 5);

-- Insert order lines
INSERT INTO order_line (order_id, book_id, price) VALUES 
(1, (SELECT book_id FROM book WHERE title = 'Harry Potter and the Sorcerer\'s Stone' LIMIT 1), 20),
(2, (SELECT book_id FROM book WHERE title = 'A Game of Thrones' LIMIT 1), 25),
(3, (SELECT book_id FROM book WHERE title = 'The Hobbit' LIMIT 1), 15),
(4, (SELECT book_id FROM book WHERE title = 'Murder on the Orient Express' LIMIT 1), 10),
(5, (SELECT book_id FROM book WHERE title = 'The Shining' LIMIT 1), 30);

-- Insert order history
INSERT INTO order_history (order_id, status_id, status_date) VALUES 
(1, (SELECT status_id FROM order_status WHERE status_value = 'Pending' LIMIT 1), '2024-04-10'),
(2, (SELECT status_id FROM order_status WHERE status_value = 'Shipped' LIMIT 1), '2024-04-11'),
(3, (SELECT status_id FROM order_status WHERE status_value = 'Delivered' LIMIT 1), '2024-04-12'),
(4, (SELECT status_id FROM order_status WHERE status_value = 'Returned' LIMIT 1), '2024-04-13'),
(5, (SELECT status_id FROM order_status WHERE status_value = 'Cancelled' LIMIT 1), '2024-04-14');

-- QUERIES FOR TESTING DATA
-- COUNTING RECORDS IN EACH TABLE
SELECT 'publisher' AS table_name, COUNT(*) AS record_count FROM publisher
UNION ALL SELECT 'author', COUNT(*) FROM author
UNION ALL SELECT 'book', COUNT(*) FROM book
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'cust_order', COUNT(*) FROM cust_order;

-- SHOWING BOOKS WITH THEIR AUTHORS
SELECT b.title, b.isbn13, a.author_name 
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;

-- BOOKS PUBLISHED AFTER 1950
SELECT title, publication_date FROM book 
WHERE publication_date > '1950-01-01'
ORDER BY publication_date DESC;

-- SHOW ALL ORDERS WITH CUSTOMERS DETAILS
SELECT o.order_id, c.first_name, c.last_name, o.order_date, 
       sm.method_name AS shipping_method, os.status_value
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN shipping_method sm ON o.shipping_method_id = sm.method_id
JOIN order_history oh ON o.order_id = oh.order_id
JOIN order_status os ON oh.status_id = os.status_id;

-- ORDERS WITH THEIR LINE ITEMS
SELECT o.order_id, b.title, ol.price, o.order_date
FROM cust_order o
JOIN order_line ol ON o.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id;

-- SHOW CUSTOMER ADDRESSES WITH COUNTRY
SELECT c.first_name, c.last_name, 
       a.street_number, a.street_name, a.city, 
       co.country_name, ads.address_status
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id
JOIN address a ON ca.address_id = a.address_id
JOIN country co ON a.country_id = co.country_id
JOIN address_status ads ON ca.status_id = ads.status_id;

-- ORDER STATUS HISTORY
SELECT o.order_id, c.first_name, c.last_name, 
       os.status_value, oh.status_date
FROM order_history oh
JOIN cust_order o ON oh.order_id = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_status os ON oh.status_id = os.status_id
ORDER BY o.order_id, oh.status_date;

-- TOTAL SALES BY BOOK 
SELECT b.title, SUM(ol.price) AS total_sales, COUNT(*) AS units_sold
FROM order_line ol
JOIN book b ON ol.book_id = b.book_id
GROUP BY b.title
ORDER BY total_sales DESC;

-- SALES BY CUSTOMER
SELECT c.first_name, c.last_name, SUM(ol.price) AS total_spent
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_line ol ON o.order_id = ol.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- Check if indexes are being used
EXPLAIN SELECT * FROM book WHERE title = 'The Hobbit';
EXPLAIN SELECT * FROM customer WHERE email = 'john.doe@example.com';

-- BOOKS WITHOUT AUTHORS
SELECT b.title FROM book b
LEFT JOIN book_author ba ON b.book_id = ba.book_id
WHERE ba.author_id IS NULL;

-- CUSTOMERS WITHOUT ORDERS
SELECT c.first_name, c.last_name FROM customer c
LEFT JOIN cust_order o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
