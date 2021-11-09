<?php

  function getSpecies() {
    $result = [];
    /* Open species.csv */
    $handle = fopen(__DIR__ . '/sample_data/species.csv', 'r');
    if (!$handle) die("Failed to open species.csv\n");
    /* Get column names and number of columns */
    $fields = fgetcsv($handle);
    $fieldLength = count($fields);
    /* Create an associative array for each row and push it to the result array */
    while ($row = fgetcsv($handle)) {
      $cells = [];
      for ($i = 0; $i < $fieldLength; $i += 1) {
        $cells[$fields[$i]] = $row[$i]; 
      }
      array_push($result, $cells);
    }
    return $result;
  }

?>