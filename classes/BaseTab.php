<?php

include_once 'classes/IssuesDB.php';
include_once 'classes/IssuesDBMySQL.php';

abstract class BaseTab implements Tab {

  protected $configuration;
  protected $tab;
  protected $dir;
  protected $subdirs;
  protected $subdir;
  protected $outputType = 'html';
  protected $lang = 'en';
  protected $db;
  protected $schema;
  protected $set_id;
  protected $provider_id;
  protected $count;

  public function __construct() {
    $this->configuration = parse_ini_file("configuration.cnf", false, INI_SCANNER_TYPED);
    $this->dir = $this->configuration['dir'];
    $this->source = $this->configuration['source'];
    $this->subdirs = array_values(array_diff(scandir($this->dir), ['.', '..']));
    $this->subdir = getOrDefault('subdir', 'DC-DDB-WuerzburgIMG', $this->subdirs);
    $this->lang = getOrDefault('lang', 'en', ['en', 'de']);
    if (isset($this->configuration['MY_USER'])) {
      $this->db = new IssuesDBMySQL($this->configuration['MY_USER'], $this->configuration['MY_PASSWORD'], $this->configuration['MY_DB']);
    } else {
      $this->db = new IssuesDB($this->dir);
    }
  }

  public function prepareData(Smarty &$smarty) {
    global $tab;
    error_log('tab: ' . $tab);

    $smarty->assign('lang', $this->lang);
    $smarty->assign('tab', $this->tab);
    $smarty->assign('subdirs', $this->subdirs);
    $smarty->assign('subdir', $this->subdir);

    // $smarty->assign('filename', trim(file_get_contents($this->getFilePath('filename'))));
    // $smarty->assign('count', intval(trim(file_get_contents($this->getFilePath('count')))));

    $smarty->assign('factors', $this->getFactors($this->lang));
    // $smarty->assign('frequency', readCsv($this->getFilePath('frequency.csv'), 'field', TRUE));
    // $smarty->assign('variability', readCsv($this->getFilePath('variability.csv'), 'field', FALSE));
    $smarty->assign('lastUpdate', '2021-07-30');

    error_log('start');
    $all_schemas = $this->db->fetchAssoc($this->db->listSchemas(), 'metadata_schema');
    $all_providers = $this->db->fetchAssoc($this->db->listProviders());
    $all_sets = $this->db->fetchAssoc($this->db->listSets());
    $schema = getOrDefault('schema', '', array_keys($all_schemas));
    $provider_id = getOrDefault('provider_id', '', array_keys($all_providers));
    $set_id = getOrDefault('set_id', '', array_keys($all_sets));
    $record_id = getOrDefault('record_id', '');
    if ($record_id != '') {
      header('Location: ?tab=record&id=' . $record_id);
      return;
    }

    $smarty->assign('filtered', ($schema != '' || $provider_id != '' || $set_id != ''));
    $smarty->assign('schema', $schema);
    $smarty->assign('provider_id', $provider_id);
    $smarty->assign('set_id', $set_id);

    // $a = $this->db->fetchAssoc($this->db->listSchemas($schema, $provider_id, $set_id), 'metadata_schema');
    $smarty->assign('schemas', $all_schemas);
    // $b = $this->db->fetchAssoc($this->db->listProviders($schema, $provider_id, $set_id));
    $smarty->assign('providers', $all_providers);
    $smarty->assign('sets', $all_sets); // $this->db->fetchAssoc($this->db->listSets($schema, $provider_id, $set_id)));
    error_log('/lists2');

    $smarty->assign('recordsBySchema', $this->db->fetchAssoc($this->db->countRecordsBySchema($schema, $provider_id, $set_id)));
    error_log('/countRecordsBySchema');
    $smarty->assign('recordsByProvider', $this->db->fetchAssoc($this->db->countRecordsByProvider($schema, $provider_id, $set_id)));
    error_log('/countRecordsByProvider');
    $smarty->assign('recordsBySet', $this->db->fetchAssoc($this->db->countRecordsBySet($schema, $provider_id, $set_id)));
    error_log('/countRecordsBySet');

    $this->schema = $schema == '' ? 'NA' : $schema;
    $this->set_id = $set_id == '' ? 'NA' : $set_id;
    $this->provider_id = $provider_id == '' ? 'NA' : $provider_id;
    $this->count = $this->db->fetchValue($this->db->getCount($this->schema, $this->provider_id, $this->set_id), 'count');
    error_log('/count');
    $smarty->assign('count', $this->count);
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

  private function getFactors($lang) {
    $factors = readCsv('factors.csv', 'id');
    foreach ($factors as $factor) {
      $factor->isGroup = preg_match('/^Q-\d$/', $factor->id);
      $factor->description = $factor->{'description@' . $lang};
    }
    return $factors;
  }

  protected function unsetNa($text) {
    return $text == 'NA' ? '' : $text;
  }

  protected function setNa($text) {
    return $text == '' ? 'NA' : $text;
  }

}