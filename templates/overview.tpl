{include 'common/html-head.tpl'}
<div class="container">
  {include 'common/header.tpl'}
  {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>Quality factors</h2>

      <p class="datasets">
        datasets:
          {foreach $subdirs as $_subdir name='subdirs'}
            {if $_subdir != $subdir}<a href="?subdir={$_subdir}&tab={$tab}">{$_subdir}</a>{else}<span>{$subdir}</span>{/if}
          {if !$smarty.foreach.subdirs.last} &mdash; {/if}
        {/foreach}
      </p>

      {include 'common/overview.tpl'}
    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}