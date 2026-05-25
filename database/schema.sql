CREATE DATABASE IF NOT EXISTS smartCityKelompok2;

USE smartCityKelompok2;

-- 1. Shared service tables 
CREATE TABLE zones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city_district VARCHAR(100) NOT NULL,
    coordinates VARCHAR(250),
    area_km2 FLOAT
);

CREATE TABLE oauth_clients(
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) UNIQUE NOT NULL,
    client_secret VARCHAR(255) NOT NULL,
    grant_types VARCHAR(100) NOT NULL,
    redirect_uris VARCHAR(255)
);

CREATE TABLE shared_oauth_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(100) NOT NULL,
    user_id INT,
    access_token VARCHAR(255) UNIQUE NOT NULL,
    refresh_token VARCHAR(255),
    expires_at DATETIME NOT NULL
);

-- 2. Citizen service tables
CREATE TABLE citizens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    zone_id VARCHAR(50),
    role ENUM('Admin', 'Warga') DEFAULT 'Warga',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    zone_id VARCHAR(50) NOT NULL,
    status ENUM('Pending', 'Processing', 'Done') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES BY citizens(id),
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    tittle VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    is_read ENUM('Read', 'Not Read') DEFAULT 'Not Read',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES BY citizens(id)
);

-- 3. Traffic service tables
CREATE TABLE traffic_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id VARCHAR(50) NOT NULL,
    vehicle_density FLOAT NOT NULL,
    avg_speed_kmh FLOAT NOT NULL,
    incident_flag BOOLEAN DEFAULT FALSE,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

CREATE TABLE incidents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id VARCHAR(50) NOT NULL,
    type VARCHAR(100) NOT NULL,
    severity ENUM ('Fatal', 'Moderate', 'Mild') DEFAULT 'Mild',
    description TEXT NOT NULL,
    resolved_at TIMESTAMP NULL,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

-- 4. Environment tables
CREATE TABLE sensor_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id VARCHAR(50) NOT NULL,
    pm25 FLOAT,
    pm10 FLOAT,
    no2 FLOAT,
    co FLOAT,
    o3 FLOAT,
    temperature FLOAT,
    humidity FLOAT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id VARCHAR(50) NOT NULL,
    alert_type VARCHAR(100) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    value FLOAT NOT NULL,
    threshold FLOAT NOT NULL,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (zone_id) REFERENCES BY zones(id)
);

CREATE INDEX idx_reports_status ON citizen_reports(status);
CREATE INDEX idx_reports_zone ON citizen_reports(zone_id);

CREATE INDEX idx_traffic_readings_zone ON traffic_readings(zone_id);
CREATE INDEX idx_traffice_readings_time ON traffic_readings(recorded_at);

CREATE INDEX idx_env_readings_zone ON env_sensor_readings(zone_id);
CREATE INDEX idx_env_readings_time ON env_sensor_readings(recorded_at);