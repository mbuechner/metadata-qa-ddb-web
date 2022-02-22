<?php

class IssuesDB extends SQLite3 {
  private $db;

  function __construct($dir) {
    $file = $dir . '/qa.sqlite';
    $this->open($file);
  }

  public function getIssues($field, $value, $offset = 0, $limit = 10) {
    $default_order = 'recordid';
    $stmt = $this->prepare('SELECT *
       FROM issue
       WHERE `' . $field . '` = :value
       ORDER BY ' . $default_order . ' 
       LIMIT :limit
       OFFSET :offset
    ');
    $stmt->bindValue(':value', $value, SQLITE3_TEXT);
    $stmt->bindValue(':offset', $offset, SQLITE3_INTEGER);
    $stmt->bindValue(':limit', $limit, SQLITE3_INTEGER);

    return $stmt->execute();
  }

  public function getIssuesById($id) {
    $default_order = 'recordid';
    $stmt = $this->prepare('SELECT * FROM issue WHERE recordId = :value');
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    return $stmt->execute();
  }

  public function countIssues($field, $value) {
    $default_order = 'recordid';
    $stmt = $this->prepare('SELECT count(*) AS count
       FROM issue
       WHERE `' . $field . '` = :value
    ');
    $stmt->bindValue(':value', $value, SQLITE3_TEXT);

    return $stmt->execute();
  }

  public function getRecord($id) {
    $stmt = $this->prepare('SELECT xml FROM record WHERE id = :value');
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    return $stmt->execute();
  }
}