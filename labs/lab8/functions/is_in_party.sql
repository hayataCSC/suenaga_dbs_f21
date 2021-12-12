DELIMITER $$

/* Function that returns a boolean indicating whether the specified pokemon is
 * in a party */
CREATE FUNCTION is_in_party
(
  pokemon_id INT
)
RETURNS BOOLEAN
/* Whether a pokemon is in a party or not can differ across queries */
-- WB: DETERMINISTIC refers to side effects, functions are typically deterministic, because 
-- WB: they don't change anything about the database.
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

DELIMITER ;