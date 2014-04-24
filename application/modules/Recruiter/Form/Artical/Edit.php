<?php 
class Recruiter_Form_Artical_Edit extends Recruiter_Form_Artical_Create
{
    
  public function init()
  {
    parent::init();
    $this->setTitle('Edit Article')
      ->setDescription('Edit your article below, then click "save change" to save.');
    $this->submit->setLabel('Save Changes');
  }
}