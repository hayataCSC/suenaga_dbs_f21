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

DELIMITER ;