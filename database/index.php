<?php
  $conn = new mysqli('localhost', 'hayata_suenaga', 'password');
  /* Connect to the database */
  if ($conn->connect_errno) die($conn->connect_error . "\n");
  /* Select database */
  if (!$conn->query('USE pokemon')) die($conn->error . "\n");
  
  /* Import GenerateTrainer class from Trainer.php */
  require(__DIR__ . '/Trainer.php');
  /* Generate the array of trainers */
  $trainerGenerator = new TrainerGenerator();
  $trainers = $trainerGenerator->getTrainers();
  /* Insert each trainer to the trainer table */
  foreach ($trainers as $trainer) {
    $query = "INSERT INTO trainer(name, phone, email)
      VALUES (\"{$trainer->name}\", \"{$trainer->phone}\", \"{$trainer->email}\");";
    if (!$conn->query($query)) die($conn->error . "\n");
  }

  /* Import getTypes from Type.php */
  require(__DIR__ . '/Type.php');
  /* Get the array of pokemon types */
  $types = getTypes();
  /* Insert each type to the type table */
  foreach ($types as $type) {
    $query = "INSERT INTO type(name) VALUES (\"{$type}\");";
    if (!$conn->query($query)) die($conn->error . "\n");
  }

  /* Import getSpecies from Species.php */
  require(__DIR__ . '/Species.php');
  /* Get the array of species */
  $species = getSpecies();
  /* Insert each species to the species table */
  foreach ($species as $item) {
    insertSpecies($conn, $item['Name'], $item['Type 1']);
    /* If there is a second type for the species, add another entry */
    if ($item['Type 2'] !== "") {
      insertSpecies($conn, $item['Name'], $item['Type 2']);
    }
  }
  /* Helper func for constructing the query to insert species */
  function insertSpecies($conn, $name, $type) {
    $query = "INSERT INTO species(name, type)
      VALUES (\"{$name}\", \"{$type}\");";
    if (!$conn->query($query)) die($conn->error . "\n");
  }

  /* Import generatePokemons form Pokemon.php */
  require(__DIR__ . '/Pokemon.php');
  $pokemons = generatePokemons($species);

  /* Insert each species to the species table */
  foreach ($pokemons as $pokemon) {
    $is_female = $pokemon->is_female ? 'True' : 'False';

    $query = "INSERT INTO pokemon(name, species, trainer_id, level, is_female)
      VALUES (\"{$pokemon->name}\",
        \"{$pokemon->species}\",
        {$pokemon->trainer_id},
        {$pokemon->level},
        {$is_female})";

    if (!$conn->query($query)) die($conn->error . "\n");
  }
  
?>