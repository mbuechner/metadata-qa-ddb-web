<?php

class Overview extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
    $smarty->assign('frequency', $this->db->fetchAssocList($this->db->getFrequency($this->schema, $this->provider_id, $this->set_id), 'field'));
    $smarty->assign('variability', $this->db->fetchAssocList($this->db->getVariablitily($this->schema, $this->provider_id, $this->set_id), 'field'));
  }

  public function getTemplate() {
    return 'overview.tpl';
  }
}