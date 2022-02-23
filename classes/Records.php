<?php

include_once 'classes/IssuesDB.php';

class Records extends BaseTab {

  private $db;

  public function __construct() {
    parent::__construct();
    $this->db = new IssuesDB($this->getDir());
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $field = getOrDefault('field', '1.1');
    $value = getOrDefault('value', '1', ['0', '1', 'NA']);
    $page = getOrDefault('page', 0);
    $limit = getOrDefault('limit', 100);

    $recordCount = intval($this->db->countIssues($field, $value)->fetchArray(SQLITE3_ASSOC)['count']);
    $result = $this->db->getIssues($field, $value, $page * $limit, $limit);
    $recordIds = [];
    while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
      $recordIds[] = $row['recordId'];
    }
    $smarty->assign('recordCount', $recordCount);
    $smarty->assign('page', $page);
    $smarty->assign('limit', $limit);
    $smarty->assign('field', $field);
    $smarty->assign('value', $value);
    $smarty->assign('recordIds', $recordIds);
  }

  public function getTemplate() {
    return 'records.tpl';
  }
}