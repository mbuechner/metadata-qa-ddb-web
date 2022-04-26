<?php
include_once 'common-functions.php';

$smarty = createSmarty('templates');

$tab = getOrDefault('tab', 'overview', ['overview', 'records', 'record', 'about', 'downloader']);
$ajax = getOrDefault('ajax', 0, [0, 1]);

$map = [
  'overview' => 'Overview',
  'factors'  => 'Overview',
  'records'  => 'Records',
  'record'   => 'Record',
  'about'    => 'About',
  'downloader' => 'Downloader',
];

include_once('classes/Tab.php');
include_once('classes/BaseTab.php');
$class = isset($map[$tab]) ? $map[$tab] : 'Completeness';
$controller = createTab($class);
$controller->prepareData($smarty);

if ($ajax == 1) {
  if (!is_null($controller->getAjaxTemplate()))
    $smarty->display($controller->getAjaxTemplate());
} elseif ($controller->getOutputType() == 'html')
  $smarty->display($controller->getTemplate());

