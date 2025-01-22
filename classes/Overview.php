<?php

require_once 'libs/dompdf/autoload.inc.php';

use Dompdf\Dompdf;

class Overview extends BaseTab {

  private $blockers = ['Q-1.1', 'Q-4.1', 'Q-5.1', 'Q-6.1'];

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'pdf']);

    $frequency = $this->db->fetchAssocList($this->db->getFrequency($this->schema, $this->provider_id, $this->set_id), 'field');
    $smarty->assign('frequency', $frequency);
    $smarty->assign('variability', $this->db->fetchAssocList($this->db->getVariablitily($this->schema, $this->provider_id, $this->set_id), 'field'));
    $count = 0;
    $total = 0;
    $not_measured = 0;
    if (!is_null($frequency) && !empty($frequency)) {
      foreach ($frequency['ruleCatalog:score'] as $record) {
        if (!is_null($record['value']) && $record['value'] != 'NA') {
          $count += $record['frequency'];
          $total += ($record['frequency'] * $record['value']);
        } else {
          $not_measured += $record['frequency'];
        }
      }
    }
    $smarty->assign('totalScore', ($total == 0 ? 0 : $total / $count));
    $smarty->assign('notMeasured', $not_measured);
    $smarty->assign('blockers', $this->blockers);
    $smarty->assign('displayType', 'html');

    if ($this->action == 'pdf') {
      $smarty->assign('displayType', 'pdf');
      $html = $smarty->fetch('overview-content.tpl');
      $this->createPdf($html);
    }
  }

  public function getTemplate() {
    return 'overview.tpl';
  }
}