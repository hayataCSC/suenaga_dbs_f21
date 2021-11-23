<?php

  function connect($database) {
    /* Get database credentials */
    $config = parse_ini_file(__DIR__ . '/../../../../mysql.ini');

    /* Connect to the specified database */
    $conn = new Mysqli(
      $config['mysqli.default_host'],
      $config['mysqli.admin_user'],
      $config['mysqli.admin_pw'],
      $database);

    /* Handle connection error */
    if ($conn->connect_errno)
      die("$conn->connection_errno: $conn->connection_error\n");

    /* Return the connection object */
    return $conn;
  }

?>