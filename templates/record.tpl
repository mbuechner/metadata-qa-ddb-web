{include 'common/html-head.tpl'}
<div class="container">
  {include 'common/header.tpl'}
  {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="record" role="tabpanel" aria-labelledby="factors-tab">
      <h2>Record view</h2>

      <p>
        {$filename}<br>
        {$id}
      </p>

      <xmp>{$record}</xmp>

      <table>
        {foreach $issues as $id => $value}
          {if $id != 'recordId'}
            <tr>
              <td>{if isset($factors[$id])}Q-{$id} {$factors[$id]->description}{else}{$id}{/if}</td>
              <td class="{if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if}">
                {if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if}
              </td>
            </tr>
          {/if}
        {/foreach}
      </table>

    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}