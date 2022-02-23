<?php

class Downloader extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
    $this->outputType = 'none';

    $this->action = getOrDefault('action', 'downloadFile', ['downloadRecord', 'downloadFile']);
    $id = getOrDefault('id', '');
    if ($id != '' && $this->action == 'downloadRecord') {
      include_once('Record.php');
      $record = new Record();
      $this->downloadContent($record->getXml($id), 'record.xml', 'application/xml');
    } else if ($this->action == 'downloadFile') {
      $filename = $smarty->getTemplateVars('filename');
      $this->outputType = 'none';
      $this->downloadFile($filename, 'application/xml');
    }

  }

  public function getTemplate() {
    return null;
  }

  public function getAjaxTemplate() {
    return null;
  }

}