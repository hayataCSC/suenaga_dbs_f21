<?php

  function getTypes() {
    $handle = fopen(__DIR__ . '/sample_data/types.txt', 'r');
    if (!$handle) die("Failed to open types.txt\n");

    $types = [];
    while ($line = fgets($handle)) {
      array_push($types, str_replace(PHP_EOL, '', $line));
    }
    return $types;
  }

?>