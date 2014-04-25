<h2><?php echo $this->translate("Job Plugin") ?></h2>

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
        <h3> <?php echo $this->translate("Industries") ?> </h3>
        
        <?php if(count($this->industries)>0):?>
    
         <table class='admin_table'>
          <thead>
            <tr>
              <th><?php echo $this->translate("Industry Name") ?></th>
              
              <th><?php echo $this->translate("Options") ?></th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($this->industries as $category): ?>
            <tr>
              <td><?php echo $category->name ?></td>
              
              <td>
                <?php echo $this->htmlLink(
                    array('route' => 'default', 'module' => 'recruiter', 'controller' => 'admin-manage', 'action' => 'edit-industry', 'id' =>$category->industry_id),
					$this->translate('edit'),
					array('class' => 'smoothbox',
                )); ?>
                |
                <?php echo $this->htmlLink(array('route' => 'default', 'module' => 'recruiter', 'controller' => 'admin-manage', 'action' => 'delete-industry', 'id' =>$category->industry_id),
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
      <span><?php echo $this->translate("There are currently no industries.") ?></span>
      </div>
      <?php endif;?>
      <br/>
      <?php echo $this->htmlLink(array('route' => 'admin_default', 'module' => 'recruiter', 'controller' => 'manage', 'action' => 'add-industry'), $this->translate('Add New Industry'), array(
      'class' => 'smoothbox buttonlink',
      'style' => 'background-image: url(application/modules/Core/externals/images/admin/new_category.png);')) ?>
    </div>
    </form>
    </div>
  </div>
     