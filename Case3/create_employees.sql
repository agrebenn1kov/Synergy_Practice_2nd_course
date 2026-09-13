CREATE TABLE Employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    manager_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_employee_name (full_name),
    FOREIGN KEY (manager_id) REFERENCES Employees(id) ON DELETE SET NULL
);