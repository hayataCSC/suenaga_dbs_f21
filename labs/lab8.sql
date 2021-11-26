DROP DATABASE IF EXISTS pokemon_trading;
CREATE DATABASE pokemon_trading;

USE pokemon_trading;

/* Create trainer table */
CREATE TABLE trainer (
  PRIMARY KEY (id),
  id INT AUTO_INCREMENT,
  name VARCHAR(255)
);

/* Create species table */
CREATE TABLE species (
  PRIMARY KEY (name),
  name VARCHAR(255)
);

/* Create pokemon table. Since the relationship between
 * pokemons and trainers is not many-to-many, a linking table
 * is not necessary to represent that relationship */
CREATE TABLE pokemon (
  PRIMARY KEY (id),
  id INT AUTO_INCREMENT,
  species_name VARCHAR(255),
  trainer_id INT,
  /* Column that shows if the pokemon is in party or not */
  in_party BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (trainer_id)
    REFERENCES trainer(id),
  FOREIGN KEY (species_name)
    REFERENCES species(name)
);

/* Insert sample trainer data into the trainer table */
INSERT INTO trainer(name)
VALUES ('Will'),
       ('Koga'),
       ('Bruno'),
       ('Lance');

/* Insert sample species data into the species table */
INSERT INTO species(name)
VALUES ('Pikachu'),
       ('Charmander'),
       ('Bulbasuar'),
       ('Squirtle'),
       ('Geodude'),
       ('Magikarp'),
       ('Weedle'),
       ('Butterfree');

/* Insert sample pokemon data into the pokemon table */
INSERT INTO pokemon(trainer_id, species_name, in_party)
VALUES (1, 'Pikachu', 1),
       (1, 'Charmander', 1),
       (1, 'Bulbasuar', 1),
       (1, 'Squirtle', 1),
       (1, 'Geodude', 0),
       (1, 'Magikarp', 0),
       (1, 'Weedle', 0),
       (2, 'Pikachu', 1),
       (2, 'Charmander', 1),
       (2, 'Bulbasuar', 1),
       (2, 'Squirtle', 1),
       (2, 'Geodude', 1),
       (2, 'Magikarp', 1),
       (2, 'Weedle', 0);

/* Get the trainer_id of the pokemon_1.
Get the trainer of pokemon_2.
Remember trainer_id of pokemon_1
Set the trainer_id of pokemon_1 to traie */

DELIMITER $$

/* Function that returns the trainer_id for a specified pokemon */
CREATE FUNCTION get_trainer_id_for_pokemon
(
  pokemon_id INT
)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE trainer_id INT;
    
  SELECT p.trainer_id INTO trainer_id
  FROM pokemon p
  WHERE id = pokemon_id;
  
  RETURN trainer_id;
END $$

/* Procedure for updating the trainer_id for a specified pokemon */
CREATE PROCEDURE change_trainer_of_pokemon
(
  pokemon_id INT,
  new_trainer_id INT
)
BEGIN
  UPDATE pokemon
  SET trainer_id = new_trainer_id
  WHERE id = pokemon_id;
END $$

/* Function that returns a boolean indicating whether the specified pokemon is
 * in a party */
CREATE FUNCTION is_in_party
(
  pokemon_id INT
)
RETURNS BOOLEAN
/* Whether a pokemon is in a party or not can differ across queries */
NOT DETERMINISTIC
BEGIN
  /* Create a local variable that stores a boolean */
  DECLARE is_in_party BOOLEAN;

  /* Select the in_party field from the pokemon table
   * and store it in the local variable */
  SELECT in_party
    INTO is_in_party
    FROM pokemon
    WHERE id = pokemon_id;

  RETURN is_in_party;
END $$

/* Procedure for trading pokemons between two trainers */
CREATE PROCEDURE trade_pokemons
(
  pokemon_1_id INT,
  pokemon_2_id INT
)
BEGIN
  /* Create variables for keeping trainer ids */
  DECLARE trainer_1_id INT;
  DECLARE trainer_2_id INT;

  /* Check if both pokemons are in parties */
  IF (NOT is_in_party(pokemon_1_id) OR NOT is_in_party(pokemon_2_id)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Both pokemons need to be in parties to be traded';
  END IF;

  /* Get the trainer id for each pokemon */
  SET trainer_1_id = get_trainer_id_for_pokemon(pokemon_1_id);
  SET trainer_2_id = get_trainer_id_for_pokemon(pokemon_2_id);

  /* Check if pokemons belong to the same trainer. If they do, raise an error */
  IF trainer_1_id = trainer_2_id THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pokemons belonging to the same trainer cannot be traded';
  END IF;

  /* Start a transaction that changes the tainer id in both pokemon records */
  START TRANSACTION;
    CALL change_trainer_of_pokemon(pokemon_1_id, trainer_2_id);
    CALL change_trainer_of_pokemon(pokemon_2_id, trainer_1_id);
  COMMIT;
END $$

/* Function to get a total number of pokemon in a trainer's party */
CREATE FUNCTION get_party_size
(
  trainer_id INT
)
RETURNS INT
/* Party size can vary across queries */
NOT DETERMINISTIC
BEGIN
  /* Use session variable to store the party size */
  SELECT count(*) into @count
    FROM pokemon p
    WHERE p.trainer_id = trainer_id AND p.in_party
    GROUP BY p.trainer_id;
  /* Return the party size */
  RETURN @count;
END $$

/* Trigger that checks for the maximum party size before insertion of a new pokemon */
CREATE TRIGGER before_pokemon_insert
BEFORE INSERT ON pokemon
FOR EACH ROW
BEGIN
/* If new pokemon is added to a party, check for the maximum party size */
IF (NEW.in_party) THEN
  /* If currently the party is full, raise an error */
  IF (get_party_size(NEW.trainer_id) >= 6) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only up to 6 pokemons can be at a trainer\' party at a time';
  END IF;
END IF;
END $$

/* Trigger that checks for the maxium party size before update of an existing pokemon */
CREATE TRIGGER before_pokemon_update
BEFORE UPDATE ON pokemon
FOR EACH ROW
BEGIN
/* If the updated pokemon is to be in a party, check for the maximum party size */
IF (NEW.in_party) THEN
  IF (get_party_size(NEW.trainer_id) >= 6) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only up to 6 pokemons can be at a trainer\' party at a time';
  END IF;
END IF;
END $$

DELIMITER ;