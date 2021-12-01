<?php

  /* Check if the query parameter is set */
  if (!isset($_GET['database']))
    die("You need to specify the name of the database in the query parameter\n");
  /* Configure error output level */
  require('./config/error.php');
  /* Import the connect function from db.php */
  require('./config/db.php');
  /* Connect to the requested database */
  $conn = connect($_GET['database']);

  /* Get the list of tables */
  $result = $conn->query('SHOW TABLES;');
  /* Handle query error */
  if (!$result) die(mysqli_error($conn) . "\n");
  /* Get list of tables as an associative array */
  $tables = $result->fetch_all(MYSQLI_NUM);

  /* Close the connection to the database */
  $conn->close();
?>

<?php require('./inc/header.php') ?>

<a href="dashboard.php" class="btn btn-secondary">Back to Dashboard</a>

<h3 style="margin-top:3rem;">List of tables in the <?php echo ucfirst(htmlspecialchars($_GET['database'])); ?> table</h3>
<ul class="list-group">
  <?php foreach($tables as $table) : ?>
    <li class="list-group-item">
      <a href="<?php echo './table.php?database=' . $_GET['database'] . '&table=' . $table[0]; ?>">
        <?php echo $table[0] ?>
      </a>
    </li>
  <?php endforeach ?>
</ul>

<?php require('./inc/footer.php') ?>