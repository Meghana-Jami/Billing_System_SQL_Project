--
-- This script creates the entire database schema and inserts sample data.
--

-- Drop the database if it exists to allow for a clean restart
DROP DATABASE IF EXISTS billing_system;
CREATE DATABASE billing_system;
USE billing_system;

-- --------------------------------------------------------
-- Table structure for `Customers`
--
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20)
);

-- --------------------------------------------------------
-- Table structure for `Items`
--
CREATE TABLE Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- --------------------------------------------------------
-- Table structure for `Invoices`
--
CREATE TABLE Invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- --------------------------------------------------------
-- Table structure for `Invoice_Items`
--
CREATE TABLE Invoice_Items (
    invoice_item_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

-- --------------------------------------------------------
-- Table structure for `Payments`
--
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    payment_date DATE,
    amount_paid DECIMAL(10, 2),
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id)
);

--
-- Inserting sample data into the tables
--

-- Sample data for `Customers`
INSERT INTO Customers (name, email, phone) VALUES
('Ravi', 'ravi@mail.com', '9876543210'),
('Priya', 'priya@mail.com', '9876543211');

-- Sample data for `Items`
INSERT INTO Items (name, price) VALUES
('Keyboard', 1200.00),
('Mouse', 500.00),
('Monitor', 10000.00);

-- Sample data for `Invoices`
INSERT INTO Invoices (customer_id, date, total_amount) VALUES
(1, '2025-04-01', 1700.00), -- Ravi's invoice
(2, '2025-04-02', 10000.00); -- Priya's invoice

-- Sample data for `Invoice_Items`
INSERT INTO Invoice_Items (invoice_id, item_id, quantity) VALUES
(1, 1, 1), -- Ravi bought 1 Keyboard
(1, 2, 1), -- Ravi bought 1 Mouse
(2, 3, 1); -- Priya bought 1 Monitor

-- Sample data for `Payments`
INSERT INTO Payments (invoice_id, payment_date, amount_paid) VALUES
(1, '2025-04-02', 1700.00),
(2, '2025-04-03', 10000.00);