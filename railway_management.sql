
/*
railway_management.sql
Complete schema + sample data for Railway Management Database (MySQL-compatible)
Created for: RaghadAlmutairi/railway-management-database
*/

-- DROP tables if they exist (order matters because of FKs)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS trains;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS stations;
DROP TABLE IF EXISTS passengers;

-- passengers
CREATE TABLE passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_name VARCHAR(150) NOT NULL,
    passenger_phone VARCHAR(30),
    passenger_email VARCHAR(150),
    street VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- stations
CREATE TABLE stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(150) NOT NULL,
    city VARCHAR(100),
    address VARCHAR(250),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- employees (work at stations)
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    station_id INT NOT NULL,
    employee_name VARCHAR(150) NOT NULL,
    employee_mobile VARCHAR(30),
    employee_email VARCHAR(150),
    role VARCHAR(80),
    hired_date DATE,
    FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- trains
CREATE TABLE trains (
    train_id INT AUTO_INCREMENT PRIMARY KEY,
    train_number VARCHAR(50) NOT NULL UNIQUE,
    train_type VARCHAR(50),
    capacity INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- trips (a train visiting a station at given times)
-- using a surrogate primary key for trip schedule
CREATE TABLE trips (
    trip_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT NOT NULL,
    station_id INT NOT NULL,
    arrival_time DATETIME,
    departure_time DATETIME,
    stop_sequence INT DEFAULT 0,
    FOREIGN KEY (train_id) REFERENCES trains(train_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (station_id) REFERENCES stations(station_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (train_id, station_id, stop_sequence)
);

-- bookings (made by passengers; one booking may cover one or more tickets)
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by_employee INT,
    status ENUM('CONFIRMED','CANCELLED','PENDING') DEFAULT 'CONFIRMED',
    notes TEXT,
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (created_by_employee) REFERENCES employees(employee_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- tickets (linked to a booking and to origin/destination station via trip)
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    origin_station_id INT NOT NULL,
    destination_station_id INT NOT NULL,
    seat_number VARCHAR(20),
    price DECIMAL(10,2) DEFAULT 0.00,
    ticket_expiration DATETIME,
    issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (origin_station_id) REFERENCES stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (destination_station_id) REFERENCES stations(station_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- payments (optional)
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    method ENUM('CARD','CASH','ONLINE') DEFAULT 'CARD',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Sample data inserts

INSERT INTO passengers (passenger_name, passenger_phone, passenger_email, street, city, state)
VALUES
('Aisha Al Saud', '966501234567', 'aisha@example.com', 'King Abdulaziz St', 'Riyadh', 'Riyadh Province'),
('Mohammed Al Fahad', '966501234568', 'mohammed@example.com', 'Prince Sultan St', 'Jeddah', 'Makkah Province');

INSERT INTO stations (station_name, city, address)
VALUES
('Riyadh Central', 'Riyadh', 'Riyadh Central Station, King Khalid Rd'),
('Jeddah North', 'Jeddah', 'Jeddah North Station, Airport Road'),
('Dammam Main', 'Dammam', 'Dammam Main Station, Corniche');

INSERT INTO employees (station_id, employee_name, employee_mobile, employee_email, role, hired_date)
VALUES
(1, 'Sara Ahmed', '966501112233', 'sara@rail.example','Station Manager','2020-05-10'),
(2, 'Omar Saleh', '966501445566', 'omar@rail.example','Ticket Agent','2021-07-01');

INSERT INTO trains (train_number, train_type, capacity)
VALUES
('R-100', 'Express', 300),
('C-200', 'Cargo', 100);

INSERT INTO trips (train_id, station_id, arrival_time, departure_time, stop_sequence)
VALUES
(1,1,'2025-12-01 08:00:00','2025-12-01 08:20:00',1),
(1,2,'2025-12-01 12:00:00','2025-12-01 12:15:00',2),
(1,3,'2025-12-01 16:00:00','2025-12-01 16:30:00',3);

INSERT INTO bookings (passenger_id, booking_date, created_by_employee, status)
VALUES
(1,'2025-11-01 10:00:00',1,'CONFIRMED'),
(2,'2025-11-05 11:30:00',2,'PENDING');

INSERT INTO tickets (booking_id, origin_station_id, destination_station_id, seat_number, price, ticket_expiration)
VALUES
(1,1,2,'12A',150.00,'2025-12-01 07:00:00'),
(1,2,3,'12B',200.00,'2025-12-01 11:00:00'),
(2,1,3,'5C',300.00,'2025-12-01 07:00:00');

INSERT INTO payments (booking_id, amount, payment_date, method)
VALUES
(1,150.00,'2025-11-01 10:01:00','CARD'),
(1,200.00,'2025-11-01 10:02:00','CARD');

-- Useful sample queries (uncomment to run)
-- 1) List tickets for a passenger:
-- SELECT p.passenger_name, b.booking_date, t.ticket_id, s1.station_name AS origin, s2.station_name AS destination, t.seat_number, t.price
-- FROM passengers p
-- JOIN bookings b ON p.passenger_id = b.passenger_id
-- JOIN tickets t ON b.booking_id = t.booking_id
-- JOIN stations s1 ON t.origin_station_id = s1.station_id
-- JOIN stations s2 ON t.destination_station_id = s2.station_id
-- WHERE p.passenger_id = 1;

-- 2) Train schedule:
-- SELECT tr.train_number, st.station_name, tp.arrival_time, tp.departure_time, tp.stop_sequence
-- FROM trips tp
-- JOIN trains tr ON tp.train_id = tr.train_id
-- JOIN stations st ON tp.station_id = st.station_id
-- WHERE tr.train_id = 1
-- ORDER BY tp.stop_sequence;

