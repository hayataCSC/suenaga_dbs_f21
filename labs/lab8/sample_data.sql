/* Insert sample trainer data into the trainer table */
INSERT INTO trainer(name)
VALUES ('Will'),
       ('Koga'),
       ('Bruno'),
       ('Lance');

/* Insert sample species data into the species table */
INSERT INTO species(name)
VALUES ('Pikachu'),
       ('Charmander'),
       ('Bulbasuar'),
       ('Squirtle'),
       ('Geodude'),
       ('Magikarp'),
       ('Weedle'),
       ('Butterfree');

/* Insert sample pokemon data into the pokemon table */
INSERT INTO pokemon(trainer_id, species_name, in_party)
VALUES (1, 'Pikachu', 1),
       (1, 'Charmander', 1),
       (1, 'Bulbasuar', 1),
       (1, 'Squirtle', 1),
       (1, 'Geodude', 0),
       (1, 'Magikarp', 0),
       (1, 'Weedle', 0),
       (2, 'Pikachu', 1),
       (2, 'Charmander', 1),
       (2, 'Bulbasuar', 1),
       (2, 'Squirtle', 1),
       (2, 'Geodude', 1),
       (2, 'Magikarp', 1),
       (2, 'Weedle', 0);