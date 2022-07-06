<p class="data-source-statistics">
  <strong>{t}metadata schemas{/t}:</strong>
    {foreach $schemasStatistic as $item name="stat"}
      <a href="?tab={$tab}&schema={$item['metadata_schema']}&lang={$lang}">{$item['metadata_schema']}</a>
      <span>({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <strong>{t}data providers{/t}:</strong>
    {foreach $providersStatistic as $item name="stat"}
      <a href="?tab={$tab}&provider_id={$item['id']}&lang={$lang}">{$item['name']}</a>
      <span>({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
  <strong>{t}datasets{/t}:</strong>
    {foreach $setsStatistic as $item name="stat"}
      <a href="?tab={$tab}&set_id={$item['id']}&lang={$lang}">{$item['name']}</a> <span>&mdash; id:{$item['id']}
      ({t 1=$item['count']}n.records{/t})</span>{if !$smarty.foreach.stat.last}, {/if}
    {/foreach}<br>
</p>
