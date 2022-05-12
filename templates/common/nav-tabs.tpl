<!-- Nav tabs -->
<nav>
  <ul class="nav nav-tabs" id="myTab">
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'factors'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="overview-tab" aria-controls="overview"
         href="?tab=overview">Overview</a>
    </li>
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'records'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="records-tab" aria-controls="records"
         href="?tab=records">Records</a>
    </li>
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'record'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="record-tab" aria-controls="record"
         href="?tab=record">Record</a>
    </li>
<!--
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'images'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="images-tab" aria-controls="images"
         href="?tab=images">Images</a>
    </li>
    <li class="nav-item">
      <a class="nav-link1{if $tab == 'texts'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="images-tab" aria-controls="texts"
         href="?tab=texts">Texts</a>
    </li>
-->
    <li class="nav-item1">
      <a class="nav-link1{if $tab == 'about'} active{/if}" data-toggle="tab1" role="tab1" aria-selected="false"
         id="about-tab" aria-controls="about"
         href="?tab=about">About</a>
    </li>
  </ul>
</nav>

<form method="get" action="?">
  <div class="row">
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <label class="label label-info" for="schemas">metadata schema</label><br>
      <select id="schemas" name="schema" style="width: 300px;">
        <option value="">all</option>
        {foreach $schemas as $id => $_schema}
          <option value="{$id}"{if $id == $schema} selected="selected"{/if}>{$id} ({$_schema['count']} files,
            {if isset($recordsBySchema[$id])}{$recordsBySchema[$id]['count']}{else}0{/if} records)</option>
        {/foreach}
      </select>
    </div>

    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <label class="label label-info" for="providers">data provider</label><br>
      <select id="providers" name="provider_id" style="width: 300px;">
        <option value="">all</option>
        {foreach $providers as $id => $provider}
          <option value="{$id}"{if $id == $provider_id} selected="selected"{/if}>{$provider['name']} ({$provider['count']} files,
            {if isset($recordsByProvider[$id])}{$recordsByProvider[$id]['count']}{else}0{/if} records)</option>
        {/foreach}
      </select>
    </div>

    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <label class="label label-info" for="sets">dataset</label><br>
      <select id="sets" name="set_id" style="width: 300px;">
        <option value="">all</option>
        {foreach $sets as $id => $set}
          <option value="{$id}"{if $id == $set_id} selected="selected"{/if}>{$set['name']} ({$set['count']} files,
            {if isset($recordsBySet[$id])}{$recordsBySet[$id]['count']}{else}0{/if} records)</option>
        {/foreach}
      </select>
    </div>
  </div>

  <div class="row">
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4"></div>
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <p style="margin-top: 0.5rem">
        <label class="label label-info col-form-label" for="record_id">record ID</label><br/>
        <input type="text" name="record_id" id="record_id"><br>
        <span style="color: #999999">type in a complete record number</span>
      </p>
    </div>
    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
      <p style="margin-top: 2rem" class="text-right">
        <button type="submit" class="btn btn-primary btn-lg">Select</button>
        <button type="submit" class="btr btn-info">cancel</button>
      </p>
      <p>
    </p>
  </div>
</form>
