<?php
    /* Configure the error level */
    require('./config/error.php');
    /* Configure the timeout for sessions. Set the max lifetime to 30 min */
    ini_set('session.gc_maxlifetime', 60 * 30);
    /* Start a session */
    session_start();
    /* Get the connect function */
    require('./config/db.php');
    /* Connect to the instrument_rentals table */
    $conn = connect('instrument_rentals');
    /* Get all rows from the instrument table */
    $query = "SELECT * FROM instruments";
    $result = $conn->query($query);
    if (!$result) die ($conn->error);
    $instruments = $result->fetch_all(MYSQLI_ASSOC);

    //TODO: Account for the usual get request 
    switch ($_POST['operation'] ?? 'get_all') {
      case 'delete_selected_rows':
        /* Query for deleting a specified instrument */
        $query = "DELETE FROM instruments WHERE instrument_id = ?";
        /* Declare a variable for counting the number of records to be deleted */
        $num_of_deleted_records = 0;
        /* Iterate over all instruments in the instruments table */
        foreach($instruments as $instrument) {
          /* Get the id of the instrument being iterated */
          $id = $instrument['instrument_id'];
          /* Check if the instrument is requested to be deleted */
          if (isset($_POST["checkbox$id"])) {
            $stmt = $conn->prepare($query);
            $stmt->bind_param('i', $id);
            if (!$stmt->execute()) die($conn->error);
            /* Increment the number of records deleted */
            $num_of_deleted_records += 1;
          }
        }
        /* Add the number of records deleted to the count session variable */
        $_SESSION['del_count'] += $num_of_deleted_records;
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
        /* Get the number of instruments currently on database.
         * This number is addd to the session variable that keeps trakc of
         * the number of recorded deleted */
        $query = 'SELECT count(*) FROM instruments';
        $result = $conn->query($query);
        if (!$result) die($conn->error);
        $count = $result->fetch_all(MYSQLI_NUM)[0][0];

        /* Update the session variable for the count if a user is logged in */
        if (isset($_SESSION['del_count']))
          $_SESSION['del_count'] += $count;

        /* Delete all instruments from the database */
        $query = 'DELETE FROM instruments';
        if (!$conn->query($query)) die ($conn->error);

        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'sign_in':
        /* Get the user name from the request */
        $user_name = $_POST['user_name'];
        /* Set the count variable for the new user to zero */
        $_SESSION['user_name'] = $user_name;
        $_SESSION['del_count'] = 0;

        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'sing_out':
        /* Remove the count variable for the requested user */
        unset($_SESSION['user_name']);
        unset($_SESSION['del_count']);

        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'set_light_mode':
        /* Set the mode cookie variable to light.
         * Set the expiration time to the  maximum epoch time - 1
         * Epoch time is a 4 byte signed integer (32 bit + signed bit) */
        setcookie('mode', 'light', 2^31 - 1);

        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      case 'set_dark_mode';
        /* Send the mode cookie variable to dark */
        setcookie('mode', 'dark');

        header("Location: {$_SERVER['PHP_SELF']}", true, 303);
        exit();

      default: break;
    }

    $fields = $result->fetch_fields();
    $fields = array_map(function ($field) { return $field->name; }, $fields);
    $conn->close();
?>

<!-- Import the header --->
<?php require('./inc/header.php') ?>

<?php if(!isset($_SESSION['user_name'])): ?>
  <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
    <div class="form-group">
      <label>Your name</label>
      <input type="text" class="form-control" name="user_name" />
    </div>
    <button type="submit" class="btn btn-primary" name="operation" value="sign_in">Sign in</button>
  </form>
<?php else: ?>
  <h3><?php echo 'Welcome, ' . htmlentities($_SESSION['user_name']) . '!'; ?></h3>
  <p><?php echo "You have deleted {$_SESSION['del_count']} records"; ?></p>
  <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
    <button type="submit" class="btn btn-primary" name="operation" value="sing_out">Sign out</button>
  </form>
<?php endif; ?>

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