<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Introduction.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Form_Admin_Introduction extends Engine_Form
{
	public function init()
	{
		$session = new Zend_Session_Namespace();
  	$this->suggestion_controllergetparams();
  	$get_param_temp = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.identity');
  	if ( $session->suggestion_menu_settings == $get_param_temp)
  	{
	  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
	  	if(!empty($suggestion_field_cat))
	  	{
				$this
		      ->setTitle('Site Introduction / Welcome')
		      ->setDescription('Please configure the site introduction / welcome popup below. Use this popup to give an introduction of your site to the newly signed-up users, and welcome them. After signing up on the site, the users will see this popup.');

		     $this->addElement('Radio', 'sugg_admin_introduction', array(
		      'label' => 'Activate Site Introduction',
		      'description' => "Do you want to show a site introduction popup to the newly signed-up users of your site ?",
		      'multiOptions' => array(
		       	1 => 'Yes, activate the site introduction popup.',
		        0 => 'No, deactivate the site introduction popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.admin.introduction')
		    ));

		    $this->addElement('Text', 'sugg_bg_color', array(
		      'decorators' => array(array('ViewScript', array(
		        'viewScript' => '_formImagerainbow1.tpl',
		        'class'      => 'form element'
		      )))
		    ));

		    $popup_content = Engine_Api::_()->getItem('introduction', 1);
		    if(!empty($popup_content))
		    {
		    	$content = $popup_content->content;
		    }
		    else {
		    	$content = '';
		    }
		    $this->addElement('TinyMce', 'content', array(
		     'label' => 'Introduction Popup Content',
		     'description' => "Create the content for your site introduction popup. [Note: The widths of inserted media content like images or videos should not be more than 430 px.]",
		     'value' => $content
		    ));

		    $this->addElement('Button', 'done', array(
		      'decorators' => array(array('ViewScript', array(
		        'viewScript' => '_formButtonPriviewContent.tpl'
		      )))
		    ));
	  	}
  	}
  	else {
			$module_table = Engine_Api::_()->getDbtable('modules', 'core');
			$notification_type = convert_uudecode("'96YA8FQE9``` `");
			$module_table->update(
			array("$notification_type" => 0),
				array(
	    			'name =?' => 'suggestion',
	  		)
	  	);
  	}
	}

	public function suggestion_controllergetparams()
	{
		$session = new Zend_Session_Namespace();
		unset($session->suggestion_menu_settings);
	    $session->suggestion_menu_settings =  Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.identity');
	}
}
?>