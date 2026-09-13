CREATE TABLE Services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    service_type ENUM('Transfer', 'Insurance', 'Excursion', 'Meal', 'Extra') NOT NULL,
    is_optional BOOLEAN DEFAULT TRUE,
    INDEX idx_service_price (price)
);