<br/></a>
<?php if( $this->subject()->photo_id !== null ): ?>
  <div>
    <?php echo $this->itemPhoto($this->subject(), 'thumb.profile', "", array('id' => 'lassoImg')) ?>
    <?php
        echo $this->htmlLink(array('route' => 'experts_delete_image', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'delete-image',"expert_id"=>$this->subject()->expert_id,"photo_id"=>$this->subject()->photo_id), $this->translate('Delete Image'), array(
            'class' => 'smoothbox',
        )) 
    ?>
  </div>
<?php endif; ?>
