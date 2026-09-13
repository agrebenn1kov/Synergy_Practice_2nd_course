CREATE TABLE Tours (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    duration_days INT NOT NULL CHECK (duration_days > 0),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    hotel_stars INT CHECK (hotel_stars BETWEEN 1 AND 5),
    tour_type ENUM('Rest', 'Excursion', 'Treatment', 'Shopping', 'Combined') NOT NULL,
    description TEXT,
    max_participants INT DEFAULT 20,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_tour_country (country),
    INDEX idx_tour_price (price)
);