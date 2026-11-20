-- Run once on the existing cineman database. MySQL DDL auto-commits: back up first.
CREATE TABLE schema_versions(version INT PRIMARY KEY, applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE genres(id BIGINT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(80) NOT NULL UNIQUE);
INSERT INTO genres(name) SELECT DISTINCT genre FROM movies;
CREATE TABLE movie_genres(movie_id BIGINT NOT NULL,genre_id BIGINT NOT NULL,PRIMARY KEY(movie_id,genre_id),FOREIGN KEY(movie_id) REFERENCES movies(id) ON DELETE CASCADE,FOREIGN KEY(genre_id) REFERENCES genres(id));
INSERT INTO movie_genres SELECT m.id,g.id FROM movies m JOIN genres g ON g.name=m.genre;
ALTER TABLE movies ADD poster_key VARCHAR(80), ADD poster_mime VARCHAR(40), ADD poster_size BIGINT, ADD poster_source VARCHAR(255), ADD create_key VARCHAR(36) UNIQUE;
ALTER TABLE orders ADD status ENUM('PENDING','PAID','FAILED','EXPIRED','REVIEW') NOT NULL DEFAULT 'PAID', ADD show_id BIGINT NULL, ADD expires_at DATETIME NULL, ADD FOREIGN KEY(show_id) REFERENCES shows(id);
ALTER TABLE payments MODIFY method ENUM('SIMULATED','CASH','VNPAY') NOT NULL, ADD provider_ref VARCHAR(80) UNIQUE;
CREATE TABLE order_seats(order_id BIGINT NOT NULL,seat_id BIGINT NOT NULL,price DECIMAL(12,0) NOT NULL,PRIMARY KEY(order_id,seat_id),FOREIGN KEY(order_id) REFERENCES orders(id),FOREIGN KEY(seat_id) REFERENCES seats(id));
CREATE TABLE seat_holds(show_id BIGINT NOT NULL,seat_id BIGINT NOT NULL,order_id BIGINT NOT NULL,expires_at DATETIME NOT NULL,PRIMARY KEY(show_id,seat_id),FOREIGN KEY(show_id) REFERENCES shows(id),FOREIGN KEY(seat_id) REFERENCES seats(id),FOREIGN KEY(order_id) REFERENCES orders(id));
CREATE TABLE payment_events(order_id BIGINT PRIMARY KEY,provider_ref VARCHAR(80) NOT NULL UNIQUE,amount DECIMAL(14,0) NOT NULL,received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(order_id) REFERENCES orders(id));
INSERT INTO schema_versions(version) VALUES(2);
