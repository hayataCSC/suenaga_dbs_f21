-- If "school" database exists, delete it
DROP DATABASE IF EXISTS school;
-- Create "school" database
CREATE DATABASE school;
-- Switch to "school" database
USE school;
-- Create "instructors" table inside "school" database
CREATE TABLE instructors (
    instructor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,      -- I'd omitted this comma, causing an error
    inst_first_name VARCHAR(20),
    inst_last_name VARCHAR(20),
    campus_phone VARCHAR(20),
    PRIMARY KEY (instructor_id)
);
-- Insert data to "instructors" table
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) VALUES ("Kira", "Bently", "363-9948");
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) VALUES ("Timothy", "Ennis", "527-4992");
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) VALUES ("Shannon", "Black", "322-5992");
INSERT INTO instructors (inst_first_name, inst_last_name, campus_phone) VALUES ("Estela", "Rosales", " 322-6992");
-- Select all data from "instructors" table
SELECT * FROM instructors;