<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Widgetitem.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Form_Admin_Widgetitem extends Engine_Form
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
		      ->setTitle('Suggestion types settings')
		      ->setDescription('Configure the settings for the various suggestion types available on your site. These settings allow you to set action points for showing suggestions to users, and also configure the number of entries in the suggestion widgets.');

		    // In the selection box only that entry will show which enabled by site admin.
		    $module_array = array('friend', 'group', 'classified', 'video', 'blog', 'event', 'album', 'music', 'poll', 'forum');
		    $enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();
		    $enabledModuleNames[] = 'friend';
		   	$final_module_array = array_intersect($module_array, $enabledModuleNames);
		   	foreach ($final_module_array as $row_module_name)
		   	{
		   		$levels_prepared[$row_module_name] = ucfirst($row_module_name);
		   	}

		    // category field
		    $this->addElement('Select', 'sugg_select', array(
		      'label' => 'Suggestion Type',
		      'multiOptions' => $levels_prepared,
		      'onchange' => 'javascript:fetchWidgetSettings(this.value);'
		    ));

		    //FORM FOR "FRIEND MODULE".

		     $this->addElement('Text', 'sugg_friend_wid', array(
		      'label' => 'Friend Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Friend Suggestions widget ? [Note: Please activate the Friend Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.friend.wid')
		    ));

		     $this->addElement('Radio', 'send_friend_popup', array(
		      'label' => 'Suggestions popup after Add as Friend',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Adding of a Friend ? [This popup enables the user to suggest the newly added friend to his/her other friends, so that they may also add him/her.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('send.friend.popup')
		    ));

		     $this->addElement('Radio', 'accept_friend_popup', array(
		      'label' => 'Suggestions popup after Accepting a Friend Request',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Accepting a Friend Request ? [This popup suggests to a user other friends of the added friend, and allows the user to add them as a friend.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('accept.friend.popup')
		    ));



		    // FORM FOR "GROUP" MODULE.

		     $this->addElement('Text', 'sugg_group_wid', array(
		      'label' => 'Group Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Group Suggestions widget ? [Note: Please activate the Group Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.group.wid')
		    ));

		     $this->addElement('Radio', 'after_group_create', array(
		      'label' => 'Suggestions popup after Creating a Group',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Group ? [This popup enables the user to suggest the newly created group to his/her friends, so that they may join it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.group.create')
		    ));

		     $this->addElement('Radio', 'after_group_join', array(
		      'label' => 'Suggestions popup after Joining a Group',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Joining a Group ? [This popup enables the user to suggest the just joined group to his/her friends, so that they may join it too.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		    	'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.group.join')
		    ));


		    // FORM FOR "EVENT" MODULE.

		     $this->addElement('Text', 'sugg_event_wid', array(
		      'label' => 'Event Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Event Suggestions widget ? [Note: Please activate the Event Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.event.wid')
		    ));

		     $this->addElement('Radio', 'after_event_create', array(
		      'label' => 'Suggestions popup after Creating an Event',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Event ? [This popup enables the user to suggest the newly created event to his/her friends, so that they may attend / join it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.event.create')
		    ));

		     $this->addElement('Radio', 'after_event_join', array(
		      'label' => 'Suggestions popup after Joining an Event',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Joining an Event ? [This popup enables the user to suggest the just joined event to his/her friends, so that they may attend / join it too.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.event.join')
		    ));


		    // FORM FOR "CLASSIFIED" MODULE.

		     $this->addElement('Text', 'sugg_classified_wid', array(
		      'label' => 'Classified Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Classified Suggestions widget ? [Note: Please activate the Classified Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.classified.wid')
		    ));

		     $this->addElement('Radio', 'after_classified_create', array(
		      'label' => 'Suggestions popup after Creating a Classified',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Classified ? [This popup enables the user to suggest the newly created classified to his/her friends, so that they may view it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.classified.create')
		    ));


		    // FORM FOR "VIDEO" MODULE.

		     $this->addElement('Text', 'sugg_video_wid', array(
		      'label' => 'Video Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Video Suggestions widget ? [Note: Please activate the Video Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.video.wid')
		    ));

		     $this->addElement('Radio', 'after_video_create', array(
		      'label' => 'Suggestions popup after Creating a Video',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Video ? [This popup enables the user to suggest the newly created video to his/her friends, so that they may view it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.video.create')
		    ));


		    // FORM FOR "BLOG" MODULE.

		     $this->addElement('Text', 'sugg_blog_wid', array(
		      'label' => 'Blog Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Blog Suggestions widget ? [Note: Please activate the Blog Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.blog.wid')
		    ));

		     $this->addElement('Radio', 'after_blog_create', array(
		      'label' => 'Suggestions popup after Creating a Blog',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Blog ? [This popup enables the user to suggest the newly created blog to his/her friends, so that they may read it or comment on it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.blog.create')
		    ));

		    // FORM FOR "ALBUM" MODULE.

		     $this->addElement('Text', 'sugg_album_wid', array(
		      'label' => 'Album Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Album Suggestions widget ? [Note: Please activate the Album Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.album.wid')
		    ));

		     $this->addElement('Radio', 'after_album_create', array(
		      'label' => 'Suggestions popup after Creating an Album',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating an Album ? [This popup enables the user to suggest the newly created album to his/her friends, so that they may view it, tag on it or comment on it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.album.create')
		    ));


		    // FORM FOR "MUSIC" MODULE.

		     $this->addElement('Text', 'sugg_music_wid', array(
		      'label' => 'Music Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Music Suggestions widget ? [Note: Please activate the Music Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.music.wid')
		    ));

		     $this->addElement('Radio', 'after_music_create', array(
		      'label' => 'Suggestions popup after Uploading Music',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Uploading Music ? [This popup enables the user to suggest the newly uploaded music to his/her friends, so that they may listen to it or comment on it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.music.create')
		    ));


		    // FORM FOR "POLL" MODULE.

		     $this->addElement('Text', 'sugg_poll_wid', array(
		      'label' => 'Poll Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Poll Suggestions widget ? [Note: Please activate the Poll Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.poll.wid')
		    ));

		     $this->addElement('Radio', 'after_poll_create', array(
		      'label' => 'Suggestions popup after Creating a Poll',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Poll ? [This popup enables the user to suggest the newly created poll to his/her friends, so that they may vote on it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.poll.create')
		    ));


		    // FORM FOR "FORUM" MODULE.

		     $this->addElement('Text', 'sugg_forum_wid', array(
		      'label' => 'Forum Suggestions Widget',
		      'description' => "How many suggestions do you want to display in the Forum Suggestions widget ? [Note: Please activate the Forum Suggestions widget from the Layout Editor for this.]",
		      'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.forum.wid')
		    ));

		     $this->addElement('Radio', 'after_forum_create', array(
		      'label' => 'Suggestions popup after Creating a Forum Topic',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Creating a Forum Topic ? [This popup enables the user to suggest the newly created forum topic to his/her friends, so that they may view it / comment on it.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.forum.create')
		    ));

		     $this->addElement('Radio', 'after_forum_join', array(
		      'label' => 'Suggestions popup after Replying to a Forum Topic',
		      'description' => 'Do you want the suggestions popup to be shown to a user after Replying to a Forum Topic ? [This popup enables the user to suggest the forum topic to his/her friends, so that they may view it / take part in the discussion too.]',
		      'multiOptions' => array(
		      	1 => 'Yes, show this suggestions popup.',
		        0 => 'No, do not show this suggestions popup.'
		      ),
		     'value' => Engine_Api::_()->getApi('settings', 'core')->getSetting('after.forum.join')
		    ));

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