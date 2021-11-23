<?php

  /* Check if the query parameter is set */
  if (!isset($_GET['database']) || !isset($_GET['table']))
    die("You need to specify the name of the database and table in the query parameter\n");
  /* Configure error output level */
  require('./config/error.php');
  /* Import the connect function from db.php */
  require('./config/db.php');
  /* Connect to the requested database */
  $conn = connect($_GET['database']);

  /* Get and sanitize the table name */
  $table = $conn->real_escape_string($_GET['table']);

  /* Set all rows with all columns from the specified tables */
  $query = "SELECT * FROM $table";
  /* Prepare and bind the statement */
  $result = $conn->query($query);
  /* Handle query error */
  if (!$result) die($conn->error);
  /* Get fields */
  $fields = $result->fetch_fields();
  /* Extract field names */
  $fields = array_map(function ($field) { return $field->name; }, $fields);
  /* Get rows, with each row as an associative array */
  $rows = $result->fetch_all(MYSQLI_ASSOC);
  /* Close the connection to the database */
  $conn->close();

?>

<?php require('./inc/header.php') ?>

<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">Add</button>

<table class="table">
  <thead>
    <tr>
      <?php foreach($fields as $field): ?>
        <th><?php echo $field ?></th>
      <?php endforeach; ?>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach($rows as $row): ?>
      <tr>
        <?php foreach($row as $key => $val): ?>
          <th><?php echo $val; ?></th>
        <?php endforeach; ?>
        <th><button class="btn btn-outline-danger">Delete</button></th>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<div class="modal fade" id="addModal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Edit Row</h5>
        <button type="button" class="close btn" data-bs-dismiss="modal">
          <span>&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="trainer-form" action="/poke_care/api/trainers.php" method="POST">
          <input type="hidden" name="id" value=<?php echo $trainer['id']; ?>>
          <div class="form-group">
            <label for="name">Full name</label>
            <input id="name" name="name" class="form-control" type="text" value="<?php echo $trainer['name']; ?>" required>
          </div>
          <div class="form-group">
            <label for="phone">Phone number</label>
            <input id="phone" name="phone" class="form-control" type="tel" value="<?php echo $trainer['phone']; ?>" required>
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input id="emial" name="email" class="form-control" type="email" value="<?php  echo $trainer['email']; ?>" required>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <input type="submit" form="trainer-form" class="btn btn-primary" />
      </div>
    </div>
  </div>
</div>

<?php require('./inc/footer.php') ?>