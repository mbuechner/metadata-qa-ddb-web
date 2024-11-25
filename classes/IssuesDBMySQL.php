<?php

class IssuesDBMySQL {
  private $db;

  function __construct($user, $password, $database, $host, $port) {
    // $this->db = new mysqli("localhost", $user, $password, $database);
    $dsn = sprintf('mysql:dbname=%s;host=%s;port=%s', $database, $host, $port);
    $this->db = new PDO($dsn, $user, $password);
  }

  public function getIssuesCount($field, $value, $op = 'eq', $schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id, FALSE, 'i.');
    $_op = $op == 'eq' ? '=' : ($op == 'lt' ? '<' : '>');
    if ($where == '') {
      $sql = 'SELECT COUNT(*) AS count
       FROM issue AS i
       WHERE `' . $field . '` ' . $_op . ' :value';
    } else {
      $sql = 'SELECT COUNT(*) AS count
        FROM issue AS i
        LEFT JOIN file_record r ON (i.recordId = r.recordId AND i.filename = r.file)
        LEFT JOIN file AS f ON (r.file = f.file)
        WHERE `' . $field . '` ' . $_op . ' :value AND ' . $where;
    }
    // error_log(cleanSql($sql));
    $stmt = $this->db->prepare($sql);
    $stmt->bindValue(':value', $value, preg_match('/:score$/', $field) ? SQLITE3_INTEGER : SQLITE3_TEXT);
    if ($where != '')
      $this->bindValues($schema, $provider_id, $set_id, $stmt);

