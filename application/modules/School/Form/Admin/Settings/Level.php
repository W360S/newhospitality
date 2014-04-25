<?php
/*
@function: Settings for members level, allow comment and like on share school
@author: huynhnv
@date: 21-05-2011
*/
class School_Form_Admin_Settings_Level extends Authorization_Form_Admin_Level_Abstract
{
  public function init()
  {
    parent::init();

    // My stuff
    $this
      ->setTitle('Member Level Settings')
      //->setDescription('SCHOOL_FORM_ADMIN_LEVEL_DESCRIPTION')
      ;

      // Element: comment
      $this->addElement('Radio', 'comment', array(
        'label' => 'Allow Commenting on share school?',
        'description' => 'Do you want to let members of this level comment on share school?',
        'multiOptions' => array(
          2 => 'Yes, allow members to comment on all share schools, including private ones.',
          1 => 'Yes, allow members to comment on share schools.',
          0 => 'No, do not allow members to comment on share schools.',
        ),
        'value' => ( $this->isModerator() ? 2 : 1 ),
      ));
      if( !$this->isModerator() ) {
        unset($this->comment->options[2]);
      }

  }
  
}