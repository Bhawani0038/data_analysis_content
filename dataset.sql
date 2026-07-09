-- =====================================================================
--  RETAIL "ShopSphere" SAMPLE DATABASE
--  MySQL 8.0+  |  Use with the SQL Practical Test (1 Hour)
--  ---------------------------------------------------------------------
--  Tables: categories, suppliers, customers, employees,
--          products, orders, order_items, payments
--  Run this whole file once to create and populate the schema.
-- =====================================================================

DROP DATABASE IF EXISTS shopsphere;
CREATE DATABASE shopsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopsphere;

-- ---------------------------------------------------------------------
-- 1. CATEGORIES
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description   VARCHAR(200)
);

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Phones, laptops, gadgets and accessories'),
('Home & Kitchen', 'Cookware, appliances and home essentials'),
('Books', 'Fiction, non-fiction and academic titles'),
('Clothing', 'Men, women and kids apparel'),
('Sports', 'Fitness gear, outdoor and sports equipment'),
('Toys', 'Toys and games for all ages');

-- ---------------------------------------------------------------------
-- 2. SUPPLIERS
-- ---------------------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id   INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(80) NOT NULL,
    city          VARCHAR(50),
    country       VARCHAR(50),
    rating        DECIMAL(2,1)          -- 0.0 to 5.0
);

INSERT INTO suppliers (supplier_name, city, country, rating) VALUES
('TechWorld Distributors', 'Mumbai',    'India',   4.5),
('HomeLine Traders',       'Delhi',     'India',   4.1),
('PageTurner Books Ltd',   'Bengaluru', 'India',   4.8),
('UrbanStyle Apparel',     'Chennai',   'India',   3.9),
('FitGear Global',         'Pune',      'India',   4.3),
('PlayZone Imports',       'Kolkata',   'India',   NULL);

-- ---------------------------------------------------------------------
-- 3. CUSTOMERS
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(40) NOT NULL,
    last_name     VARCHAR(40) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    city          VARCHAR(50),
    state         VARCHAR(50),
    signup_date   DATE
);

INSERT INTO customers (first_name, last_name, email, city, state, signup_date) VALUES
('Aarav',  'Sharma',  'aarav.sharma@mail.com',  'Mumbai',    'Maharashtra',   '2023-01-15'),
('Diya',   'Patel',   'diya.patel@mail.com',    'Ahmedabad', 'Gujarat',       '2023-02-20'),
('Kabir',  'Singh',   'kabir.singh@mail.com',   'Delhi',     'Delhi',         '2023-03-05'),
('Anaya',  'Reddy',   'anaya.reddy@mail.com',   'Hyderabad', 'Telangana',     '2023-03-25'),
('Vivaan', 'Nair',    'vivaan.nair@mail.com',   'Kochi',     'Kerala',        '2023-05-10'),
('Ishita', 'Gupta',   'ishita.gupta@mail.com',  'Delhi',     'Delhi',         '2023-06-18'),
('Arjun',  'Mehta',   'arjun.mehta@mail.com',   'Mumbai',    'Maharashtra',   '2023-07-22'),
('Saanvi', 'Iyer',    NULL,                     'Chennai',   'Tamil Nadu',    '2023-08-30'),
('Rohan',  'Verma',   'rohan.verma@mail.com',   'Pune',      'Maharashtra',   '2023-09-12'),
('Myra',   'Joshi',   'myra.joshi@mail.com',    'Jaipur',    'Rajasthan',     '2023-11-01');

-- ---------------------------------------------------------------------
-- 4. EMPLOYEES  (self-referencing manager_id)
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name  VARCHAR(40) NOT NULL,
    last_name   VARCHAR(40) NOT NULL,
    department  VARCHAR(40),
    salary      DECIMAL(10,2),
    hire_date   DATE,
    manager_id  INT,
    CONSTRAINT fk_emp_manager
        FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, manager_id) VALUES
('Neha',   'Kapoor',  'Management', 120000.00, '2021-01-10', NULL),
('Raj',    'Malhotra','Sales',       65000.00, '2021-03-15', 1),
('Priya',  'Desai',   'Sales',       58000.00, '2021-06-01', 2),
('Sameer', 'Khan',    'Support',     52000.00, '2022-02-20', 1),
('Tara',   'Bose',    'Support',     47000.00, '2022-05-11', 4),
('Karan',  'Sethi',   'Warehouse',   43000.00, '2022-08-19', 1),
('Aisha',  'Rao',     'Sales',       61000.00, '2023-01-05', 2);

