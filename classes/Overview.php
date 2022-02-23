<?php

class Overview extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
  }

  public function getTemplate() {
    return 'overview.tpl';
  }
}