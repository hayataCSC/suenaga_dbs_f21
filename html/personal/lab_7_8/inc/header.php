<!DOCTYPE html>
<html lang="en">
<head>
  <title>Lab 7</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
  <?php if(isset($_COOKIE['mode']) && $_COOKIE['mode'] === 'dark'): ?>
    <link rel="stylesheet" href="/personal/lab_7_8/dark.css">
  <?php endif; ?>
</head>
<body>
  <header class="d-flex flex-wrap justify-content-center px-5 py-3 mb-4 border-bottom">
    <a href="manageInstruments.php" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
      <span class="fs-4">Lab7</span>
    </a>
  </header>
  <div class="container">
    <?php if(isset($_COOKIE['mode']) && $_COOKIE['mode'] === 'dark'): ?>
      <h4>Currently on Dark Mode</h4>
      <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
        <button class="btn btn-primary" type="submit" name="operation" value="set_light_mode">Change to Light Mode</button>
      </form>
    <?php else: ?>
      <h4>Currently on Light Mode</h4>
      <form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
        <button class="btn btn-primary" type="submit" name="operation" value="set_dark_mode">Change to Dark Mode</button>
      </form>
    <?php endif; ?>
