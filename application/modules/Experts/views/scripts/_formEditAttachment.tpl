<br/></a>
<?php if( $this->subject()->file_id !== null ): ?>
  <div>
    <?php
        $attachment = Engine_Api::_()->getDbtable('files', 'storage')->find($this->subject()->file_id)->current();
    ?>
    <a href="<?php echo $this->baseUrl("/").$attachment->storage_path; ?>"><?php echo $attachment->name; ?></a>
    <?php
        echo $this->htmlLink(array('route' => 'experts_delete_attachment', 'module' => 'experts', 'controller' => 'manage-experts', 'action' => 'delete-file',"expert_id"=>$this->subject()->expert_id,"file_id"=>$this->subject()->file_id), $this->translate('Delete Attachment'), array(
            'class' => 'smoothbox',
        )) 
    ?>
  </div>
<?php endif; ?>