-- ---------------------------------------------------------------------
-- 5. PRODUCTS
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id   INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id  INT,
    supplier_id  INT,
    price        DECIMAL(10,2) NOT NULL,
    stock_qty    INT DEFAULT 0,
    CONSTRAINT fk_prod_cat  FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_prod_supp FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

INSERT INTO products (product_name, category_id, supplier_id, price, stock_qty) VALUES
('Smartphone X200',        1, 1,  24999.00,  40),
('Wireless Earbuds Pro',   1, 1,   4999.00, 120),
('14" Laptop UltraBook',   1, 1,  58999.00,  15),
('Non-Stick Cookware Set', 2, 2,   2499.00,  60),
('Electric Kettle 1.5L',   2, 2,   1299.00,  80),
('Stainless Water Bottle', 2, 2,    499.00, 200),
('SQL Fundamentals Book',  3, 3,    650.00,  35),
('Mystery Novel Boxset',   3, 3,   1200.00,  25),
('Men''s Cotton T-Shirt',  4, 4,    799.00, 150),
('Women''s Running Shoes', 4, 4,   2999.00,  45),
('Yoga Mat Premium',       5, 5,    999.00,  70),
('Adjustable Dumbbells',   5, 5,   4499.00,  20),
('Building Blocks 500pc',  6, 6,   1499.00,  55),
('Remote Control Car',     6, 6,   1899.00,   0);   -- out of stock

-- ---------------------------------------------------------------------
-- 6. ORDERS
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id    INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    employee_id INT,
    order_date  DATE NOT NULL,
    status      ENUM('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    CONSTRAINT fk_ord_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_ord_emp  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO orders (customer_id, employee_id, order_date, status) VALUES
(1, 2, '2024-01-05', 'Delivered'),
(2, 3, '2024-01-12', 'Delivered'),
(1, 2, '2024-02-03', 'Shipped'),
(3, 7, '2024-02-15', 'Delivered'),
(4, 3, '2024-03-01', 'Cancelled'),
(5, 2, '2024-03-18', 'Delivered'),
(6, 7, '2024-04-02', 'Pending'),
(7, 3, '2024-04-20', 'Delivered'),
(1, 2, '2024-05-06', 'Delivered'),
(9, 7, '2024-05-22', 'Shipped'),
(3, 3, '2024-06-10', 'Delivered'),
(10, 2, '2024-06-28', 'Pending');

-- ---------------------------------------------------------------------
-- 7. ORDER_ITEMS  (composite key; line items per order)
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    order_id   INT,
    product_id INT,
    quantity   INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,   -- price at time of sale
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_oi_prod  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 24999.00),
(1, 2, 2,  4999.00),
(2, 7, 3,   650.00),
(2, 4, 1,  2499.00),
(3, 3, 1, 58999.00),
(4, 9, 4,   799.00),
(4,10, 1,  2999.00),
(5, 5, 2,  1299.00),
(6, 6, 5,   499.00),
(6,11, 1,   999.00),
(7,13, 2,  1499.00),
(8, 2, 1,  4999.00),
(8, 8, 1,  1200.00),
(9,12, 1,  4499.00),
(9,11, 2,   999.00),
(10, 1, 1, 24999.00),
(11, 7, 2,   650.00),
(11, 6, 3,   499.00),
(12,10, 1,  2999.00);

-- ---------------------------------------------------------------------
-- 8. PAYMENTS
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    payment_id   INT PRIMARY KEY AUTO_INCREMENT,
    order_id     INT NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    method       ENUM('Card','UPI','NetBanking','COD') NOT NULL,
    payment_date DATE,
    CONSTRAINT fk_pay_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO payments (order_id, amount, method, payment_date) VALUES
(1, 34997.00, 'Card',       '2024-01-05'),
(2,  4449.00, 'UPI',        '2024-01-12'),
(3, 58999.00, 'NetBanking', '2024-02-03'),
(4,  6195.00, 'COD',        '2024-02-16'),
(6,  2598.00, 'UPI',        '2024-03-18'),
(8,  6199.00, 'Card',       '2024-04-20'),
(9,  6497.00, 'UPI',        '2024-05-06'),
(10,24999.00, 'NetBanking', '2024-05-22'),
(11, 2797.00, 'Card',       '2024-06-10');
-- Note: orders 5 (Cancelled), 7 & 12 (Pending) have no payment yet.

-- =====================================================================
--  END OF DATASET
-- =====================================================================
