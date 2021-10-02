DROP DATABASE IF EXISTS rug_shop;

CREATE DATABASE rug_shop;

USE rug_shop;

CREATE TABLE states (
  `name` CHAR(2) PRIMARY KEY
);

CREATE TABLE countries (
  `name` CHAR(255) PRIMARY KEY
);

CREATE TABLE customers (
  customer_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone CHAR(10),
  zip CHAR(5),
  street VARCHAR(225),
  city VARCHAR(255),
  `state` CHAR(2),
  FOREIGN KEY (`state`)
    REFERENCES states(`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

/* The styles table has an auto-incremented integer as a primary key as the
  future business requirements might require the database to store additional
  attributes about each style in this table
*/
CREATE TABLE styles (
  style_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255)
);

/* The materials table has an auto-incremented integer as a primary key as the
  future business requirements might require the database to store additional
  attributes about each material in this table
*/
CREATE TABLE materials (
  material_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255)
);

CREATE TABLE rugs (
  rug_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
  made_in VARCHAR(255) NOT NULL,
  year_made YEAR DEFAULT (YEAR(NOW())), -- Rugs are made no earlier than 1901
  style SMALLINT NOT NULL,
  material SMALLINT NOT NULL,
  width DECIMAL(5, 2) UNSIGNED NOT NULL,
  height DECIMAL(5, 2) UNSIGNED NOT NULL, -- width, height < 1km (millimeter precision)
  cost DECIMAL(8, 2) UNSIGNED NOT NULL, -- Rugs cost less than $1M (cent precision)
  markup DECIMAL(6, 2), -- markup < 10,000.00% (can be negative)
  acquired_on DATE NOT NULL,
  CHECK (acquired_on >= year_made), -- rugs can be acquired after being made
--   FOREIGN KEY (made_in)
--     REFERENCES countries(`name`)
--     ON DELETE RESTRICT,
  FOREIGN KEY (style)
    REFERENCES styles(style_id)
    ON DELETE RESTRICT,
  FOREIGN KEY (material)
    REFERENCES materials(material_id)
    ON DELETE RESTRICT
);

CREATE TABLE sales (
  customer_id SMALLINT NOT NULL,
  rug_id SMALLINT NOT NULL,
  price DECIMAL(8, 2) UNSIGNED NOT NULL, -- Rugs are sold at less than $1M
  sold_on DATE NOT NULL DEFAULT (CURDATE()),
  returned_on DATE,
  PRIMARY KEY (customer_id, rug_id), -- A customer can only buy the same rug for once
  FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT,
  FOREIGN KEY (rug_id)
    REFERENCES rugs(rug_id)
    ON DELETE RESTRICT,
  CHECK (returned_on >= sold_on) -- Customer can only return rugs after they purchases them
);

CREATE TABLE rentals (
  customer_id SMALLINT NOT NULL,
  rug_id SMALLINT NOT NULL,
  rented_on DATE NOT NULL DEFAULT (DATE(NOW())),
  due_on DATE NOT NULL DEFAULT (DATE(NOW()) + INTERVAL 1 MONTH), -- The default due date is one month after the day the rug was rented
  returned_on DATE,
  PRIMARY KEY (customer_id, rug_id), -- A customer can only rent the same rug for once
  FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT,
  FOREIGN KEY (rug_id)
    REFERENCES rugs(rug_id)
    ON DELETE RESTRICT,
  CHECK (due_on >= rented_on), -- Due dates are not earlier than the day rugs are rented
  CHECK (returned_on >= rented_on) -- Customer can only return rugs after they rents them
);

/* ------------------------------------ Triggers, Functions, Stored Procedures --------------------------------------------- */

/* Define a function that takes a customer id and returns the number of active rents for that user */
DELIMITER $$
CREATE FUNCTION get_active_rent_count
(
  customer_id SMALLINT
)
RETURNS TINYINT
READS SQL DATA -- This functioin reads data from the rents table
BEGIN
  DECLARE rent_count SMALLINT;
  
  SELECT COUNT(*) into rent_count
    FROM rentals r
    WHERE r.customer_id = customer_id and
          r.returned_on IS NULL;
          
  RETURN rent_count;
END$$
DELIMITER ;

/* (Trigger) A user cannot have more than four active rents */
DELIMITER $$
CREATE TRIGGER before_rent_insert
  BEFORE INSERT
  ON rentals FOR EACH ROW
BEGIN
  -- Declare a local variable to store the number of active rentals
  DECLARE rent_count SMALLINT;
  -- Get the number of active rents for the customer using a funtion
  SET rent_count = get_active_rent_count(NEW.customer_id);
  -- If the new insert causes the the number of active rents to be more than four, raise an error
  IF rent_count >= 4 THEN
    SIGNAL SQLSTATE '22001'
      SET MESSAGE_TEXT = 'Customer cannot have more than four active rentals';
  END IF;
END$$
DELIMITER ;

/* (Trigger) A rug cannot be sold if it matches any of the following conditions 
  1. A rug has been sold and it has not been returned
  2. A rug has been rented out and it has not been returned
  3. A rug's sold_on date is earlier than the acquisition date  
*/
DELIMITER $$
CREATE TRIGGER before_sale_insert
  BEFORE INSERT
  ON sales FOR EACH ROW
BEGIN
  DECLARE sale_count SMALLINT;
  DECLARE rent_count SMALLINT;
  DECLARE sale_date DATE;
  DECLARE acquisition_date DATE;

  /* Check if the rug has been purchased and has not been returned */
  SELECT COUNT(*) INTO sale_count
  FROM sales
  WHERE rug_id = new.rug_id AND
        returned_on IS NOT NULL;

  /* Check if the rug has been rented and has not been returned */
  SELECT COUNT(*) INTO rent_count
    FROM rentals
    WHERE rug_id = new.rug_id AND
          returned_on IS NOT NULL;
  
  /* Get acquisition date */
  SELECT acquired_on INTO acquisition_date
    FROM rugs
    WHERE rug_id = new.rug_id;
  
  /* Get the sale date. If sold_on date of the new data is default (null),
  use the current date (as it is the default value of the sold_on field) */
  SET sale_date = IFNULL(new.sold_on, DATE(NOW()));

  IF sale_count <> 0 AND
    rent_count <> 0 AND
    acquisition_date > sale_date THEN
    SIGNAL SQLSTATE '22001'
      SET MESSAGE_TEXT = 'Rug is not available to sell';
  END IF;
END$$
DELIMITER ;

/* ------------------------------------ Insertion of dummy data --------------------------------------------- */

INSERT INTO styles
  VALUES
    (DEFAULT, 'Beohemian'),
    (DEFAULT, 'Marrakesh'),
    (DEFAULT, 'Tangier'),
    (DEFAULT, 'Morocco'),
    (DEFAULT, 'Mirage'),
    (DEFAULT, 'Tiffany'),
    (DEFAULT, 'Rodeo Drive');

INSERT INTO materials
  VALUES
    (DEFAULT, 'wool'),
    (DEFAULT, 'cotton'),
    (DEFAULT, 'silk');

INSERT INTO countries
  VALUES
    ('Turkey'),
    ('Iran'),
    ('India'),
    ('Afghanistan');

INSERT INTO states
  VALUES
    ('AL'),
    ('AK'),
    ('AZ'),
    ('AR'),
    ('CA'),
    ('CO'),
    ('CT'),
    ('DE'),
    ('DC'),
    ('FL'),
    ('GA'),
    ('HI'),
    ('ID'),
    ('IL'),
    ('IN'),
    ('IA'),
    ('KS'),
    ('KY'),
    ('LA'),
    ('ME'),
    ('MD'),
    ('MA'),
    ('MI'),
    ('MN'),
    ('MS'),
    ('MO'),
    ('MT'),
    ('NE'),
    ('NV'),
    ('NH'),
    ('NJ'),
    ('NM'),
    ('NY'),
    ('NC'),
    ('ND'),
    ('OH'),
    ('OK'),
    ('OR'),
    ('PA'),
    ('RI'),
    ('SC'),
    ('SD'),
    ('TN'),
    ('TX'),
    ('UT'),
    ('VT'),
    ('VA'),
    ('WA'),
    ('WV'),
    ('WI'),
    ('WY');

INSERT INTO customers
  VALUES
    (DEFAULT,"Wing","Hood","1481847764","78535","P.O. Box 580, 9704 Fusce Ave","Lower Hutt","MA"),
    (DEFAULT,"Nathaniel","Frost","4480417580","79121","1558 Cras St.","Bielefeld","IA"),
    (DEFAULT,"Hamilton","Compton","5228539114","84471","498-8174 Per Ave","Salzgitter","DE"),
    (DEFAULT,"Cleo","Berg","5182018251","21527","250-7179 Mi. Rd.","Trà Vinh","MA"),
    (DEFAULT,"Ulysses","Mullen","3846127532","78560","413 Dui. St.","Tauranga","NV"),
    (DEFAULT,"Ian","Pena","3814908884","28613","725-4149 Nunc Avenue","Okene","CO"),
    (DEFAULT,"Mariko","Gould","2741595275","78168","Ap #777-3722 Sagittis St.","Tuy Hòa","MI"),
    (DEFAULT,"Addison","Rhodes","7793156422","28323","P.O. Box 339, 2765 In Rd.","Tirrases","AR"),
    (DEFAULT,"Gretchen","Gardner","6445928711","47925","589-1890 Duis St.","Minitonas","IA"),
    (DEFAULT,"Imelda","Blevins","3834566573","66137","P.O. Box 177, 6183 Enim, St.","Makassar","VA"),
    (DEFAULT,"Christine","Henry","3996689276","83225","2045 Non, Rd.","Ulloa (Barrial]","MT"),
    (DEFAULT,"Matthew","Pruitt","7877062331","49402","702-9455 Varius Ave","Sangju","IA"),
    (DEFAULT,"Leonard","Blackburn","2221589614","60975","300-7169 Nascetur Av.","Leffinge","AR"),
    (DEFAULT,"Haviva","Forbes","5633235611","11181","Ap #260-2400 Porttitor St.","Tranås","MD"),
    (DEFAULT,"Herman","Richardson","9591545123","57255","Ap #168-2280 Luctus Av.","Ananindeua","VT"),
    (DEFAULT,"Hayes","Austin","1443682641","39410","825-7791 Risus Rd.","Lunel","KS"),
    (DEFAULT,"Curran","Ferguson","1224202675","70156","353-4640 Adipiscing Av.","Rossignol","MT"),
    (DEFAULT,"Hedley","Farrell","4181789167","78705","Ap #404-6501 Vivamus Road","Ilesa","CT"),
    (DEFAULT,"Marshall","Schroeder","6937246221","33939","9822 Vel Ave","Uddevalla","MT"),
    (DEFAULT,"Ramona","Frazier","5372223041","26117","Ap #995-1810 Auctor Avenue","Kurram Agency","MS"),
    (DEFAULT,"Sharon","Ware","7325137464","56835","499-2982 Dolor Avenue","Sotteville-lès-Rouen","KS"),
    (DEFAULT,"Melyssa","Olsen","1527112678","01795","Ap #841-1687 Fusce Ave","Banda Aceh","NV"),
    (DEFAULT,"Aristotle","Mooney","8425734234","63672","787-8102 Sagittis Ave","Belfast","KS"),
    (DEFAULT,"Natalie","Parks","2756368652","30932","Ap #159-6160 Massa. Av.","Thames","IA"),
    (DEFAULT,"Lucian","Strong","4144793528","83991","166-2001 Lorem, St.","Larkana","MS"),
    (DEFAULT,"Salvador","Webb","8899758853","36139","Ap #496-973 Lacus, St.","Monte San Giovanni in Sabina","MI"),
    (DEFAULT,"Phelan","Salinas","7652428785","37615","8276 Pede. St.","Orosei","GA"),
    (DEFAULT,"Aidan","Mcbride","1934321302","87696","Ap #529-3851 Sem, St.","Illapel","KS"),
    (DEFAULT,"Germane","Foreman","5657770818","87867","664-6792 Iaculis Street","Sanghar","VA"),
    (DEFAULT,"Nadine","Simon","6134299219","12952","298-9727 Tincidunt. Ave","Dublin","TN");
    
/*
  1500 <= year_made <= 1999
  1 <= style_id <= 7
  1 <= material_id <= 3
  1 <= width, height <= 100
  1 <= cost <= 1000
  1 <= markup <= 500
  2000-1-1 <= acquired_on <= 2009-12-31
*/
INSERT INTO rugs (made_in, year_made, style, material, width, height, cost, markup, acquired_on)
  VALUES
    ("Iran",1948,2,2,10,22,818,148,"2000-9-12"),
    ("Turkey",1935,5,3,51,22,714,467,"2000-12-3"),
    ("Turkey",1954,6,1,61,63,746,254,"2004-5-21"),
    ("India",1904,4,2,54,54,418,425,"2008-3-15"),
    ("Turkey",1911,4,1,3,2,640,405,"2007-11-21"),
    ("Turkey",1986,4,2,41,40,786,16,"2001-3-9"),
    ("Iran",1995,2,3,76,38,215,437,"2008-8-9"),
    ("Iran",1941,4,3,11,66,138,440,"2000-4-29"),
    ("Iran",1911,4,3,97,69,292,84,"2004-12-13"),
    ("Afghanistan",1961,5,3,5,82,256,193,"2001-5-1"),
    ("Afghanistan",1943,6,1,50,94,251,4,"2009-4-27"),
    ("Iran",1909,4,2,2,4,87,352,"2000-12-6"),
    ("Turkey",1984,6,1,44,74,985,3,"2009-7-17"),
    ("Afghanistan",1919,4,2,8,42,74,225,"2005-9-7"),
    ("Afghanistan",1959,6,2,63,81,492,295,"2007-10-6"),
    ("Afghanistan",1986,1,3,5,17,762,63,"2006-6-4"),
    ("Afghanistan",1993,7,3,94,17,331,391,"2008-4-2"),
    ("India",1943,4,2,22,64,814,108,"2008-1-23"),
    ("Afghanistan",1963,4,2,28,80,274,63,"2005-2-3"),
    ("Afghanistan",1958,7,3,44,87,33,499,"2009-7-16"),
    ("Afghanistan",1966,4,2,67,3,422,312,"2000-2-25"),
    ("Afghanistan",1942,3,1,35,75,220,60,"2009-3-17"),
    ("Afghanistan",1958,7,1,3,43,379,362,"2008-11-1"),
    ("Afghanistan",1924,3,1,38,36,775,24,"2000-2-8"),
    ("Turkey",1970,3,2,2,34,856,86,"2006-10-15"),
    ("India",1923,7,1,21,99,393,418,"2003-9-14"),
    ("India",1912,4,2,69,58,730,105,"2001-6-22"),
    ("Turkey",1938,2,3,30,54,107,372,"2000-8-28"),
    ("Iran",1967,5,2,10,91,774,41,"2002-8-4"),
    ("India",1985,7,2,65,77,659,243,"2002-4-23");

/*
  1 <= customer_id <= 30
  1 <= rug_id <= 15
  1 <= price <= 1000
  2010-1-1 <= sold_on < 2020-12-31
*/
INSERT INTO sales (customer_id, rug_id, price, sold_on)
  VALUES
    (5,5,240,"2012-6-7"),
    (28,11,935,"2020-1-22"),
    (9,1,719,"2015-1-9"),
    (23,9,111,"2014-8-8"),
    (27,9,113,"2016-11-4"),
    (21,10,320,"2012-2-19"),
    (11,8,376,"2014-3-16"),
    (27,3,453,"2019-4-1"),
    (16,5,601,"2011-2-7"),
    (15,14,588,"2020-6-14");
/*
  1 <= customer_id <= 30
  16 <= rug_id <= 30
  1 <= price <= 1000
  2010-1-1 <= sold_on < 2020-12-31
*/
INSERT INTO rentals (customer_id, rug_id, rented_on)
  VALUES
    (22,23,"2020-5-3"),
    (13,25,"2012-2-22"),
    (3,23,"2015-5-23"),
    (29,21,"2012-5-15"),
    (29,27,"2015-10-14"),
    (3,19,"2017-10-1"),
    (6,30,"2012-9-22"),
    (3,29,"2011-9-25"),
    (1,22,"2020-12-15"),
    (13,28,"2018-6-9");