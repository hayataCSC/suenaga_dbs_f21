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