    // error_log(cleanSql($this->getSQL($stmt)));
    $stmt->execute();
    return $stmt;
  }

  public function getIssues($field, $value, $op = 'eq', $schema = '', $provider_id = '', $set_id = '',
                            $offset = 0, $limit = 10): PDOStatement {
    $default_order = 'recordid';
    $where = $this->getWhere($schema, $provider_id, $set_id, FALSE, 'i.');
    $_op = $op == 'eq' ? '=' : ($op == 'lt' ? '<' : '>');
    if ($where == '') {
      $sql = 'SELECT i.*, f.file, f.metadata_schema, f.provider_name
       FROM issue AS i
       LEFT JOIN file_record r ON (i.recordId = r.recordId AND i.filename = r.file)
       LEFT JOIN file AS f ON (r.file = f.file)
       WHERE `' . $field . '` ' . $_op . ' :value
       ORDER BY ' . $default_order . '
       LIMIT :limit
       OFFSET :offset';
    } else {
      $sql = 'SELECT i.*, f.file, f.metadata_schema, f.provider_name
       FROM issue AS i
       LEFT JOIN file_record r ON (i.recordId = r.recordId AND i.filename = r.file)
       LEFT JOIN file AS f ON (r.file = f.file)
       WHERE `' . $field . '` ' . $_op . ' :value AND ' . $where . '
       ORDER BY ' . $default_order . ' 
       LIMIT :limit
       OFFSET :offset';
    }
    // error_log(cleanSql($sql));
    $stmt = $this->db->prepare($sql);
    $value_type = preg_match('/:score$/', $field) ? SQLITE3_INTEGER : SQLITE3_TEXT;
    $stmt->bindValue(':value', $value, $value_type);
    if ($where != '')
      $this->bindValues($schema, $provider_id, $set_id, $stmt);
    $stmt->bindValue(':offset', $offset, SQLITE3_INTEGER);
    $stmt->bindValue(':limit', $limit, SQLITE3_INTEGER);
    // error_log(cleanSql($this->getSQL($stmt)));

    $stmt->execute();
    return $stmt;
  }

  public function getIssuesByRecordId($id) {
    $default_order = 'recordid';
    $stmt = $this->db->prepare('SELECT * FROM issue WHERE recordId = :value');
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function getIssuesByFileAndRecordId($file, $id) {
    $default_order = 'recordid';
    $stmt = $this->db->prepare('SELECT * FROM issue WHERE filename = :file AND recordId = :value');
    $stmt->bindValue(':file', $file, SQLITE3_TEXT);
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function countIssues($field, $value) {
    $default_order = 'recordid';
    $stmt = $this->db->prepare('SELECT count(*) AS count
       FROM issue
       WHERE `' . $field . '` = :value
    ');
    $stmt->bindValue(':value', $value, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function getCount($schema = 'NA', $provider_id = 'NA', $set_id = 'NA') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->db->prepare('SELECT count FROM count ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function getFrequency($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->db->prepare('SELECT field, value, frequency FROM frequency ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function getVariablitily($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    $stmt = $this->db->prepare('SELECT field, number_of_values FROM variability ' . $where);
    $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function getRecord($id) {
    $stmt = $this->db->prepare('SELECT xml FROM record WHERE id = :value');
    $stmt->bindValue(':value', $id, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function listSchemas($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    if ($where == '') {
      $stmt = $this->db->prepare(
        'SELECT metadata_schema, COUNT(*) AS count FROM file '
        . ' GROUP BY metadata_schema ORDER BY metadata_schema');
    } else {
      $stmt = $this->db->prepare(
        'SELECT metadata_schema, COUNT(*) AS count FROM file AS f 
        LEFT JOIN file_record AS r ON (f.file = r.file)'
        . $where
        . ' GROUP BY metadata_schema ORDER BY metadata_schema');
    }
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($this->getSQL($stmt)));

    $stmt->execute();
    return $stmt;
  }

  public function listProviders($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    if ($where == '') {
      $stmt = $this->db->prepare(
        'SELECT provider_id AS id, provider_name AS name, COUNT(*) AS count FROM file'
        . ' GROUP BY provider_id, provider_name');
    } else {
      $stmt = $this->db->prepare(
        'SELECT provider_id AS id, provider_name AS name, COUNT(*) AS count
        FROM file AS f
        LEFT JOIN file_record AS r ON (f.file = r.file)'
        . $where
        . ' GROUP BY provider_id, provider_name');
    }
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($this->getSQL($stmt)));

    $stmt->execute();
    return $stmt;
  }

  public function listSets($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    if ($where == '') {
      $stmt = $this->db->prepare(
        'SELECT set_id AS id, set_name AS name, COUNT(*) AS count FROM file GROUP BY set_id, set_name');
    } else {
      $stmt = $this->db->prepare(
        'SELECT set_id AS id, set_name AS name, COUNT(*) AS count
         FROM file AS f 
         LEFT JOIN file_record AS r ON (f.file = r.file)'
        . $where
        . ' GROUP BY set_id, set_name');
    }
    $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function getFilenameByRecordId($record_id = '') {
    $stmt = $this->db->prepare('SELECT file FROM file_record WHERE recordId = :record_id');
    $stmt->bindValue(':record_id', $record_id, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function getFileDataByRecordId($file, $record_id = '') {
    $stmt = $this->db->prepare('SELECT f.* 
      FROM file_record AS r 
      JOIN file AS f ON (f.file = r.file) 
      WHERE r.file = :file AND r.recordId = :record_id');
    $stmt->bindValue(':file', $file, SQLITE3_TEXT);
    $stmt->bindValue(':record_id', $record_id, SQLITE3_TEXT);

    $stmt->execute();
    return $stmt;
  }

  public function countRecordsBySchema($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id, TRUE, 'i.');
    $stmt = $this->db->prepare('SELECT i.metadata_schema as id, COUNT(*) AS count
      FROM issue AS i
      LEFT JOIN file_record AS r ON (i.recordId = r.recordId AND i.filename = r.file)
      INNER JOIN file AS f USING (file) '
      . $where . ' GROUP BY i.metadata_schema');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($this->getSQL($stmt)));

    $stmt->execute();
    return $stmt;
  }

  public function countRecordsByProvider($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id, TRUE, 'i.');
    $stmt = $this->db->prepare('SELECT provider_name AS name, provider_id AS id, COUNT(*) AS count
      FROM issue AS i
      LEFT JOIN file_record AS r ON (i.recordId = r.recordId AND i.filename = r.file)
      INNER JOIN file AS f USING (file) '
      . $where . ' GROUP BY provider_name, provider_id');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);
    // error_log(cleanSql($this->getSQL($stmt)));

    $stmt->execute();
    return $stmt;
  }

  public function countRecordsBySet($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id, TRUE, 'i.');
    $stmt = $this->db->prepare('SELECT set_name AS name, set_id AS id, COUNT(*) AS count
      FROM issue AS i
      LEFT JOIN file_record AS r ON (i.recordId = r.recordId AND i.filename = r.file)
      INNER JOIN file AS f USING (file) '
      . $where . ' GROUP BY set_name, set_id');
    $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function getLastUpdate($schema = '', $provider_id = '', $set_id = '') {
    $where = $this->getWhere($schema, $provider_id, $set_id);
    if (!empty($where))
      $where = ' ' . $where;
    $stmt = $this->db->prepare('SELECT max(datum) as last_update FROM file' . $where . ';');
    if (!empty($where))
      $this->bindValues($schema, $provider_id, $set_id, $stmt);

    $stmt->execute();
    return $stmt;
  }

  public function fetchValue(PDOStatement $result, $key) {
    error_log('rowCount: ' . $result->rowCount());
    if ($result->rowCount() > 0) {
      $row = $result->fetch(PDO::FETCH_ASSOC);
      if (!is_array($row)) {
        error_log('SQL: ' . $this->getSQL($result));
        error_log('ERROR key: ' . $key);
        error_log('ERROR gettype($row): ' . gettype($row));
        error_log('ERROR gettype($row): ' . gettype($row));
        error_log(json_encode(debug_backtrace()));
      }
      try {
        return $row[$key];
      } catch (PDOException $e) {
        error_log('fetchValue error: ' . $e->getMessage());
      }
    } else {
      if ($key == 'count') {
        return 0;
      }
      error_log('ERROR unhandled key in empty result set: ' . $key);
      return null;
    }
  }

  public function fetchList(PDOStatement $result, $key) {
    $items = [];
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
      $items[] = $row[$key];
    }
    return $items;
  }

  public function fetchAssoc(PDOStatement $result, $key = 'id', $debug = false) {
    $items = [];
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
      if ($debug)
        error_log('row: ' . json_encode($row));
      $items[$row[$key]] = $row;
    }
    return $items;
  }

  public function fetchAssocList(PDOStatement $result, $key = 'id') {
    $items = [];
    while ($item = $result->fetch(PDO::FETCH_ASSOC)) {
      $key_val = $item[$key];
      unset($item[$key]);
      if (!isset($items[$key_val])) {
        $items[$key_val] = [];
      }
      $items[$key_val][] = $item;
    }
    return $items;
  }

  /**
   * @param $schema
   * @param $provider_id
   * @param $set_id
   * @param bool $prefix
   *
   * @param string $table_prefix
   *   Table prefix for the metadata_schema, such as 'i.' (default: '')
   * @return string
   */
  private function getWhere($schema, $provider_id, $set_id, $prefix = TRUE, $table_prefix = ''): string {
    if ($schema != '' || $provider_id != '' || $set_id != '') {
      $criteria = [];
      if ($schema != '')
        $criteria[] = $table_prefix . 'metadata_schema = :metadata_schema';
      if ($provider_id != '')
        $criteria[] = 'provider_id = :provider_id';
      if ($set_id != '')
        $criteria[] = 'set_id = :set_id';
      $where = ($prefix ? ' WHERE ' : '') . join(' AND ', $criteria);
    } else {
      $where = '';
    }
    return $where;
  }

  /**
   * @param $schema
   * @param $provider_id
   * @param $set_id
   * @param $stmt
   * @return void
   */
  private function bindValues($schema, $provider_id, $set_id, &$stmt): void {
    if ($schema != '' || $provider_id != '' || $set_id != '') {
      if ($schema != '') {
        // error_log(':metadata_schema = ' . $schema);
        $stmt->bindValue(':metadata_schema', $schema, SQLITE3_TEXT);
      }
      if ($provider_id != '') {
        // error_log(':provider_id = ' . $provider_id);
        $stmt->bindValue(':provider_id', $provider_id, SQLITE3_TEXT);
      }
      if ($set_id != '') {
        // error_log(':set_id = ' . $set_id);
        $stmt->bindValue(':set_id', $set_id, SQLITE3_TEXT);
      }
    }
  }

  private function getSQL($stmt) {
    ob_start();
    $stmt->debugDumpParams();
    $r = ob_get_contents();
    ob_end_clean();
    return $r;
  }
}