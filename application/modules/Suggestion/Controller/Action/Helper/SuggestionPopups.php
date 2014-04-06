<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: SuggestionPopups.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Controller_Action_Helper_SuggestionPopups extends Zend_Controller_Action_Helper_Abstract
{
	function preDispatch()
	{
		$front = Zend_Controller_Front::getInstance();
        $module = $front->getRequest()->getModuleName();
		$action = $front->getRequest()->getActionName();
		$controller = $front->getRequest()->getControllerName();
		// Module : FORUM
		// Description : Here make the session variable for the "Forum Modul" with the help of this session popup will be open.
		if($module == 'forum' && $controller == 'topic')
		{			
  		$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
			$session = new Zend_Session_Namespace();
			// When "create new Topic" from "Forum Modules"
			if ($action == 'create') {
				// Check popup set or not by siteadmin.
				$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.forum.create');
				if($show_popup == 1 && !empty($suggestion_field_cat))
				{
					$session->check_forum_popup_create = 1;
				}
			}
			// When "Reply on Topic" from "Forum Module"
			elseif ($action == 'view') {
				// Check popup set or not by siteadmin.
				$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.forum.join');
				if($show_popup == 1 && !empty($suggestion_field_cat))
				{
					$session->check_forum_popup_reply = 1;				
				}
			}
		}
		
		// Module : USER
		// Description : Set the session variable when open the popup after click on "Add Friend".
		if($module == 'user' && $action == 'add') {
			$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('send.friend.popup');
			if($show_popup == 1 && !empty($suggestion_field_cat))
			{
				$curr_url = $front->getRequest()->getRequestUri();			
				$session = new Zend_Session_Namespace();
				$sending_friend_id_str = explode("/", $curr_url);
				$get_last_key = count($sending_friend_id_str) - 1;
				$sending_friend_id = explode("?", $sending_friend_id_str[$get_last_key]);
				//$sending_friend_id = strstr($sending_friend_id_str[$get_last_key], '?', true);
				// The ID of the user being added as a friend is assigned to a session variable
				$session->check_send_friend_id = $sending_friend_id[0];
			}
		}
		
		// Module : USER
		// Description : Set the session variable when open the popup after click on "Accept Friend".	
		if($module == 'user' && $action == 'confirm') { 
			$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('accept.friend.popup');
			if($show_popup == 1 && !empty($suggestion_field_cat))
			{
				$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
				$curr_url = $front->getRequest()->getRequestUri();					
				$session = new Zend_Session_Namespace();
				$accept_friend_id_str = explode("/",$curr_url);
				$get_last_key = count($accept_friend_id_str)-1;
				$accept_friend_id = explode("?",$accept_friend_id_str[$get_last_key]);
				$accept_friend_req_id = $accept_friend_id[0];
				// The ID of the user whose friend request is being accepted, is assigned to a session variable
				$session->check_accept_friend_id = $accept_friend_req_id;
			}
		}
		
		// Module : USER
		// Description : Set the session variable when open the popup after click on "Make your profile photo".	
		if($module == 'user' && $action == 'external-photo') {
			$session = new Zend_Session_Namespace();
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the Photo ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 3;
			$photo_id_str = explode("_", $sugg_id_array[$suggestion_id]);
			$photo_id = $photo_id_str[2];
			
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id', 'entity_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'photo')
				->where('entity_id = ?', $photo_id);
			$fetch_array = $received_select->query()->fetchAll();
			// This case could occur when the user clicks on make my profile photo on an album photo
			if(!empty($fetch_array))
			{
				$session->check_photo_id = array("photo_id" => $photo_id, "suggestion_id" => $fetch_array[0]['suggestion_id'], "entity_id" => $fetch_array[0]['entity_id']);
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'picture_suggestion'));
			}
		}
		
		// Module : GROUP
		// Description : Set the session variable when open the popup after click on "Join Group".
		if($module == 'group' && $action == 'join'){
			$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.group.join');
			if($show_popup == 1 && !empty($suggestion_field_cat))
			{
				$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
				$curr_url = $front->getRequest()->getRequestUri();
				$session = new Zend_Session_Namespace();
				$group_str = explode("/", $curr_url);
				$get_last_key = count($group_str) - 1;
				$group_id = explode("?", $group_str[$get_last_key]);
				// The ID of the group.
				$session->check_group_id = $group_id[0];
		  }
		}
		
		// Module : EVENT
		// Description : Set the session variable when open the popup after click on "Join Event".
		if($module == 'event' && $action == 'join') { 
			$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
			// Check popup set or not by siteadmin.
			$show_popup = Engine_Api::_()->getApi('settings', 'core')->getSetting('after.event.join');
			if($show_popup == 1 && !empty($suggestion_field_cat))
			{
				$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
				$curr_url = $front->getRequest()->getRequestUri();
				$session = new Zend_Session_Namespace();
				$event_str = explode("/", $curr_url);
				$get_last_key = count($event_str) - 1;
				$event_id = explode("?", $event_str[$get_last_key]);
				// The ID of the event.
				$session->check_event_id = $event_id[0];
			}	
		}
	}
	
	
	
	function postDispatch()
	{	
		$suggestion_identity = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion_identity');
		$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
		$session = new Zend_Session_Namespace();
		$front = Zend_Controller_Front::getInstance();
        $module = $front->getRequest()->getModuleName();
		$action = $front->getRequest()->getActionName();
		$controller = $front->getRequest()->getControllerName();
		//Base URL which are use for giving path of popups.
		$base_url = Zend_Controller_Front::getInstance()->getBaseUrl();
		
		if(($module == 'suggestion') && ($action != 'global'))
		{
			$suggestion_identity = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.identity');
			$suggestion_menu = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.menu');
			if (($suggestion_identity != $suggestion_menu) || (empty($suggestion_identity) && empty($suggestion_menu)))
			{
				$module_table = Engine_Api::_()->getDbtable('modules', 'core');
				$module_type = convert_uudecode("'96YA8FQE9``` `");
				$module_table->update(
				array("$module_type" => 0),
					array(
	      			'name =?' => 'suggestion',
	    		)
	    	);
			}
		}
		
		
		// Module : USER
		// Description : Set the session variable, which set if session variable set which set when click on "Accept Friend".
		if(isset($session->check_accept_friend_id)){
			// If the confirmation button is clicked
			if ($module == 'core' && $action == 'success' && $session->check_accept_friend_id != 'confirm') {
				$session->accept_friend_id = $session->check_accept_friend_id;
			}
			unset($session->check_accept_friend_id);			
		}
		
		// Module : USER
		// Description : If set the session variable, which set after accept friend request then open the popup.
		if(isset($session->accept_friend_id))
		{
			$curr_url = $front->getRequest()->getRequestUri();
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$accept_friend_id = $session->accept_friend_id;
			// Check if there are any users to be suggested in the popup. Only then should the popup be shown
			$accept_popup = Engine_Api::_()->suggestion()->add_friend_suggestion($user_id, $accept_friend_id, '', 1, 'accept_request', '');
			$accept_popup = count($accept_popup);
			// This if condition is needed so that our suggestion popup comes after the confirmation popup, and not inside it
			if(strpos($curr_url, 'members/friends/confirm/user_id/') === FALSE)
			{	
				// Here we are deleting the all suggestion which we have of this friend from "Suggestion Table" & "Notification Table".
				$received_table = Engine_Api::_()->getItemTable('suggestion');
				$received_name = $received_table->info('name');
				$received_select = $received_table->select()
					->from($received_name, array('suggestion_id'))
					->where('owner_id = ?', $user_id)
					->where('entity = ?', 'friend')
					->where('entity_id = ?', $session->accept_friend_id);
				$fetch_array = $received_select->query()->fetchAll();
				if(!empty($fetch_array))
				{			
					foreach ($fetch_array as $sugg_friend_id)	
					// Delete from "Notification table" from update tab.
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_friend_id['suggestion_id'], 'type = ?' => 'friend_suggestion'));
					// Remove suggestion from "suggestion table".
					Engine_Api::_()->getItem('suggestion', $sugg_friend_id['suggestion_id'])->delete();
				}				
				// Here we are open the popups.
				if(!empty($accept_popup)) 
				{
					// @todo : check why this is not working
					$accept_view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
					$accept_script = <<<EOF
						var baseurl_temp = "$base_url";
						var sugg_accept_id = "$session->accept_friend_id";
						window.addEvent('load', function()
						{							
							setTimeout('sugg_friend_accept_popup();', 1000);
						});
						function sugg_friend_accept_popup()
						{
							var browserName=navigator.appName; 
							if (browserName=="Netscape"){ 
							 	this.stop();
							}
							else 
							{ 
							 if (browserName=="Microsoft Internet Explorer")
							 { }
							 else{
							    this.stop();
							  }
							}
							Smoothbox.open(baseurl_temp + '/suggestion/index/requestaccept/sugg_accept_id/' + sugg_accept_id);
						}
EOF;
      		$accept_view_this->headScript()->appendScript($accept_script);
				}
				unset($session->accept_friend_id);				
			}
		}
		
		// Module : USER
		// Description : Set the session variable, which set if session variable set which set when click on "Add Friend".
		if(isset($session->check_send_friend_id)) {
			// If the confirmation button is clicked
			if ($module == 'core' && $action == 'success') {
				$session->send_friend_id = $session->check_send_friend_id;
			}
			unset($session->check_send_friend_id);
		}
		
		// Module : USER
		// Description : If set the session variable, which set after add friend then open the popup.
		if(isset($session->send_friend_id)){
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			$send_friend_id = $session->send_friend_id;
			// Check if there are any users to be suggested in the popup. Only then should the popup be shown
			$check_popup = Engine_Api::_()->suggestion()->add_friend_suggestion($user_id, $send_friend_id, '', 1, 'add_friend', '');				$check_popup = count($check_popup);
			// This if condition is needed so that our suggestion popup comes after the confirmation popup, and not inside it
			if(strpos($curr_url, 'members/friends/add/user_id/') === FALSE) {
				
			// Here we are deleting the all suggestion which we have of this friend from "Suggestion Table" & "Notification Table".
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'friend')
				->where('entity_id = ?', $session->send_friend_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{			
				foreach ($fetch_array as $sugg_friend_id)	
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_friend_id['suggestion_id'], 'type = ?' => 'friend_suggestion'));
				// Remove suggestion from "suggestion table".
				Engine_Api::_()->getItem('suggestion', $sugg_friend_id['suggestion_id'])->delete();
			}				
				
				if (!empty($check_popup)) {					
					//Add JS for showing the popup
					$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
				
 					$script = <<<EOF
 						var baseurl_temp = "$base_url";
 						var send_friend_id = "$session->send_friend_id";
						window.addEvent('load', function()
						{							
							setTimeout('sugg_friend_send_popup();', 1000);
						});
						function sugg_friend_send_popup()
						{
							var browserName=navigator.appName; 
							if (browserName=="Netscape"){ 
							 	this.stop();
							}
							else 
							{ 
							 if (browserName=="Microsoft Internet Explorer")
							 { }
							 else{
							    this.stop();
							  }
							}
							Smoothbox.open(baseurl_temp + '/suggestion/index/requestsend/send_friend_id/' + send_friend_id);
						}
EOF;
      
      		$view_this->headScript()->appendScript($script);
				}
				unset($session->send_friend_id);
			}
		}
		
		
		// Module : Forum
		// Description : Set the session variable, which set if session variable set which set when new topic create.
		if (isset($session->check_forum_popup_create))
		{
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the forum ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$forum_id = $sugg_id_array[$suggestion_id];
			$session->forum_popup_create = $forum_id;
			unset($session->check_forum_popup_create);		
		}
		
		// Module : Forum
		// Description : open the popup if after create new topic session set.
		if(isset($session->forum_popup_create))
		{
			$check_popup = Engine_Api::_()->suggestion()->forum_suggestion($session->forum_popup_create, '', 1);			
			$check_popup = count($check_popup);
			// Check redirect url which made after creating form. 
			if ((strpos($_SERVER['REDIRECT_URL'], 'forums/topic/view/') !== FALSE) && !empty($check_popup))
			{				
				$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
				$script = <<<EOF
				var baseurl_temp = "$base_url";
				var sugg_forum = "$session->forum_popup_create";
				window.addEvent('load', function()
				{							
					setTimeout('sugg_friend_send_popup();', 100);
				});
				function sugg_friend_send_popup()
				{
					Smoothbox.open(baseurl_temp + '/suggestion/index/forum/sugg_forum/' + sugg_forum);
				}
EOF;
    		$view_this->headScript()->appendScript($script);    		
			}
			unset($session->forum_popup_create);
		}
		
		// Module : Forum
		// Description : Set the session variable, which set if session variable set which set when reply on Forum topic.
		if (isset($session->check_forum_popup_reply))
		{
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the forum ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$forum_id = $sugg_id_array[$suggestion_id];
			$session->forum_popup_reply = $forum_id;
			unset($session->check_forum_popup_reply);		
		}
		/*
		// Module : Forum
		// Description : open the popup if after reply on topic session set.
		if(isset($session->forum_popup_reply))
		{
			$check_popup = Engine_Api::_()->suggestion()->forum_suggestion($session->forum_popup_reply, '', 1);			
			$check_popup = count($check_popup);
			if(!empty($_POST['body']) && !empty($check_popup))
			{				
				$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
			
				$script = <<<EOF
				var baseurl_temp = "$base_url";
				var sugg_forum = "$session->forum_popup_reply";
				window.addEvent('load', function()
				{							
					setTimeout('sugg_friend_send_popup();', 100);
				});
				function sugg_friend_send_popup()
				{
					Smoothbox.open(baseurl_temp + '/suggestion/index/forum/sugg_forum/' + sugg_forum);
				}
EOF;
    		$view_this->headScript()->appendScript($script);
			}
			unset($session->forum_popup_reply);
		}
		*/
		// Module : GROUP
		// Description : Set the session if set "After join new group session" which set in predispatch.
		if(isset($session->check_group_id)){
			// If the confirmation button is clicked
			if ($module == 'core' && $action == 'success') {
				$session->sugg_group_join = $session->check_group_id;
			}
			unset($session->check_group_id);
		}	
		
		// Module : GROUP
		// Description : If set the "After create new group session" or "After join new group session" then open the popup.
		if(isset($session->sugg_group_create) || isset($session->sugg_group_join)){
			// Set when Join any Group.
			if(isset($session->sugg_group_join))
			{
				$group_id = $session->sugg_group_join;
			}
			// Set when Create any Group.
			elseif (isset($session->sugg_group_create))
			{
				$group_id = $session->sugg_group_create;
			}
			$curr_url = $front->getRequest()->getRequestUri();
			// Check if there are any users to be suggested in the popup. Only then should the popup be shown
			$check_popup = Engine_Api::_()->suggestion()->group_suggestion($group_id, '', 1, '');			
			// This if condition is needed so that our suggestion popup comes after the confirmation popup, and not inside it
			if(strpos($curr_url, 'groups/member/join/group_id/') === FALSE) {
				// Here we are delete this group suggestion from the "notification table" and "suggestion table" .
				$received_table = Engine_Api::_()->getItemTable('suggestion');
				$received_name = $received_table->info('name');
				$received_select = $received_table->select()
					->from($received_name, array('suggestion_id'))
					->where('owner_id = ?', $user_id)
					->where('entity = ?', 'group')
					->where('entity_id = ?', $group_id);
				$fetch_array = $received_select->query()->fetchAll();
				if(!empty($fetch_array))
				{				
					foreach ($fetch_array as $suggested_group_id)
					{
						// Delete from "Notification table" from update tab.
						Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $suggested_group_id['suggestion_id'], 'type = ?' => 'group_suggestion'));
						// Delete from "suggestion table".
						Engine_Api::_()->getItem('suggestion', $suggested_group_id['suggestion_id'])->delete();
					}			
				}				
				
				//Script for open popup.
				if (!empty($check_popup)) {
					$check_popup = count($check_popup);
					$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
 					$script = <<<EOF
 						var baseurl_temp = "$base_url";
 						var group_sugge_id = "$group_id";
						window.addEvent('domready', function()
						{							
							setTimeout('sugg_group_popup();', 1000);
						});
						function sugg_group_popup()
						{
							var browserName=navigator.appName; 
							if (browserName=="Netscape"){ 
							 	this.stop();
							}
							else 
							{ 
							 if (browserName=="Microsoft Internet Explorer")
							 { }
							 else{
							    this.stop();
							  }
							}
							Smoothbox.open(baseurl_temp + '/suggestion/index/group/group_sugge_id/' + group_sugge_id);
						}
EOF;
      		$view_this->headScript()->appendScript($script);	
				}
				unset($session->sugg_group_join);// When we join any group unset session variable.
			}
			unset($session->sugg_group_create);// When we create any group unset session variable.			
		}
		
		// Module : EVENT
		// Description : Set the session if set "After join new event session" which set in predispatch.
		if(isset($session->check_event_id)){
			// If the confirmation button is clicked
			if ($module == 'core' && $action == 'success') {
				$session->sugg_event_join = $session->check_event_id;
			}
			unset($session->check_event_id);
		}
		
		// Module : EVENT
		// Description : If set the "After create new event session" or "After join new event session" then open the popup.		
		if((isset($session->sugg_event_create) || isset($session->sugg_event_join))){			
			if(isset($session->sugg_event_join))
			{
				$event_id = $session->sugg_event_join;
			}
			elseif (isset($session->sugg_event_create)) {
				$event_id = $session->sugg_event_create;
			}		
			$curr_url = $front->getRequest()->getRequestUri();
			// Check if there are any users to be suggested in the popup. Only then should the popup be shown
			$check_popup = Engine_Api::_()->suggestion()->event_suggestion($event_id, '', 1);			
			// This if condition is needed so that our suggestion popup comes after the confirmation popup, and not inside it
			if(strpos($curr_url, 'events/member/join/event_id/') === FALSE) {				
				// Here we are delete this event suggestion from "Notification Table" and "Suggestion Table".
				$received_table = Engine_Api::_()->getItemTable('suggestion');
				$received_name = $received_table->info('name');
				
				$received_select1 = $received_table->select()
					->from($received_name, array('suggestion_id'))
					->where('owner_id = ?', $user_id)
					->where('entity = ?', 'event')
					->where('entity_id = ?', $event_id);
				$fetch_array = $received_select1->query()->fetchAll();				
				if(!empty($fetch_array))
				{
					foreach ($fetch_array as $suggest_event_id)
					// Delete from "Notification table".
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $suggest_event_id['suggestion_id'], 'type = ?' => 'event_suggestion'));
					// Delete from "suggestion table".
					Engine_Api::_()->getItem('suggestion', $suggest_event_id['suggestion_id'])->delete();
				}
				
				// Here open the popups for the suggestion friend.
				if (!empty($check_popup)) {
					$check_popup = count($check_popup);
					$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
 					$script = <<<EOF
 						var baseurl_temp = "$base_url";
 						var sugg_event_id = "$event_id";
						window.addEvent('load', function()
						{							
							setTimeout('sugg_event_popup();', 1000);
						});
						function sugg_event_popup()
						{
							var browserName=navigator.appName; 
							if (browserName=="Netscape"){ 
							 	this.stop();
							}
							else 
							{ 
							 if (browserName=="Microsoft Internet Explorer")
							 { }
							 else{
							    this.stop();
							  }
							}
							Smoothbox.open(baseurl_temp + '/suggestion/index/event/sugg_event_id/' + sugg_event_id);						
						}
EOF;
      		$view_this->headScript()->appendScript($script);		
				}
				unset($session->sugg_event_join);// Unset event join session variable.								
			}
			unset($session->sugg_event_create);// Unset event create variable.
		}
		
		// Popup open When : New user signup.
		// Description : When new user sign up then open popup which show, which set by the siteadmin.The session variable set with the help of hook.
		if (isset($session->user_create_after_content))
		{
	  	// Get value that popup enable or not. : Check if site admin has enabled site introduction.
	  	$popup_value = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.admin.introduction');  	
	  	if($popup_value == 1)
	  	{
	  		// Get the BG color for popup.
	  		$bg_color = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.bg.color');
	  		// Get the content which will show in popup.
				$content = Engine_Api::_()->getItem('introduction', 1)->content;
				if(!empty($content))
				{
					$ret_str = '';
			    $str = trim($content); 
			    for($i=0;$i < strlen($str);$i++) 
			    { 
		        if(substr($str, $i, 1) != " ") 
		        { 
		        	$string_world = trim(substr($str, $i, 1));
		        	if($string_world == '"')
		        	{
		        		$string_world = "'";
		        	}
		          $ret_str .= $string_world; 
		        } 
		        else 
		        { 
		          while(substr($str,$i,1) == " ")	           
		          { 
		          	$i++; 
		          } 
		          $ret_str.= " "; 
		         	$i--; // *** 
		        }
			    }
					$popup_content = "<style type='text/css'>#TB_window {top:150px !important;width:438px !important;}#TB_ajaxContent{padding:0 !important;width:1px;height:auto !important;width:438px !important;overflow:auto;max-height:420px !important;}</style>" . "<div class='sugg_newuser' style='background:" . $bg_color . ";'>$ret_str</div>";
					
					$accept_view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
				  $accept_script = <<<EOF
				  var data = "$popup_content";
									this.onload = function()
								{
				 Smoothbox.open(data, {autoResize : true});
			}  
EOF;
					$accept_view_this->headScript()->appendScript($accept_script);
				}
	  	}
			unset($session->user_create_after_content);
		}

		// Module : BLOG.
		// Description : When new blog create then open popup.The session variable set with the help of hook.
		if(isset($session->blog_id))
		{
			$check_popup = Engine_Api::_()->suggestion()->blog_suggestion($session->blog_id, '', 1);				
		  if (!empty($check_popup)) { 
				$check_popup = count($check_popup);
	  		$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
					$script = <<<EOF
						var baseurl_temp = "$base_url";
						var sugg_blog_create = "$session->blog_id";
						window.addEvent('load', function()
						{
							Smoothbox.open(baseurl_temp + '/suggestion/index/blog/sugg_blog_create/' + sugg_blog_create);
						});
EOF;
    		$view_this->headScript()->appendScript($script);
			}
			unset($session->blog_id);
		}
		
		// Module : POLL.
		// Description : When new poll create then open popup.The session variable set with the help of hook.
		if(isset($session->poll_sugg_id))
		{
			$check_popup = Engine_Api::_()->suggestion()->poll_suggestion($session->poll_sugg_id, '', 1);
			$check_popup = count($check_popup);
		  if (!empty($check_popup))
		  {		  	
	  		$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
				$script = <<<EOF
					var baseurl_temp = "$base_url";
					var sugg_poll_create = "$session->poll_sugg_id";
					window.addEvent('load', function()
					{
						Smoothbox.open(baseurl_temp + '/suggestion/index/poll/sugg_poll_create/' + sugg_poll_create);
					});
EOF;
	  		$view_this->headScript()->appendScript($script);
			}
			unset($session->poll_sugg_id);			
		}
		
		// Module : ALBUM.
		// Description : When new "Album create" or "Add photo in album" then open popup.The session variable set with the help of hook.
		if(isset($session->album_sugg_id))
		{
			$check_popup = Engine_Api::_()->suggestion()->album_suggestion($session->album_sugg_id, '', 1);
		  if (!empty($check_popup)) {
		  		$check_popup = count($check_popup);
		  		$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
 					$script = <<<EOF
 						var baseurl_temp = "$base_url";
 						var sugg_album_create = "$session->album_sugg_id";
						window.addEvent('load', function()
						{
							Smoothbox.open(baseurl_temp + '/suggestion/index/album/sugg_album_create/' + sugg_album_create);
						});
EOF;
      		$view_this->headScript()->appendScript($script);
			}
			unset($session->album_sugg_id);
		}
		
		// Module : CLASSIFIED.
		// Description : When new classified create then open popup.The session variable set with the help of hook.
		if(isset($session->classified_sugg_id))
		{			
			$check_popup = Engine_Api::_()->suggestion()->classified_suggestion($session->classified_sugg_id, '', 1);			
		  if (!empty($check_popup)) { 
				$check_popup = count($check_popup);
	  		$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
			
					$script = <<<EOF
					var baseurl_temp = "$base_url";
					var sugg_classified_create = "$session->classified_sugg_id";
					window.addEvent('load', function()
					{					
						Smoothbox.open(baseurl_temp + '/suggestion/index/classified/sugg_classified_create/' + sugg_classified_create);
					});
EOF;
    		$view_this->headScript()->appendScript($script);
			}
			unset($session->classified_sugg_id);
		}
		
		// Module : VIDEO.
		// Description : When new video create then open popup.The session variable set with the help of hook.
		if (isset($session->video_sugg_id))
		{
			$check_popup = Engine_Api::_()->suggestion()->video_suggestion($session->video_sugg_id, '', 1);			
		  if (!empty($check_popup)) 
		  {
		  	$check_popup = count($check_popup);
	  		$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;			
				$script = <<<EOF
					var baseurl_temp = "$base_url";
					var sugg_video_create = "$session->video_sugg_id";
					window.addEvent('load', function()
					{
						Smoothbox.open(baseurl_temp + '/suggestion/index/video/sugg_video_create/' + sugg_video_create);
					});
EOF;
    		$view_this->headScript()->appendScript($script);
			}
			unset($session->video_sugg_id);
		}
		
		// Module : MUSIC.
		// Description : When new music create then open popup.The session variable set with the help of hook.
		if(isset($session->music_sugg_id))
		{
			$check_popup = Engine_Api::_()->suggestion()->music_suggestion($session->music_sugg_id, '', 1);			
		  if (!empty($check_popup)) 
		  {
		  	$check_popup = count($check_popup);		  	
		  	$view_this = Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer')->view;
 				$script = <<<EOF
 				var baseurl_temp = "$base_url";
 				var sugg_music_create = "$session->music_sugg_id";
					window.addEvent('load', function()
					{
						Smoothbox.open(baseurl_temp + '/suggestion/index/music/sugg_music_create/' + sugg_music_create);
					});
EOF;
      	$view_this->headScript()->appendScript($script);
			}
			unset($session->music_sugg_id);
		}
		
		// Module : Video.
		// Event : Delete suggestion.
		// Description : When user visit any video and this video in suggestion then delete this video from suggestion.
		if($module == 'video' && $controller == 'index' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the video ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 2;
			$video_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'video')
				->where('entity_id = ?', $video_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this Video when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'video_suggestion'));
			}
		}
		
		// Module : MUSIC.
		// Event : Delete suggestion.
		// Description : When user listen any music and this music in suggestion then delete this music from suggestion.
		if($module == 'music' && $controller == 'index' && $action == 'playlist')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the video ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$music_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'music')
				->where('entity_id = ?', $music_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this Music when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'music_suggestion'));				
			}
		}
		
		// Module : ALBUM.
		// Event : Delete suggestion.
		// Description : When user visit any album and this album in suggestion then delete this album from suggestion.
		if($module == 'album' && $controller == 'album' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the video ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$album_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'album')
				->where('entity_id = ?', $album_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				foreach ($fetch_array as $delete_album_id)
				{
					// Deleting the suggestion for this Album when it is viewed
					Engine_Api::_()->getItem('suggestion', $delete_album_id['suggestion_id'])->delete();
					// Delete from "Notification table" from update tab.
					Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $delete_album_id['suggestion_id'], 'type = ?' => 'album_suggestion'));				
				}
			}
		}
		
		// Module : CLASSIFIED.
		// Event : Delete suggestion.
		// Description : When user view any classified and this classified in suggestion then delete this classified from suggestion.
		if($module == 'classified' && $controller == 'index' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the video ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$classified_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'classified')
				->where('entity_id = ?', $classified_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this Classified when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'album_suggestion'));
			}
		}
		
		// Module : BLOG.
		// Event : Delete suggestion.
		// Description : When user view any blog and this blog in suggestion then delete this blog from suggestion.
		if($module == 'blog' && $controller == 'index' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the video ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 2;
			$blog_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'blog')
				->where('entity_id = ?', $blog_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this Blog when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'blog_suggestion'));
			}
		}
		
		// Module : POLL.
		// Event : Delete suggestion.
		// Description : When user view any poll and this poll in suggestion then delete this poll from suggestion.
		if($module == 'poll' && $controller == 'index' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the poll ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 2;
			$poll_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'poll')
				->where('entity_id = ?', $poll_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this poll when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'poll_suggestion'));
			}
		}
		
		// Module : FORUM.
		// Event : Delete suggestion.
		// Description : When user view any "forum topic" and this topic in suggestion then delete this topic from suggestion.
		if($module == 'forum' && $controller == 'topic' && $action == 'view')
		{
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$curr_url = $front->getRequest()->getRequestUri();
			// Geting the forum ID.
			$sugg_id_array = explode("/", $curr_url);
			$suggestion_id = count($sugg_id_array) - 1;
			$forum_id = $sugg_id_array[$suggestion_id];
			// Check in the "Received" table.
			$received_table = Engine_Api::_()->getItemTable('suggestion');
			$received_name = $received_table->info('name');
			$received_select = $received_table->select()
				->from($received_name, array('suggestion_id'))
				->where('owner_id = ?', $user_id)
				->where('entity = ?', 'forum')
				->where('entity_id = ?', $forum_id);
			$fetch_array = $received_select->query()->fetchAll();
			if(!empty($fetch_array))
			{
				// Deleting the suggestion for this forum when it is viewed
				Engine_Api::_()->getItem('suggestion', $fetch_array[0]['suggestion_id'])->delete();
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $fetch_array[0]['suggestion_id'], 'type = ?' => 'forum_suggestion'));
			}
		}
		
		// Module : Suggest Photo.
		// Event : Set session variable.
		// Description : When a user clicks on the button for Profile photo suggestion in suggestion listing page.	
		if(isset($session->check_photo_id))
		{
			if ($module == 'core' && $action == 'success') {
				$session->sugg_photo_id = $session->check_photo_id;
			}
			unset($session->check_photo_id);
		}
		
		// Module : Suggest Photo.
		// Event : Delete Suggestion.
		// Description : If the user accepts to make the suggested photo his profile photo.
		if(isset($session->sugg_photo_id))
		{
			Engine_Api::_()->getItem('suggestion_photo', $session->sugg_photo_id['entity_id'])->delete();
			Engine_Api::_()->getItem('suggestion', $session->sugg_photo_id['suggestion_id'])->delete();
			Engine_Api::_()->getItem('suggestion_album', $session->sugg_photo_id['suggestion_id'])->delete();		
			unset($session->sugg_photo_id);
		}
	}	
}