<div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
  {assign var="max" value=(($page+1) * $limit)}
  <h2>
    Record IDs ({($page * $limit) + 1}&mdash;{if ($max < $recordCount)}{$max}{else}{$recordCount}{/if})
  </h2>

  <p>criteria:
    {if ($type == 'score')}
      {$factors[$factor]->description} = {$value}<br/>
    {else}
      {$factors[$factor]->description} = {if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if}<br/>
    {/if}
    {$recordCount} records
  </p>
  <ol start="{($page * $limit) + 1}">
    {foreach $recordIds as $row}
      <li>
        {if $displayType == 'html'}
          <a href="?&tab=record&id={$row['recordId']}&file={$row['file']|urlencode}&{$controller->getCommonUrlParameters()}">{$row['recordId']}</a>
        {elseif $displayType == 'pdf'}
          <strong>{$row['recordId']}</strong>
        {/if}
        ({$row['metadata_schema']}, from {$row['provider_name']}
        <span style="color: #bbbbbb">file: {$row['file']}</span>)</li>
    {/foreach}
  </ol>

  {if ceil($recordCount / $limit) > 1}
    <p>
      paging:
      {for $i=0; $i<ceil($recordCount / $limit); $i++}
        {if $i != $page}
          <a title="{($i * $limit) + 1}&mdash;{($i+1) * $limit}" href="?&tab=records&field={$field}&value={$value}&schema={$schema}&provider_id={$provider_id}&set_id={$set_id}&page={$i}">{$i+1}</a>
        {else}
          {$i+1}
        {/if}
      {/for}
    </p>
  {/if}

  {if $displayType == 'html'}
    <p>
      <a href="?tab=records&action=pdf&field={$field}&value={$value}&schema={$schema}&set_id={$set_id}&provider_id={$provider_id}&lang={$lang}&page={$page}" target="_blank">PDF</a>
    </p>
  {/if}
</div>
