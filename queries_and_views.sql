--
-- This script contains views and queries for data analysis and reporting.
--
USE billing_system;

-- --------------------------------------------------------
-- Views for Reporting
--

-- View 1: Daily Revenue Report
-- This view summarizes the total revenue generated on a daily basis.
CREATE VIEW DailyRevenue AS
SELECT
    date,
    SUM(total_amount) AS daily_revenue
FROM Invoices
GROUP BY date;

-- View 2: Payment Status of Invoices
-- This view checks if an invoice has been paid, unpaid, or partially paid.
CREATE VIEW PaymentStatus AS
SELECT
    i.invoice_id,
    i.date,
    i.total_amount,
    p.amount_paid,
    CASE
        WHEN p.amount_paid >= i.total_amount THEN 'Paid'
        WHEN p.amount_paid IS NULL THEN 'Unpaid'
        ELSE 'Partially Paid'
    END AS payment_status
FROM Invoices i
LEFT JOIN Payments p ON i.invoice_id = p.invoice_id;

-- --------------------------------------------------------
-- Join-Based Queries
--

-- Query 1: Invoices with Item and Customer Details
-- This query retrieves comprehensive info about each invoice, including
-- customer name and details of the items purchased.
SELECT
    c.name AS customer_name,
    i.invoice_id,
    i.date,
    ii.quantity,
    it.name AS item_name,
    it.price
FROM Customers c
JOIN Invoices i ON c.customer_id = i.customer_id
JOIN Invoice_Items ii ON i.invoice_id = ii.invoice_id
JOIN Items it ON ii.item_id = it.item_id;

-- Query 2: Items with Highest Sales Volume
-- This query identifies the item that has been sold the most.
SELECT
    i.name AS item_name,
    SUM(ii.quantity) AS total_sold
FROM Items i
JOIN Invoice_Items ii ON i.item_id = ii.item_id
GROUP BY i.name
ORDER BY total_sold DESC
LIMIT 1;

-- --------------------------------------------------------
-- Nested Queries
--

-- Query 3: Customers with High Purchase Amounts
-- This query finds all customers who have spent more than $1500 in total.
SELECT name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Invoices
    GROUP BY customer_id
    HAVING SUM(total_amount) > 1500
);

-- Query 4: Invoices with delayed payments (Example)
-- This query identifies invoices where payment was made more than 1 day after the invoice date.
SELECT
    i.invoice_id,
    i.date AS invoice_date,
    p.payment_date
FROM Invoices i
JOIN Payments p ON i.invoice_id = p.invoice_id
WHERE p.payment_date > i.date + INTERVAL 1 DAY;