{include 'common/html-head.tpl'}
<div class="container">
  {if $displayType == 'html'}
    {include 'common/header.tpl'}
    {include 'common/nav-tabs.tpl'}
  {/if}
  <div class="tab-content" id="myTabContent">
    {include 'records-content.tpl'}
  </div>
</div>
{include 'common/html-footer.tpl'}