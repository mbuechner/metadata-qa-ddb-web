<?php

abstract class BaseTab implements Tab {

  protected $configuration;
  protected $tab;
  protected $dir;
  protected $subdirs;
  protected $subdir;
  protected $outputType = 'html';

  public function __construct() {
    $this->configuration = parse_ini_file("configuration.cnf", false, INI_SCANNER_TYPED);
    $this->dir = $this->configuration['dir'];
    $this->source = $this->configuration['source'];
    $this->subdirs = array_values(array_diff(scandir($this->dir), ['.', '..']));
    $this->subdir = getOrDefault('subdir', 'DC-DDB-WuerzburgIMG', $this->subdirs);
  }

  public function prepareData(Smarty &$smarty) {
    $smarty->assign('tab', $this->tab);
    $smarty->assign('subdirs', $this->subdirs);
    $smarty->assign('subdir', $this->subdir);

    $smarty->assign('filename', trim(file_get_contents($this->getFilePath('filename'))));
    $smarty->assign('count', intval(trim(file_get_contents($this->getFilePath('count')))));

    $smarty->assign('factors', readCsv('factors.csv', 'id'));
    $smarty->assign('frequency', readCsv($this->getFilePath('frequency.csv'), 'field', TRUE));
    $smarty->assign('variability', readCsv($this->getFilePath('variability.csv'), 'field', FALSE));
    $smarty->assign('lastUpdate', '2021-07-30');
  }

  protected function getDir() {
    return $this->dir . '/' . $this->subdir;
  }

  protected function getFilePath($name) {
    return sprintf('%s/%s', $this->getDir(), $name);
  }

  protected function downloadFile($file, $contentType) {
    header(sprintf('Content-Type: %s; charset=utf-8', $contentType));
    header('Content-Disposition: ' . sprintf('attachment; filename="%s"', $file));
    readfile($this->source . '/' . $file);
  }

  protected function downloadContent($content, $filename, $contentType) {
    header(sprintf('Content-Type: %s; charset=utf-8', $contentType));
    header('Content-Disposition: ' . sprintf('attachment; filename="%s"', $filename));
    echo $content;
  }

  public function getOutputType() {
    return $this->outputType;
  }
}