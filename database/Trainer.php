<?php

  class Trainer {
    public $name;
    public $phone;
    public $email;

    public function __construct($name, $phone, $email) {
      $this->name = $name;
      $this->phone = $phone;
      $this->email = $email;
    }
  }

  class TrainerGenerator {
    private static $chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    private static $charLength = 36;
    private static $NAME_FILE = __DIR__ . '/sample_data/names_1.txt';

    private $trainers = [];

    public function __construct() {
      $names = self::generateNames();
      $emails = self::generateEmails();
      $phoneNums = self::generatePhoneNums();

      for ($i = 0; $i < 100; $i += 1) {
        array_push($this->trainers, new Trainer($names[$i], $phoneNums[$i], $emails[$i]));
      }
    }

    public function getTrainers() {
      return $this->trainers;
    }

    private static function generateNames() {
      /* Define the array to return */
      $names = [];
      /* Open the name file */
      if (!$handle = fopen(self::$NAME_FILE, 'r')) die("Failed to open the name file\n");
      /* Iterave over lines in the name file */
      while (($line = fgets($handle))) {
        /* Remove new line chars from the current line */
        $name = str_replace(PHP_EOL, '', $line);
        /* Append the name to the names array */
        array_push($names, $name);
      }
      return $names;
    }

    private static function generateEmails() {
      $emails = [];
      for ($i = 0; $i < 100; $i += 1) {
        array_push($emails, self::generateEmail());
      }
      return $emails;
    }

    private static function generatePhoneNums() {
      $phoneNums = [];
      for ($i = 0; $i < 100; $i += 1) {
        array_push($phoneNums, self::generatePhoneNum());
      }
      return $phoneNums;
    }

    private static function generateEmail() {
      $email = '';
      for ($i = 0; $i < rand(5, 15); $i += 1) {
        $email = $email . self::$chars[rand(0, self::$charLength - 1)];
      }
      return $email . '@pokemon.com';
    }

    private static function generatePhoneNum() {
      $phoneNum = '';
      for ($i = 0; $i < 10; $i += 1) {
        $phoneNum = $phoneNum . strval(rand(0, 9));
      }
      return $phoneNum;
    }
  }

?>