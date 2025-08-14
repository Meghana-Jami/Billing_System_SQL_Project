# SQL Billing System Project

### **Project Description**

This project is a comprehensive SQL-based solution designed to automate and manage the billing process for various services and products. It enables the generation of bills, the storage of customer and item details, and the tracking of all transaction records. This database provides a foundation for generating essential business reports and analytics.

### **Problem Statement**

The primary goal was to create a robust and scalable relational database to replace a manual billing process. The system needed to effectively track key business entities and their relationships, including:

-   Customer information
-   Item inventory and pricing
-   Invoices and billing dates
-   Payments and transaction history

### **Database Schema**

The database is composed of five interconnected tables, each designed with specific data integrity and relationship constraints.

#### **1. `Customers` Table**
Stores basic information about each customer.
-   `customer_id` (INT, PK): Unique identifier for each customer.
-   `name` (VARCHAR): Customer's full name.
-   `email` (VARCHAR, UNIQUE): Customer's email address.
-   `phone` (VARCHAR): Customer's contact number.

#### **2. `Items` Table**
Lists all available products or services with their prices.
-   `item_id` (INT, PK): Unique identifier for each item.
-   `name` (VARCHAR): Name of the item.
-   `price` (DECIMAL): The price of a single unit of the item.

#### **3. `Invoices` Table**
Records each billing transaction.
-   `invoice_id` (INT, PK): Unique identifier for each invoice.
-   `customer_id` (INT, FK): Links the invoice to a specific customer.
-   `date` (DATE): The date the invoice was generated.
-   `total_amount` (DECIMAL): The final amount to be paid for the invoice.

#### **4. `Invoice_Items` Table**
A junction table to handle the many-to-many relationship between `Invoices` and `Items`.
-   `invoice_item_id` (INT, PK): Unique identifier for each record.
-   `invoice_id` (INT, FK): Links the record to a specific invoice.
-   `item_id` (INT, FK): Links the record to a specific item.
-   `quantity` (INT): The number of units of the item purchased in this invoice.

#### **5. `Payments` Table**
Tracks all payments made against an invoice.
-   `payment_id` (INT, PK): Unique identifier for each payment.
-   `invoice_id` (INT, FK): Links the payment to a specific invoice.
-   `payment_date` (DATE): The date the payment was made.
-   `amount_paid` (DECIMAL): The amount paid by the customer.

### **Key SQL Components and Queries**

This section demonstrates the functionality of the database through various SQL components.

#### **Views for Reporting**

-   **Daily Revenue Report:** A view that provides a summary of total revenue generated on a daily basis.
    ```sql
    CREATE VIEW DailyRevenue AS
    SELECT date, SUM(total_amount) AS daily_revenue
    FROM Invoices
    GROUP BY date;
    ```
-   **Payment Status of Invoices:** A view that checks if an invoice is paid, unpaid, or partially paid.
    ```sql
    CREATE VIEW PaymentStatus AS
    SELECT
        i.invoice_id,
        i.total_amount,
        p.amount_paid,
        CASE
            WHEN p.amount_paid >= i.total_amount THEN 'Paid'
            WHEN p.amount_paid IS NULL THEN 'Unpaid'
            ELSE 'Partially Paid'
        END AS payment_status
    FROM Invoices i
    LEFT JOIN Payments p ON i.invoice_id = p.invoice_id;
    ```

#### **Join-Based Queries**

-   **Invoices with Item and Customer Details:** This query retrieves comprehensive information about each invoice, including the customer's name and the details of the items purchased.
    ```sql
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
    ```

-   **Items with Highest Sales Volume:** This query identifies the item that has been sold the most.
    ```sql
    SELECT
        i.name AS item_name,
        SUM(ii.quantity) AS total_sold
    FROM Items i
    JOIN Invoice_Items ii ON i.item_id = ii.item_id
    GROUP BY i.name
    ORDER BY total_sold DESC
    LIMIT 1;
    ```

#### **Nested Queries**

-   **Customers with High Purchase Amounts:** This query finds all customers who have spent more than a certain amount (e.g., $1500) in total.
    ```sql
    SELECT name
    FROM Customers
    WHERE customer_id IN (
        SELECT customer_id
        FROM Invoices
        GROUP BY customer_id
        HAVING SUM(total_amount) > 1500
    );
    ```

### **Getting Started**

#### **Technologies Used**
-   **Database:** MySQL
-   **Local Server:** XAMPP
-   **Database Management Tool:** phpMyAdmin

#### **Installation and Setup**
1.  **Install XAMPP:** Download and install XAMPP from [https://www.apachefriends.org/](https://www.apachefriends.org/).
2.  **Start Services:** Open the XAMPP Control Panel and start the **Apache** and **MySQL** modules.
3.  **Create Database:** In your browser, navigate to `http://localhost/phpmyadmin/`. Create a new database named `billing_system`.
4.  **Run SQL Scripts:**
    -   Go to the "SQL" tab of your `billing_system` database.
    -   Copy and paste the `CREATE TABLE` statements from the project documentation and execute them.
    -   After the tables are created, insert the sample data using the `INSERT INTO` statements.

### **Contribution and Contact**

This project is for educational and portfolio purposes. Feel free to use and adapt the code for your own learning.
For any questions or feedback, you can contact me via my GitHub profile.# Billing_System_SQL_Project
