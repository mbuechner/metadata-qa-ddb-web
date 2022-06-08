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
          <th>Kriterium nicht erfüllt</th>
          <th>Kriterium erfüllt</th>
          <th style="width: 80px" class="red">blocked</th>
          <th style="width: 80px" class="orange">To be improved</th>
          <th style="width: 80px">Acceptable</th>
          <th style="width: 80px" class="green">Good</th>
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
              <td class="text-center {if isset($blocked[$id])}red{/if}">{if $criteria['score'] < 0}{$criteria['score']}{else}0{/if}</td>
              <td class="text-center {if isset($blocked[$id])}red{/if}">{if $criteria['score'] > 0}{$criteria['score']}{else}0{/if}</td>
              <td class="text-center red">
                {if isset($distribution[$id]['blocked'])}{$distribution[$id]['blocked']}{/if}
              </td>
              <td class="text-center orange">
                {if isset($distribution[$id]['To be improved'])}{$distribution[$id]['To be improved']}{/if}
              </td>
              <td class="text-center">
                {if isset($distribution[$id]['Acceptable'])}{$distribution[$id]['Acceptable']}{/if}
              </td>
              <td class="text-center green">
                {if isset($distribution[$id]['Good'])}{$distribution[$id]['Good']}{/if}
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