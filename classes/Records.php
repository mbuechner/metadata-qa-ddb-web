<?php

include_once 'classes/IssuesDB.php';

class Records extends BaseTab {

  public function __construct() {
    parent::__construct();
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'pdf']);

    $field = getOrDefault('field', '');
    if ($this->file != '') {
      $file = '' ? '' : '%' . $this->file . '%';
    } else {
      $file = '';
      if ($field == '')
        $field = 'Q-1.1:status';
    }
    // $field = getOrDefault('field', 'Q-1.1:status');
    $value = getOrDefault('value', '');
    // $value = getOrDefault('value', '1', ['0', '1', 'NA']);
    $page = getOrDefault('page', 0);
    $limit = getOrDefault('limit', 100, [25, 50, 100]);
    $op = getOrDefault('op', 'eq', ['eq', 'lt', 'gt']);
    if (preg_match('/^(.*?):(score|status)$/', $field, $matches)) {
      $factor = $matches[1];
      $type = $matches[2];
    } else {
      $factor = $field;
      $type = 'unknown';
    }
    $smarty->assign('factor', $factor);
    $smarty->assign('type', $type);

    $recordCount = $this->db->fetchValue(
      $this->db->getIssuesCount(
        $field, $value, $op, $this->unsetNa($this->schema), $this->unsetNa($this->provider_id), $this->unsetNa($this->set_id), $file
      ), 'count');
    $result = $this->db->getIssues(
      $field, $value, $op,
      $this->unsetNa($this->schema), $this->unsetNa($this->provider_id), $this->unsetNa($this->set_id), $file,
      $page * $limit, $limit
    );
    $recordIds = [];
    while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
      $recordIds[] = $row;
    }
    $smarty->assign('recordCount', $recordCount);
    $smarty->assign('page', $page);
    $smarty->assign('limit', $limit);
    $smarty->assign('field', $field);
    $smarty->assign('value', $value);
    $smarty->assign('recordIds', $recordIds);

    if ($this->action == 'pdf') {
      $smarty->assign('displayType', 'pdf');
      $html = $smarty->fetch("records.tpl");
      error_log($html);
      $this->createPdf($html);
    } else {
      $smarty->assign('displayType', 'html');
    }
  }

  public function getTemplate() {
    return 'records.tpl';
  }

}