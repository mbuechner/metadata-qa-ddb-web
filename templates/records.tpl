{include 'common/html-head.tpl'}
<div class="container">
  {include 'common/header.tpl'}
  {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>Record IDs ({($page * $limit) + 1}&mdash;{($page+1) * $limit})</h2>

      <p>criteria:
        {if ($type == 'score')}
          {$factors[$factor]->description} = {$value}<br/>
        {else}
          {$factors[$factor]->description} = {if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if}<br/>
        {/if}
        {$recordCount} records
      </p>
      <ul>
        {foreach $recordIds as $recodId}
          <li><a href="?&tab=record&id={$recodId}">{$recodId}</a></li>
        {/foreach}
      </ul>

      {if ceil($recordCount / $limit) > 1}
        <p>
          paging:
          {for $i=0; $i<ceil($recordCount / $limit); $i++}
            {if $i != $page}
              <a href="?&tab=records&field={$field}&value={$value}&schema={$schema}&provider_id={$provider_id}&set_id={$set_id}&page={$i}">{$i+1}</a>
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