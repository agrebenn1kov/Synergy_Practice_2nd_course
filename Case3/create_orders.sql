CREATE TABLE Orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tour_id INT NOT NULL,
    service_id INT,
    employee_id INT NOT NULL,
    status_id INT NOT NULL,
    client_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price > 0),
    payment_date DATETIME,
    comment TEXT,
    
    CHECK (end_date > start_date),
    
    FOREIGN KEY (client_id) REFERENCES Clients(id) ON DELETE RESTRICT,
    FOREIGN KEY (tour_id) REFERENCES Tours(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES Services(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES Statuses(id) ON DELETE RESTRICT,
    
    INDEX idx_order_client (client_id),
    INDEX idx_order_tour (tour_id),
    INDEX idx_order_employee (employee_id),
    INDEX idx_order_status (status_id),
    INDEX idx_order_date (order_date)
);

CREATE INDEX idx_orders_dates ON Orders(start_date, end_date);
CREATE INDEX idx_orders_price_status ON Orders(total_price, status_id);