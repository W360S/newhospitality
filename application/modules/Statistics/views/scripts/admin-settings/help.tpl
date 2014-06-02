<h2><?php echo $this->translate("Statistics Plugin") ?></h2>

<?php if( count($this->navigation) ): ?>
  <div class='tabs'>
    <?php
      // Render the menu
      //->setUlClass()
      echo $this->navigation()->menu()->setContainer($this->navigation)->render()
    ?>
  </div>
<?php endif; ?>

  <div class='clear'>
    <div class='settings'>
    <form class="global_form">
      <div>
        <h3> <?php echo $this->translate("Help Menu Panel") ?> </h3>
        
        <?php if(count($this->categories)>0):?>
    
         <table class='admin_table'>
          <thead>
            <tr>
              <th><?php echo $this->translate("Name") ?></th>
              <th><?php echo $this->translate("Priority") ?></th>
              <th><?php echo $this->translate("Options") ?></th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($this->categories as $category): ?>
            <tr>
              <td><?php echo $category->name ?></td>
              <td><?php echo $category->priority?></td>
              <td>
                <?php echo $this->htmlLink(
                    array('route' => 'default', 'module' => 'statistics', 'controller' => 'admin-settings', 'action' => 'edit-category', 'id' =>$category->category_id),
					$this->translate('edit'),
					array('class' => 'smoothbox',
                )); ?>
                |
                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'statistics', 'controller' => 'admin-settings', 'action' => 'delete-category', 'id' =>$category->category_id),
												$this->translate('delete'),
												array('class' => 'smoothbox',)); ?>

              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php else:?>
      <br/>
      <div class="tip">
      <span><?php echo $this->translate("There are currently no menu.") ?></span>
      </div>
      <?php endif;?>
      <br/>
      <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'statistics', 'controller' => 'settings', 'action' => 'add-category'), $this->translate('Add New Menu'), array(
      'class' => 'smoothbox buttonlink',
      'style' => 'background-image: url(application/modules/Core/externals/images/admin/new_category.png);')) ?>
    </div>
    </form>
    </div>
  </div>
     