CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;
SELECT DATABASE();

USE sales_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CHECK (price >= 0),
    CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('Completed', 'Pending', 'Cancelled') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CHECK (quantity > 0),
    CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE stock_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    old_stock INT NOT NULL,
    new_stock INT NOT NULL,
    change_reason VARCHAR(100) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_name, email, city) VALUES
('Arun Kumar', 'arun@example.com', 'Hyderabad'),
('Priya Sharma', 'priya@example.com', 'Mumbai'),
('Rahul Verma', 'rahul@example.com', 'Delhi'),
('Sneha Reddy', 'sneha@example.com', 'Hyderabad'),
('Vikram Singh', 'vikram@example.com', 'Chennai'),
('Ananya Das', 'ananya@example.com', 'Kolkata'),
('Kiran Rao', 'kiran@example.com', 'Bengaluru'),
('Meera Nair', 'meera@example.com', 'Chennai');

INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 55000.00, 10),
('Smartphone', 'Electronics', 25000.00, 20),
('Headphones', 'Accessories', 2000.00, 50),
('Keyboard', 'Accessories', 1500.00, 30),
('Office Chair', 'Furniture', 8000.00, 12),
('Desk', 'Furniture', 12000.00, 8),
('Monitor', 'Electronics', 15000.00, 15),
('Mouse', 'Accessories', 800.00, 60);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-10-02', 'Completed'),
(2, '2025-10-05', 'Completed'),
(3, '2025-10-08', 'Pending'),
(1, '2025-10-12', 'Completed'),
(4, '2025-10-15', 'Cancelled'),
(5, '2025-11-01', 'Completed'),
(6, '2025-11-05', 'Completed'),
(2, '2025-11-10', 'Completed'),
(7, '2025-11-15', 'Pending'),
(8, '2025-12-01', 'Completed'),
(3, '2025-12-10', 'Completed'),
(4, '2025-12-15', 'Completed');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 2000.00),
(2, 2, 1, 25000.00),
(2, 8, 2, 800.00),
(3, 7, 1, 15000.00),
(4, 4, 2, 1500.00),
(4, 3, 1, 2000.00),
(5, 5, 1, 8000.00),
(6, 6, 1, 12000.00),
(6, 8, 2, 800.00),
(7, 2, 2, 25000.00),
(7, 3, 1, 2000.00),
(8, 1, 1, 55000.00),
(8, 7, 1, 15000.00),
(9, 5, 1, 8000.00),
(10, 8, 3, 800.00),
(10, 4, 1, 1500.00),
(11, 2, 1, 25000.00),
(11, 3, 2, 2000.00),
(12, 6, 1, 12000.00);

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM products WHERE price > 10000;

SELECT * FROM customers WHERE city = 'Hyderabad';

SELECT product_name, price FROM products ORDER BY price DESC;

SELECT DISTINCT city FROM customers;

SELECT product_name, stock FROM products WHERE stock < 15;

SELECT * FROM products WHERE product_name LIKE '%o%';

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_products FROM products;

SELECT MAX(price) AS highest_price FROM products;

SELECT MIN(price) AS lowest_price FROM products;

SELECT ROUND(AVG(price), 2) AS average_price FROM products;

SELECT SUM(stock) AS total_stock FROM products;

SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status;

-- Orders with customer names
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- Products in each order
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity, oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Total value of each order
SELECT o.order_id, o.status, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.status ORDER BY order_total DESC;

-- Completed sales revenue
SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

-- Revenue by product
SELECT p.product_name, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name ORDER BY revenue DESC;

-- Revenue by category
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category ORDER BY revenue DESC;

-- Monthly revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m') ORDER BY sales_month;

-- Top five products
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name ORDER BY revenue DESC LIMIT 5;

-- Customer spending
SELECT c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name ORDER BY total_spending DESC;

-- Customers who never ordered
SELECT c.customer_id, c.customer_name
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Orders worth more than 20,000
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 20000;

-- Average completed order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id
) AS completed_orders;

-- Order counts by status
SELECT status, COUNT(*) AS total_orders FROM orders GROUP BY status;

-- Products never ordered
SELECT p.product_id, p.product_name
FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Completed revenue by city
SELECT c.city, SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.city ORDER BY revenue DESC;

CREATE INDEX idx_orders_order_date ON orders(order_date);

CREATE INDEX idx_orders_status_date ON orders(status, order_date);

CREATE INDEX idx_products_category ON products(category);

CREATE INDEX idx_customers_city ON customers(city);

CREATE INDEX idx_order_items_product ON order_items(product_id);

SHOW INDEX FROM orders;
SHOW INDEX FROM products;
SHOW INDEX FROM customers;
SHOW INDEX FROM order_items;

EXPLAIN SELECT * FROM orders WHERE order_date = '2025-10-02';

CREATE OR REPLACE VIEW v_completed_sales AS
SELECT o.order_id, c.customer_name, c.city, o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.order_id, c.customer_name, c.city, o.order_date;

CREATE OR REPLACE VIEW v_product_revenue AS
SELECT p.product_id, p.product_name, p.category,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category;

CREATE OR REPLACE VIEW v_category_revenue AS
SELECT p.category, SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category;

