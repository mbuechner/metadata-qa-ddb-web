<?php

class Fair extends BaseTab {

  public function prepareData(Smarty &$smarty) {
    parent::prepareData($smarty);
    $frequency = $this->db->fetchAssocList($this->db->getFrequency($this->schema, $this->provider_id, $this->set_id), 'field');
    $smarty->assign('frequency', $frequency);
    $smarty->assign('variability', $this->db->fetchAssocList($this->db->getVariablitily($this->schema, $this->provider_id, $this->set_id), 'field'));
    $fair = [
      'findable' => [
        'criteria' => ['Q-1.1', 'Q-1.2', 'Q-1.3', 'Q-1.4', 'Q-2.1', 'Q-2.2', 'Q-2.3', 'Q-3.2', 'Q-6.1', 'Q-6.2', 'Q-6.3', 'Q-6.4', 'Q-6.5', 'Q-7.1', 'Q-7.2', 'Q-7.4'],
        'ranges' => [
          'poor/below average' => ['range' => [-72.0, -30.0], 'color' => 'orange'],
          'average' => ['range' => [-27.0, -3.0], 'color' => 'orange'],
          'good/above average' => ['range' => 0.0, 'color' => 'green']
        ],
        'blockers' => ['Q-1.1', 'Q-6.1']
      ],
      'accessible' => [
        'criteria' => ['Q-3.1', 'Q-3.3', 'Q-3.5', 'Q-4.1', 'Q-4.3', 'Q-4.4', 'Q-4.5', 'Q-4.6'],
        'ranges' => [
          'poor/below average' => ['range' => [-12.0, -3.0], 'color' => 'orange'],
          'average' => ['range' => 0.0, 'color' => 'green'],
          'good/above average' => ['range' => [3.0, 6.0], 'color' => 'green'],
          'very good/outstanding' => ['range' => [9.0, 1000.0], 'color' => 'green']
        ],
        'blockers' => ['Q-4.1']
      ],
      'interoperable' => [
        'criteria' => ['Q-1.5', 'Q-2.4', 'Q-2.5', 'Q-2.6', 'Q-3.6', 'Q-4.2', 'Q-5.2', 'Q-7.3', 'Q-7.5', 'Q-7.6', 'Q-7.7', 'Q-7.8'],
        'ranges' => [
          'poor/below average' => ['range' => [-18.0, -15.0], 'color' => 'orange'],
          'average' => ['range' => [-12.0, 0.0], 'color' => 'orange'],
          'good/above average' => ['range' => [3.0, 18.0], 'color' => 'green'],
          'very good/outstanding' => ['range' => [21.0, 1000.0], 'color' => 'green']
        ],
        'blockers' => []
      ],
      'reusable' => [
        'criteria' => ['Q-3.4', 'Q-5.1', 'Q-5.3', 'Q-5.4', 'Q-5.5', 'Q-5.6', 'Q-5.7'],
        'ranges' => [
          'poor/below average' => ['range' => [-6.0, -3.0], 'color' => 'orange'],
          'average' => ['range' => 0.0, 'color' => 'green'],
          'good/above average' => ['range' => 3.0, 'color' => 'green'],
          'very good/outstanding' => ['range' => 6.0, 'color' => 'green']
        ],
        'blockers' => ['Q-5.1']
      ],
    ];

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

    $blocked = [];
    $colors = [];
    foreach ($fair as $category => $definition) {
      $label = '';
      $color = '';
      $total = 0.0;
      foreach ($definition['blockers'] as $blocker) {
        $key = $blocker . ':score';
        if (isset($frequency[$key])) {
          foreach ($frequency[$key] as $value) {
            if ($value['value'] < 0.0) {
              $label = 'blocked';
              $color = 'red';
              $blocked[$blocker] = TRUE;
              $colors[$blocker] = $color;
            }
          }
        }
      }
      foreach ($definition['criteria'] as $Q) {
        if (isset($means[$Q]) && $means[$Q] != '&mdash;' && !isset($colors[$Q])) {
          list($l, $c) = $this->getLabel((float) $means[$Q], $definition['ranges']);
          $colors[$Q] = $c;
        }
      }

      if ($label == '') {
        foreach ($definition['criteria'] as $Q) {
          if (isset($means[$Q]) && $means[$Q] != '&mdash;') {
            $total += (float) $means[$Q];
          }
        }
        list($label, $color) = $this->getLabel($total, $definition['ranges']);
      }
      error_log($category . ': ' . $total . ' - ' . $label);
      $fair[$category] = [
        'total' => $total,
        'label' => $label,
        'color' => $color,
      ];
    }
    $smarty->assign('fair', $fair);
    $smarty->assign('blocked', $blocked);
    $smarty->assign('colors', $colors);

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

  private function getLabel($score, $ranges) {
    $label = '';
    $color = '';
    foreach ($ranges as $_label => $range) {
      if (is_array($range['range'])) {
        if ($range['range'][0] <= $score && $range['range'][1] >= $score) {
          $label = $_label;
        }
      } else {
        if ($score == $range['range']) {
          $label = $_label;
        }
      }
      if ($label != '') {
        $color = $range['color'];
        break;
      }
    }
    return [$label, $color];
  }
}