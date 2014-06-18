<br/></a>
<?php if( $this->subject()->photo_id !== null ): ?>
  <div>
    <?php echo $this->itemPhoto($this->subject(), 'thumb.profile', "", array('id' => 'lassoImg')) ?>
    <?php
        echo $this->htmlLink(array('route' => 'book_delete_image', 'module' => 'library', 'controller' => 'manage-libraries', 'action' => 'delete-image',"book_id"=>$this->subject()->book_id,"photo_id"=>$this->subject()->book_id), $this->translate('Delete Image'), array(
            'class' => 'smoothbox',
        )) 
    ?>
  </div>
<?php endif; ?>
