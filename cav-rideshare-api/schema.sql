-- Script to initialize schema across all CavRideShare databases
-- Databases: wyb4kk, wyb4kk_a, wyb4kk_b, wyb4kk_c

-- ===============================================
-- Create tables in all databases
-- ===============================================

-- wyb4kk
CREATE TABLE IF NOT EXISTS wyb4kk.User (
  uva_id VARCHAR(6) PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS wyb4kk.Driver (uva_id VARCHAR(6) PRIMARY KEY, license_plate VARCHAR(8) UNIQUE NOT NULL, FOREIGN KEY (uva_id) REFERENCES wyb4kk.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Car (license_plate VARCHAR(20) PRIMARY KEY, user_id VARCHAR(6) NOT NULL, make VARCHAR(50) NOT NULL, model VARCHAR(50) NOT NULL, mpg DECIMAL(5,2), max_passengers INT NOT NULL, FOREIGN KEY (user_id) REFERENCES wyb4kk.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Location (location_id INT PRIMARY KEY, name VARCHAR(255) NOT NULL, address VARCHAR(255), lat DECIMAL(9,6) NOT NULL, lng DECIMAL(9,6) NOT NULL);
CREATE TABLE IF NOT EXISTS wyb4kk.Trips (trip_id INT AUTO_INCREMENT PRIMARY KEY, departure_time DATETIME NOT NULL, arrival_location INT NOT NULL, seats_available INT NOT NULL, notes TEXT, start_location INT NOT NULL, trip_duration TIME, arrival_time TIMESTAMP, FOREIGN KEY (arrival_location) REFERENCES wyb4kk.Location(location_id), FOREIGN KEY (start_location) REFERENCES wyb4kk.Location(location_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Reviews (review_id INT AUTO_INCREMENT PRIMARY KEY, trip_id INT NOT NULL, comment TEXT, stars INT NOT NULL, FOREIGN KEY (trip_id) REFERENCES wyb4kk.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Review_Users (review_id INT PRIMARY KEY, reviewer_id VARCHAR(6) NOT NULL, reviewee_id VARCHAR(6) NOT NULL, FOREIGN KEY (review_id) REFERENCES wyb4kk.Reviews(review_id), FOREIGN KEY (reviewer_id) REFERENCES wyb4kk.User(uva_id), FOREIGN KEY (reviewee_id) REFERENCES wyb4kk.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Drives (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk.Driver(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Rides_In (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (uva_id, trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk.User(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk.Contains (trip_id INT NOT NULL, location_id INT NOT NULL, PRIMARY KEY (trip_id, location_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk.Trips(trip_id), FOREIGN KEY (location_id) REFERENCES wyb4kk.Location(location_id));

-- wyb4kk_a
CREATE TABLE IF NOT EXISTS wyb4kk_a.User (
  uva_id VARCHAR(6) PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS wyb4kk_a.Driver (uva_id VARCHAR(6) PRIMARY KEY, license_plate VARCHAR(8) UNIQUE NOT NULL, FOREIGN KEY (uva_id) REFERENCES wyb4kk_a.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Car (license_plate VARCHAR(20) PRIMARY KEY, user_id VARCHAR(6) NOT NULL, make VARCHAR(50) NOT NULL, model VARCHAR(50) NOT NULL, mpg DECIMAL(5,2), max_passengers INT NOT NULL, FOREIGN KEY (user_id) REFERENCES wyb4kk_a.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Location (location_id INT PRIMARY KEY, name VARCHAR(255) NOT NULL, address VARCHAR(255), lat DECIMAL(9,6) NOT NULL, lng DECIMAL(9,6) NOT NULL);
CREATE TABLE IF NOT EXISTS wyb4kk_a.Trips (trip_id INT AUTO_INCREMENT PRIMARY KEY, departure_time DATETIME NOT NULL, arrival_location INT NOT NULL, seats_available INT NOT NULL, notes TEXT, start_location INT NOT NULL, trip_duration TIME, arrival_time TIMESTAMP, FOREIGN KEY (arrival_location) REFERENCES wyb4kk_a.Location(location_id), FOREIGN KEY (start_location) REFERENCES wyb4kk_a.Location(location_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Reviews (review_id INT AUTO_INCREMENT PRIMARY KEY, trip_id INT NOT NULL, comment TEXT, stars INT NOT NULL, FOREIGN KEY (trip_id) REFERENCES wyb4kk_a.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Review_Users (review_id INT PRIMARY KEY, reviewer_id VARCHAR(6) NOT NULL, reviewee_id VARCHAR(6) NOT NULL, FOREIGN KEY (review_id) REFERENCES wyb4kk_a.Reviews(review_id), FOREIGN KEY (reviewer_id) REFERENCES wyb4kk_a.User(uva_id), FOREIGN KEY (reviewee_id) REFERENCES wyb4kk_a.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Drives (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_a.Driver(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_a.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Rides_In (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (uva_id, trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_a.User(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_a.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_a.Contains (trip_id INT NOT NULL, location_id INT NOT NULL, PRIMARY KEY (trip_id, location_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_a.Trips(trip_id), FOREIGN KEY (location_id) REFERENCES wyb4kk_a.Location(location_id));

-- wyb4kk_b
CREATE TABLE IF NOT EXISTS wyb4kk_b.User (
  uva_id VARCHAR(6) PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS wyb4kk_b.Driver (uva_id VARCHAR(6) PRIMARY KEY, license_plate VARCHAR(8) UNIQUE NOT NULL, FOREIGN KEY (uva_id) REFERENCES wyb4kk_b.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Car (license_plate VARCHAR(20) PRIMARY KEY, user_id VARCHAR(6) NOT NULL, make VARCHAR(50) NOT NULL, model VARCHAR(50) NOT NULL, mpg DECIMAL(5,2), max_passengers INT NOT NULL, FOREIGN KEY (user_id) REFERENCES wyb4kk_b.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Location (location_id INT PRIMARY KEY, name VARCHAR(255) NOT NULL, address VARCHAR(255), lat DECIMAL(9,6) NOT NULL, lng DECIMAL(9,6) NOT NULL);
CREATE TABLE IF NOT EXISTS wyb4kk_b.Trips (trip_id INT AUTO_INCREMENT PRIMARY KEY, departure_time DATETIME NOT NULL, arrival_location INT NOT NULL, seats_available INT NOT NULL, notes TEXT, start_location INT NOT NULL, trip_duration TIME, arrival_time TIMESTAMP, FOREIGN KEY (arrival_location) REFERENCES wyb4kk_b.Location(location_id), FOREIGN KEY (start_location) REFERENCES wyb4kk_b.Location(location_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Reviews (review_id INT AUTO_INCREMENT PRIMARY KEY, trip_id INT NOT NULL, comment TEXT, stars INT NOT NULL, FOREIGN KEY (trip_id) REFERENCES wyb4kk_b.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Review_Users (review_id INT PRIMARY KEY, reviewer_id VARCHAR(6) NOT NULL, reviewee_id VARCHAR(6) NOT NULL, FOREIGN KEY (review_id) REFERENCES wyb4kk_b.Reviews(review_id), FOREIGN KEY (reviewer_id) REFERENCES wyb4kk_b.User(uva_id), FOREIGN KEY (reviewee_id) REFERENCES wyb4kk_b.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Drives (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_b.Driver(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_b.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Rides_In (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (uva_id, trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_b.User(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_b.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_b.Contains (trip_id INT NOT NULL, location_id INT NOT NULL, PRIMARY KEY (trip_id, location_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_b.Trips(trip_id), FOREIGN KEY (location_id) REFERENCES wyb4kk_b.Location(location_id));

-- wyb4kk_c
CREATE TABLE IF NOT EXISTS wyb4kk_c.User (
  uva_id VARCHAR(6) PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  phone_number VARCHAR(15) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS wyb4kk_c.Driver (uva_id VARCHAR(6) PRIMARY KEY, license_plate VARCHAR(8) UNIQUE NOT NULL, FOREIGN KEY (uva_id) REFERENCES wyb4kk_c.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Car (license_plate VARCHAR(20) PRIMARY KEY, user_id VARCHAR(6) NOT NULL, make VARCHAR(50) NOT NULL, model VARCHAR(50) NOT NULL, mpg DECIMAL(5,2), max_passengers INT NOT NULL, FOREIGN KEY (user_id) REFERENCES wyb4kk_c.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Location (location_id INT PRIMARY KEY, name VARCHAR(255) NOT NULL, address VARCHAR(255), lat DECIMAL(9,6) NOT NULL, lng DECIMAL(9,6) NOT NULL);
CREATE TABLE IF NOT EXISTS wyb4kk_c.Trips (trip_id INT AUTO_INCREMENT PRIMARY KEY, departure_time DATETIME NOT NULL, arrival_location INT NOT NULL, seats_available INT NOT NULL, notes TEXT, start_location INT NOT NULL, trip_duration TIME, arrival_time TIMESTAMP, FOREIGN KEY (arrival_location) REFERENCES wyb4kk_c.Location(location_id), FOREIGN KEY (start_location) REFERENCES wyb4kk_c.Location(location_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Reviews (review_id INT AUTO_INCREMENT PRIMARY KEY, trip_id INT NOT NULL, comment TEXT, stars INT NOT NULL, FOREIGN KEY (trip_id) REFERENCES wyb4kk_c.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Review_Users (review_id INT PRIMARY KEY, reviewer_id VARCHAR(6) NOT NULL, reviewee_id VARCHAR(6) NOT NULL, FOREIGN KEY (review_id) REFERENCES wyb4kk_c.Reviews(review_id), FOREIGN KEY (reviewer_id) REFERENCES wyb4kk_c.User(uva_id), FOREIGN KEY (reviewee_id) REFERENCES wyb4kk_c.User(uva_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Drives (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_c.Driver(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_c.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Rides_In (uva_id VARCHAR(6) NOT NULL, trip_id INT NOT NULL, PRIMARY KEY (uva_id, trip_id), FOREIGN KEY (uva_id) REFERENCES wyb4kk_c.User(uva_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_c.Trips(trip_id));
CREATE TABLE IF NOT EXISTS wyb4kk_c.Contains (trip_id INT NOT NULL, location_id INT NOT NULL, PRIMARY KEY (trip_id, location_id), FOREIGN KEY (trip_id) REFERENCES wyb4kk_c.Trips(trip_id), FOREIGN KEY (location_id) REFERENCES wyb4kk_c.Location(location_id)); 

-- ===============================================
-- Insert data into all databases
-- ===============================================

INSERT INTO wyb4kk.`User` (uva_id, fname, lname, phone_number, password_hash) VALUES 
('bi2yn', 'Iris', 'Diaz', '2395889785', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk6bf', 'Elena', 'Kim', '7745415016', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('fa7yc', 'Troy', 'Miller', '2712066168', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('xo2bc', 'Vik', 'Evans', '3292215780', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ns8ip', 'Ben', 'Young', '5125519547', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('zp4tu', 'Quinne', 'Sing', '5222127524', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu9nv', 'Ravi', 'Ueda', '8828108964', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('qv7lq', 'Ben', 'Youngs', '8603852353', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('pv5fk', 'Kira', 'Rodriguez', '6002758483', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ms6ag', 'Sara', 'Cho', '8435721210', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lh7rq', 'Xena', 'Baker', '8544949106', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu4rp', 'Finn', 'Evans', '7496557202', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yo1ae', 'Owen', 'Gupta', '2214626767', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('vi7un', 'Ava', 'Diaz', '8322649361', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lw2cn', 'Ava', 'Zhang', '7485862203', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rw7ak', 'Iria', 'Patel', '2339686485', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('nl1uu', 'Finn', 'Nguyen', '2659343359', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lv4xc', 'Uma', 'Baker', '9767317344', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rj3uy', 'Jae', 'Young', '5985773072', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk9du', 'Finn', 'Zhang', '8035958080', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');

INSERT INTO wyb4kk_a.`User` (uva_id, fname, lname, phone_number, password_hash) VALUES 
('bi2yn', 'Iris', 'Diaz', '2395889785', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk6bf', 'Elena', 'Kim', '7745415016', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('fa7yc', 'Troy', 'Miller', '2712066168', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('xo2bc', 'Vik', 'Evans', '3292215780', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ns8ip', 'Ben', 'Young', '5125519547', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('zp4tu', 'Quinne', 'Sing', '5222127524', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu9nv', 'Ravi', 'Ueda', '8828108964', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('qv7lq', 'Ben', 'Youngs', '8603852353', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('pv5fk', 'Kira', 'Rodriguez', '6002758483', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ms6ag', 'Sara', 'Cho', '8435721210', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lh7rq', 'Xena', 'Baker', '8544949106', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu4rp', 'Finn', 'Evans', '7496557202', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yo1ae', 'Owen', 'Gupta', '2214626767', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('vi7un', 'Ava', 'Diaz', '8322649361', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lw2cn', 'Ava', 'Zhang', '7485862203', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rw7ak', 'Iria', 'Patel', '2339686485', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('nl1uu', 'Finn', 'Nguyen', '2659343359', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lv4xc', 'Uma', 'Baker', '9767317344', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rj3uy', 'Jae', 'Young', '5985773072', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk9du', 'Finn', 'Zhang', '8035958080', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');

INSERT INTO wyb4kk_b.`User` (uva_id, fname, lname, phone_number, password_hash) VALUES 
('bi2yn', 'Iris', 'Diaz', '2395889785', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk6bf', 'Elena', 'Kim', '7745415016', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('fa7yc', 'Troy', 'Miller', '2712066168', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('xo2bc', 'Vik', 'Evans', '3292215780', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ns8ip', 'Ben', 'Young', '5125519547', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('zp4tu', 'Quinne', 'Sing', '5222127524', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu9nv', 'Ravi', 'Ueda', '8828108964', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('qv7lq', 'Ben', 'Youngs', '8603852353', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('pv5fk', 'Kira', 'Rodriguez', '6002758483', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ms6ag', 'Sara', 'Cho', '8435721210', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lh7rq', 'Xena', 'Baker', '8544949106', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu4rp', 'Finn', 'Evans', '7496557202', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yo1ae', 'Owen', 'Gupta', '2214626767', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('vi7un', 'Ava', 'Diaz', '8322649361', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lw2cn', 'Ava', 'Zhang', '7485862203', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rw7ak', 'Iria', 'Patel', '2339686485', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('nl1uu', 'Finn', 'Nguyen', '2659343359', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lv4xc', 'Uma', 'Baker', '9767317344', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rj3uy', 'Jae', 'Young', '5985773072', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk9du', 'Finn', 'Zhang', '8035958080', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');

INSERT INTO wyb4kk_c.`User` (uva_id, fname, lname, phone_number, password_hash) VALUES 
('bi2yn', 'Iris', 'Diaz', '2395889785', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk6bf', 'Elena', 'Kim', '7745415016', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('fa7yc', 'Troy', 'Miller', '2712066168', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('xo2bc', 'Vik', 'Evans', '3292215780', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ns8ip', 'Ben', 'Young', '5125519547', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('zp4tu', 'Quinne', 'Sing', '5222127524', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu9nv', 'Ravi', 'Ueda', '8828108964', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('qv7lq', 'Ben', 'Youngs', '8603852353', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('pv5fk', 'Kira', 'Rodriguez', '6002758483', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('ms6ag', 'Sara', 'Cho', '8435721210', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lh7rq', 'Xena', 'Baker', '8544949106', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yu4rp', 'Finn', 'Evans', '7496557202', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('yo1ae', 'Owen', 'Gupta', '2214626767', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('vi7un', 'Ava', 'Diaz', '8322649361', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lw2cn', 'Ava', 'Zhang', '7485862203', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rw7ak', 'Iria', 'Patel', '2339686485', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('nl1uu', 'Finn', 'Nguyen', '2659343359', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('lv4xc', 'Uma', 'Baker', '9767317344', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rj3uy', 'Jae', 'Young', '5985773072', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy'),
('rk9du', 'Finn', 'Zhang', '8035958080', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
INSERT INTO wyb4kk.Car(`license_plate`, `user_id`, `make`, `model`, `mpg`, `max_passengers`) VALUES ('OJ-8028', 'rk6bf', 'Subaru', 'Outback', 29, 4), ('ZY-1462', 'ns8ip', 'Honda', 'Civic', 34, 4), ('FQ-6322', 'lw2cn', 'Toyota', 'Corolla', 33, 4), ('QQ-3250', 'bi2yn', 'Subaru', 'Outback', 29, 4),('KQ-2716', 'yu4rp', 'Toyota', 'Corolla', 33, 4), ('RX-7045', 'qv7lq', 'Kia', 'Soul', 31, 4), ('HS-6571', 'vi7un', 'Honda', 'Civic', 34, 4), ('CI-9295', 'rw7ak', 'Toyota', 'Corolla', 33, 4),('HG-6276', 'yo1ae', 'Tesla', 'Model 3', 120, 4), ('IM-1704', 'lh7rq', 'Subaru', 'Outback', 29, 4);
INSERT INTO wyb4kk_a.Car(`license_plate`, `user_id`, `make`, `model`, `mpg`, `max_passengers`) VALUES ('OJ-8028', 'rk6bf', 'Subaru', 'Outback', 29, 4), ('ZY-1462', 'ns8ip', 'Honda', 'Civic', 34, 4), ('FQ-6322', 'lw2cn', 'Toyota', 'Corolla', 33, 4), ('QQ-3250', 'bi2yn', 'Subaru', 'Outback', 29, 4),('KQ-2716', 'yu4rp', 'Toyota', 'Corolla', 33, 4), ('RX-7045', 'qv7lq', 'Kia', 'Soul', 31, 4), ('HS-6571', 'vi7un', 'Honda', 'Civic', 34, 4), ('CI-9295', 'rw7ak', 'Toyota', 'Corolla', 33, 4),('HG-6276', 'yo1ae', 'Tesla', 'Model 3', 120, 4), ('IM-1704', 'lh7rq', 'Subaru', 'Outback', 29, 4);
INSERT INTO wyb4kk_b.Car(`license_plate`, `user_id`, `make`, `model`, `mpg`, `max_passengers`) VALUES ('OJ-8028', 'rk6bf', 'Subaru', 'Outback', 29, 4), ('ZY-1462', 'ns8ip', 'Honda', 'Civic', 34, 4), ('FQ-6322', 'lw2cn', 'Toyota', 'Corolla', 33, 4), ('QQ-3250', 'bi2yn', 'Subaru', 'Outback', 29, 4),('KQ-2716', 'yu4rp', 'Toyota', 'Corolla', 33, 4), ('RX-7045', 'qv7lq', 'Kia', 'Soul', 31, 4), ('HS-6571', 'vi7un', 'Honda', 'Civic', 34, 4), ('CI-9295', 'rw7ak', 'Toyota', 'Corolla', 33, 4),('HG-6276', 'yo1ae', 'Tesla', 'Model 3', 120, 4), ('IM-1704', 'lh7rq', 'Subaru', 'Outback', 29, 4);
INSERT INTO wyb4kk_c.Car(`license_plate`, `user_id`, `make`, `model`, `mpg`, `max_passengers`) VALUES ('OJ-8028', 'rk6bf', 'Subaru', 'Outback', 29, 4), ('ZY-1462', 'ns8ip', 'Honda', 'Civic', 34, 4), ('FQ-6322', 'lw2cn', 'Toyota', 'Corolla', 33, 4), ('QQ-3250', 'bi2yn', 'Subaru', 'Outback', 29, 4),('KQ-2716', 'yu4rp', 'Toyota', 'Corolla', 33, 4), ('RX-7045', 'qv7lq', 'Kia', 'Soul', 31, 4), ('HS-6571', 'vi7un', 'Honda', 'Civic', 34, 4), ('CI-9295', 'rw7ak', 'Toyota', 'Corolla', 33, 4),('HG-6276', 'yo1ae', 'Tesla', 'Model 3', 120, 4), ('IM-1704', 'lh7rq', 'Subaru', 'Outback', 29, 4);
INSERT INTO wyb4kk.`Location` (`location_id`, `name`, `address`, `lat`, `lng`) VALUES (1, 'UVA Rotunda', '1826 University Ave, Charlottesville, VA', 38.0356, -78.5034),
 (2, 'The Corner', '104 14th St NW, Charlottesville, VA', 38.035, -78.5008),
 (3, 'AFC', '450 Whitehead Rd, Charlottesville, VA', 38.0311, -78.5142),
 (4, 'JPJ Arena', '295 Massie Rd, Charlottesville, VA', 38.0478, -78.5125),
 (5, 'Amtrak Station', '810 W Main St, Charlottesville, VA', 38.0344, -78.4948),
 (6, 'Barracks Road', '1117 Emmet St N, Charlottesville, VA', 38.0525, -78.497),
 (7, 'Darden', '100 Darden Blvd, Charlottesville, VA', 38.0551, -78.5152),
 (8, 'UVA Hospital', '1215 Lee St, Charlottesville, VA', 38.0317, -78.5011),
 (9, 'Aldi 5th St', '1738 5th St SW, Charlottesville, VA', 38.011, -78.5013),
 (10, 'Fashion Square', '1600 Rio Rd E, Charlottesville, VA', 38.0745, -78.4768);
INSERT INTO wyb4kk_a.`Location` (`location_id`, `name`, `address`, `lat`, `lng`) VALUES (1, 'UVA Rotunda', '1826 University Ave, Charlottesville, VA', 38.0356, -78.5034),
 (2, 'The Corner', '104 14th St NW, Charlottesville, VA', 38.035, -78.5008),
 (3, 'AFC', '450 Whitehead Rd, Charlottesville, VA', 38.0311, -78.5142),
 (4, 'JPJ Arena', '295 Massie Rd, Charlottesville, VA', 38.0478, -78.5125),
 (5, 'Amtrak Station', '810 W Main St, Charlottesville, VA', 38.0344, -78.4948),
 (6, 'Barracks Road', '1117 Emmet St N, Charlottesville, VA', 38.0525, -78.497),
 (7, 'Darden', '100 Darden Blvd, Charlottesville, VA', 38.0551, -78.5152),
 (8, 'UVA Hospital', '1215 Lee St, Charlottesville, VA', 38.0317, -78.5011),
 (9, 'Aldi 5th St', '1738 5th St SW, Charlottesville, VA', 38.011, -78.5013),
 (10, 'Fashion Square', '1600 Rio Rd E, Charlottesville, VA', 38.0745, -78.4768);
INSERT INTO wyb4kk_b.`Location` (`location_id`, `name`, `address`, `lat`, `lng`) VALUES (1, 'UVA Rotunda', '1826 University Ave, Charlottesville, VA', 38.0356, -78.5034),
 (2, 'The Corner', '104 14th St NW, Charlottesville, VA', 38.035, -78.5008),
 (3, 'AFC', '450 Whitehead Rd, Charlottesville, VA', 38.0311, -78.5142),
 (4, 'JPJ Arena', '295 Massie Rd, Charlottesville, VA', 38.0478, -78.5125),
 (5, 'Amtrak Station', '810 W Main St, Charlottesville, VA', 38.0344, -78.4948),
 (6, 'Barracks Road', '1117 Emmet St N, Charlottesville, VA', 38.0525, -78.497),
 (7, 'Darden', '100 Darden Blvd, Charlottesville, VA', 38.0551, -78.5152),
 (8, 'UVA Hospital', '1215 Lee St, Charlottesville, VA', 38.0317, -78.5011),
 (9, 'Aldi 5th St', '1738 5th St SW, Charlottesville, VA', 38.011, -78.5013),
 (10, 'Fashion Square', '1600 Rio Rd E, Charlottesville, VA', 38.0745, -78.4768);
INSERT INTO wyb4kk_c.`Location` (`location_id`, `name`, `address`, `lat`, `lng`) VALUES (1, 'UVA Rotunda', '1826 University Ave, Charlottesville, VA', 38.0356, -78.5034),
 (2, 'The Corner', '104 14th St NW, Charlottesville, VA', 38.035, -78.5008),
 (3, 'AFC', '450 Whitehead Rd, Charlottesville, VA', 38.0311, -78.5142),
 (4, 'JPJ Arena', '295 Massie Rd, Charlottesville, VA', 38.0478, -78.5125),
 (5, 'Amtrak Station', '810 W Main St, Charlottesville, VA', 38.0344, -78.4948),
 (6, 'Barracks Road', '1117 Emmet St N, Charlottesville, VA', 38.0525, -78.497),
 (7, 'Darden', '100 Darden Blvd, Charlottesville, VA', 38.0551, -78.5152),
 (8, 'UVA Hospital', '1215 Lee St, Charlottesville, VA', 38.0317, -78.5011),
 (9, 'Aldi 5th St', '1738 5th St SW, Charlottesville, VA', 38.011, -78.5013),
 (10, 'Fashion Square', '1600 Rio Rd E, Charlottesville, VA', 38.0745, -78.4768);
INSERT INTO wyb4kk.`Trips` (`trip_id`, `departure_time`, `arrival_location`, `seats_available`, `notes`, `start_location`, `trip_duration`, `arrival_time`) VALUES (20001, '2024-09-21 16:00:00', 2, 3, 'Game day ride', 4, 29, '2024-09-21 16:29:00'),
 (20002, '2024-09-10 05:00:00', 3, 3, '--', 9, 39, '2024-09-10 05:39:00'),
 (20003, '2024-10-17 05:00:00', 1, 2, 'Grocery run', 7, 29, '2024-10-17 05:29:00'),
 (20004, '2024-10-10 14:00:00', 9, 1, 'Airport drop', 4, 39, '2024-10-10 14:39:00'),
 (20005, '2024-09-05 01:00:00', 2, 3, 'Airport drop', 10, 37, '2024-09-05 01:37:00'),
 (20006, '2024-09-15 04:00:00', 6, 2, 'Late night study group', 7, 29, '2024-09-15 04:29:00'),
 (20007, '2024-10-25 03:00:00', 7, 1, 'Game day ride', 3, 32, '2024-10-25 03:32:00'),
 (20008, '2024-09-26 01:00:00', 3, 3, 'Airport drop', 5, 12, '2024-09-26 01:12:00'),
 (20009, '2024-10-24 00:00:00', 5, 3, 'Grocery run', 2, 11, '2024-10-24 00:11:00'),
 (20010, '2024-09-08 04:00:00', 7, 2, 'Late night study group', 1, 28, '2024-09-08 04:28:00'),
 (20011, '2024-10-08 01:00:00', 5, 2, '--', 8, 23, '2024-10-08 01:23:00'),
 (20012, '2024-10-28 22:00:00', 9, 3, 'Morning class run', 8, 29, '2024-10-28 22:29:00'),
 (20013, '2024-09-29 05:00:00', 2, 1, 'Grocery run', 3, 16, '2024-09-29 05:16:00'),
 (20014, '2024-10-05 18:00:00', 1, 2, 'Airport drop', 9, 28, '2024-10-05 18:28:00'),
 (20015, '2024-10-03 23:00:00', 1, 2, 'Airport drop', 4, 8, '2024-10-03 23:08:00'),
 (20016, '2024-10-27 16:00:00', 4, 3, 'Airport drop', 7, 24, '2024-10-27 16:24:00'),
 (20017, '2024-09-28 15:00:00', 7, 2, 'Grocery run', 3, 8, '2024-09-28 15:08:00'),
 (20018, '2024-09-19 06:00:00', 4, 1, '--', 3, 18, '2024-09-19 06:18:00'),
 (20019, '2024-10-03 04:00:00', 4, 2, 'Airport drop', 9, 22, '2024-10-03 04:22:00'),
 (20020, '2024-09-29 22:00:00', 2, 1, 'Game day ride', 9, 20, '2024-09-29 22:20:00');
INSERT INTO wyb4kk_a.`Trips` (`trip_id`, `departure_time`, `arrival_location`, `seats_available`, `notes`, `start_location`, `trip_duration`, `arrival_time`) VALUES (20001, '2024-09-21 16:00:00', 2, 3, 'Game day ride', 4, 29, '2024-09-21 16:29:00'),
 (20002, '2024-09-10 05:00:00', 3, 3, '--', 9, 39, '2024-09-10 05:39:00'),
 (20003, '2024-10-17 05:00:00', 1, 2, 'Grocery run', 7, 29, '2024-10-17 05:29:00'),
 (20004, '2024-10-10 14:00:00', 9, 1, 'Airport drop', 4, 39, '2024-10-10 14:39:00'),
 (20005, '2024-09-05 01:00:00', 2, 3, 'Airport drop', 10, 37, '2024-09-05 01:37:00'),
 (20006, '2024-09-15 04:00:00', 6, 2, 'Late night study group', 7, 29, '2024-09-15 04:29:00'),
 (20007, '2024-10-25 03:00:00', 7, 1, 'Game day ride', 3, 32, '2024-10-25 03:32:00'),
 (20008, '2024-09-26 01:00:00', 3, 3, 'Airport drop', 5, 12, '2024-09-26 01:12:00'),
 (20009, '2024-10-24 00:00:00', 5, 3, 'Grocery run', 2, 11, '2024-10-24 00:11:00'),
 (20010, '2024-09-08 04:00:00', 7, 2, 'Late night study group', 1, 28, '2024-09-08 04:28:00'),
 (20011, '2024-10-08 01:00:00', 5, 2, '--', 8, 23, '2024-10-08 01:23:00'),
 (20012, '2024-10-28 22:00:00', 9, 3, 'Morning class run', 8, 29, '2024-10-28 22:29:00'),
 (20013, '2024-09-29 05:00:00', 2, 1, 'Grocery run', 3, 16, '2024-09-29 05:16:00'),
 (20014, '2024-10-05 18:00:00', 1, 2, 'Airport drop', 9, 28, '2024-10-05 18:28:00'),
 (20015, '2024-10-03 23:00:00', 1, 2, 'Airport drop', 4, 8, '2024-10-03 23:08:00'),
 (20016, '2024-10-27 16:00:00', 4, 3, 'Airport drop', 7, 24, '2024-10-27 16:24:00'),
 (20017, '2024-09-28 15:00:00', 7, 2, 'Grocery run', 3, 8, '2024-09-28 15:08:00'),
 (20018, '2024-09-19 06:00:00', 4, 1, '--', 3, 18, '2024-09-19 06:18:00'),
 (20019, '2024-10-03 04:00:00', 4, 2, 'Airport drop', 9, 22, '2024-10-03 04:22:00'),
 (20020, '2024-09-29 22:00:00', 2, 1, 'Game day ride', 9, 20, '2024-09-29 22:20:00');
INSERT INTO wyb4kk_b.`Trips` (`trip_id`, `departure_time`, `arrival_location`, `seats_available`, `notes`, `start_location`, `trip_duration`, `arrival_time`) VALUES (20001, '2024-09-21 16:00:00', 2, 3, 'Game day ride', 4, 29, '2024-09-21 16:29:00'),
 (20002, '2024-09-10 05:00:00', 3, 3, '--', 9, 39, '2024-09-10 05:39:00'),
 (20003, '2024-10-17 05:00:00', 1, 2, 'Grocery run', 7, 29, '2024-10-17 05:29:00'),
 (20004, '2024-10-10 14:00:00', 9, 1, 'Airport drop', 4, 39, '2024-10-10 14:39:00'),
 (20005, '2024-09-05 01:00:00', 2, 3, 'Airport drop', 10, 37, '2024-09-05 01:37:00'),
 (20006, '2024-09-15 04:00:00', 6, 2, 'Late night study group', 7, 29, '2024-09-15 04:29:00'),
 (20007, '2024-10-25 03:00:00', 7, 1, 'Game day ride', 3, 32, '2024-10-25 03:32:00'),
 (20008, '2024-09-26 01:00:00', 3, 3, 'Airport drop', 5, 12, '2024-09-26 01:12:00'),
 (20009, '2024-10-24 00:00:00', 5, 3, 'Grocery run', 2, 11, '2024-10-24 00:11:00'),
 (20010, '2024-09-08 04:00:00', 7, 2, 'Late night study group', 1, 28, '2024-09-08 04:28:00'),
 (20011, '2024-10-08 01:00:00', 5, 2, '--', 8, 23, '2024-10-08 01:23:00'),
 (20012, '2024-10-28 22:00:00', 9, 3, 'Morning class run', 8, 29, '2024-10-28 22:29:00'),
 (20013, '2024-09-29 05:00:00', 2, 1, 'Grocery run', 3, 16, '2024-09-29 05:16:00'),
 (20014, '2024-10-05 18:00:00', 1, 2, 'Airport drop', 9, 28, '2024-10-05 18:28:00'),
 (20015, '2024-10-03 23:00:00', 1, 2, 'Airport drop', 4, 8, '2024-10-03 23:08:00'),
 (20016, '2024-10-27 16:00:00', 4, 3, 'Airport drop', 7, 24, '2024-10-27 16:24:00'),
 (20017, '2024-09-28 15:00:00', 7, 2, 'Grocery run', 3, 8, '2024-09-28 15:08:00'),
 (20018, '2024-09-19 06:00:00', 4, 1, '--', 3, 18, '2024-09-19 06:18:00'),
 (20019, '2024-10-03 04:00:00', 4, 2, 'Airport drop', 9, 22, '2024-10-03 04:22:00'),
 (20020, '2024-09-29 22:00:00', 2, 1, 'Game day ride', 9, 20, '2024-09-29 22:20:00');
INSERT INTO wyb4kk_c.`Trips` (`trip_id`, `departure_time`, `arrival_location`, `seats_available`, `notes`, `start_location`, `trip_duration`, `arrival_time`) VALUES (20001, '2024-09-21 16:00:00', 2, 3, 'Game day ride', 4, 29, '2024-09-21 16:29:00'),
 (20002, '2024-09-10 05:00:00', 3, 3, '--', 9, 39, '2024-09-10 05:39:00'),
 (20003, '2024-10-17 05:00:00', 1, 2, 'Grocery run', 7, 29, '2024-10-17 05:29:00'),
 (20004, '2024-10-10 14:00:00', 9, 1, 'Airport drop', 4, 39, '2024-10-10 14:39:00'),
 (20005, '2024-09-05 01:00:00', 2, 3, 'Airport drop', 10, 37, '2024-09-05 01:37:00'),
 (20006, '2024-09-15 04:00:00', 6, 2, 'Late night study group', 7, 29, '2024-09-15 04:29:00'),
 (20007, '2024-10-25 03:00:00', 7, 1, 'Game day ride', 3, 32, '2024-10-25 03:32:00'),
 (20008, '2024-09-26 01:00:00', 3, 3, 'Airport drop', 5, 12, '2024-09-26 01:12:00'),
 (20009, '2024-10-24 00:00:00', 5, 3, 'Grocery run', 2, 11, '2024-10-24 00:11:00'),
 (20010, '2024-09-08 04:00:00', 7, 2, 'Late night study group', 1, 28, '2024-09-08 04:28:00'),
 (20011, '2024-10-08 01:00:00', 5, 2, '--', 8, 23, '2024-10-08 01:23:00'),
 (20012, '2024-10-28 22:00:00', 9, 3, 'Morning class run', 8, 29, '2024-10-28 22:29:00'),
 (20013, '2024-09-29 05:00:00', 2, 1, 'Grocery run', 3, 16, '2024-09-29 05:16:00'),
 (20014, '2024-10-05 18:00:00', 1, 2, 'Airport drop', 9, 28, '2024-10-05 18:28:00'),
 (20015, '2024-10-03 23:00:00', 1, 2, 'Airport drop', 4, 8, '2024-10-03 23:08:00'),
 (20016, '2024-10-27 16:00:00', 4, 3, 'Airport drop', 7, 24, '2024-10-27 16:24:00'),
 (20017, '2024-09-28 15:00:00', 7, 2, 'Grocery run', 3, 8, '2024-09-28 15:08:00'),
 (20018, '2024-09-19 06:00:00', 4, 1, '--', 3, 18, '2024-09-19 06:18:00'),
 (20019, '2024-10-03 04:00:00', 4, 2, 'Airport drop', 9, 22, '2024-10-03 04:22:00'),
 (20020, '2024-09-29 22:00:00', 2, 1, 'Game day ride', 9, 20, '2024-09-29 22:20:00');
INSERT INTO wyb4kk.`Driver` (`uva_id`, `license_plate`) VALUES ('rk6bf', 'OJ-8028'), ('ns8ip', 'ZY-1462'), ('lw2cn', 'FQ-6322'), ('bi2yn', 'QQ-3250'), ('yu4rp', 'KQ-2716'), ('qv7lq', 'RX-7045'), ('vi7un', 'HS-6571'), ('rw7ak', 'CI-9295'), ('yo1ae', 'HG-6276'), ('lh7rq', 'IM-1704');
INSERT INTO wyb4kk_a.`Driver` (`uva_id`, `license_plate`) VALUES ('rk6bf', 'OJ-8028'), ('ns8ip', 'ZY-1462'), ('lw2cn', 'FQ-6322'), ('bi2yn', 'QQ-3250'), ('yu4rp', 'KQ-2716'), ('qv7lq', 'RX-7045'), ('vi7un', 'HS-6571'), ('rw7ak', 'CI-9295'), ('yo1ae', 'HG-6276'), ('lh7rq', 'IM-1704');
INSERT INTO wyb4kk_b.`Driver` (`uva_id`, `license_plate`) VALUES ('rk6bf', 'OJ-8028'), ('ns8ip', 'ZY-1462'), ('lw2cn', 'FQ-6322'), ('bi2yn', 'QQ-3250'), ('yu4rp', 'KQ-2716'), ('qv7lq', 'RX-7045'), ('vi7un', 'HS-6571'), ('rw7ak', 'CI-9295'), ('yo1ae', 'HG-6276'), ('lh7rq', 'IM-1704');
INSERT INTO wyb4kk_c.`Driver` (`uva_id`, `license_plate`) VALUES ('rk6bf', 'OJ-8028'), ('ns8ip', 'ZY-1462'), ('lw2cn', 'FQ-6322'), ('bi2yn', 'QQ-3250'), ('yu4rp', 'KQ-2716'), ('qv7lq', 'RX-7045'), ('vi7un', 'HS-6571'), ('rw7ak', 'CI-9295'), ('yo1ae', 'HG-6276'), ('lh7rq', 'IM-1704');
INSERT INTO wyb4kk.`Drives` (`uva_id`, `trip_id`) VALUES ('ns8ip', 20001), ('vi7un', 20002), ('vi7un', 20003), ('rw7ak', 20004), ('ns8ip', 20005), ('rk6bf', 20006), ('lh7rq', 20007), ('vi7un', 20008), ('vi7un', 20009), ('yo1ae', 20010), ('qv7lq', 20011), ('lw2cn', 20012), ('rw7ak', 20013), ('lw2cn', 20014), ('bi2yn', 20015), ('bi2yn', 20016), ('bi2yn', 20017), ('rk6bf', 20018), ('bi2yn', 20019), ('bi2yn', 20020);
INSERT INTO wyb4kk_a.`Drives` (`uva_id`, `trip_id`) VALUES ('ns8ip', 20001), ('vi7un', 20002), ('vi7un', 20003), ('rw7ak', 20004), ('ns8ip', 20005), ('rk6bf', 20006), ('lh7rq', 20007), ('vi7un', 20008), ('vi7un', 20009), ('yo1ae', 20010), ('qv7lq', 20011), ('lw2cn', 20012), ('rw7ak', 20013), ('lw2cn', 20014), ('bi2yn', 20015), ('bi2yn', 20016), ('bi2yn', 20017), ('rk6bf', 20018), ('bi2yn', 20019), ('bi2yn', 20020);
INSERT INTO wyb4kk_b.`Drives` (`uva_id`, `trip_id`) VALUES ('ns8ip', 20001), ('vi7un', 20002), ('vi7un', 20003), ('rw7ak', 20004), ('ns8ip', 20005), ('rk6bf', 20006), ('lh7rq', 20007), ('vi7un', 20008), ('vi7un', 20009), ('yo1ae', 20010), ('qv7lq', 20011), ('lw2cn', 20012), ('rw7ak', 20013), ('lw2cn', 20014), ('bi2yn', 20015), ('bi2yn', 20016), ('bi2yn', 20017), ('rk6bf', 20018), ('bi2yn', 20019), ('bi2yn', 20020);
INSERT INTO wyb4kk_c.`Drives` (`uva_id`, `trip_id`) VALUES ('ns8ip', 20001), ('vi7un', 20002), ('vi7un', 20003), ('rw7ak', 20004), ('ns8ip', 20005), ('rk6bf', 20006), ('lh7rq', 20007), ('vi7un', 20008), ('vi7un', 20009), ('yo1ae', 20010), ('qv7lq', 20011), ('lw2cn', 20012), ('rw7ak', 20013), ('lw2cn', 20014), ('bi2yn', 20015), ('bi2yn', 20016), ('bi2yn', 20017), ('rk6bf', 20018), ('bi2yn', 20019), ('bi2yn', 20020);
INSERT INTO wyb4kk.`Reviews` (`review_id`, `trip_id`, `comment`, `stars`) VALUES (60001, 20002, 'Would ride again.', 4), (60002, 20002, 'Polite passenger.', 5), (60003, 20003, 'On time and friendly.', 4), (60004, 20003, 'On time and friendly.', 4), (60005, 20004, 'Would ride again.', 5), (60006, 20009, 'On time and friendly.', 4), (60007, 20011, 'Safe driving.', 5), (60008, 20011, 'Easy pickup.', 5), (60009, 20013, 'Clean car.', 4), (60010, 20015, 'Would ride again.', 4), (60011, 20016, 'Safe driving.', 4), (60012, 20016, 'Polite passenger.', 4), (60013, 20016, 'Clean car.', 5), (60014, 20017, 'Safe driving.', 4), (60015, 20017, 'On time.', 4), (60016, 20018, 'Clean car.', 4), (60017, 20018, 'Polite passenger.', 5);
INSERT INTO wyb4kk_a.`Reviews` (`review_id`, `trip_id`, `comment`, `stars`) VALUES (60001, 20002, 'Would ride again.', 4), (60002, 20002, 'Polite passenger.', 5), (60003, 20003, 'On time and friendly.', 4), (60004, 20003, 'On time and friendly.', 4), (60005, 20004, 'Would ride again.', 5), (60006, 20009, 'On time and friendly.', 4), (60007, 20011, 'Safe driving.', 5), (60008, 20011, 'Easy pickup.', 5), (60009, 20013, 'Clean car.', 4), (60010, 20015, 'Would ride again.', 4), (60011, 20016, 'Safe driving.', 4), (60012, 20016, 'Polite passenger.', 4), (60013, 20016, 'Clean car.', 5), (60014, 20017, 'Safe driving.', 4), (60015, 20017, 'On time.', 4), (60016, 20018, 'Clean car.', 4), (60017, 20018, 'Polite passenger.', 5);
INSERT INTO wyb4kk_b.`Reviews` (`review_id`, `trip_id`, `comment`, `stars`) VALUES (60001, 20002, 'Would ride again.', 4), (60002, 20002, 'Polite passenger.', 5), (60003, 20003, 'On time and friendly.', 4), (60004, 20003, 'On time and friendly.', 4), (60005, 20004, 'Would ride again.', 5), (60006, 20009, 'On time and friendly.', 4), (60007, 20011, 'Safe driving.', 5), (60008, 20011, 'Easy pickup.', 5), (60009, 20013, 'Clean car.', 4), (60010, 20015, 'Would ride again.', 4), (60011, 20016, 'Safe driving.', 4), (60012, 20016, 'Polite passenger.', 4), (60013, 20016, 'Clean car.', 5), (60014, 20017, 'Safe driving.', 4), (60015, 20017, 'On time.', 4), (60016, 20018, 'Clean car.', 4), (60017, 20018, 'Polite passenger.', 5);
INSERT INTO wyb4kk_c.`Reviews` (`review_id`, `trip_id`, `comment`, `stars`) VALUES (60001, 20002, 'Would ride again.', 4), (60002, 20002, 'Polite passenger.', 5), (60003, 20003, 'On time and friendly.', 4), (60004, 20003, 'On time and friendly.', 4), (60005, 20004, 'Would ride again.', 5), (60006, 20009, 'On time and friendly.', 4), (60007, 20011, 'Safe driving.', 5), (60008, 20011, 'Easy pickup.', 5), (60009, 20013, 'Clean car.', 4), (60010, 20015, 'Would ride again.', 4), (60011, 20016, 'Safe driving.', 4), (60012, 20016, 'Polite passenger.', 4), (60013, 20016, 'Clean car.', 5), (60014, 20017, 'Safe driving.', 4), (60015, 20017, 'On time.', 4), (60016, 20018, 'Clean car.', 4), (60017, 20018, 'Polite passenger.', 5);

INSERT INTO wyb4kk.`Review_Users` (`review_id`, `reviewer_id`, `reviewee_id`) VALUES (60001, 'bi2yn', 'vi7un'), (60002, 'vi7un', 'bi2yn'), (60003, 'lh7rq', 'vi7un'), (60004, 'rj3uy', 'vi7un'), (60005, 'rk6bf', 'rw7ak'), (60006, 'yu4rp', 'vi7un'), (60007, 'lw2cn', 'qv7lq'), (60008, 'qv7lq', 'lw2cn'), (60009, 'yo1ae', 'rw7ak'), (60010, 'lh7rq', 'bi2yn'), (60011, 'nl1uu', 'bi2yn'), (60012, 'bi2yn', 'nl1uu'), (60013, 'nl1uu', 'bi2yn'), (60014, 'rk9du', 'bi2yn'), (60015, 'bi2yn', 'rk9du'), (60016, 'yo1ae', 'rk6bf'), (60017, 'rk6bf', 'yo1ae');
INSERT INTO wyb4kk_a.`Review_Users` (`review_id`, `reviewer_id`, `reviewee_id`) VALUES (60001, 'bi2yn', 'vi7un'), (60002, 'vi7un', 'bi2yn'), (60003, 'lh7rq', 'vi7un'), (60004, 'rj3uy', 'vi7un'), (60005, 'rk6bf', 'rw7ak'), (60006, 'yu4rp', 'vi7un'), (60007, 'lw2cn', 'qv7lq'), (60008, 'qv7lq', 'lw2cn'), (60009, 'yo1ae', 'rw7ak'), (60010, 'lh7rq', 'bi2yn'), (60011, 'nl1uu', 'bi2yn'), (60012, 'bi2yn', 'nl1uu'), (60013, 'nl1uu', 'bi2yn'), (60014, 'rk9du', 'bi2yn'), (60015, 'bi2yn', 'rk9du'), (60016, 'yo1ae', 'rk6bf'), (60017, 'rk6bf', 'yo1ae');
INSERT INTO wyb4kk_b.`Review_Users` (`review_id`, `reviewer_id`, `reviewee_id`) VALUES (60001, 'bi2yn', 'vi7un'), (60002, 'vi7un', 'bi2yn'), (60003, 'lh7rq', 'vi7un'), (60004, 'rj3uy', 'vi7un'), (60005, 'rk6bf', 'rw7ak'), (60006, 'yu4rp', 'vi7un'), (60007, 'lw2cn', 'qv7lq'), (60008, 'qv7lq', 'lw2cn'), (60009, 'yo1ae', 'rw7ak'), (60010, 'lh7rq', 'bi2yn'), (60011, 'nl1uu', 'bi2yn'), (60012, 'bi2yn', 'nl1uu'), (60013, 'nl1uu', 'bi2yn'), (60014, 'rk9du', 'bi2yn'), (60015, 'bi2yn', 'rk9du'), (60016, 'yo1ae', 'rk6bf'), (60017, 'rk6bf', 'yo1ae');
INSERT INTO wyb4kk_c.`Review_Users` (`review_id`, `reviewer_id`, `reviewee_id`) VALUES (60001, 'bi2yn', 'vi7un'), (60002, 'vi7un', 'bi2yn'), (60003, 'lh7rq', 'vi7un'), (60004, 'rj3uy', 'vi7un'), (60005, 'rk6bf', 'rw7ak'), (60006, 'yu4rp', 'vi7un'), (60007, 'lw2cn', 'qv7lq'), (60008, 'qv7lq', 'lw2cn'), (60009, 'yo1ae', 'rw7ak'), (60010, 'lh7rq', 'bi2yn'), (60011, 'nl1uu', 'bi2yn'), (60012, 'bi2yn', 'nl1uu'), (60013, 'nl1uu', 'bi2yn'), (60014, 'rk9du', 'bi2yn'), (60015, 'bi2yn', 'rk9du'), (60016, 'yo1ae', 'rk6bf'), (60017, 'rk6bf', 'yo1ae');

INSERT INTO wyb4kk.`Rides_In` (`uva_id`, `trip_id`) VALUES ('vi7un', 20001), ('bi2yn', 20002), ('lh7rq', 20003), ('rk6bf', 20004), ('lw2cn', 20005), ('lh7rq', 20006), ('ms6ag', 20007), ('lh7rq', 20008), ('yu4rp', 20009), ('rw7ak', 20010), ('lw2cn', 20011), ('lv4xc', 20012), ('vi7un', 20013), ('fa7yc', 20014), ('lh7rq', 20015), ('nl1uu', 20016), ('ns8ip', 20017), ('yo1ae', 20018), ('rk6bf', 20019), ('lh7rq', 20020), ('rj3uy', 20003), ('yu9nv', 20006), ('rk9du', 20006), ('yu9nv', 20008), ('lv4xc', 20008), ('yo1ae', 20013), ('yu9nv', 20013), ('nl1uu', 20014), ('zp4tu', 20017), ('rk9du', 20017);
INSERT INTO wyb4kk_a.`Rides_In` (`uva_id`, `trip_id`) VALUES ('vi7un', 20001), ('bi2yn', 20002), ('lh7rq', 20003), ('rk6bf', 20004), ('lw2cn', 20005), ('lh7rq', 20006), ('ms6ag', 20007), ('lh7rq', 20008), ('yu4rp', 20009), ('rw7ak', 20010), ('lw2cn', 20011), ('lv4xc', 20012), ('vi7un', 20013), ('fa7yc', 20014), ('lh7rq', 20015), ('nl1uu', 20016), ('ns8ip', 20017), ('yo1ae', 20018), ('rk6bf', 20019), ('lh7rq', 20020), ('rj3uy', 20003), ('yu9nv', 20006), ('rk9du', 20006), ('yu9nv', 20008), ('lv4xc', 20008), ('yo1ae', 20013), ('yu9nv', 20013), ('nl1uu', 20014), ('zp4tu', 20017), ('rk9du', 20017);
INSERT INTO wyb4kk_b.`Rides_In` (`uva_id`, `trip_id`) VALUES ('vi7un', 20001), ('bi2yn', 20002), ('lh7rq', 20003), ('rk6bf', 20004), ('lw2cn', 20005), ('lh7rq', 20006), ('ms6ag', 20007), ('lh7rq', 20008), ('yu4rp', 20009), ('rw7ak', 20010), ('lw2cn', 20011), ('lv4xc', 20012), ('vi7un', 20013), ('fa7yc', 20014), ('lh7rq', 20015), ('nl1uu', 20016), ('ns8ip', 20017), ('yo1ae', 20018), ('rk6bf', 20019), ('lh7rq', 20020), ('rj3uy', 20003), ('yu9nv', 20006), ('rk9du', 20006), ('yu9nv', 20008), ('lv4xc', 20008), ('yo1ae', 20013), ('yu9nv', 20013), ('nl1uu', 20014), ('zp4tu', 20017), ('rk9du', 20017);
INSERT INTO wyb4kk_c.`Rides_In` (`uva_id`, `trip_id`) VALUES ('vi7un', 20001), ('bi2yn', 20002), ('lh7rq', 20003), ('rk6bf', 20004), ('lw2cn', 20005), ('lh7rq', 20006), ('ms6ag', 20007), ('lh7rq', 20008), ('yu4rp', 20009), ('rw7ak', 20010), ('lw2cn', 20011), ('lv4xc', 20012), ('vi7un', 20013), ('fa7yc', 20014), ('lh7rq', 20015), ('nl1uu', 20016), ('ns8ip', 20017), ('yo1ae', 20018), ('rk6bf', 20019), ('lh7rq', 20020), ('rj3uy', 20003), ('yu9nv', 20006), ('rk9du', 20006), ('yu9nv', 20008), ('lv4xc', 20008), ('yo1ae', 20013), ('yu9nv', 20013), ('nl1uu', 20014), ('zp4tu', 20017), ('rk9du', 20017);

INSERT INTO wyb4kk.`Contains` (`trip_id`, `location_id`) VALUES (20007, 8), (20013, 3), (20002, 1), (20004, 3), (20017, 2), (20010, 6), (20011, 1), (20006, 2), (20012, 3), (20018, 4), (20016, 8), (20020, 7), (20003, 4), (20015, 7), (20014, 1);
INSERT INTO wyb4kk_a.`Contains` (`trip_id`, `location_id`) VALUES (20007, 8), (20013, 3), (20002, 1), (20004, 3), (20017, 2), (20010, 6), (20011, 1), (20006, 2), (20012, 3), (20018, 4), (20016, 8), (20020, 7), (20003, 4), (20015, 7), (20014, 1);
INSERT INTO wyb4kk_b.`Contains` (`trip_id`, `location_id`) VALUES (20007, 8), (20013, 3), (20002, 1), (20004, 3), (20017, 2), (20010, 6), (20011, 1), (20006, 2), (20012, 3), (20018, 4), (20016, 8), (20020, 7), (20003, 4), (20015, 7), (20014, 1);
INSERT INTO wyb4kk_c.`Contains` (`trip_id`, `location_id`) VALUES (20007, 8), (20013, 3), (20002, 1), (20004, 3), (20017, 2), (20010, 6), (20011, 1), (20006, 2), (20012, 3), (20018, 4), (20016, 8), (20020, 7), (20003, 4), (20015, 7), (20014, 1);
-- ===============================================
-- Demo and Test Operations (applied to all databases)
-- ===============================================

INSERT INTO wyb4kk.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
DELETE FROM wyb4kk.User WHERE uva_id='ab123c';
INSERT INTO wyb4kk.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
SELECT uva_id, fname, lname, phone_number FROM wyb4kk.User WHERE uva_id='ab123c';
UPDATE wyb4kk.User SET phone_number='8045555678' WHERE uva_id='ab123c';

INSERT INTO wyb4kk.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
DELETE FROM wyb4kk.Driver WHERE uva_id='ab123c';
INSERT INTO wyb4kk.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
SELECT uva_id, license_plate FROM wyb4kk.Driver WHERE uva_id='ab123c';
UPDATE wyb4kk.Driver SET license_plate='VA88TEST' WHERE uva_id='ab123c';

INSERT INTO wyb4kk.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
DELETE FROM wyb4kk.Car WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
SELECT license_plate, user_id, make, model, mpg, max_passengers FROM wyb4kk.Car WHERE license_plate='CAR-0001';
UPDATE wyb4kk.Car SET mpg=35.00, max_passengers=5 WHERE license_plate='CAR-0001';

INSERT INTO wyb4kk.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
DELETE FROM wyb4kk.Location WHERE location_id=11;
INSERT INTO wyb4kk.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
SELECT location_id, name, address, lat, lng FROM wyb4kk.Location WHERE location_id=11;
UPDATE wyb4kk.Location SET address='1826 University Ave, Charlottesville, VA 22903' WHERE location_id=11;

DELETE FROM wyb4kk.Trips WHERE trip_id=2;
INSERT INTO wyb4kk.Trips (departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time) VALUES ('2024-11-01 10:00:00',2,3,'Morning ride',1,'00:30:00','2024-11-01 10:30:00');
SELECT trip_id, departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time FROM wyb4kk.Trips WHERE trip_id=1;
UPDATE wyb4kk.Trips SET seats_available=2, notes='Seats filling fast' WHERE trip_id=1;

INSERT INTO wyb4kk.Reviews (trip_id, comment, stars) VALUES ((SELECT MIN(trip_id) FROM wyb4kk.Trips),'Great ride',5);
DELETE FROM wyb4kk.Reviews WHERE review_id=3;
SELECT review_id, trip_id, comment, stars FROM wyb4kk.Reviews WHERE review_id=1;
UPDATE wyb4kk.Reviews SET comment='Great ride, very safe', stars=5 WHERE review_id=1;

INSERT INTO wyb4kk.Review_Users (review_id, reviewer_id, reviewee_id) VALUES ((SELECT MAX(review_id) FROM wyb4kk.Reviews),'ab123c','bi2yn');
DELETE FROM wyb4kk.Review_Users WHERE review_id=3;
SELECT review_id, reviewer_id, reviewee_id FROM wyb4kk.Review_Users WHERE review_id=1;
UPDATE wyb4kk.Review_Users SET reviewee_id='ab123c' WHERE review_id=1;

INSERT INTO wyb4kk.Drives (uva_id, trip_id) VALUES ('ab123c',(SELECT MAX(trip_id) FROM wyb4kk.Trips));
DELETE FROM wyb4kk.Drives WHERE trip_id=3;
SELECT uva_id, trip_id FROM wyb4kk.Drives WHERE trip_id=1;
UPDATE wyb4kk.Drives SET uva_id='cd234d' WHERE trip_id=1;

INSERT INTO wyb4kk.Rides_In (uva_id, trip_id) VALUES ('bi2yn',(SELECT MAX(trip_id) FROM wyb4kk.Trips));
DELETE FROM wyb4kk.Rides_In WHERE uva_id='bi2yn' AND trip_id=5;
SELECT uva_id, trip_id FROM wyb4kk.Rides_In WHERE trip_id=1;
UPDATE wyb4kk.Rides_In SET uva_id='ab123c' WHERE uva_id='bi2yn' AND trip_id=1;

-- Apply same operations to wyb4kk_a, wyb4kk_b, wyb4kk_c
INSERT INTO wyb4kk_a.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
DELETE FROM wyb4kk_a.User WHERE uva_id='ab123c';
INSERT INTO wyb4kk_a.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
SELECT uva_id, fname, lname, phone_number FROM wyb4kk_a.User WHERE uva_id='ab123c';
UPDATE wyb4kk_a.User SET phone_number='8045555678' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_a.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
DELETE FROM wyb4kk_a.Driver WHERE uva_id='ab123c';
INSERT INTO wyb4kk_a.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
SELECT uva_id, license_plate FROM wyb4kk_a.Driver WHERE uva_id='ab123c';
UPDATE wyb4kk_a.Driver SET license_plate='VA88TEST' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_a.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
DELETE FROM wyb4kk_a.Car WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_a.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
SELECT license_plate, user_id, make, model, mpg, max_passengers FROM wyb4kk_a.Car WHERE license_plate='CAR-0001';
UPDATE wyb4kk_a.Car SET mpg=35.00, max_passengers=5 WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_a.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
DELETE FROM wyb4kk_a.Location WHERE location_id=11;
INSERT INTO wyb4kk_a.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
SELECT location_id, name, address, lat, lng FROM wyb4kk_a.Location WHERE location_id=11;
UPDATE wyb4kk_a.Location SET address='1826 University Ave, Charlottesville, VA 22903' WHERE location_id=11;
DELETE FROM wyb4kk_a.Trips WHERE trip_id=2;
INSERT INTO wyb4kk_a.Trips (departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time) VALUES ('2024-11-01 10:00:00',2,3,'Morning ride',1,'00:30:00','2024-11-01 10:30:00');
SELECT trip_id, departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time FROM wyb4kk_a.Trips WHERE trip_id=1;
UPDATE wyb4kk_a.Trips SET seats_available=2, notes='Seats filling fast' WHERE trip_id=1;
INSERT INTO wyb4kk_a.Reviews (trip_id, comment, stars) VALUES ((SELECT MIN(trip_id) FROM wyb4kk_a.Trips),'Great ride',5);
DELETE FROM wyb4kk_a.Reviews WHERE review_id=3;
SELECT review_id, trip_id, comment, stars FROM wyb4kk_a.Reviews WHERE review_id=1;
UPDATE wyb4kk_a.Reviews SET comment='Great ride, very safe', stars=5 WHERE review_id=1;
INSERT INTO wyb4kk_a.Review_Users (review_id, reviewer_id, reviewee_id) VALUES ((SELECT MAX(review_id) FROM wyb4kk_a.Reviews),'ab123c','bi2yn');
DELETE FROM wyb4kk_a.Review_Users WHERE review_id=3;
SELECT review_id, reviewer_id, reviewee_id FROM wyb4kk_a.Review_Users WHERE review_id=1;
UPDATE wyb4kk_a.Review_Users SET reviewee_id='ab123c' WHERE review_id=1;
INSERT INTO wyb4kk_a.Drives (uva_id, trip_id) VALUES ('ab123c',(SELECT MAX(trip_id) FROM wyb4kk_a.Trips));
DELETE FROM wyb4kk_a.Drives WHERE trip_id=3;
SELECT uva_id, trip_id FROM wyb4kk_a.Drives WHERE trip_id=1;
UPDATE wyb4kk_a.Drives SET uva_id='cd234d' WHERE trip_id=1;
INSERT INTO wyb4kk_a.Rides_In (uva_id, trip_id) VALUES ('bi2yn',(SELECT MAX(trip_id) FROM wyb4kk_a.Trips));
DELETE FROM wyb4kk_a.Rides_In WHERE uva_id='bi2yn' AND trip_id=5;
SELECT uva_id, trip_id FROM wyb4kk_a.Rides_In WHERE trip_id=1;
UPDATE wyb4kk_a.Rides_In SET uva_id='ab123c' WHERE uva_id='bi2yn' AND trip_id=1;

INSERT INTO wyb4kk_b.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
DELETE FROM wyb4kk_b.User WHERE uva_id='ab123c';
INSERT INTO wyb4kk_b.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
SELECT uva_id, fname, lname, phone_number FROM wyb4kk_b.User WHERE uva_id='ab123c';
UPDATE wyb4kk_b.User SET phone_number='8045555678' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_b.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
DELETE FROM wyb4kk_b.Driver WHERE uva_id='ab123c';
INSERT INTO wyb4kk_b.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
SELECT uva_id, license_plate FROM wyb4kk_b.Driver WHERE uva_id='ab123c';
UPDATE wyb4kk_b.Driver SET license_plate='VA88TEST' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_b.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
DELETE FROM wyb4kk_b.Car WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_b.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
SELECT license_plate, user_id, make, model, mpg, max_passengers FROM wyb4kk_b.Car WHERE license_plate='CAR-0001';
UPDATE wyb4kk_b.Car SET mpg=35.00, max_passengers=5 WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_b.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
DELETE FROM wyb4kk_b.Location WHERE location_id=11;
INSERT INTO wyb4kk_b.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
SELECT location_id, name, address, lat, lng FROM wyb4kk_b.Location WHERE location_id=11;
UPDATE wyb4kk_b.Location SET address='1826 University Ave, Charlottesville, VA 22903' WHERE location_id=11;
DELETE FROM wyb4kk_b.Trips WHERE trip_id=2;
INSERT INTO wyb4kk_b.Trips (departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time) VALUES ('2024-11-01 10:00:00',2,3,'Morning ride',1,'00:30:00','2024-11-01 10:30:00');
SELECT trip_id, departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time FROM wyb4kk_b.Trips WHERE trip_id=1;
UPDATE wyb4kk_b.Trips SET seats_available=2, notes='Seats filling fast' WHERE trip_id=1;
INSERT INTO wyb4kk_b.Reviews (trip_id, comment, stars) VALUES ((SELECT MIN(trip_id) FROM wyb4kk_b.Trips),'Great ride',5);
DELETE FROM wyb4kk_b.Reviews WHERE review_id=3;
SELECT review_id, trip_id, comment, stars FROM wyb4kk_b.Reviews WHERE review_id=1;
UPDATE wyb4kk_b.Reviews SET comment='Great ride, very safe', stars=5 WHERE review_id=1;
INSERT INTO wyb4kk_b.Review_Users (review_id, reviewer_id, reviewee_id) VALUES ((SELECT MAX(review_id) FROM wyb4kk_b.Reviews),'ab123c','bi2yn');
DELETE FROM wyb4kk_b.Review_Users WHERE review_id=3;
SELECT review_id, reviewer_id, reviewee_id FROM wyb4kk_b.Review_Users WHERE review_id=1;
UPDATE wyb4kk_b.Review_Users SET reviewee_id='ab123c' WHERE review_id=1;
INSERT INTO wyb4kk_b.Drives (uva_id, trip_id) VALUES ('ab123c',(SELECT MAX(trip_id) FROM wyb4kk_b.Trips));
DELETE FROM wyb4kk_b.Drives WHERE trip_id=3;
SELECT uva_id, trip_id FROM wyb4kk_b.Drives WHERE trip_id=1;
UPDATE wyb4kk_b.Drives SET uva_id='cd234d' WHERE trip_id=1;
INSERT INTO wyb4kk_b.Rides_In (uva_id, trip_id) VALUES ('bi2yn',(SELECT MAX(trip_id) FROM wyb4kk_b.Trips));
DELETE FROM wyb4kk_b.Rides_In WHERE uva_id='bi2yn' AND trip_id=5;
SELECT uva_id, trip_id FROM wyb4kk_b.Rides_In WHERE trip_id=1;
UPDATE wyb4kk_b.Rides_In SET uva_id='ab123c' WHERE uva_id='bi2yn' AND trip_id=1;

INSERT INTO wyb4kk_c.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
DELETE FROM wyb4kk_c.User WHERE uva_id='ab123c';
INSERT INTO wyb4kk_c.User (uva_id, fname, lname, phone_number, password_hash) VALUES ('ab123c','Ava','Kim','8045551234','$2a$10$CwTycUXWue0Thq9StjUM0uJ8XQ/0Z1S4QhIWGAaHo9dZYkTfLZ7Cy');
SELECT uva_id, fname, lname, phone_number FROM wyb4kk_c.User WHERE uva_id='ab123c';
UPDATE wyb4kk_c.User SET phone_number='8045555678' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_c.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
DELETE FROM wyb4kk_c.Driver WHERE uva_id='ab123c';
INSERT INTO wyb4kk_c.Driver (uva_id, license_plate) VALUES ('ab123c','UV1234VA');
SELECT uva_id, license_plate FROM wyb4kk_c.Driver WHERE uva_id='ab123c';
UPDATE wyb4kk_c.Driver SET license_plate='VA88TEST' WHERE uva_id='ab123c';
INSERT INTO wyb4kk_c.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
DELETE FROM wyb4kk_c.Car WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_c.Car (license_plate, user_id, make, model, mpg, max_passengers) VALUES ('CAR-0001','ab123c','Honda','Civic',33.50,4);
SELECT license_plate, user_id, make, model, mpg, max_passengers FROM wyb4kk_c.Car WHERE license_plate='CAR-0001';
UPDATE wyb4kk_c.Car SET mpg=35.00, max_passengers=5 WHERE license_plate='CAR-0001';
INSERT INTO wyb4kk_c.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
DELETE FROM wyb4kk_c.Location WHERE location_id=11;
INSERT INTO wyb4kk_c.Location (location_id, name, address, lat, lng) VALUES (11,'UVA Rotunda','1826 University Ave, Charlottesville, VA',38.035600,-78.503400);
SELECT location_id, name, address, lat, lng FROM wyb4kk_c.Location WHERE location_id=11;
UPDATE wyb4kk_c.Location SET address='1826 University Ave, Charlottesville, VA 22903' WHERE location_id=11;
DELETE FROM wyb4kk_c.Trips WHERE trip_id=2;
INSERT INTO wyb4kk_c.Trips (departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time) VALUES ('2024-11-01 10:00:00',2,3,'Morning ride',1,'00:30:00','2024-11-01 10:30:00');
SELECT trip_id, departure_time, arrival_location, seats_available, notes, start_location, trip_duration, arrival_time FROM wyb4kk_c.Trips WHERE trip_id=1;
UPDATE wyb4kk_c.Trips SET seats_available=2, notes='Seats filling fast' WHERE trip_id=1;
INSERT INTO wyb4kk_c.Reviews (trip_id, comment, stars) VALUES ((SELECT MIN(trip_id) FROM wyb4kk_c.Trips),'Great ride',5);
DELETE FROM wyb4kk_c.Reviews WHERE review_id=3;
SELECT review_id, trip_id, comment, stars FROM wyb4kk_c.Reviews WHERE review_id=1;
UPDATE wyb4kk_c.Reviews SET comment='Great ride, very safe', stars=5 WHERE review_id=1;
INSERT INTO wyb4kk_c.Review_Users (review_id, reviewer_id, reviewee_id) VALUES ((SELECT MAX(review_id) FROM wyb4kk_c.Reviews),'ab123c','bi2yn');
DELETE FROM wyb4kk_c.Review_Users WHERE review_id=3;
SELECT review_id, reviewer_id, reviewee_id FROM wyb4kk_c.Review_Users WHERE review_id=1;
UPDATE wyb4kk_c.Review_Users SET reviewee_id='ab123c' WHERE review_id=1;
INSERT INTO wyb4kk_c.Drives (uva_id, trip_id) VALUES ('ab123c',(SELECT MAX(trip_id) FROM wyb4kk_c.Trips));
DELETE FROM wyb4kk_c.Drives WHERE trip_id=3;
SELECT uva_id, trip_id FROM wyb4kk_c.Drives WHERE trip_id=1;
UPDATE wyb4kk_c.Drives SET uva_id='cd234d' WHERE trip_id=1;
INSERT INTO wyb4kk_c.Rides_In (uva_id, trip_id) VALUES ('bi2yn',(SELECT MAX(trip_id) FROM wyb4kk_c.Trips));
DELETE FROM wyb4kk_c.Rides_In WHERE uva_id='bi2yn' AND trip_id=5;
SELECT uva_id, trip_id FROM wyb4kk_c.Rides_In WHERE trip_id=1;
UPDATE wyb4kk_c.Rides_In SET uva_id='ab123c' WHERE uva_id='bi2yn' AND trip_id=1;

-- ===============================================
-- Constraints
-- ===============================================

ALTER TABLE wyb4kk.Reviews
ADD CONSTRAINT ck_reviews_stars CHECK (stars BETWEEN 1 AND 5);

ALTER TABLE wyb4kk.Trips
ADD CONSTRAINT ck_trips_seats CHECK (seats_available >= 0),
ADD CONSTRAINT ck_trips_duration CHECK (trip_duration IS NULL OR trip_duration > 0);

ALTER TABLE wyb4kk_a.Reviews
ADD CONSTRAINT ck_reviews_stars CHECK (stars BETWEEN 1 AND 5);

ALTER TABLE wyb4kk_a.Trips
ADD CONSTRAINT ck_trips_seats CHECK (seats_available >= 0),
ADD CONSTRAINT ck_trips_duration CHECK (trip_duration IS NULL OR trip_duration > 0);

ALTER TABLE wyb4kk_b.Reviews
ADD CONSTRAINT ck_reviews_stars CHECK (stars BETWEEN 1 AND 5);

ALTER TABLE wyb4kk_b.Trips
ADD CONSTRAINT ck_trips_seats CHECK (seats_available >= 0),
ADD CONSTRAINT ck_trips_duration CHECK (trip_duration IS NULL OR trip_duration > 0);

ALTER TABLE wyb4kk_c.Reviews
ADD CONSTRAINT ck_reviews_stars CHECK (stars BETWEEN 1 AND 5);

ALTER TABLE wyb4kk_c.Trips
ADD CONSTRAINT ck_trips_seats CHECK (seats_available >= 0),
ADD CONSTRAINT ck_trips_duration CHECK (trip_duration IS NULL OR trip_duration > 0);

-- ===============================================
-- Views
-- ===============================================

DROP VIEW IF EXISTS wyb4kk.v_trips_public;
CREATE VIEW wyb4kk.v_trips_public AS
SELECT 
  t.trip_id,
  t.departure_time,
  t.seats_available,
  t.notes,
  sl.name AS start_location_name,
  al.name AS arrival_location_name
FROM wyb4kk.Trips t
JOIN wyb4kk.Location sl ON sl.location_id = t.start_location
JOIN wyb4kk.Location al ON al.location_id = t.arrival_location;

DROP VIEW IF EXISTS wyb4kk.v_reviews_public;
CREATE VIEW wyb4kk.v_reviews_public AS
SELECT r.review_id, r.trip_id, r.stars, r.comment
FROM wyb4kk.Reviews r;

DROP VIEW IF EXISTS wyb4kk_a.v_trips_public;
CREATE VIEW wyb4kk_a.v_trips_public AS
SELECT 
  t.trip_id,
  t.departure_time,
  t.seats_available,
  t.notes,
  sl.name AS start_location_name,
  al.name AS arrival_location_name
FROM wyb4kk_a.Trips t
JOIN wyb4kk_a.Location sl ON sl.location_id = t.start_location
JOIN wyb4kk_a.Location al ON al.location_id = t.arrival_location;

DROP VIEW IF EXISTS wyb4kk_a.v_reviews_public;
CREATE VIEW wyb4kk_a.v_reviews_public AS
SELECT r.review_id, r.trip_id, r.stars, r.comment
FROM wyb4kk_a.Reviews r;

DROP VIEW IF EXISTS wyb4kk_b.v_trips_public;
CREATE VIEW wyb4kk_b.v_trips_public AS
SELECT 
  t.trip_id,
  t.departure_time,
  t.seats_available,
  t.notes,
  sl.name AS start_location_name,
  al.name AS arrival_location_name
FROM wyb4kk_b.Trips t
JOIN wyb4kk_b.Location sl ON sl.location_id = t.start_location
JOIN wyb4kk_b.Location al ON al.location_id = t.arrival_location;

DROP VIEW IF EXISTS wyb4kk_b.v_reviews_public;
CREATE VIEW wyb4kk_b.v_reviews_public AS
SELECT r.review_id, r.trip_id, r.stars, r.comment
FROM wyb4kk_b.Reviews r;

DROP VIEW IF EXISTS wyb4kk_c.v_trips_public;
CREATE VIEW wyb4kk_c.v_trips_public AS
SELECT 
  t.trip_id,
  t.departure_time,
  t.seats_available,
  t.notes,
  sl.name AS start_location_name,
  al.name AS arrival_location_name
FROM wyb4kk_c.Trips t
JOIN wyb4kk_c.Location sl ON sl.location_id = t.start_location
JOIN wyb4kk_c.Location al ON al.location_id = t.arrival_location;

DROP VIEW IF EXISTS wyb4kk_c.v_reviews_public;
CREATE VIEW wyb4kk_c.v_reviews_public AS
SELECT r.review_id, r.trip_id, r.stars, r.comment
FROM wyb4kk_c.Reviews r;

-- ===============================================
-- Procedures
-- ===============================================

DELIMITER $$
USE wyb4kk$$
DROP PROCEDURE IF EXISTS sp_book_trip$$
CREATE PROCEDURE sp_book_trip(IN p_rider VARCHAR(6), IN p_trip INT)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_remaining INT DEFAULT NULL;
  DECLARE v_exists INT DEFAULT 0;

  START TRANSACTION;

  SELECT seats_available INTO v_remaining
  FROM Trips
  WHERE trip_id = p_trip
  FOR UPDATE;

  IF v_remaining IS NULL THEN
    ROLLBACK;
    SELECT 'Trip not found' AS message;
  ELSE
    SELECT COUNT(*) INTO v_exists
    FROM Rides_In
    WHERE uva_id = p_rider AND trip_id = p_trip
    FOR UPDATE;

    IF v_exists > 0 THEN
      ROLLBACK;
      SELECT 'Already booked' AS message;
    ELSEIF v_remaining > 0 THEN
      INSERT INTO Rides_In(uva_id, trip_id) VALUES (p_rider, p_trip);
      UPDATE Trips SET seats_available = seats_available - 1 WHERE trip_id = p_trip;
      COMMIT;
      SELECT 'Booked' AS message;
    ELSE
      ROLLBACK;
      SELECT 'Trip is full' AS message;
    END IF;
  END IF;
END$$
DELIMITER ;

DELIMITER $$
USE wyb4kk_a$$
DROP PROCEDURE IF EXISTS sp_book_trip$$
CREATE PROCEDURE sp_book_trip(IN p_rider VARCHAR(6), IN p_trip INT)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_remaining INT DEFAULT NULL;
  DECLARE v_exists INT DEFAULT 0;

  START TRANSACTION;

  SELECT seats_available INTO v_remaining
  FROM Trips
  WHERE trip_id = p_trip
  FOR UPDATE;

  IF v_remaining IS NULL THEN
    ROLLBACK;
    SELECT 'Trip not found' AS message;
  ELSE
    SELECT COUNT(*) INTO v_exists
    FROM Rides_In
    WHERE uva_id = p_rider AND trip_id = p_trip
    FOR UPDATE;

    IF v_exists > 0 THEN
      ROLLBACK;
      SELECT 'Already booked' AS message;
    ELSEIF v_remaining > 0 THEN
      INSERT INTO Rides_In(uva_id, trip_id) VALUES (p_rider, p_trip);
      UPDATE Trips SET seats_available = seats_available - 1 WHERE trip_id = p_trip;
      COMMIT;
      SELECT 'Booked' AS message;
    ELSE
      ROLLBACK;
      SELECT 'Trip is full' AS message;
    END IF;
  END IF;
END$$
DELIMITER ;

DELIMITER $$
USE wyb4kk_b$$
DROP PROCEDURE IF EXISTS sp_book_trip$$
CREATE PROCEDURE sp_book_trip(IN p_rider VARCHAR(6), IN p_trip INT)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_remaining INT DEFAULT NULL;
  DECLARE v_exists INT DEFAULT 0;

  START TRANSACTION;

  SELECT seats_available INTO v_remaining
  FROM Trips
  WHERE trip_id = p_trip
  FOR UPDATE;

  IF v_remaining IS NULL THEN
    ROLLBACK;
    SELECT 'Trip not found' AS message;
  ELSE
    SELECT COUNT(*) INTO v_exists
    FROM Rides_In
    WHERE uva_id = p_rider AND trip_id = p_trip
    FOR UPDATE;

    IF v_exists > 0 THEN
      ROLLBACK;
      SELECT 'Already booked' AS message;
    ELSEIF v_remaining > 0 THEN
      INSERT INTO Rides_In(uva_id, trip_id) VALUES (p_rider, p_trip);
      UPDATE Trips SET seats_available = seats_available - 1 WHERE trip_id = p_trip;
      COMMIT;
      SELECT 'Booked' AS message;
    ELSE
      ROLLBACK;
      SELECT 'Trip is full' AS message;
    END IF;
  END IF;
END$$
DELIMITER ;

DELIMITER $$
USE wyb4kk_c$$
DROP PROCEDURE IF EXISTS sp_book_trip$$
CREATE PROCEDURE sp_book_trip(IN p_rider VARCHAR(6), IN p_trip INT)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_remaining INT DEFAULT NULL;
  DECLARE v_exists INT DEFAULT 0;

  START TRANSACTION;

  SELECT seats_available INTO v_remaining
  FROM Trips
  WHERE trip_id = p_trip
  FOR UPDATE;

  IF v_remaining IS NULL THEN
    ROLLBACK;
    SELECT 'Trip not found' AS message;
  ELSE
    SELECT COUNT(*) INTO v_exists
    FROM Rides_In
    WHERE uva_id = p_rider AND trip_id = p_trip
    FOR UPDATE;

    IF v_exists > 0 THEN
      ROLLBACK;
      SELECT 'Already booked' AS message;
    ELSEIF v_remaining > 0 THEN
      INSERT INTO Rides_In(uva_id, trip_id) VALUES (p_rider, p_trip);
      UPDATE Trips SET seats_available = seats_available - 1 WHERE trip_id = p_trip;
      COMMIT;
      SELECT 'Booked' AS message;
    ELSE
      ROLLBACK;
      SELECT 'Trip is full' AS message;
    END IF;
  END IF;
END$$
DELIMITER ;

-- ===============================================
-- Audit Tables and Triggers
-- ===============================================

DROP TABLE IF EXISTS wyb4kk.Reviews_audit;
CREATE TABLE wyb4kk.Reviews_audit (
  log_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  who VARCHAR(128) NOT NULL,
  review_id INT NOT NULL,
  old_stars INT,
  new_stars INT
);

DELIMITER $$
USE wyb4kk$$
DROP TRIGGER IF EXISTS trg_reviews_audit$$
CREATE TRIGGER trg_reviews_audit
BEFORE UPDATE ON Reviews
FOR EACH ROW
BEGIN
  IF NOT (OLD.stars <=> NEW.stars) THEN
    INSERT INTO Reviews_audit(who, review_id, old_stars, new_stars)
    VALUES (CURRENT_USER(), OLD.review_id, OLD.stars, NEW.stars);
  END IF;
END$$
DELIMITER ;

DROP TABLE IF EXISTS wyb4kk_a.Reviews_audit;
CREATE TABLE wyb4kk_a.Reviews_audit (
  log_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  who VARCHAR(128) NOT NULL,
  review_id INT NOT NULL,
  old_stars INT,
  new_stars INT
);

DELIMITER $$
USE wyb4kk_a$$
DROP TRIGGER IF EXISTS trg_reviews_audit$$
CREATE TRIGGER trg_reviews_audit
BEFORE UPDATE ON Reviews
FOR EACH ROW
BEGIN
  IF NOT (OLD.stars <=> NEW.stars) THEN
    INSERT INTO Reviews_audit(who, review_id, old_stars, new_stars)
    VALUES (CURRENT_USER(), OLD.review_id, OLD.stars, NEW.stars);
  END IF;
END$$
DELIMITER ;

DROP TABLE IF EXISTS wyb4kk_b.Reviews_audit;
CREATE TABLE wyb4kk_b.Reviews_audit (
  log_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  who VARCHAR(128) NOT NULL,
  review_id INT NOT NULL,
  old_stars INT,
  new_stars INT
);

DELIMITER $$
USE wyb4kk_b$$
DROP TRIGGER IF EXISTS trg_reviews_audit$$
CREATE TRIGGER trg_reviews_audit
BEFORE UPDATE ON Reviews
FOR EACH ROW
BEGIN
  IF NOT (OLD.stars <=> NEW.stars) THEN
    INSERT INTO Reviews_audit(who, review_id, old_stars, new_stars)
    VALUES (CURRENT_USER(), OLD.review_id, OLD.stars, NEW.stars);
  END IF;
END$$
DELIMITER ;

DROP TABLE IF EXISTS wyb4kk_c.Reviews_audit;
CREATE TABLE wyb4kk_c.Reviews_audit (
  log_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  who VARCHAR(128) NOT NULL,
  review_id INT NOT NULL,
  old_stars INT,
  new_stars INT
);

DELIMITER $$
USE wyb4kk_c$$
DROP TRIGGER IF EXISTS trg_reviews_audit$$
CREATE TRIGGER trg_reviews_audit
BEFORE UPDATE ON Reviews
FOR EACH ROW
BEGIN
  IF NOT (OLD.stars <=> NEW.stars) THEN
    INSERT INTO Reviews_audit(who, review_id, old_stars, new_stars)
    VALUES (CURRENT_USER(), OLD.review_id, OLD.stars, NEW.stars);
  END IF;
END$$
DELIMITER ;

-- ===============================================
-- Role and Privilege Management
-- ===============================================
-- Grant privileges for all four databases to development users
-- Configure roles for wyb4kk (primary database)

SET @g1 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk`.* TO ''wyb4kk_a''@"%"');
SET @g2 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk`.* TO ''wyb4kk_b''@"%"');
PREPARE g1 FROM @g1; EXECUTE g1; DEALLOCATE PREPARE g1;
PREPARE g2 FROM @g2; EXECUTE g2; DEALLOCATE PREPARE g2;

-- Configure roles for wyb4kk_a

SET @g3 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_a`.* TO ''wyb4kk_a''@"%"');
SET @g4 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_a`.* TO ''wyb4kk_b''@"%"');
PREPARE g3 FROM @g3; EXECUTE g3; DEALLOCATE PREPARE g3;
PREPARE g4 FROM @g4; EXECUTE g4; DEALLOCATE PREPARE g4;

-- Configure roles for wyb4kk_b

SET @g5 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_b`.* TO ''wyb4kk_a''@"%"');
SET @g6 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_b`.* TO ''wyb4kk_b''@"%"');
PREPARE g5 FROM @g5; EXECUTE g5; DEALLOCATE PREPARE g5;
PREPARE g6 FROM @g6; EXECUTE g6; DEALLOCATE PREPARE g6;

-- Configure roles for wyb4kk_c (application database)

SET @g7 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_c`.* TO ''wyb4kk_a''@"%"');
SET @g8 = CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON `wyb4kk_c`.* TO ''wyb4kk_b''@"%"');
PREPARE g7 FROM @g7; EXECUTE g7; DEALLOCATE PREPARE g7;
PREPARE g8 FROM @g8; EXECUTE g8; DEALLOCATE PREPARE g8;

-- Grant application user privileges on views and procedures
SET @ga1 = CONCAT('GRANT SELECT ON `wyb4kk`.v_trips_public TO ''wyb4kk_c''@"%"');
SET @ga2 = CONCAT('GRANT SELECT ON `wyb4kk`.v_reviews_public TO ''wyb4kk_c''@"%"');
SET @ga3 = CONCAT('GRANT EXECUTE ON PROCEDURE `wyb4kk`.sp_book_trip TO ''wyb4kk_c''@"%"');
PREPARE ga1 FROM @ga1; EXECUTE ga1; DEALLOCATE PREPARE ga1;
PREPARE ga2 FROM @ga2; EXECUTE ga2; DEALLOCATE PREPARE ga2;
PREPARE ga3 FROM @ga3; EXECUTE ga3; DEALLOCATE PREPARE ga3;

SET @ga4 = CONCAT('GRANT SELECT ON `wyb4kk_a`.v_trips_public TO ''wyb4kk_c''@"%"');
SET @ga5 = CONCAT('GRANT SELECT ON `wyb4kk_a`.v_reviews_public TO ''wyb4kk_c''@"%"');
SET @ga6 = CONCAT('GRANT EXECUTE ON PROCEDURE `wyb4kk_a`.sp_book_trip TO ''wyb4kk_c''@"%"');
PREPARE ga4 FROM @ga4; EXECUTE ga4; DEALLOCATE PREPARE ga4;
PREPARE ga5 FROM @ga5; EXECUTE ga5; DEALLOCATE PREPARE ga5;
PREPARE ga6 FROM @ga6; EXECUTE ga6; DEALLOCATE PREPARE ga6;

SET @ga7 = CONCAT('GRANT SELECT ON `wyb4kk_b`.v_trips_public TO ''wyb4kk_c''@"%"');
SET @ga8 = CONCAT('GRANT SELECT ON `wyb4kk_b`.v_reviews_public TO ''wyb4kk_c''@"%"');
SET @ga9 = CONCAT('GRANT EXECUTE ON PROCEDURE `wyb4kk_b`.sp_book_trip TO ''wyb4kk_c''@"%"');
PREPARE ga7 FROM @ga7; EXECUTE ga7; DEALLOCATE PREPARE ga7;
PREPARE ga8 FROM @ga8; EXECUTE ga8; DEALLOCATE PREPARE ga8;
PREPARE ga9 FROM @ga9; EXECUTE ga9; DEALLOCATE PREPARE ga9;
