<?php

include_once 'classes/IssuesDB.php';

class Record extends BaseTab {

  private $db;

  public function __construct() {
    parent::__construct();
    $this->db = new IssuesDB($this->getDir());
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'downloadRecord', 'downloadFile']);

    $id = getOrDefault('id', '');
    $smarty->assign('id', $id);
    if ($id != '') {
      $xml = $this->getXml($id);
      if ($this->action == 'downloadRecord') {
        $this->outputType = 'none';
        $this->downloadContent($xml, 'record.xml', 'application/xml');
      } else {
        $smarty->assign('record', $xml);
        $smarty->assign('issues', $this->getIssues($id));
      }
    }
    if ($this->action == 'downloadFile') {
      $filename = $smarty->getTemplateVars('filename');
      $this->outputType = 'none';
      $this->downloadFile($filename, 'application/xml');

    }
  }

  public function getTemplate() {
    return 'record.tpl';
  }

  public function getAjaxTemplate() {
    return null;
  }

  public function getXml($id) {
    return $this->db->getRecord($id)->fetchArray(SQLITE3_ASSOC)['xml'];
  }

  private function getIssues($id) {
    return $this->db->getIssuesById($id)->fetchArray(SQLITE3_ASSOC);
  }
}