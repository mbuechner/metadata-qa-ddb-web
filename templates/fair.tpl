{include 'common/html-head.tpl'}
<div class="container">
    {include 'common/header.tpl'}
    {include 'common/nav-tabs.tpl'}
  <div class="tab-content" id="myTabContent">
    <div class="tab-pane active" id="factors" role="tabpanel" aria-labelledby="factors-tab">
      <h2>FAIR assessment</h2>

      <h3>{$count} records</h3>
      <p>
        metadata schemas: {foreach $schemasStatistic as $item name="stat"}
          {$item['metadata_schema']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        providers: {foreach $providersStatistic as $item name="stat"}
          {$item['name']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}<br>
        datasets: {foreach $setsStatistic as $item name="stat"}
              {$item['name']} ({$item['count']}){if !$smarty.foreach.stat.last}, {/if}
          {/foreach}
      </p>

      <table class="fair">
        <thead>
          <tr>
            <th style="min-width: 100px; max-width: 150px;">Kategorien für Qualitätskriterien (FAIR Prinzipien)</th>
            <th>Beschreibung</th>
            <th>Bewertungs-matrix</th>
            <th>Maximale Punktzahl</th>
            <th style="min-width: 50px;">avg. score</th>
            <th style="min-width: 200px;">actual scores</th>
          </tr>
        </thead>
        <tbody>
        <tr>
          <td class="category" colspan="6">Auffindbarkeit und Identifzierbarkeit</td>
        </tr>
        <tr>
          <td class="fair-category-result" rowspan="14">
            <div class="label {$fair['findable']['color']}">{$fair['findable']['label']}</div>
            <span class="score">({$fair['findable']['total']})</span>
          </td>
          <td class="{if isset($blocked['Q-1.1'])}red{/if}"><strong>Datensatz-ID</strong> ist vorhanden.*</td>
          <td class="text-center {if isset($blocked['Q-1.1'])}red{/if}">Q 1.1</td>
          <td class="text-center {if isset($blocked['Q-1.1'])}red{/if}"></td>
          <td class="score text-center {if isset($colors['Q-1.1'])}{$colors['Q-1.1']}{/if}">
            {$means['Q-1.1']}
          </td>
          <td class="text-center {if isset($blocked['Q-1.1'])}red{/if}">{include file="fair-table.tpl" table=$frequency['Q-1.1:score']}</td>
        </tr>
        <tr>
          <td><strong>Datensatz-ID</strong> ist eindeutig.</td>
          <td class="text-center">Q 1.2 </td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-1.2'])}{$colors['Q-1.2']}{/if}">
            {$means['Q-1.2']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-1.2:score']}</td>
        </tr>
        <tr>
          <td><strong>Datensatz-IDs </strong>für hierarchische Objekt Darstelleungen</td>
          <td class="text-center">Q 1.3 </td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-1.3'])}{$colors['Q-1.3']}{/if}">
            {$means['Q-1.3']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-1.3:score']}</td>
        </tr>
        <tr>
          <td><strong>Datensatz</strong>-ID ist unveränderlich </td>
          <td class="text-center">Q 1.4</td>
          <td class="text-center">-6</td>
          <td class="score text-center {if isset($colors['Q-1.4'])}{$colors['Q-1.4']}{/if}">
            {$means['Q-1.4']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-1.4:score']}</td>
        </tr>
        <tr>
          <td><strong>Datengeber-ID</strong> ist vorhanden.</td>
          <td class="text-center">Q 2.1 </td>
          <td class="text-center">-6</td>
          <td class="score text-center {if isset($colors['Q-2.1'])}{$colors['Q-2.1']}{/if}">
            {$means['Q-2.1']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.1:score']}</td>
        </tr>
        <tr>
          <td><strong>Datengeber-ID</strong> ist weltweit eindeutig. <em>(stammt aus einer Normdatei)</em></td>
          <td class="text-center">Q 2.2</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-2.2'])}{$colors['Q-2.2']}{/if}">
            {$means['Q-2.2']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.2:score']}</td>
        </tr>
        <tr>
          <td><strong>Datengeber</strong>-ID ist unveränderlich </td>
          <td class="text-center">Q 2.3</td>
          <td class="text-center">-6</td>
          <td class="score text-center {if isset($colors['Q-2.3'])}{$colors['Q-2.3']}{/if}">
            {$means['Q-2.3']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.3:score']}</td>
        </tr>
        <tr>
          <td><strong>Das Vorschaubild </strong>muss explizit gekennzeichnet sein, wenn mehr als eine Bilddatei im Datensatz referenziert ist.</td>
          <td class="text-center">Q 3.2 </td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-3.2'])}{$colors['Q-3.2']}{/if}">
            {$means['Q-3.2']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-3.2:score']}</td>
        </tr>
        <tr>
          <td class="{if isset($blocked['Q-6.1'])}red{/if}">Ein <strong>Objekttitel</strong> muss für den Datensatz vorhanden sein*</td>
          <td class="text-center {if isset($blocked['Q-6.1'])}red{/if}">Q 6.1 </td>
          <td class="text-center {if isset($blocked['Q-6.1'])}red{/if}"> </td>
          <td class="score text-center {if isset($colors['Q-6.1'])}{$colors['Q-6.1']}{/if}">
            {$means['Q-6.1']}
          </td>
          <td class="text-center {if isset($blocked['Q-6.1'])}red{/if}">{include file="fair-table.tpl" table=$frequency['Q-6.1:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttitel</strong> muss eindeutig sein.</td>
          <td class="text-center">Q 6.2</td>
          <td class="text-center">-6</td>
          <td class="score text-center {if isset($colors['Q-6.2'])}{$colors['Q-6.2']}{/if}">
            {$means['Q-6.2']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-6.2:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttitel</strong> muss eindeutig sein <em>und darf nicht mit dem Objekttyp identisch sein</em>.</td>
          <td class="text-center">Q 6.5</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-6.5'])}{$colors['Q-6.5']}{/if}">
            {$means['Q-6.5']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-6.5:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttitel</strong> muss aussagekräftig sein.</td>
          <td class="text-center">Q 6.3</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-6.3'])}{$colors['Q-6.3']}{/if}">
            {$means['Q-6.3']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-6.3:score']}</td>
        </tr>
        <tr>
          <td>Im Datensatz muss mindestens eine bevorzugte Bezeichnung für den <strong>Objekttyp</strong> vorhanden sein.</td>
          <td class="text-center">Q 7.1</td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-7.1'])}{$colors['Q-7.1']}{/if}">
            {$means['Q-7.1']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.1:score']}</td>
        </tr>
        <tr>
          <td>Es handelt sich um eine spezifische <strong>Objekttyp</strong>-Bezeichnung und nicht um eine Objektbeschreibung oder Objektklassifizierung.</td>
          <td class="text-center">Q 7.4</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-7.4'])}{$colors['Q-7.4']}{/if}">
            {$means['Q-7.4']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.4:score']}</td>
        </tr>
        <tr>
          <td class="category" colspan="6">Zugänglichkeit</td>
        </tr>
        <tr>
          <td class="fair-category-result" rowspan="9">
            <div class="label {$fair['accessible']['color']}">{$fair['accessible']['label']}</div>
            <span class="score">({$fair['accessible']['total']})</span>
          </td>
          <td class="{if isset($blocked['Q-4.1'])}red{/if}"><strong>Link zu der Bilddatei/digitalen Objekt</strong> ist vorhanden*</td>
          <td class="text-center {if isset($blocked['Q-4.1'])}red{/if}">Q 4.1 </td>
          <td class="text-center {if isset($blocked['Q-4.1'])}red{/if}"> </td>
          <td class="score text-center {if isset($colors['Q-4.1'])}{$colors['Q-4.1']}{/if}">
            {$means['Q-4.1']}
          </td>
          <td class="text-center {if isset($blocked['Q-4.1'])}red{/if}">{include file="fair-table.tpl" table=$frequency['Q-4.1:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Link zur Bilddatei</strong> muss valide sein.</td>
          <td class="text-center">Q 3.3 </td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-3.3'])}{$colors['Q-3.3']}{/if}">
            {$means['Q-3.3']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-3.3:score']}</td>
        </tr>
        <tr>
          <td><strong>Link zum Objekt in Kontext</strong> ist vorhanden</td>
          <td class="text-center">Q 4.5</td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-4.5'])}{$colors['Q-4.5']}{/if}">
            {$means['Q-4.5']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-4.5:score']}</td>
        </tr>
        <tr>
          <td>Link zum <strong>Vorschaubild ist vorhanden</strong>.</td>
          <td class="text-center">Q 3.5 </td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-3.5'])}{$colors['Q-3.5']}{/if}">
            {$means['Q-3.5']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-3.5:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Link zur Bilddatei/ Digitalen Objekt</strong> muss valide sein.</td>
          <td class="text-center">Q 4.3 </td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-4.3'])}{$colors['Q-4.3']}{/if}">
            {$means['Q-4.3']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-4.3:score']}</td>
        </tr>
        <tr>
          <td><strong>Bilddatei</strong> - Im gelieferten Datensatz muss eine Referenz auf eine Bilddatei vorhanden sein (entweder als Link oder als Dateiname).</td>
          <td class="text-center">Q 3.1</td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-3.1'])}{$colors['Q-3.1']}{/if}">
            {$means['Q-3.1']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-3.1:score']}</td>
        </tr>
        <tr>
          <td><em>Der Datensatz enthält einen Link zu einer Mediendatei.</em></td>
          <td class="text-center">Q 4.4 </td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-4.4'])}{$colors['Q-4.4']}{/if}">
            {$means['Q-4.4']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-4.4:score']}</td>
        </tr>
        <tr>
          <td><em>Der Datensatz enthält einen Link zum Objekt im Kontext</em></td>
          <td class="text-center">Q 4.5</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-4.5'])}{$colors['Q-4.5']}{/if}">
            {$means['Q-4.5']}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-4.5:score']}</td>
        </tr>
        <tr>
          <td><em>Der Datensatz enthält einen Link zum Objekt im Medienviewer</em></td>
          <td class="text-center"><em>Q 4.6</em></td>
          <td class="text-center"><em>?</em></td>
          <td class="score text-center {if isset($colors['Q-4.6'])}{$colors['Q-4.6']}{/if}">
            {if isset($means['Q-4.6'])}{$means['Q-4.6']}{/if}
          </td>
          <td class="text-center">
            {if isset($frequency['Q-4.6:score'])}{include file="fair-table.tpl" table=$frequency['Q-4.6:score']}{/if}
          </td>
        </tr>
        <tr>
          <td class="category" colspan="6">Interoperabilität und Maschinenlesbarkeit</td>
        </tr>
        <tr>
          <td class="fair-category-result" rowspan="13">
            <div class="label {$fair['interoperable']['color']}">{$fair['interoperable']['label']}</div>
            <span class="score">({$fair['interoperable']['total']})</span>
          </td>
          <td><strong>Der Datengeber</strong> kann durch einen http-URI aus der GND identifiziert sein.</td>
          <td class="text-center">Q 2.6 </td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-2.6'])}{$colors['Q-2.6']}{/if}">
            {if isset($means['Q-2.6'])}{$means['Q-2.6']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.6:score']}</td>
        </tr>
        <tr>
          <td><strong>Die Bilddatei</strong> soll in einem bevorzugten Format geliefert werden.</td>
          <td class="text-center">Q 3.6</td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-3.6'])}{$colors['Q-3.6']}{/if}">
            {if isset($means['Q-3.6'])}{$means['Q-3.6']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-3.6:score']}</td>
        </tr>
        <tr>
          <td><strong>Bilddateien</strong> müssen in einem von der DDB unterstützten Format geliefert werden.</td>
          <td class="text-center">Q 4.2</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-4.2'])}{$colors['Q-4.2']}{/if}">
            {if isset($means['Q-4.2'])}{$means['Q-4.2']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-4.2:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Datensatz-ID</strong> ist maschinell gut zu verarbeiten.</td>
          <td class="text-center">Q 1.5</td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-1.5'])}{$colors['Q-1.5']}{/if}">
            {if isset($means['Q-1.5'])}{$means['Q-1.5']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-1.5:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Datengeber-ID</strong> soll durch einen http-URI aus der ISIL-Registrierung referenziert sein.</td>
          <td class="text-center">Q 2.5</td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-2.5'])}{$colors['Q-2.5']}{/if}">
            {if isset($means['Q-2.5'])}{$means['Q-2.5']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.5:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttyp</strong> stammt aus der Gemeinsamen Normdatei (GND) oder dem Art &amp; Architecture Thesaurus (AAT).</td>
          <td class="text-center">Q 7.5</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-7.5'])}{$colors['Q-7.5']}{/if}">
            {if isset($means['Q-7.5'])}{$means['Q-7.5']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.5:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttyp</strong> ist durch einen http-URI aus einem LOD-Vokabular referenziert.</td>
          <td class="text-center">Q 7.6</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-7.6'])}{$colors['Q-7.6']}{/if}">
            {if isset($means['Q-7.6'])}{$means['Q-7.6']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.6:score']}</td>
        </tr>
        <tr>
          <td>Der http-URI für den <strong>Objekttyp</strong> verweist auf einen Begriff in der GND oder dem AAT.</td>
          <td class="text-center">Q 7.7</td>
          <td class="text-center">+9</td>
          <td class="score text-center {if isset($colors['Q-7.7'])}{$colors['Q-7.7']}{/if}">
            {if isset($means['Q-7.7'])}{$means['Q-7.7']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.7:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttyp</strong> http-URI verweist auf einen Begriff in Wikidata.</td>
          <td class="text-center">Q 7.8</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-7.8'])}{$colors['Q-7.8']}{/if}">
            {if isset($means['Q-7.8'])}{$means['Q-7.8']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.8:score']}</td>
        </tr>
        <tr>
          <td><strong>Datengeber</strong>-ID- Der Datengeber soll durch einen International Standard Identifier for Libraries and Related Organisations (ISIL) identifiziert sein.</td>
          <td class="text-center">Q 2.4</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-2.4'])}{$colors['Q-2.4']}{/if}">
            {if isset($means['Q-2.4'])}{$means['Q-2.4']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-2.4:score']}</td>
        </tr>
        <tr>
          <td>Der <strong>Objekttyp</strong> muss aus einem kontrollierten Vokabular stammen.</td>
          <td class="text-center">Q 7.3</td>
          <td class="text-center">-6</td>
          <td class="score text-center {if isset($colors['Q-7.3'])}{$colors['Q-7.3']}{/if}">
            {if isset($means['Q-7.3'])}{$means['Q-7.3']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-7.3:score']}</td>
        </tr>
        <tr>
          <td>Die <strong>Lizenz</strong> muss durch einen http-URI gekennzeichnet sein, der im Lizenzkorb der Deutschen Digitalen Bibliothek genannt ist.</td>
          <td class="text-center">Q 5.2</td>
          <td class="text-center">-9</td>
          <td class="score text-center {if isset($colors['Q-5.2'])}{$colors['Q-5.2']}{/if}">
            {if isset($means['Q-5.2'])}{$means['Q-5.2']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-5.2:score']}</td>
        </tr>
        <tr>
          <td><strong>Lizenz</strong>: Es wird ein standardisierter Rechtehinweis verwendet. Die Nutzungsrechte müssen erfragt werden.</td>
          <td class="text-center">Q 5.7</td>
          <td class="text-center">-3</td>
          <td class="score text-center {if isset($colors['Q-5.7'])}{$colors['Q-5.7']}{/if}">
            {if isset($means['Q-5.7'])}{$means['Q-5.7']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-5.7:score']}</td>
        </tr>
        <tr>
          <td class="category" colspan="6">Wiederverwendbarkeit</td>
        </tr>
        <tr>
          <td class="fair-category-result" rowspan="4">
            <div class="label {$fair['reusable']['color']}">{$fair['reusable']['label']}</div>
            <span class="score">({$fair['reusable']['total']})</span>
          </td>
          <td class="{if isset($blocked['Q-5.1'])}red{/if}">Im Datensatz muss eine <strong>Lizenz</strong> für das Digitale Objekt angegeben sein.*</td>
          <td class="text-center {if isset($blocked['Q-5.1'])}red{/if}">Q 5.1</td>
          <td class="text-center {if isset($blocked['Q-5.1'])}red{/if}"> </td>
          <td class="score text-center {if isset($colors['Q-5.1'])}{$colors['Q-5.1']}{/if}">
            {if isset($means['Q-5.1'])}{$means['Q-5.1']}{/if}
          </td>
          <td class="text-center {if isset($blocked['Q-5.1'])}red{/if}">{include file="fair-table.tpl" table=$frequency['Q-5.1:score']}</td>
        </tr>
        <tr>
          <td>Es wird eine <strong>offene Lizenz</strong> für den Rechtsstatus verwendet.</td>
          <td class="text-center">Q 5.4</td>
          <td class="text-center">+6</td>
          <td class="score text-center {if isset($colors['Q-5.4'])}{$colors['Q-5.4']}{/if}">
            {if isset($means['Q-5.4'])}{$means['Q-5.4']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-5.4:score']}</td>
        </tr>
        <tr>
          <td>Es wird eine <strong>offene Lizenz mit Namensnennung</strong> verwendet.</td>
          <td class="text-center">Q 5.5</td>
          <td class="text-center">+3</td>
          <td class="score text-center {if isset($colors['Q-5.5'])}{$colors['Q-5.5']}{/if}">
            {if isset($means['Q-5.5'])}{$means['Q-5.5']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-5.5:score']}</td>
        </tr>
        <tr>
          <td><strong>Lizenz</strong> - Es wird ein standardisierter Rechtehinweis verwendet. Das Digitale Objekt darf mit Einschränkungen genutzt werden.</td>
          <td class="text-center">Q 5.6</td>
          <td class="text-center">0</td>
          <td class="score text-center {if isset($colors['Q-5.6'])}{$colors['Q-5.6']}{/if}">
            {if isset($means['Q-5.6'])}{$means['Q-5.6']}{/if}
          </td>
          <td class="text-center">{include file="fair-table.tpl" table=$frequency['Q-5.6:score']}</td>
        </tr>
        </tbody>
      </table>

    </div>
  </div>
</div>
{include 'common/html-footer.tpl'}