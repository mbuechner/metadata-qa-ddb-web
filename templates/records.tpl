{include 'common/html-head.tpl'}
<div class="container">
  {include 'common/header.tpl'}
  {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>Record IDs</h2>

      <p>criteria: {$factors[$field]->description} = {if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if};
          {$recordCount} records</p>
      <ul>
        {foreach $recordIds as $recodId}
          <li>{$recodId}</li>
        {/foreach}
      </ul>

      {if ceil($recordCount / $limit) > 1}
        <p>
          paging:
          {for $i=0; $i<ceil($recordCount / $limit); $i++}
            {if $i != $page}
              <a href="?subdir={$subdir}&tab=records&field={$field}&value={$value}&page={$i}">{$i+1}</a>
            {else}
              {$i+1}
            {/if}
          {/for}
        </p>
      {/if}
    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}