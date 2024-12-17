<?php

include_once 'classes/IssuesDB.php';

class Record extends BaseTab {

  public function __construct() {
    parent::__construct();
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'downloadRecord', 'downloadFile']);

    $id = getOrDefault('id', '');
    $file = getOrDefault('file', '');
    $smarty->assign('id', $id);
    if ($id != '') {
      list($file, $xml) = $this->getXml($file, $id);
      if ($this->action == 'downloadRecord') {
        $this->outputType = 'none';
        $this->downloadContent($xml, 'record.xml', 'application/xml');
      } else {
        $smarty->assign('record', $xml);
        $smarty->assign('issues', $this->getIssues($file, $id));
        $smarty->assign('filename', $file); // $this->db->fetchValue($this->db->getFilenameByRecordId($id), 'file'));
        $smarty->assign('filedata', $this->db->getFileDataByRecordId($file, $id)->fetch(PDO::FETCH_ASSOC));
      }
    }
    if ($this->action == 'downloadFile') {
      $filename = $this->db->fetchValue($this->db->getFilenameByRecordId($id), 'file');
      // error_log('filename: ' . $filename);
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

  public function getXml($file, $id): array {
    $db = new IssuesDB($this->outputDir, 'ddb-record.sqlite');
    $res = $db->getRecord($file, $id)->fetchArray(SQLITE3_ASSOC);
    if ($file == '')
      $file = $res['file'];
    return [$file, $res['xml']];
  }

  private function getIssues($file, $id) {
    $issues = $this->db->getIssuesByFileAndRecordId($file, $id)->fetch(PDO::FETCH_ASSOC);
    foreach ($issues as $key => $value) {
      if (preg_match('/^(.*):(.*)$/', $key, $matches)) {
        unset($issues[$key]);
        $key2 = $matches[1] == 'ruleCatalog' ? 'total' : $matches[1];
        if (!isset($issues[$key2])) {
          $issues[$key2] = [];
        }
        $issues[$key2][$matches[2]] = $value;
      }
    }
    return $issues;
  }
}