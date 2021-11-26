/* Try to trade pokemon #1 (that is in a party) with pokemon #14 (that is not in a party).
 * Should error with the message: "Both pokemons need to be in parties to be traded"  */
CALL trade_pokemons(1, 14);

/* Try to trade pokemons owned by the same trainer (trainer #1).
 * Should error with the message: "Pokemons belonging to the same trainer cannot be traded" */
CALL trade_pokemons(1, 2);

/* Try to insert a pokemon that is to be in a party when the trainer's party size is already 6.
 * Should error with the message: "Only up to 6 pokemons can be in a trainer' party at a time" */
INSERT INTO pokemon(species_name, trainer_id, in_party)
  VALUES('Butterfree', 2, TRUE);

/* Try to move a pokemon to a party when the trainer's pary is already full.
 * Should error with the message: "Only up to 6 pokemons can be in a trainer' party at a time" */
UPDATE pokemon
  SET in_party=TRUE
  WHERE id=14;