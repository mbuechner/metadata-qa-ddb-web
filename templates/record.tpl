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
        <a href="?tab=downloader&action=downloadRecord&id={$id}">download record</a>
        &mdash;
        <a href="?tab=downloader&action=downloadFile&id={$id}">download file</a>
      </p>

      <table>
        {foreach $issues as $id => $value}
          {if $id != 'recordId'}
            <tr>
              <td>{$id}</td>
              <td>{if isset($factors[$id])}{$factors[$id]->description}{/if}</td>
              {if isset($value['status'])}
                <td class="result {if $value['status'] == "1"}passed{elseif $value['status'] == "0"}failed{else}{$value['status']}{/if}">
                  {if $value['status'] == "1"}passed{elseif $value['status'] == "0"}failed{else}{$value['status']}{/if}
                </td>
              {else}
                <td></td>
              {/if}
              <td class="result">{if isset($value['score'])}{$value['score']}{/if}</td>
            </tr>
          {/if}
        {/foreach}
      </table>

    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}