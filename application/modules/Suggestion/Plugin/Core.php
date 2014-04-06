<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Core.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Plugin_Core
{
	public function onItemDeleteAfter($event)
	{
		$payload = $event->getPayload();
  	$activitActionType = $payload['type'];
  	$activitActionIdentity = $payload['identity'];
  	// Delete suggestion if user delete
  	if( $activitActionType == 'group' || $activitActionType == 'blog' || $activitActionType == 'event' || $activitActionType == 'album' || $activitActionType == 'classified' || $activitActionType == 'video' || $activitActionType == 'music_playlist' || $activitActionType == 'poll' || $activitActionType == 'forum' )
  	{
  		// In the case of "Music Delete"
  		if($activitActionType == 'music_playlist')
  		{
  			$activitActionType = 'music';
  		}
			// Delete all entry from "suggestion_rejected" table.
			Engine_Api::_()->getDbtable('rejecteds', 'suggestion')->delete(array(
			'entity = ?' => $activitActionType,
			'entity_id = ?' => $activitActionIdentity
			));			
			// Delete all entry from "Notification table" table.
			$suggestion_table = Engine_Api::_()->getItemTable('suggestion');
			$suggestion_name = $suggestion_table->info('name');
			$select_suggestion = $suggestion_table->select()
				->from($suggestion_name, array('suggestion_id'))
				->where('entity = ?', $activitActionType)
				->where('entity_id = ?', $activitActionIdentity);
			$sugg_suggestion = $select_suggestion->query()->fetchAll();
			if(!empty($sugg_suggestion))
			{
				foreach ($sugg_suggestion as $sugg_delete)
				{
					// Delete from "Notification" table.
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_delete['suggestion_id'], 'object_type = ?' => 'suggestion'));
				}
			}
			
			// Delete all entry from "suggestion_suggestions" table.
			Engine_Api::_()->getDbtable('suggestions', 'suggestion')->delete(array(
			'entity = ?' => $activitActionType,
			'entity_id = ?' => $activitActionIdentity
			));	
  	}
	}
	
  public function onUserDeleteBefore($event)
  {
  	$payload = $event->getPayload();
		$user_id = $payload['user_id'];// User id which are delete self or by admin.
		// Delete from "suggestions" table.
		$suggestion_table = Engine_Api::_()->getItemTable('suggestion');
		$suggestion_name = $suggestion_table->info('name');
		// Delete all suggestion which user have. 
		$sugg_select_owner = $suggestion_table->select()
			->from($suggestion_name, array('suggestion_id'))
			->where('owner_id = ?', $user_id);
		$sugg_owner = $sugg_select_owner->query()->fetchAll();
		// User does not have any suggestion.
		if(empty($sugg_owner))
		{
			$sugg_owner = array(0);
		}
		// Delete all suggestion which user sent.
		$sugg_select_sender = $suggestion_table->select()
			->from($suggestion_name, array('suggestion_id'))
			->where('sender_id = ?', $user_id);
		$sugg_sender = $sugg_select_sender->query()->fetchAll();
		// If user does not send any suggestion.
		if(empty($sugg_sender))
		{
			$sugg_sender = array(0);
		}
		$sugg_id_array = (array_merge($sugg_owner, $sugg_sender));
		// Delete one by one all entry which user sent or recieved.
		foreach($sugg_id_array as $row_suggestion)
		{
			// Value would be 0 if no data return.
			if($row_suggestion != 0)
			{
				$sugg_table_select = Engine_Api::_()->getItem('suggestion', $row_suggestion['suggestion_id']);
				if($sugg_table_select->entity == 'photo') 
				{
					// Delete from "Suggestion_Album" table.
					Engine_Api::_()->getItem('suggestion_album', $sugg_table_select->suggestion_id)->delete();
					// Delete from "Suggestion" table.
					Engine_Api::_()->getItem('suggestion', $sugg_table_select->suggestion_id)->delete();
					// Delete from "Notification_Activity" table.
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_table_select->suggestion_id, 'object_type = ?' => 'suggestion'));
				}
				else {
					// Delete from "Suggestion" table.
					Engine_Api::_()->getItem('suggestion', $sugg_table_select->suggestion_id)->delete();
					// Delete from "Notification_Activity" table.
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_table_select->suggestion_id, 'object_type = ?' => 'suggestion'));
				}
			}
		}
		
		// Delete all entry from "suggestion_rejected" table.
		$reject_table = Engine_Api::_()->getItemTable('rejected');
		$reject_name = $reject_table->info('name');
		$select_reject = $reject_table->select()
			->from($reject_name, array('rejected_id'))
			->where('owner_id = ?', $user_id);
		$sugg_reject = $select_reject->query()->fetchAll();
		if(!empty($sugg_reject))
		{
			foreach ($sugg_reject as $row_reject)
			{				
				Engine_Api::_()->getItem('rejected', $row_reject['rejected_id'])->delete();
			}
		}
  }
  
  // Hook for new user signup
  public function onUserCreateAfter($event)
  {
  	$session = new Zend_Session_Namespace();
  	$session->user_create_after_content = 1;
  }
  
  
  public function addActivity($event)
  {
  	$payload = $event->getPayload();
  	$activitActionType = $payload['type'];
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	$front = Zend_Controller_Front::getInstance();
    $module = $front->getRequest()->getModuleName();
		$action = $front->getRequest()->getActionName();
		
		// Module : BLOG
		// Description : When create new blog then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'blog_new') && ($module == 'blog') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.blog.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current blog id which are user in POSTDISPATCH.
			  $session->blog_id = $payload['object']->blog_id;
			}
		}

		// Module : ALBUM
		// Description : When create "New album" or "Add photo in album" then set session variable for this we open popup from post dispatch.		
		if(($activitActionType == 'album_photo_new') && ($module == 'album') && ($action == 'upload') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.album.create');
			if($show_popup == 1)
			{			
				$session = new Zend_Session_Namespace();
			  //Make session variable of current album id which are user in POSTDISPATCH.
			  $session->album_sugg_id = $payload['object']->album_id;
			}
		}
		
		// Module : CLASSIFIED
		// Description : When create new classified then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'classified_new') && ($module == 'classified') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.classified.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current classified id which are user in POSTDISPATCH.
			  $session->classified_sugg_id = $payload['object']->classified_id;
			}
		}
		
		// Module : VIDEO
		// Description : When create new video then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'video_new') && ($module == 'video') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.video.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current video id which are user in POSTDISPATCH.
			  $session->video_sugg_id = $payload['object']->video_id;
			}
		}
		
		// Module : MUSIC
		// Description : When create new music then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'music_playlist_new') && ($module == 'music') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.music.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current music id which are user in POSTDISPATCH.
			  $session->music_sugg_id = $payload['object']->playlist_id;
			}
		}
		
		// Module : POLL
		// Description : When create new poll then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'poll_new') && ($module == 'poll') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.poll.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current poll id which are user in POSTDISPATCH.
			  $session->poll_sugg_id = $payload['object']->poll_id;
			}
		}
		
		// Module : GROUP
		// Description : When create new blog then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'group_create') && ($module == 'group') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.group.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current music id which are user in POSTDISPATCH.
			  $session->sugg_group_create = $payload['object']->group_id;
			}
		}
		
		// Module : EVENT
		// Description : When create new event then set session variable for this we open popup from post dispatch.
		if(($activitActionType == 'event_create') && ($module == 'event') && ($action == 'create') && !empty($suggestion_field_cat))
		{
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.event.create');
			if($show_popup == 1)
			{
				$session = new Zend_Session_Namespace();
			  //Make session variable of current music id which are user in POSTDISPATCH.
			  $session->sugg_event_create = $payload['object']->event_id;
			}
		}
  }
}