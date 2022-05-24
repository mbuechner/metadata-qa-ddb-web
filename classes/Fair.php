<?php

class Fair extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
    $frequency = $this->db->fetchAssocList($this->db->getFrequency($this->schema, $this->provider_id, $this->set_id), 'field');
    $smarty->assign('frequency', $frequency);
    $smarty->assign('variability', $this->db->fetchAssocList($this->db->getVariablitily($this->schema, $this->provider_id, $this->set_id), 'field'));

    $means = [];
    foreach ($frequency as $key => $values) {
      if (preg_match('/^(Q.*):score$/', $key, $matches)) {
        $Q = $matches[1];
        $count = 0;
        $total = 0;
        foreach ($values as $record) {
          if (!is_null($record['value']) && $record['value'] != 'NA') {
            $count += $record['frequency'];
            $total += ($record['frequency'] * $record['value']);
          }
        }
        $means[$Q] = ($count > 0) ? sprintf("%.2f", ($total / $count)) : '&mdash;';
      }
    }
    $smarty->assign('means', $means);

    $count = 0;
    $total = 0;
    $not_measured = 0;
    foreach ($frequency['ruleCatalog:score'] as $record) {
      if (!is_null($record['value']) && $record['value'] != 'NA') {
        $count += $record['frequency'];
        $total += ($record['frequency'] * $record['value']);
      } else {
        $not_measured += $record['frequency'];
      }
    }
    $smarty->assign('totalScore', $total / $count);
    $smarty->assign('notMeasured', $not_measured);
  }

  public function getTemplate() {
    return 'fair.tpl';
  }
}