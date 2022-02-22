<h3>{$filename}: {$count} records</h3>
<table>
  <thead>
  <tr>
    <th colspan="2">criterium</th>
    <th>result</th>
  </tr>
  </thead>
  <tbody>
    {foreach $factors as $id => $factor}
      {if $id != 'file'}
        <tr class="{if strlen($id) == 1}criteria-group{else}criterium{/if}">
          <td>{$id}</td>
          <td style="width: 600px">{$factor->description}</td>
          <td style="width: 300px">
            {if isset($frequency[$id])}
              <table class="values">
                {foreach $frequency[$id] as $record name="records"}
                  <tr>
                    <td class="value">{if $record->value == "1"}passed{elseif $record->value == "0"}failed{else}{$record->value}{/if}</td>
                    <td class="frequency">{$record->frequency}</td>
                    <td class="bar {if $record->value == "0"}red{elseif $record->value == "1"}green{else}grey{/if}">
                      <div style="width: {200 * $record->frequency / $count}px">&nbsp;</div>
                    </td>
                  </tr>
                {/foreach}
              </table>
            {/if}
          </td>
        </tr>
      {/if}
    {/foreach}
  </tbody>
</table>
