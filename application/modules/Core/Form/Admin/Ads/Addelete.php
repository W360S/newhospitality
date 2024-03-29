<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Addelete.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Admin_Ads_Addelete extends Engine_Form
{
  public function init()
  {
    $this
      ->setTitle('Delete Advertisement')
      ->setDescription('Are you sure you want to delete this advertisement? ');
    
    $ad_id = new Zend_Form_Element_Hidden('ad_id');
    $ad_id
      //->clearDecorators()
      //->addDecorator('ViewHelper');
      ->addValidator('Int');

    $this->addElements(array(
      $ad_id
    ));
    // Buttons
    $this->addElement('Button', 'submit', array(
      'label' => 'Delete Ad',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array('ViewHelper')
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => ' or ',
      'href' => '',
      'onclick' => 'parent.Smoothbox.close();',
      'decorators' => array(
        'ViewHelper'
      )
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
    $button_group = $this->getDisplayGroup('buttons');
  }
}