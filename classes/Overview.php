<?php

require_once 'libs/dompdf/autoload.inc.php';

use Dompdf\Dompdf;

class Overview extends BaseTab {

  private $blockers = ['Q-1.1', 'Q-4.1', 'Q-5.1', 'Q-6.1'];

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);

    $this->action = getOrDefault('action', 'display', ['display', 'pdf', 'downloadStatus', 'downloadScores']);

    $raw_frequency = $this->db->getFrequency($this->schema, $this->provider_id, $this->set_id, $this->file);
    $frequency = $this->db->fetchAssocList($raw_frequency, 'field');
    error_log('frequency: ' . substr(json_encode($frequency, JSON_PRETTY_PRINT), 0, 100));
    $smarty->assign('frequency', $frequency);

    $variability = $this->db->fetchAssocList($this->db->getVariablitily($this->schema, $this->provider_id, $this->set_id), 'field');
    $smarty->assign('variability', $variability);
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

    if ($this->action == 'pdf') {
      $smarty->assign('displayType', 'pdf');
      $html = $smarty->fetch('overview.tpl');
      $this->createPdf($html);
    } elseif ($this->action == 'downloadStatus') {
      $this->downloadStatus($frequency);
    } elseif ($this->action == 'downloadScores') {
      $this->downloadScores($frequency);
    } else {
      $smarty->assign('displayType', 'html');
    }
  }

  public function getTemplate() {
    if ($this->action == 'pdf' || $this->action == 'download') {
      return null;
    }
    return 'overview.tpl';
  }

  /**
   * @param array $frequency
   * @return void
   */
  protected function downloadScores(array $frequency): void {
    $this->outputType = 'none';

    $this->printHeader('overview-scores.csv');
    echo "criteria,value,frequency\n";
    foreach ($frequency as $key => $record) {
      if (preg_match('/:score$/', $key)) {
        error_log($key);
        error_log(json_encode($record));
        foreach ($record as $entry) {
          echo sprintf("%s,%d,%d\n", str_replace(':score', '', $key), $entry['value'], $entry['frequency']);
        }
      }
    }
  }

  /**
   * @param array $frequency
   * @return void
   */
  protected function downloadStatus(array $frequency): void {
    $this->outputType = 'none';

    $this->printHeader('overview-status.csv');
    echo "criteria,passed,failed,na\n";
    foreach ($frequency as $key => $record) {
      if (preg_match('/:status$/', $key)) {
        $passed = 0;
        $failed = 0;
        $na = 0;
        foreach ($record as $entry) {
          if ($entry['value'] == '0')
            $failed = $entry['frequency'];
          elseif ($entry['value'] == '1')
            $passed = $entry['frequency'];
          elseif ($entry['value'] == 'na')
            $na = $entry['frequency'];
        }
        echo sprintf("%s,%d,%d,%d\n", str_replace(':status', '', $key), $passed, $failed, $na);
      }
    }
  }

  /**
   * @return void
   */
  protected function printHeader($filename = 'overview-status.csv'): void {
    header(sprintf('Content-Type: %s; charset=utf-8', 'text/csv'));
    header('Content-Disposition: ' . sprintf('attachment; filename="%s"', $filename));
  }
}