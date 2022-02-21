<?php
include_once 'common-functions.php';

$configuration = parse_ini_file("configuration.cnf", false, INI_SCANNER_TYPED);
$dir = $configuration['dir'];

$tab = getOrDefault('tab', 'images', ['images', 'texts']);

$factors = readCsv('factors.csv', 'id');

$frequency = readCsv(sprintf('%s/results/%s-frequency.csv', $dir, $tab), 'field', TRUE);
$variability = readCsv(sprintf('%s/results/%s-variability.csv', $dir, $tab), 'field', FALSE);

$smarty = createSmarty('templates');
$smarty->assign('factors', $factors);
$smarty->assign('frequency', $frequency);
$smarty->assign('variability', $variability);
$smarty->assign('lastUpdate', '2021-12-30');
$smarty->assign('count', '3000');
$smarty->assign('tab', $tab);

$smarty->display(sprintf('%s.tpl', $tab));
