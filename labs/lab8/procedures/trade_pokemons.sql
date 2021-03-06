DELIMITER $$

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
    /* Temporarily remove both pokemons from parties so that the transaction does not error
     * for the illegal party size (which might happen on update of a pokemon's trainer id) */
    CALL update_party_status(pokemon_1_id, FALSE);
    CALL update_party_status(pokemon_2_id, FALSE);
    /* Update the trainer id of both pokemons */
    CALL change_trainer_of_pokemon(pokemon_1_id, trainer_2_id);
    CALL change_trainer_of_pokemon(pokemon_2_id, trainer_1_id);
    /* Move back both pokemons to parties */
    CALL update_party_status(pokemon_1_id, TRUE);
    CALL update_party_status(pokemon_2_id, TRUE);
  COMMIT;
END $$

DELIMITER ;