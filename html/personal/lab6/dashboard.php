<?php

  /* Configure the error output level */
  require('./config/error.php');
  /* Import the connect function from db.php */
  require('./config/db.php');
  /* Connect to database */
  $conn = connect(null);

  /* Fetch the list of databases */
  $query = 'SHOW DATABASES;';
  $result = $conn->query($query);
  /* Handle query error */
  if (!$result) die(mysqli_error($conn));
  /* Get the array of rows in the database table,
   * with each row as a numeric array */
  $databases = $result->fetch_all(MYSQLI_NUM);
  
  /* Close the connection to the database */
  $conn->close();
?>

<!-- Import the header --->
<?php require('./inc/header.php'); ?>

<div style="margin-top: 5rem;">
  <h3>List of Databases</h3>
  <p><?php echo 'Number of databases: ' . count($databases) ?></p>
  <ul class="list-group">
    <?php foreach($databases as $db) : ?>
      <li class="list-group-item">
        <a href=<?php echo './details.php?database=' . $db[0]; ?>>
          <?php echo $db[0]; ?>
        </a>
      </li>
    <?php endforeach; ?>
  </ul>
</div>
<hr>
<div>
  <h4>See details infomation about a database</h4>
  <form action="details.php" method="GET">
    <div class="mb-3">
      <label for="database" class="form-label">Database Name</label>
      <input id="database" class="form-control" type="text" name="database" required>
    </div>
    <div>
      <input type="submit" value="See details" class="btn btn-primary">
    </div>
  </form>
</div>

<!-- Import the footer --->
<?php require('./inc/footer.php'); ?>