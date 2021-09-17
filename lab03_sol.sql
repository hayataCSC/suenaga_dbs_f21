-- Drop database "movie_ratings" if exists
DROP DATABASE IF EXISTS movie_ratings;
-- Create database "movie_ratings"
CREATE DATABASE movie_ratings;
-- Use database "movie_ratings"
USE movie_ratings;
-- Create table "movie"
CREATE TABLE movie (
  movie_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  movie_title VARCHAR(200),
  release_date DATE,
  PRIMARY KEY (movie_id)
);
-- Create table "genre"
CREATE TABLE genre (
  genre_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  genre_name VARCHAR(50),
  PRIMARY KEY (genre_id)
);
-- Create link table "movie_genre"
CREATE TABLE movie_genre (
  movie_id INT UNSIGNED NOT NULL,
  genre_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (movie_id, genre_id),
  FOREIGN KEY (movie_id) REFERENCES movie (movie_id),
  FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
);
-- Create table "consumer"
CREATE TABLE consumer (
  consumer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(15),
  last_name VARCHAR(15),
  address VARCHAR(100),
  city VARCHAR(50),
  state CHAR(2),
  zip CHAR(5),
  PRIMARY KEY (consumer_id)
);
-- Create link table "rating"
CREATE TABLE rating (
  movie_id INT UNSIGNED NOT NULL,
  consumer_id INT UNSIGNED NOT NULL,
  rated_at DATETIME,
  num_star INT UNSIGNED,
  PRIMARY KEY (movie_id, consumer_id),
  FOREIGN KEY (movie_id) REFERENCES movie (movie_id),
  FOREIGN KEY (consumer_id) REFERENCES consumer (consumer_id)
);
-- Insert genres to "genre" table
INSERT INTO genre (genre_name) VALUES ("Action"); -- 1
INSERT INTO genre (genre_name) VALUES ("Adventure"); -- 2
INSERT INTO genre (genre_name) VALUES ("Thriller"); -- 3
INSERT INTO genre (genre_name) VALUES ("Comedy"); -- 4
INSERT INTO genre (genre_name) VALUES ("Drama"); -- 5
INSERT INTO genre (genre_name) VALUES ("Sci-Fi"); -- 6
-- Insert movies to "movie" table
INSERT INTO movie (movie_title, release_date)
  VALUES ("The Hunt for Red October", STR_TO_DATE('1990,3,2','%Y,%m,%d')); -- 1
INSERT INTO movie (movie_title, release_date)
  VALUES ("Lady Bird", STR_TO_DATE('2017,12,1','%Y,%m,%d')); -- 2
INSERT INTO movie (movie_title, release_date)
  VALUES ("IncepAon", STR_TO_DATE('2010,8,6','%Y,%m,%d')); -- 3
-- Insert movies and genres to "movie_genre" table
INSERT INTO movie_genre (movie_id, genre_id) VALUES (1, 1);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (1, 2);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (1, 3);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (2, 4);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (2, 5);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (3, 1);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (3, 2);
INSERT INTO movie_genre (movie_id, genre_id) VALUES (3, 6);
-- Insert consumers to "consumer" table
INSERT INTO consumer (first_name, last_name, address, city, state, zip)
  VALUES ("Toru", "Okada", "800 Glenridge Ave", "Hobart", "IN", "46342"); -- 1
INSERT INTO consumer (first_name, last_name, address, city, state, zip)
  VALUES ("Kumiko", "Okada", "864 NW Bohemia St", "Vincentown", "NJ", "08088"); -- 2
INSERT INTO consumer (first_name, last_name, address, city, state, zip)
  VALUES ("Nobooru", "Wataya", "342 Joy Ridge St", "Hermitage", "TN", "37076"); -- 3
INSERT INTO consumer (first_name, last_name, address, city, state, zip)
  VALUES ("May", "Kasahara", "5 Kent Rd", "East Haven", "CT", "06512"); -- 4
-- Insert ratings to "rating" table
INSERT INTO rating (movie_id, consumer_id, rated_at, num_star) VALUES (1, 1, NOW(), 4);
INSERT INTO rating (movie_id, consumer_id, rated_at, num_star) VALUES (1, 3, NOW(), 3);
INSERT INTO rating (movie_id, consumer_id, rated_at, num_star) VALUES (1, 4, NOW(), 1);
INSERT INTO rating (movie_id, consumer_id, rated_at, num_star) VALUES (2, 3, NOW(), 2);
INSERT INTO rating (movie_id, consumer_id, rated_at, num_star) VALUES (2, 4, NOW(), 4);
-- Check each table
SELECT * FROM movie;
SELECT * FROM genre;
SELECT * FROM movie_genre;
SELECT * FROM consumer;
SELECT * FROM rating;
/* Generate a report */
SELECT first_name, last_name, movie_title, num_star
  FROM movie
  NATURAL JOIN rating
  NATURAL JOIN consumer;