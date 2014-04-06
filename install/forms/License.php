<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: License.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Install
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 */
class Install_Form_License extends Engine_Form
{
  public function init()
  {
    // Key
    $this->addElement('Text', 'key', array(
      'label' => 'License Key:',
	  'value' => $this->generateKey(),
      'required' => true,
      'allowEmpty' => false,
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

    // Email
    $this->addElement('Text', 'email', array(
      'label' => 'License Email:',
      'required' => true,
      'allowEmpty' => false,
      'validators' => array(
        'EmailAddress',
      )
    ));

    // Submit
    $this->addElement('Button', 'submit', array(
      'label' => 'Continue...',
      'type' => 'submit',
      'order' => 10000,
      'ignore' => true,
      'decorators' => array(
        'ViewHelper',
        array('HtmlTag', array('tag' => 'div', 'class' => 'form-wrapper submit-wrapper')),
      )
    ));

    $this->addElement('Hidden', 'valid', array(
      'label' => 'Continue...',
      'type' => 'submit',
      'order' => 10001,
    ));
    
    // Modify decorators
    $this->loadDefaultDecorators();
    $this->getDecorator('FormErrors')->setSkipLabels(true);
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
  
  // Keygen by TrioxX
  static public function generateKey()
  {
	$k1 = mt_rand(1000,9999);
	$k2 = mt_rand(1000,9999);
	$k3a = mt_rand(5,9);
	$k3b = mt_rand(5,9);
	$k3c = mt_rand(5,9);
	$k3d = mt_rand(5,9);
	$k3e = $k3a . $k3b . $k3c . $k3d;
	$k4 = $k3a * $k3b * $k3c * $k3d;

	return $k1.'-'.$k2.'-'.$k3e.'-'.$k4;
  } 
}