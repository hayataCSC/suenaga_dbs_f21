DELIMITER $$

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

DELIMITER ;