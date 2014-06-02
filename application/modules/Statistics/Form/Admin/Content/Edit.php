<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Statistics
 * 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */

class Statistics_Form_Admin_Content_Edit extends Statistics_Form_Admin_Content_Create
{
    
  public function init()
  {
   
    
    // Element: max
    /*
    $this->addElement('Text', 'priority', array(
        'label' => 'Priority',
        'validators' => array(
          array('Int', true),
          new Engine_Validate_AtLeast(0),
        ),
    ));
    */
    parent::init();
    $this->setTitle('Edit Content')
      ->setDescription('Edit your content below, then click "save change" to save.');
    $this->submit->setLabel('Save Changes');
  }
}