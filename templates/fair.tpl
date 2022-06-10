{include 'common/html-head.tpl'}
<div class="container">
    {include 'common/header.tpl'}
    {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>FAIR assessment</h2>

      <h3>{$count} records</h3>
      <p>
        metadata schemas:
          {foreach $schemasStatistic as $item name="stat"}
            {$item['metadata_schema']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        providers:
          {foreach $providersStatistic as $item name="stat"}
            {$item['name']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        datasets:
          {foreach $setsStatistic as $item name="stat"}
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
        {foreach $categories as $name => $cat_definition}
          <tr>
            <td class="category" colspan="9">{$cat_definition['name']}</td>
          </tr>
          {foreach $cat_definition['criteria'] as $id => $criteria name="criteria"}
            {assign var="value" value=$values[$id]}
            <tr>
              {if $smarty.foreach.criteria.first}
                <td class="fair-category-result" rowspan="{count($cat_definition['criteria'])}">
                  <div class="label {$fair[$name]['color']}">{$fair[$name]['label']}</div>
                  <span class="score">({$fair[$name]['total']})</span>
                </td>
              {/if}
              <td class="{$value->getClass()}">{$criteria['title']}</td>
              <td class="text-center {$value->getClass()}">{$id}</td>
              <td class="text-center {$value->getClass()}">{if $criteria['score'] < 0}{$criteria['score']}{else}0{/if}</td>
              <td class="text-center {$value->getClass()}">{if $criteria['score'] > 0}{$criteria['score']}{else}0{/if}</td>
              <td class="text-center {if $value->isBlocked()}red{/if}" title="{$value->tooltip('blocked', $count)}">
                {if $value->isBlocked()}
                  <div>{$value->percent('blocked', $count)}</div>
                {/if}
              </td>
              <td class="text-center orange" title="{$value->tooltip('orange', $count)}">
                {if $value->has('orange')}
                  <div>{$value->percent('orange', $count)}</div>
                {/if}
              </td>
              <td class="text-center white" title="{$value->tooltip('white', $count)}">
                {if $value->has('white')}
                  <div>{$value->percent('white', $count)}</div>
                {/if}
              </td>
              <td class="text-center green" title="{$value->tooltip('green', $count)}">
                {if $value->has('green')}
                  <div>{$value->percent('green', $count)}</div>
                {/if}
              </td>
            </tr>
          {/foreach}
          <tr>
            <td colspan="5"></td>
            <td style="width: 80px"><strong>Blocked</strong></td>
            <td style="width: 80px"><strong>To be improved</strong></td>
            <td style="width: 80px"><strong>Acceptable</strong></td>
            <td style="width: 80px"><strong>Good</strong></td>
          </tr>
          <tr>
            <td colspan="5" style="margin-bottom: 20px;"><strong>Average PERCENTAGE</strong></td>
            <td class="text-center {if isset($categoryCount[$name]['blocked'])}red{/if}">
              {if isset($categoryCount[$name]['blocked'])}
                <div>{$categoryCount[$name]['blocked']}</div>
              {/if}
            </td>
            <td class="text-center orange">
              {if isset($categoryCount[$name]['orange'])}
                <div>{$categoryCount[$name]['orange']}</div>
              {/if}
            </td>
            <td class="text-center white">
              {if isset($categoryCount[$name]['white'])}
                <div>{$categoryCount[$name]['white']}</div>
              {/if}
            </td>
            <td class="text-center green">
                {if isset($categoryCount[$name]['green'])}
                    <div>{$categoryCount[$name]['green']}</div>
                {/if}
            </td>
          </tr>
        {/foreach}
        </tbody>
      </table>
    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}