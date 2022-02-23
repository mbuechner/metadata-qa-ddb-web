{include 'common/html-head.tpl'}
<div class="container">
  {include 'common/header.tpl'}
  {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="record" role="tabpanel" aria-labelledby="factors-tab">
      <h2>Record view <span>{$id}</span></h2>

      <p>in {$filename}</p>

      <xmp>{$record}</xmp>
      <p>
        <a href="?tab=downloader&action=downloadRecord&subdir={$subdir}&id={$id}">download record</a>
        &mdash;
        <a href="?tab=downloader&action=downloadFile&subdir={$subdir}">download file</a>
      </p>

      <table>
        {foreach $issues as $id => $value}
          {if $id != 'recordId'}
            <tr>
              <td>Q-{$id}</td>
              <td>{if isset($factors[$id])}{$factors[$id]->description}{else}{$id}{/if}</td>
              <td class="result {if $value == "1"}passed{elseif $value == "0"}failed{else}{$value}{/if}">
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