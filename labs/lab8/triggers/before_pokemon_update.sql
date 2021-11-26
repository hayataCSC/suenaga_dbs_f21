DELIMITER $$

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