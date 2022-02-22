<?php
include_once 'common-functions.php';

$configuration = parse_ini_file("configuration.cnf", false, INI_SCANNER_TYPED);
$dir = $configuration['dir'];
$subdirs = array_values(array_diff(scandir($dir), ['.', '..']));

$tab = getOrDefault('tab', 'factors', ['factors', 'images', 'texts', 'about']);
$subdir = getOrDefault('subdir', 'DC-DDB-WuerzburgIMG', $subdirs);

$factors = readCsv('factors.csv', 'id');

$frequency = readCsv(sprintf('%s/%s/frequency.csv', $dir, $subdir), 'field', TRUE);
$variability = readCsv(sprintf('%s/%s/variability.csv', $dir, $subdir), 'field', FALSE);
$filename = trim(file_get_contents(sprintf('%s/%s/filename', $dir, $subdir)));
$count = intval(trim(file_get_contents(sprintf('%s/%s/count', $dir, $subdir))));

$smarty = createSmarty('templates');

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
