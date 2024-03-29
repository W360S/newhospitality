<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Map.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Fields
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
* @author     John
 */
class Fields_Form_Admin_Map extends Engine_Form
{
  public function init()
  {
    $this
      ->setMethod('POST')
      ->setAttrib('class', 'global_form_smoothbox');

    $this->addElement('Select', 'field_id', array(
      'label' => 'Question',
      'required' => true,
      'allowEmpty' => false,
    ));

    // Add submit
    $this->addElement('Button', 'execute', array(
      'label' => 'Save Question',
      'type' => 'submit',
      'decorators' => array(
        'ViewHelper',
      ),
      'order' => 10000,
      'ignore' => true,
    ));

    // Add cancel
    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'onclick' => 'parent.Smoothbox.close();',
      'prependText' => ' or ',
      'decorators' => array(
        'ViewHelper',
      ),
      'order' => 10001,
      'ignore' => true,
    ));

    $this->addDisplayGroup(array('execute', 'cancel'), 'buttons', array(
      'order' => 10002,
    ));
  }
}
