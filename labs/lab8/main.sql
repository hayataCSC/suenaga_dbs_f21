DROP DATABASE IF EXISTS pokemon_trading;
CREATE DATABASE pokemon_trading;

USE pokemon_trading;

SOURCE tables.sql;

SOURCE functions/get_trainer_id_for_pokemon.sql;
SOURCE functions/is_in_party.sql;
SOURCE functions/get_party_size.sql;

SOURCE triggers/before_pokemon_insert.sql;
SOURCE triggers/before_pokemon_update.sql;

SOURCE procedures/change_trainer_of_pokemon.sql;
SOURCE procedures/trade_pokemons.sql;
SOURCE procedures/delete_trainer_and_pokemons.sql;

SOURCE sample_data.sql;

SOURCE test_scripts.sql;