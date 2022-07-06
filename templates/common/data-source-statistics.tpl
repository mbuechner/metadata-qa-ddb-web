<p class="data-source-statistics">
  <strong>metadata schemas:</strong>
    {foreach $schemasStatistic as $item name="stat"}
      {$item['metadata_schema']} <span>({$item['count']} records)</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <strong>{translate}provider{/translate}:</strong>
    {foreach $providersStatistic as $item name="stat"}
      {$item['name']} <span>({$item['count']} records)</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <strong>datasets:</strong>
    {foreach $setsStatistic as $item name="stat"}
      {$item['name']} <span>({$item['count']} records)</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>

</p>
