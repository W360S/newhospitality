<?php if( count($this->navigation) ): ?>
    <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
    </div>
    <?php endif; ?>
<h2>
  <?php echo $this->translate("Manage statistics pages") ?>
</h2>
<?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'create'), $this->translate('Add new statistics page')) ?>
<br /><br />
<?php if( count($this->paginator) ): ?>
<table class='admin_table'>
  <thead>
    <tr>
      <th class='admin_table_short'>ID</th>
      <th><?php echo $this->translate("Alias") ?></th>
      <th><?php echo $this->translate("Title") ?></th>
      <th><?php echo $this->translate("Options") ?></th>
    </tr>
  </thead>
  <tbody>
    <?php foreach ($this->paginator as $item): ?>
      <tr>
        <td><?php echo $item['statistics_id']; ?></td>
        <td><?php echo $item['alias']; ?></td>
        <td><?php echo $item['title']; ?></td>
        <td>
          <?php echo $this->htmlLink(array('route' => 'statistics_view', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'view', 'statistic_id' =>$item['statistics_id']), $this->translate('view'), array(
            'class' => 'smoothbox',
          )) ?>
          |
          <?php echo $this->htmlLink(array('route' => 'statistics_edit', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'edit', 'statistic_id' =>$item['statistics_id']), $this->translate('edit')) ?>
          |
          <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'statistics', 'controller' => 'manage', 'action' => 'delete', 'id' =>$item['statistics_id']), $this->translate('delete'), array(
            'class' => 'smoothbox',
          )) ?>
         </td>
      </tr>
    <?php endforeach; ?>
  </tbody>
</table>

<br />


<form id='delete_selected' method='post' action='<?php echo $this->url(array('action' =>'deleteselected')) ?>'>
  <input type="hidden" id="ids" name="ids" value=""/>
</form>
<br/>
<div>
  <?php echo $this->paginationControl($this->paginator); ?>
</div>

<?php else: ?>
  <div class="tip">
    <span>
      <?php echo $this->translate("There are no statistics entries by your members yet.") ?>
    </span>
  </div>
<?php endif; ?>
