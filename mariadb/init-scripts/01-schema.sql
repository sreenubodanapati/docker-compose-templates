-- MariaDB initialization script
-- This script creates sample database structure and data

-- Create additional database for testing
CREATE DATABASE IF NOT EXISTS testdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the main application database
USE appdb;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT,
    sku VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category_id),
    INDEX idx_sku (sku),
    INDEX idx_price (price)
);

-- Create categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT DEFAULT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_parent (parent_id)
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- Create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
);

-- Add foreign key constraint for products
ALTER TABLE products ADD FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;

-- Insert sample data
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Books', 'Books and educational materials'),
('Clothing', 'Apparel and fashion items'),
('Home & Garden', 'Home improvement and gardening supplies');

INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES
('john_doe', 'john.doe@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John', 'Doe'),
('jane_smith', 'jane.smith@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane', 'Smith'),
('bob_wilson', 'bob.wilson@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bob', 'Wilson');

INSERT INTO products (name, description, price, stock_quantity, category_id, sku) VALUES
('Smartphone X1', 'Latest smartphone with advanced features', 699.99, 50, 1, 'PHONE-X1-001'),
('Laptop Pro', 'High-performance laptop for professionals', 1299.99, 25, 1, 'LAPTOP-PRO-001'),
('Programming Book', 'Complete guide to programming', 49.99, 100, 2, 'BOOK-PROG-001'),
('Cotton T-Shirt', 'Comfortable cotton t-shirt', 19.99, 200, 3, 'SHIRT-COT-001'),
('Garden Shovel', 'Durable garden shovel', 29.99, 75, 4, 'TOOL-SHOVEL-001');

INSERT INTO orders (user_id, order_number, total_amount, status) VALUES
(1, 'ORD-2024-001', 749.98, 'delivered'),
(2, 'ORD-2024-002', 1349.98, 'shipped'),
(3, 'ORD-2024-003', 99.97, 'processing');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 699.99, 699.99),
(1, 4, 2, 19.99, 39.98),
(1, 5, 1, 29.99, 29.99),
(2, 2, 1, 1299.99, 1299.99),
(2, 3, 1, 49.99, 49.99),
(3, 3, 2, 49.99, 99.98);

-- Create a view for order summaries
CREATE VIEW order_summary AS
SELECT 
    o.id,
    o.order_number,
    u.username,
    u.email,
    o.total_amount,
    o.status,
    o.created_at,
    COUNT(oi.id) as item_count
FROM orders o
JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

-- Create a stored procedure for updating product stock
DELIMITER //
CREATE PROCEDURE UpdateProductStock(
    IN p_product_id INT,
    IN p_quantity_change INT
)
BEGIN
    DECLARE current_stock INT;
    
    SELECT stock_quantity INTO current_stock 
    FROM products 
    WHERE id = p_product_id;
    
    IF current_stock + p_quantity_change >= 0 THEN
        UPDATE products 
        SET stock_quantity = stock_quantity + p_quantity_change,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_product_id;
        
        SELECT 'Stock updated successfully' as message;
    ELSE
        SELECT 'Insufficient stock' as message;
    END IF;
END //
DELIMITER ;

-- Create a function to calculate order total
DELIMITER //
CREATE FUNCTION CalculateOrderTotal(order_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    SELECT SUM(total_price) INTO total
    FROM order_items
    WHERE order_items.order_id = order_id;
    
    RETURN IFNULL(total, 0.00);
END //
DELIMITER ;
