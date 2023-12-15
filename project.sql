-- CRUD

DROP DATABASE cinema;

CREATE DATABASE IF NOT EXISTS cinema;

CREATE TABLE IF NOT EXISTS cinema.Films
(
	film_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    film_title VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS cinema.Actors
(
    actor_id SMALLINT PRIMARY KEY NOT NULL,
	actor_name VARCHAR(100) NOT NULL,
    actor_birthday DATE
);

CREATE TABLE IF NOT EXISTS cinema.Film2Actors
(
	film2actors_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
	FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id),
    FOREIGN KEY (actor_id) REFERENCES cinema.Actors (actor_id)
);

CREATE TABLE IF NOT EXISTS cinema.Directors
(
	director_id SMALLINT PRIMARY KEY NOT NULL,
	director_name VARCHAR(100) NOT NULL,
    director_birthday DATE
);

CREATE TABLE IF NOT EXISTS cinema.Film2Directors
(
	film2director_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	director_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
	FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id),
    FOREIGN KEY (director_id) REFERENCES cinema.Directors (director_id)
);

CREATE TABLE IF NOT EXISTS cinema.Composers
(
	composer_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    film_id SMALLINT NOT NULL,
	composer_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id)
);

CREATE TABLE IF NOT EXISTS cinema.Country
(
	country_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    film_id SMALLINT NOT NULL,
	country_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id)
);

CREATE TABLE IF NOT EXISTS cinema.Release_date
(
	release_date SMALLINT PRIMARY KEY NOT NULL,
    film_id SMALLINT NOT NULL,
    FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id)
);

CREATE TABLE IF NOT EXISTS cinema.Minimal_age
(
	minimal_age TINYINT PRIMARY KEY NOT NULL,
    film_id SMALLINT NOT NULL,
    FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id)
);

CREATE TABLE IF NOT EXISTS cinema.Sessions
(
	session_id SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    film_id SMALLINT NOT NULL,
    FOREIGN KEY (film_id) REFERENCES cinema.Films (film_id)
);

CREATE TABLE IF NOT EXISTS cinema.Halls
(
	hall_id TINYINT PRIMARY KEY NOT NULL,
    session_id SMALLINT NOT NULL,
    FOREIGN KEY (session_id) REFERENCES cinema.Sessions (session_id)
);

CREATE TABLE IF NOT EXISTS cinema.Time
(
	start_time_id TINYINT PRIMARY KEY NOT NULL,
    start_time TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS cinema.Display_time
(
	display_time_id TINYINT PRIMARY KEY NOT NULL,
    session_id SMALLINT NOT NULL,
    start_time_id TINYINT NOT NULL,
    length TIME NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (session_id) REFERENCES cinema.Sessions (session_id),
    FOREIGN KEY (start_time_id) REFERENCES cinema.Time (start_time_id)
);

ALTER TABLE cinema.Time
ADD FOREIGN KEY (start_time_id) REFERENCES cinema.Display_time (start_time_id);

CREATE TABLE IF NOT EXISTS cinema.Ticket_prices
(
	tikect_price SMALLINT PRIMARY KEY NOT NULL,
    session_id SMALLINT NOT NULL,
    FOREIGN KEY (session_id) REFERENCES cinema.Sessions (session_id)
);

CREATE TABLE IF NOT EXISTS cinema.Ticket_classes
(
	tikect_class TINYINT PRIMARY KEY NOT NULL,
    tikect_price SMALLINT NOT NULL,
    FOREIGN KEY (tikect_price) REFERENCES cinema.Ticket_prices (tikect_price)
);

-- все таблицы данными не заполняю, для дальнешего хватит несколько

INSERT INTO cinema.Films (film_title) VALUES
('The Matrix'),
('Forrest Gump'),
('Star Wars: A New Hope'),
('Star Wars: The Empire Strikes Back');

INSERT INTO cinema.Film2Actors (actor_id, film_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 3),
(6, 4),
(7, 3),
(8, 3);

INSERT INTO cinema.Actors (actor_id, actor_name, actor_birthday) VALUES
(1, 'Keanu Reeves', '1964-09-02'),
(2, 'Laurence Fishburne', '1961-07-30'),
(3, 'Carrie-Anne Moss', '1967-08-21'),
(4, 'Tom Hanks', '1956-07-09'),
(5, 'Robin Wright', '1966-04-08'),
(6, 'Mark  Hamill', '1951-09-25'),
(7, 'Harrison Ford', '1942-07-13'),
(8, 'Carrie Fisher', '1956-10-21');

INSERT INTO cinema.Country (film_id, country_name) VALUES
(1, 'USA'),
(2, 'USA'),
(3, 'USA');

INSERT INTO cinema.Release_date (release_date, film_id) VALUES
(1999, 1),
(1994, 2),
(1977, 3);

-- SELECT  + фильтрация

SELECT * FROM cinema.Films
WHERE film_title = 'The Matrix';

-- SELECT + группировка и агрегация

SELECT film_title, release_date, AVG(release_date) FROM cinema.Films
JOIN cinema.Release_date ON cinema.Release_date.film_id = cinema.Films.film_id;

-- SELECT + вложенный запрос

SELECT
film_title,
release_date,
release_date - (SELECT AVG(release_date) FROM cinema.Release_date) as release_date_diff_from_avg
FROM cinema.Films
JOIN cinema.Release_date ON cinema.Release_date.film_id = cinema.Films.film_id;

-- SELECT + JOIN (например, join нескольких таблиц)

SELECT * FROM cinema.Films
JOIN cinema.Film2Actors ON cinema.Film2Actors.film_id = cinema.Films.film_id
JOIN cinema.Actors ON cinema.Film2Actors.actor_id = cinema.Actors.actor_id
JOIN cinema.Country ON cinema.Country.film_id = cinema.Films.film_id
ORDER BY actor_birthday;

-- Процедура или функция

DROP PROCEDURE cinema.actor_num_films;

DELIMITER $$

CREATE PROCEDURE cinema.actor_num_films ()
BEGIN
	SELECT actor_name, COUNT(Film2Actors.actor_id) AS actor_num_films FROM cinema.Films
	JOIN cinema.Film2Actors ON cinema.Film2Actors.film_id = cinema.Films.film_id
	JOIN cinema.Actors ON cinema.Film2Actors.actor_id = cinema.Actors.actor_id
	GROUP BY actor_name;
END$$
DELIMITER ;

CALL cinema.actor_num_films();