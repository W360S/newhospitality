<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Mix.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Form_Admin_Mix extends Engine_Form
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
		      ->setTitle('Mixed Suggestions')
		      ->setDescription('Here, you can select the suggestions that you want to be shown amongst mixed suggestions(shown in the Recommendations widget and on the explore suggestion page), and also configure the number of entries. [Note : Please enable the Mixed Suggestions widget from the Layout Editor for this.]');

		     // Return the array of all module name which are enabled by site admin.
		     $enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();


		     $this->addElement('Text', 'sugg_mix_wid', array(
		      'label' => 'Recommendations Widget',
		      'description' => "How many suggestions do you want to display in the Recommendations widget ?",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.mix.wid')
		    ));

		     $this->addElement('Radio', 'messagefriend', array(
		      'label' => 'Message-a-Friend Suggestions',
		      'description' => "Do you want Message-a-Friend suggestions to be part of Mixed Suggestions ? [This suggestion shows to the user a friend that he/she has not contacted/messaged since a long time, and provides the user a quick link to message that friend.]",
		      'multiOptions' => array(
		      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
		        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
		      ),
		      'value' => in_array("messagefriend", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
		    ));

		     $this->addElement('Radio', 'friendfewfriend', array(
		      'label' => 'Suggest-Friends-to-Friend Suggestions',
		      'description' => "Do you want Suggest-Friends-to-Friend suggestions to be part of Mixed Suggestions ? [This suggestion shows to the user a friend of his/her who has few friends on the site, and enables the user to suggest friends to him/her.]",
		      'multiOptions' => array(
		      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
		        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
		      ),
		      'value' => in_array("friendfewfriend", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
		    ));

		     $this->addElement('Radio', 'friendphoto', array(
		      'label' => 'Profile Picture Suggestions',
		      'description' => "Do you want Profile Picture suggestions to be part of Mixed Suggestions ? [This suggestion shows to the user a friend of his/her who does not have a profile picture, and enables the user to suggest a profile picture to this friend.]",
		      'multiOptions' => array(
		      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
		        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
		      ),
		      'value' => in_array("friendphoto", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
		    ));

		     $this->addElement('Radio', 'friend', array(
		      'label' => 'Friend Suggestions',
		      'description' => "Do you want Friend suggestions to be part of Mixed Suggestions ?",
		      'multiOptions' => array(
		      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
		        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
		      ),
		      'value' => in_array("friend", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
		    ));

		     if(in_array("group", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'group', array(
			      'label' => 'Group Suggestions',
			      'description' => "Do you want Group suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			     'value' => in_array("group", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("event", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'event', array(
			      'label' => 'Event Suggestions',
			      'description' => "Do you want Event suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("event", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("classified", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'classified', array(
			      'label' => 'Classified Suggestions',
			      'description' => "Do you want Classified suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("classified", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("album", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'album', array(
			      'label' => 'Album Suggestions',
			      'description' => "Do you want Album suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("album", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("video", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'video', array(
			      'label' => 'Video Suggestions',
			      'description' => "Do you want Video suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("video", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("music", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'music', array(
			      'label' => 'Music Suggestions',
			      'description' => "Do you want Music suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("music", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("blog", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'blog', array(
			      'label' => 'Blog Suggestions',
			      'description' => "Do you want Blog suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("blog", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("poll", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'poll', array(
			      'label' => 'Poll Suggestions',
			      'description' => "Do you want Poll suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("poll", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		     if(in_array("forum", $enabledModuleNames) == 1)
		     {
			     $this->addElement('Radio', 'forum', array(
			      'label' => 'Forum Suggestions',
			      'description' => "Do you want Forum suggestions to be part of Mixed Suggestions ?",
			      'multiOptions' => array(
			      	1 => 'Yes, make this suggestion a part of Mixed Suggestions.',
			        0 => 'No, do not make this suggestion a part of Mixed Suggestions.'
			      ),
			      'value' => in_array("forum", unserialize(Engine_Api::_()->getApi('settings', 'core')->getSetting('mix.serialize'))),
			    ));
		     }

		    $this->addElement('Button', 'submit', array(
		      'label' => 'Save Settings',
		      'type' => 'submit',
		      'ignore' => true
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