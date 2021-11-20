<?php
    /* Configure the error level */
    require('./config/error.php');
    /* Get the connect function */
    require('./config/db.php');
    /* Connect to the instrument_rentals table */
    $conn = connect('instrument_rentals');
    /* Get all rows from the instrument table */
    $query = "SELECT * FROM instruments";
    $result = $conn->query($query);
    if (!$result) die ($conn->error);
    $instruments = $result->fetch_all(MYSQLI_ASSOC);

    switch ($_POST['operation'] ?? 'get_all') {
      case 'delete_selected_rows':
        /* Query for deleting a specified instrument */
        $query = "DELETE FROM instruments WHERE instrument_id = ?";
        /* Iterate over all instruments in the instruments table */
        foreach($instruments as $instrument) {
          /* Get the id of the instrument being iterated */
          $id = $instrument['instrument_id'];
          /* Check if the instrument is requested to be deleted */
          if (isset($_POST["checkbox$id"])) {
            $stmt = $conn->prepare($query);
            $stmt->bind_param('i', $id);
            if (!$stmt->execute()) die($conn->error);
          }
        }
        /* Redirect the user to the original url */
        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'add': /* Add new data entries */
        $query = "INSERT INTO instruments (instrument_type)
          VALUES ('Guitar'),
          ('Trumpet'),
          ('Flute'),
          ('Theremin'),
          ('Violin'),
          ('Tuba'),
          ('Melodica'),
          ('Trombone'),
          ('Keyboard');";
        if (!$conn->query($query)) die($conn->error);
        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'delete_all': /* Delete all rows from the instrument table */
        $query = 'DELETE FROM instruments';
        if (!$conn->query($query)) die ($conn->error);
        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      default: break;
    }

    $fields = $result->fetch_fields();
    $fields = array_map(function ($field) { return $field->name; }, $fields);
    $conn->close();
?>

<?php require('./inc/header.php') ?>

<form id="delete_selection" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
  <table class="table">
    <thead>
      <tr>
        <th>Delete</th>
        <?php foreach($fields as $field): ?>
          <th><?php echo $field; ?></th>
        <?php endforeach; ?>
      </tr>
    </thead>
    <tbody>
      <?php foreach($instruments as $instrument): ?>
        <tr>
          <td>
            <input type="checkbox" name="<?php echo 'checkbox' . $instrument['instrument_id']; ?>" value="checked" />
          </td>
          <?php foreach($instrument as $key=>$value): ?>
            <td><?php echo $value; ?></td>
          <?php endforeach; ?>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</form>
<div class="row">
  <div class="col-sm" align="center">
    <button class="btn btn-outline-danger" form="delete_selection" type="submit" name="operation" value="delete_selected_rows">Delete selected instruments</button>
  </div>
  <div class="col-sm" align="center">
    <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method=POST>
      <button class="btn btn-primary" type="submit" name="operation" value="add">Add sample records</button>
    </form>
  </div>
  <div class="col-sm" align="center">
    <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method=POST>
      <button class="btn btn-danger" type="submit" name="operation" value="delete_all">Delete all records</button>
    </form>
  </div>
</div>