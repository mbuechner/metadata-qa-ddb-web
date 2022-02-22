<?php
include_once 'common-functions.php';
$smarty = createSmarty('templates');

$configuration = parse_ini_file("configuration.cnf", false, INI_SCANNER_TYPED);
$dir = $configuration['dir'];
$subdirs = array_values(array_diff(scandir($dir), ['.', '..']));

$tab = getOrDefault('tab', 'factors', ['factors', 'records', 'record', 'about']);
$subdir = getOrDefault('subdir', 'DC-DDB-WuerzburgIMG', $subdirs);
if ($tab == 'records') {
  include_once 'classes/IssuesDB.php';

  $field = getOrDefault('field', '1.1');
  $value = getOrDefault('value', '1', ['0', '1', 'NA']);
  $page = getOrDefault('page', 0);
  $limit = getOrDefault('limit', 100);
  $db = new IssuesDB(sprintf('%s/%s', $dir, $subdir));
  $recordCount = intval($db->countIssues($field, $value)->fetchArray(SQLITE3_ASSOC)['count']);
  $result = $db->getIssues($field, $value, $page * $limit, $limit);
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
} else if ($tab == 'record') {
  include_once 'classes/IssuesDB.php';

  $id = getOrDefault('id', '');
  $smarty->assign('id', $id);
  if ($id != '') {
    $db = new IssuesDB(sprintf('%s/%s', $dir, $subdir));
    $xml = $db->getRecord($id)->fetchArray(SQLITE3_ASSOC)['xml'];
    $smarty->assign('record', $xml);
    $issues = $db->getIssuesById($id)->fetchArray(SQLITE3_ASSOC);
    $smarty->assign('issues', $issues);
  }
}

$factors = readCsv('factors.csv', 'id');

$frequency = readCsv(sprintf('%s/%s/frequency.csv', $dir, $subdir), 'field', TRUE);
$variability = readCsv(sprintf('%s/%s/variability.csv', $dir, $subdir), 'field', FALSE);
$filename = trim(file_get_contents(sprintf('%s/%s/filename', $dir, $subdir)));
$count = intval(trim(file_get_contents(sprintf('%s/%s/count', $dir, $subdir))));

$smarty->assign('subdirs', $subdirs);
$smarty->assign('subdir', $subdir);
$smarty->assign('filename', $filename);
$smarty->assign('count', $count);

$smarty->assign('factors', $factors);
$smarty->assign('frequency', $frequency);
$smarty->assign('variability', $variability);
$smarty->assign('lastUpdate', '2021-07-30');
$smarty->assign('tab', $tab);

$smarty->display(sprintf('%s.tpl', $tab));
