DELIMITER $$

/* Trigger that checks for the maximum party size before insertion of a new pokemon */
CREATE TRIGGER before_pokemon_insert
BEFORE INSERT ON pokemon
FOR EACH ROW
BEGIN
/* If new pokemon is added to a party, check for the maximum party size */
IF (NEW.in_party) THEN
  /* If currently the party is full, raise an error */
  IF (get_party_size(NEW.trainer_id) >= 6) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only up to 6 pokemons can be in a trainer\' party at a time';
  END IF;
END IF;
END $$

DELIMITER ;