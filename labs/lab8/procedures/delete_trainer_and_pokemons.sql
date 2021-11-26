DELIMITER $$

/* Procedure for deleting a trainer and pokemons that the trainer owns */
CREATE PROCEDURE delete_trainer_and_pokemons
(
  trainer_id INT
)
BEGIN
  /* Start a transaction. In this transaction, delete records from the
   * pokemon and trainer tables */
  START TRANSACTION;
    /* Delete all pokemons owned by the trainer.
     * Table alias cannot be used inside a delete statement.
     * Use "using" keyward to specify the table to delete and its alias */
    DELETE FROM p
      USING pokemon AS p
      WHERE p.trainer_id = trainer_id;
    /* Delete the trainer */
    DELETE FROM trainer
      WHERE id = trainer_id;
  COMMIT;
END $$

DELIMITER ;