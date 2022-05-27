{include 'common/html-head.tpl'}
<div class="container">
    {include 'common/header.tpl'}
    {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>FAIR assessment</h2>

      <h3>{$count} records</h3>
      <p>
        metadata schemas: {foreach $schemasStatistic as $item name="stat"}
          {$item['metadata_schema']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        providers: {foreach $providersStatistic as $item name="stat"}
          {$item['name']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        datasets: {foreach $setsStatistic as $item name="stat"}
              {$item['name']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}
      </p>

      <table class="fair">
        <thead>
        <tr>
          <th style="min-width: 100px; max-width: 150px;">Kategorien für Qualitätskriterien (FAIR Prinzipien)</th>
          <th>Beschreibung</th>
          <th>Bewertungs-matrix</th>
          <th>Maximale Punktzahl</th>
          <th style="width: 80px" class="red">blocked</th>
          <th style="width: 80px" class="orange">poor</th>
          <th style="width: 80px">average</th>
          <th style="width: 80px" class="green">good</th>
          <th style="width: 80px" class="green">very good</th>
        </tr>
        </thead>
        <tbody>
        {foreach $categories as $name => $cat}
          <tr>
            <td class="category" colspan="9">{$cat['name']}</td>
          </tr>
          {foreach $cat['criteria'] as $id => $criteria name="criteria"}
            <tr>
              {if $smarty.foreach.criteria.first}
                <td class="fair-category-result" rowspan="{count($cat['criteria'])}">
                  <div class="label {$fair[$name]['color']}">{$fair[$name]['label']}</div>
                  <span class="score">({$fair[$name]['total']})</span>
                </td>
              {/if}
              <td class="{if isset($blocked[$id])}red{/if}">{$criteria['title']}</td>
              <td class="text-center {if isset($blocked[$id])}red{/if}">{$id}</td>
              <td class="text-center {if isset($blocked[$id])}red{/if}">{$criteria['score']}</td>
              <td class="text-center red">
                {if isset($distribution[$id]['blocked'])}{$distribution[$id]['blocked']}{/if}
              </td>
              <td class="text-center orange">
                {if isset($distribution[$id]['poor'])}{$distribution[$id]['poor']}{/if}
              </td>
              <td class="text-center">
                {if isset($distribution[$id]['average'])}{$distribution[$id]['average']}{/if}
              </td>
              <td class="text-center green">
                {if isset($distribution[$id]['good'])}{$distribution[$id]['good']}{/if}
              </td>
              <td class="text-center green">
                {if isset($distribution[$id]['very good'])}{$distribution[$id]['very good']}{/if}
              </td>
            </tr>
          {/foreach}
        {/foreach}
        </tbody>
      </table>
    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}