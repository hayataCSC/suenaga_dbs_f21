DELIMITER $$

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

DELIMITER ;