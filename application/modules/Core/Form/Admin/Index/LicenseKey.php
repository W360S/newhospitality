<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: LicenseKey.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Core
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Core_Form_Admin_Index_LicenseKey extends Engine_Form
{
  public function init()
  {
    $this
      ->setTitle('Update License Key')
      ;
    $this->setAttrib('class', 'global_form_popup');


    // Key
    $this->addElement('Text', 'key', array(
      'label' => 'New License Key:',
      'required' => true,
      'allowEmpty' => false,
      'value' => Engine_Api::_()->getApi('settings', 'core')->core_license_key,
      'validators' => array(
        array('NotEmpty', true),
        new Engine_Validate_Callback(array(get_class($this), 'validateKey'))
      )
    ));
    $this->getElement('key')->getValidator('NotEmpty')
      ->setMessage('Please fill in the license key.', 'notEmptyInvalid')
      ->setMessage('Please fill in the license key.', 'isEmpty');
    $this->getElement('key')->getValidator('Callback')
      ->setMessage('Please enter a valid license key.', 'invalid');


    $this->addElement('Button', 'submit', array(
      'label' => 'Save',
      'type' => 'submit',
      'ignore' => true,
      'decorators' => array('ViewHelper')
    ));

    $this->addElement('Cancel', 'cancel', array(
      'label' => 'cancel',
      'link' => true,
      'prependText' => ' or ',
      'href' => '',
      'onClick'=> 'javascript:parent.Smoothbox.close();',
      'decorators' => array(
        'ViewHelper'
      )
    ));
    $this->addDisplayGroup(array('submit', 'cancel'), 'buttons');
    $button_group = $this->getDisplayGroup('buttons');

  }
  
  
  static public function validateKey($value)
  {
    $license = trim($value);
    if( !preg_match("/^[0-9]{4}[-]{1}[0-9]{4}[-]{1}[0-9]{4}[-]{1}[0-9]{4}?$/", $license) ) {
      return false;
    }
    if( substr($license,10,1) * substr($license,11,1) * substr($license,12,1) * substr($license,13,1) != substr($license,15,4) ) {
      return false;
    }
    if( preg_match('/^[0\-]+$/', $license) ) {
      return false;
    }

    return true;
  }
}