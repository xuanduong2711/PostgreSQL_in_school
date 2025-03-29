CREATE DATABASE solar_system;

-- Tạo bảng planet
CREATE TABLE planet ( 
    planet_id   INT PRIMARY KEY,
    planet_name VARCHAR(255) NOT NULL
);

-- Tạo bảng ring với khóa ngoại tham chiếu đến planet
CREATE TABLE ring (
    planet_id   INT,
    ring_tot    INT,
    PRIMARY KEY (planet_id, ring_tot), -- Dùng khóa chính kết hợp
    CONSTRAINT fk_ring_planet FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
);

-- Chèn dữ liệu vào bảng planet
INSERT INTO planet(planet_id, planet_name) VALUES
(1, 'Mercury'),
(2, 'Venus'),
(3, 'Earth'),
(4, 'Mars'),
(5, 'Jupiter'),
(6, 'Saturn'),
(7, 'Uranus'),
(8, 'Neptune');

-- Chèn dữ liệu vào bảng ring
INSERT INTO ring (planet_id, ring_tot) VALUES
(5, 3),
(6, 7),
(7, 13),
(8, 6);

----
CREATE DATABASE canada;
CREATE TABLE province (
    province_id INT PRIMARY KEY,
    province_name VARCHAR(255) NOT NULL,
    official_language VARCHAR(255) NOT NULL
);
CREATE TABLE capital_city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    province_id INT,
    FOREIGN KEY (province_id) REFERENCES province(province_id)
);
CREATE TABLE tourist_attraction (
    attraction_id INT PRIMARY KEY,
    attraction_name VARCHAR(255) NOT NULL,
    attraction_city_id INT,
    open_flag BOOLEAN,
    FOREIGN KEY (attraction_city_id) REFERENCES capital_city(city_id)
);
-- Existing content of lab2_lt.sql remains unchanged

-- New INSERT statements for the new tables
INSERT INTO province (province_id, province_name, official_language) VALUES
(1, 'Alberta', 'English'),
(2, 'British Columbia', 'English'),
(3, 'Manitoba', 'English'),
(4, 'New Brunswick', 'English, French'),
(5, 'Newfoundland', 'English'),
(6, 'Nova Scotia', 'English'),
(7, 'Ontario', 'English'),
(8, 'Prince Edward Island', 'English'),
(9, 'Quebec', 'French'),
(10, 'Saskatchewan', 'English');

INSERT INTO capital_city (city_id, city_name, province_id) VALUES
(1, 'Toronto', 7),
(2, 'Quebec City', 9),
(3, 'Halifax', 5),
(4, 'Fredericton', 4),
(5, 'Winnipeg', 3),
(6, 'Victoria', 2),
(7, 'Charlottetown', 8),
(8, 'Regina', 10),
(9, 'Edmonton', 1),
(10, 'St. Johns', 5);

INSERT INTO tourist_attraction (attraction_id, attraction_name, attraction_city_id, open_flag) VALUES
(1, 'CN Tower', 1, true),
(2, 'Old Quebec', 2, true),
(3, 'Royal Ontario Museum', 1, true),
(4, 'Place Royale', 2, true),
(5, 'Halifax Citadel', 3, true),
(6, 'Garrison District', 4, true),
(7, 'Confederation Centre of the Arts', 7, true),
(8, 'Stone Hall Castle', 8, true),
(9, 'West Edmonton Mall', 9, true),
(10, 'Signal Hill', 10, true);

-- 1.1
-- Em nghĩ sẽ trả về 4 dòng
SELECT p.planet_id, p.planet_name, r.ring_tot
FROM planet p
    JOIN ring r
    ON p.planet_id = r.planet_id;

--1.2
-- Em nghi se tra ve 8 dong
SELECT p.planet_id, p.planet_name, r.ring_tot
FROM planet p
    LEFT JOIN ring r
    ON p.planet_id = r.planet_id;

--1.3
SELECT p.planet_id, p.planet_name, r.ring_tot AS rings
FROM planet p
LEFT JOIN ring r ON p.planet_id = r.planet_id;

-- 2.1
SELECT t.attraction_name, c.city_name, p.province_name
FROM tourist_attraction t
    JOIN capital_city c 
    ON t.attraction_city_id = c.city_id
    JOIN province p 
    ON c.province_id = p.province_id
WHERE t.open_flag = TRUE;

-- 2.2
CREATE TEMPORARY TABLE open_tourist_attraction AS 
SELECT t.attraction_city_id,  t.attraction_name
FROM tourist_attraction t
    JOIN capital_city c 
    ON t.attraction_city_id = c.city_id
WHERE t.open_flag = TRUE;

-- 2.3
SELECT 
    o.attraction_name, 
    c.city_name
FROM open_tourist_attraction o
    JOIN capital_city c 
    ON o.attraction_city_id = c.city_id
WHERE c.city_name = 'Toronto';
