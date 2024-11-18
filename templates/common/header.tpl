<diw class="row">
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <a href="." class="header-link"><img class="hidden-xs hidden-sm" height="160"
    src="https://www.deutsche-digitale-bibliothek.de/assets/ddb-logo-rgb-e74dcc445aa1fd3fe5014274d4d7c6ed.png"></a>
  </div>
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <h1 style="text-align: right">
      <i class="fa fa-cogs" aria-hidden="true"></i> <span>{t}metadata quality assessment dashboard{/t}</span>
    </h1>
  </div>
</diw>

<diw class="row">
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <i class="fa fa-book" aria-hidden="true"></i>
    <span class="header-info">
      {if $lastUpdate != ''}
       last data update: <strong>{$lastUpdate}</strong>
      {/if}
    </span>
  </div>
  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
    <p style="text-align: right">
      {if $lang == 'en'}English{else}<a href="?lang=en">English</a>{/if} |
      {if $lang == 'de'}Deutsch{else}<a href="?lang=de">Deutsch</a>{/if}
    </p>
  </div>
</diw>