SELECT * FROM v_completed_sales ORDER BY order_date;
SELECT * FROM v_product_revenue ORDER BY total_revenue DESC;
SELECT * FROM v_category_revenue ORDER BY total_revenue DESC;
SHOW FULL TABLES WHERE Table_type = 'VIEW';

DELIMITER //

CREATE PROCEDURE sp_sales_by_date(IN p_start_date DATE, IN p_end_date DATE)
BEGIN
    IF p_start_date IS NULL OR p_end_date IS NULL OR p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid date range';
    END IF;

    SELECT o.order_id, c.customer_name, o.order_date,
           SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
      AND o.order_date >= p_start_date
      AND o.order_date < DATE_ADD(p_end_date, INTERVAL 1 DAY)
    GROUP BY o.order_id, c.customer_name, o.order_date
    ORDER BY o.order_date;
END //

CREATE PROCEDURE sp_top_products(IN p_limit INT)
BEGIN
    IF p_limit IS NULL OR p_limit < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Limit must be at least 1';
    END IF;

    SELECT p.product_name, p.category, SUM(oi.quantity) AS units_sold,
           SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id, p.product_name, p.category
    ORDER BY total_revenue DESC
    LIMIT p_limit;
END //

CREATE PROCEDURE sp_revenue_by_category()
BEGIN
    SELECT p.category, SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.category ORDER BY total_revenue DESC;
END //

DELIMITER ;

CALL sp_sales_by_date('2025-10-01', '2025-10-31');
CALL sp_top_products(3);
CALL sp_revenue_by_category();
SHOW PROCEDURE STATUS WHERE Db = 'sales_analysis';

DELIMITER //

CREATE TRIGGER trg_check_stock_before_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT DEFAULT NULL;
    SELECT stock INTO available_stock FROM products WHERE product_id = NEW.product_id;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
    ELSEIF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    ELSEIF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient product stock';
    END IF;
END //

CREATE TRIGGER trg_reduce_stock_after_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE previous_stock INT;
    SELECT stock INTO previous_stock FROM products WHERE product_id = NEW.product_id;
    UPDATE products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
    INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
    VALUES (NEW.product_id, previous_stock, previous_stock - NEW.quantity,
            CONCAT('Order item inserted: ', NEW.order_id));
END //

CREATE TRIGGER trg_check_stock_before_update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT DEFAULT NULL;

    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    IF OLD.product_id = NEW.product_id THEN
        SELECT stock + OLD.quantity INTO available_stock
        FROM products WHERE product_id = NEW.product_id;
    ELSE
        SELECT stock INTO available_stock
        FROM products WHERE product_id = NEW.product_id;
    END IF;

    IF available_stock IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
    ELSEIF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for update';
    END IF;
END //

CREATE TRIGGER trg_adjust_stock_after_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE old_product_stock INT;
    DECLARE new_product_stock INT;

    IF OLD.product_id = NEW.product_id THEN
        IF OLD.quantity <> NEW.quantity THEN
            SELECT stock INTO old_product_stock FROM products WHERE product_id = NEW.product_id;
            UPDATE products SET stock = stock + OLD.quantity - NEW.quantity
            WHERE product_id = NEW.product_id;
            INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
            VALUES (NEW.product_id, old_product_stock,
                    old_product_stock + OLD.quantity - NEW.quantity,
                    'Order item quantity updated');
        END IF;
    ELSE
        SELECT stock INTO old_product_stock FROM products WHERE product_id = OLD.product_id;
        UPDATE products SET stock = stock + OLD.quantity WHERE product_id = OLD.product_id;
        INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
        VALUES (OLD.product_id, old_product_stock, old_product_stock + OLD.quantity,
                'Old product returned after item update');

        SELECT stock INTO new_product_stock FROM products WHERE product_id = NEW.product_id;
        UPDATE products SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
        INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
        VALUES (NEW.product_id, new_product_stock, new_product_stock - NEW.quantity,
                'New product deducted after item update');
    END IF;
END //

CREATE TRIGGER trg_restore_stock_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    DECLARE previous_stock INT;
    SELECT stock INTO previous_stock FROM products WHERE product_id = OLD.product_id;
    UPDATE products SET stock = stock + OLD.quantity WHERE product_id = OLD.product_id;
    INSERT INTO stock_audit (product_id, old_stock, new_stock, change_reason)
    VALUES (OLD.product_id, previous_stock, previous_stock + OLD.quantity,
            CONCAT('Order item deleted: ', OLD.order_id));
END //

DELIMITER ;

SHOW TRIGGERS FROM sales_analysis;

-- Optional test: run these statements individually after creating triggers.
-- INSERT INTO orders (customer_id, order_date, status) VALUES (1, '2025-12-20', 'Pending');
-- SET @test_order_id = LAST_INSERT_ID();
-- INSERT INTO order_items (order_id, product_id, quantity, unit_price)
-- VALUES (@test_order_id, 8, 1, 800.00);
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- UPDATE order_items SET quantity = 2 WHERE order_id = @test_order_id AND product_id = 8;
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- DELETE FROM order_items WHERE order_id = @test_order_id AND product_id = 8;
-- SELECT product_name, stock FROM products WHERE product_id = 8;
-- SELECT * FROM stock_audit ORDER BY audit_id;

