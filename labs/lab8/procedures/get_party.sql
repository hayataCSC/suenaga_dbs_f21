-- WB: This is not very useful; procedures are meant to perform actions, or at least
-- WB: set the values of OUT parameters. If you just want to display the party of a 
-- WB: specific trainer; I would define a view, and filter for the trainer you are interested in
DELIMITER $$

CREATE PROCEDURE get_party
(
  trainer_id INT
)
BEGIN
SELECT *
  FROM pokemon p
  WHERE p.trainer_id = trainer_id AND p.in_party;
END $$

DELIMITER ;