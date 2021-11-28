DELIMITER $$

/* Procedure for setting a pokemon's party status (in party or not) */
CREATE PROCEDURE update_party_status
(
  pokemon_id INT,
  party_status BOOLEAN
)
BEGIN
UPDATE pokemon
  SET in_party = party_status
  WHERE id = pokemon_id;
END $$

DELIMITER ;