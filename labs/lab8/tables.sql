/* Create trainer table */
CREATE TABLE trainer (
  PRIMARY KEY (id),
  id INT AUTO_INCREMENT,
  name VARCHAR(255)
);

/* Create species table */
CREATE TABLE species (
  PRIMARY KEY (name),
  name VARCHAR(255)
);

/* Create pokemon table. Since the relationship between
 * pokemons and trainers is not many-to-many, a linking table
 * is not necessary to represent that relationship */
CREATE TABLE pokemon (
  PRIMARY KEY (id),
  id INT AUTO_INCREMENT,
  species_name VARCHAR(255),
  trainer_id INT,
  /* Column that shows if the pokemon is in party or not */
  in_party BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (trainer_id)
    REFERENCES trainer(id)
    ON DELETE RESTRICT,
  FOREIGN KEY (species_name)
    REFERENCES species(name)
);