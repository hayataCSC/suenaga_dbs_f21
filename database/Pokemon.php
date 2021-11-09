<?php

  class Pokemon {
    public $name;
    public $species;
    public $trainer_id;
    public $level;
    public $is_female;

    public function __construct($name, $species, $trainer_id, $level, $is_female) {
      $this->name = $name;
      $this->species = $species;
      $this->trainer_id = $trainer_id;
      $this->level = $level;
      $this->is_female = $is_female;
    }
  }

  function generatePokemons($speciesArray) {
    $pokemons = [];

    /* Get an array of random names */
    $names = file(__DIR__ . '/sample_data/names_2.txt');
    $getFirstName = function(string $line) : string {
      return explode(' ', $line)[0];
    };
    $names = array_map($getFirstName, $names);

    /* Generate an array of trainer ids and shuffle it */
    $trainerIds = array_merge(range(1, 100), range(1, 100));
    shuffle($trainerIds);

    for ($i = 0; $i < 100; $i += 1) {
      /* Get a random species */
      $species = $speciesArray[rand(0, count($speciesArray) - 1)]['Name'];
      /* Get a random level */
      $level = rand(1, 100);
      /* Get a random boolean value */
      $is_female = (bool)rand(0, 1);
      /* Create a new pokemon */
      $pokemon = new Pokemon($names[$i], $species, array_pop($trainerIds), $level, $is_female);
      /* Append the new pokemon to the pokemon array */
      array_push($pokemons, $pokemon);
    }

    return $pokemons;
  }

?>