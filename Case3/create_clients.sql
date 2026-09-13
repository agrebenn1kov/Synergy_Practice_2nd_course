CREATE TABLE Clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    passport VARCHAR(20) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_client_phone (phone),
    INDEX idx_client_email (email)
);