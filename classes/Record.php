<?php

include_once 'classes/IssuesDB.php';
require_once 'libs/dompdf/autoload.inc.php';

use Dompdf\Dompdf;

class Record extends BaseTab {

  public function __construct() {
    parent::__construct();
  }

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'downloadRecord', 'downloadFile', 'pdf']);

    $id = getOrDefault('id', '');
    $file = getOrDefault('file', '');
    $smarty->assign('id', $id);
    $smarty->assign('displayType', 'html');
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
    } elseif ($this->action == 'pdf') {
      $smarty->assign('displayType', 'pdf');
      $html = $smarty->fetch("record-content.tpl");
      $dompdf = new Dompdf();
      $dompdf->loadHtml($html);
      $dompdf->setPaper('A4', 'landscape');
      $dompdf->render();
      $dompdf->stream();
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
    error_log("getIssues('$file', '$id')");
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
    error_log(json_encode($issues));
    return $issues;
  }
}