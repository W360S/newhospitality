<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Global.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Form_Admin_Global extends Engine_Form
{
	public function init()
  {  
  	$this
  		->setTitle('Global Settings')
      ->setDescription('This page contains the general settings for the Suggestion plugin');
      
      $this->addElement('Text', 'suggestion_controllersettings', array(
	      'label' => 'License Key',
	      'required' => true,
	      'description' => 'Please enter your license key that was provided to you when you purchased this plugin. If you do not know your license key, please contact the Support Team of SocialEngineAddOns from the Support section of your Account Area.',
	      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.controllersettings')
	    ));  
   

		$this->addElement('Dummy', 'yahoo_settings_temp', array(
      'label' => '',
      'decorators' => array(array('ViewScript', array(
        'viewScript' => '_formcontactimport.tpl',
        'class'      => 'form element'
    )))
			
     ));

   // Add submit button
    $this->addElement('Button', 'submit', array(
      'label' => 'Save Changes',
      'type' => 'submit',
      'ignore' => true
    ));
  }
}
?>