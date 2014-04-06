<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: install.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Installer extends Engine_Package_Installer_Module
{
  function onInstall()
  {
    //
    // install content areas
    //
    $db     = $this->getDb();
    // Querys only for if upgrade the suggestion module then check name in database and update row.
    // Change introduction name.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_menuitems')
      ->where('name = ?', 'suggestion_admin_main_introduction');
    $check_intro = $select->query()->fetchObject();
    if(!empty($check_intro))
    {
	  	$db->update('engine4_core_menuitems', array(
	  			'name'    => 'suggestion_introduction'
		    ), array('name =?' => 'suggestion_admin_main_introduction'));
    }

    // Change admin main settings name.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_menuitems')
      ->where('name = ?', 'suggestion_admin_main_settings');
    $check_setting = $select->query()->fetchObject();
    if(!empty($check_setting))
    {
	  	$db->update('engine4_core_menuitems', array(
	  			'name'    => 'suggestion_admin_settings'
		    ), array('name =?' => 'suggestion_admin_main_settings'));
    }

    // Change admin global name.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_menuitems')
      ->where('name = ?', 'suggestion_admin_main_global');
    $check_global = $select->query()->fetchObject();
    if(!empty($check_global))
    {
	  	$db->update('engine4_core_menuitems', array(
	  			'name'    => 'suggestion_admin_global'
		    ), array('name =?' => 'suggestion_admin_main_global'));
    }

    // Change module name.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_menuitems')
      ->where('name = ?', 'core_admin_main_plugins_suggesti');
    $check_module_name = $select->query()->fetchObject();
    if(!empty($check_module_name))
    {
	  	$db->update('engine4_core_menuitems', array(
	  			'name'    => 'module_suggestion'
		    ), array('name =?' => 'core_admin_main_plugins_suggesti'));
    }

    // Change profile name.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_menuitems')
      ->where('name = ?', 'suggestion_find_friend_profile');
    $check_profile = $select->query()->fetchObject();
    if(!empty($check_profile))
    {
	  	$db->update('engine4_core_menuitems', array(
	  			'name'    => 'suggestion_friend_profile'
		    ), array('name =?' => 'suggestion_find_friend_profile'));
    }


    // Check in module table that "People you may know" plugin should be disable.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_modules')
      ->where('name = ?', 'peopleyoumayknow')
      ->where('enabled = ?', '1');
    $page_id_temp = $select->query()->fetchObject();
    if(!empty($page_id_temp))
    {
    	$base_url = Zend_Controller_Front::getInstance()->getBaseUrl();
    	return $this->_error('<span style="color:red">Note: You already have the "People you may know / Friend Suggestions & Inviter" module/plugin installed on your site. Please disable the "People you may know / Friend Suggestions & Inviter" module/plugin and then install this plugin.</span><br/> <a href="' . $base_url . '/manage">Click here</a> to go Manage Packages.');
    }

    // Check Group module if available then add widget in this page.
    $select = new Zend_Db_Select($db);
    $select
      ->from('engine4_core_pages')
      ->where('name = ?', 'group_profile_index')
      ->limit(1);
    $page_id_temp = $select->query()->fetchObject();
    // If page available in "core_page" table.
    if(!empty($page_id_temp))
    {
    	$page_id = $page_id_temp->page_id;
    	// Check that "Group suggestion widget" should not be there.
	    $select = new Zend_Db_Select($db);
	    $select
	      ->from('engine4_core_content')
	      ->where('page_id = ?', $page_id)
	      ->where('type = ?', 'widget')
	      ->where('name = ?', 'Suggestion.suggestion-group')
	      ;
	    $info = $select->query()->fetch();
	    // "Group Suggestion" widget not available in "core_content" table.
	    if( empty($info) )
	    {
	      // Main container_id (will always be there)
	      $select = new Zend_Db_Select($db);
	      $select
	        ->from('engine4_core_content')
	        ->where('page_id = ?', $page_id)
	        ->where('type = ?', 'container')
	        ->limit(1);
	      $container_id = $select->query()->fetchObject()->content_id;

	      // Tack left container id (will always be there)
	      $select = new Zend_Db_Select($db);
	      $select
	        ->from('engine4_core_content')
	        ->where('parent_content_id = ?', $container_id)
	        ->where('type = ?', 'container')
	        ->where('name = ?', 'left')
	        ->limit(1);
	      $left_id = $select->query()->fetchObject()->content_id;

	      $db->insert('engine4_core_content', array(
	        'page_id' => $page_id,
	        'type'    => 'widget',
	        'name'    => 'Suggestion.suggestion-group',
	        'parent_content_id' => $left_id,
	        'order'   => 3,
	        'params'  => '{"title":"Recommended Groups"}',
	      ));
	    }
    }


    // Check Event module if available then add widget in this page.
    $select = new Zend_Db_Select($db);
    $select
      ->from('engine4_core_pages')
      ->where('name = ?', 'event_profile_index')
      ->limit(1);
    $page_id_temp = $select->query()->fetchObject();
    // If page available in "core_page" table.
    if(!empty($page_id_temp))
    {
    	$page_id = $page_id_temp->page_id;
    	// Check that "Event suggestion widget" should not be there.
	    $select = new Zend_Db_Select($db);
	    $select
	      ->from('engine4_core_content')
	      ->where('page_id = ?', $page_id)
	      ->where('type = ?', 'widget')
	      ->where('name = ?', 'Suggestion.suggestion-event')
	      ;
	    $info = $select->query()->fetch();
	    // "Event Suggestion" widget not available in "core_content" table.
	    if( empty($info) )
	    {
	      // Main container_id (will always be there)
	      $select = new Zend_Db_Select($db);
	      $select
	        ->from('engine4_core_content')
	        ->where('page_id = ?', $page_id)
	        ->where('type = ?', 'container')
	        ->limit(1);
	      $container_id = $select->query()->fetchObject()->content_id;

	      // Tack left container id (will always be there)
	      $select = new Zend_Db_Select($db);
	      $select
	        ->from('engine4_core_content')
	        ->where('parent_content_id = ?', $container_id)
	        ->where('type = ?', 'container')
	        ->where('name = ?', 'left')
	        ->limit(1);
	      $left_id = $select->query()->fetchObject()->content_id;

	      $db->insert('engine4_core_content', array(
	        'page_id' => $page_id,
	        'type'    => 'widget',
	        'name'    => 'Suggestion.suggestion-event',
	        'parent_content_id' => $left_id,
	        'order'   => 3,
	        'params'  => '{"title":"Recommended Events"}',
	      ));
	    }
    }

    // Create Explore Suggestion Page for admin.
    // Check if it's already been placed
    $select = new Zend_Db_Select($db);
    $select
      ->from('engine4_core_pages')
      ->where('name = ?', 'suggestion_index_explore')
      ->limit(1);
    $info = $select->query()->fetch();
    if( empty($info) )
    {
      $db->insert('engine4_core_pages', array(
        'name' => 'suggestion_index_explore',
        'displayname' => 'Explore Suggestions Page',
        'title' => 'Explore Suggestion',
        'description' => 'This is the explore suggestion page which show mix suggestion.',
      ));
      $page_id = $db->lastInsertId('engine4_core_pages');

      // Now create the "Main Containers".
      $db->insert('engine4_core_content', array(
        'page_id' => $page_id,
        'type' => 'container',
        'name' => 'main',
        'parent_content_id' => null,
        'order' => 1,
        'params' => '',
      ));
      $container_id = $db->lastInsertId('engine4_core_content');

      // Create the "Middle Containers".
      $db->insert('engine4_core_content', array(
        'page_id' => $page_id,
        'type' => 'container',
        'name' => 'middle',
        'parent_content_id' => $container_id,
        'order' => 6,
        'params' => '',
      ));
      $middle_id = $db->lastInsertId('engine4_core_content');

      // Create the "Right Containers".
      $db->insert('engine4_core_content', array(
        'page_id' => $page_id,
        'type' => 'container',
        'name' => 'right',
        'parent_content_id' => $container_id,
        'order' => 5,
        'params' => '',
      ));
      $right_id = $db->lastInsertId('engine4_core_content');

      // Insert the widget in "Middle Containers".
      $db->insert('engine4_core_content', array(
        'page_id' => $page_id,
        'type' => 'widget',
        'name' => 'Suggestion.explore-friend',
        'parent_content_id' => $middle_id,
        'order' => 3,
        'params' => '{"title":"Explore Suggestions"}',
      ));

      // Insert the widget in "Right Containers".
      $db->insert('engine4_core_content', array(
        'page_id' => $page_id,
        'type' => 'widget',
        'name' => 'Suggestion.suggestion-friend',
        'parent_content_id' => $right_id,
        'order' => 5,
        'params' => '{"title":"People you may know"}	',
      ));
    }

    // Insert the "Mix Widget" & "People you may know Widget" for "Member Home Page"
    $select = new Zend_Db_Select($db);
    $select
      ->from('engine4_core_pages')
      ->where('name = ?', 'user_index_home')
      ->limit(1);
    $page_id = $select->query()->fetchObject()->page_id;
    if(!empty($page_id))
    {
      // Find out the "Main Container ID".
      $select = new Zend_Db_Select($db);
      $select
        ->from('engine4_core_content')
        ->where('page_id = ?', $page_id)
        ->where('type = ?', 'container')
        ->limit(1);
      $container_id = $select->query()->fetchObject()->content_id;

      // Find out the "Right Content ID".
      $select = new Zend_Db_Select($db);
      $select
        ->from('engine4_core_content')
        ->where('parent_content_id = ?', $container_id)
        ->where('type = ?', 'container')
        ->where('name = ?', 'right')
        ->limit(1);
      $right_id = $select->query()->fetchObject()->content_id;


	    // Check the "People You May Know Widget", if it's already been placed
	    $select = new Zend_Db_Select($db);
	    $select
	      ->from('engine4_core_content')
	      ->where('page_id = ?', $page_id)
	      ->where('type = ?', 'widget')
	      ->where('name = ?', 'Suggestion.suggestion-friend');
	    $info = $select->query()->fetch();
	    // If "People You May Know" widget not available in table.
	    if( empty($info) && !empty($right_id))
	    {
	      // Set "People You May Know" widget
	      $db->insert('engine4_core_content', array(
	        'page_id' => $page_id,
	        'type'    => 'widget',
	        'name'    => 'Suggestion.suggestion-friend',
	        'parent_content_id' => $right_id,
	        'order'   => 1,
	        'params'  => '{"title":"People you may know"}',
	      ));
	    }
	    else if(empty($right_id) && !empty($info)){
	    	$db->delete('engine4_core_content', array('page_id = ?' => $page_id, 'name = ?' => 'Suggestion.suggestion-friend'));
	    }

	    // Check the "Mix Widget", if it's already been placed
	    $select = new Zend_Db_Select($db);
	    $select
	      ->from('engine4_core_content')
	      ->where('page_id = ?', $page_id)
	      ->where('type = ?', 'widget')
	      ->where('name = ?', 'Suggestion.suggestion-mix')
	      ;
	    $info = $select->query()->fetch();
	    // If "Mix" widget not available in table.
	    if( empty($info) && !empty($right_id))
	    {
	      // Set "Mix" widget
	      $db->insert('engine4_core_content', array(
	        'page_id' => $page_id,
	        'type'    => 'widget',
	        'name'    => 'Suggestion.suggestion-mix',
	        'parent_content_id' => $right_id,
	        'order'   => 2,
	        'params'  => '{"title":"Recommendations"}',
	      ));
	    }
	    else if(empty($right_id) && !empty($info)){
	    	$db->delete('engine4_core_content', array('page_id = ?' => $page_id, 'name = ?' => 'Suggestion.suggestion-mix'));
	    }
    }
    // Insert the "Mix Widget"  for "Home Page"
    $select = new Zend_Db_Select($db);
    $select
      ->from('engine4_core_pages')
      ->where('name = ?', 'core_index_index')
      ->limit(1);
    $page_id = $select->query()->fetchObject()->page_id;
    if(!empty($page_id))
    {
      // Find out the "Main Container ID".
      $select = new Zend_Db_Select($db);
      $select
        ->from('engine4_core_content')
        ->where('page_id = ?', $page_id)
        ->where('type = ?', 'container')
        ->limit(1);
      $container_id = $select->query()->fetchObject()->content_id;

      // Find out the "Right Content ID".
      $select = new Zend_Db_Select($db);
      $select
        ->from('engine4_core_content')
        ->where('parent_content_id = ?', $container_id)
        ->where('type = ?', 'container')
        ->where('name = ?', 'right')
        ->limit(1);
      $right_id = $select->query()->fetchObject()->content_id;

	    // Check the "Mix Widget", if it's already been placed
	    $select = new Zend_Db_Select($db);
	    $select
	      ->from('engine4_core_content')
	      ->where('page_id = ?', $page_id)
	      ->where('type = ?', 'widget')
	      ->where('name = ?', 'Suggestion.suggestion-mix')
	      ;
	    $info = $select->query()->fetch();
	    // If "Mix" widget not available in table.
	    if( empty($info) && !empty($right_id))
	    {
	      // Set "Mix" widget
	      $db->insert('engine4_core_content', array(
	        'page_id' => $page_id,
	        'type'    => 'widget',
	        'name'    => 'Suggestion.suggestion-mix',
	        'parent_content_id' => $right_id,
	        'order'   => 2,
	        'params'  => '{"title":"Recommendations"}',
	      ));
	    }
	    else if(empty($right_id) && !empty($info)){
	    	$db->delete('engine4_core_content', array('page_id = ?' => $page_id, 'name = ?' => 'Suggestion.suggestion-mix'));
	    }
    }

		$suggestion_identity = hash('ripemd160', 'suggestion');

    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_settings')
      ->where('name = ?', 'suggestion.identity');
    $page_id_temp = $select->query()->fetchObject();
		if(empty($page_id_temp))
		{
	    $db->insert('engine4_core_settings', array(
	      'name' => 'suggestion.identity',
	      'value'    => $suggestion_identity,
	    ));
		}

    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_settings')
      ->where('name = ?', 'suggestion.modulename');
    $page_id_temp = $select->query()->fetchObject();
		if(empty($page_id_temp))
		{
	    $db->insert('engine4_core_settings', array(
	      'name' => 'suggestion.modulename',
	      'value'    => 'nulled by therealeasy',
	    ));
		}

		// Check status of "friend_suggestion" in "engine4_activity_notificationtypes" table becouse "friend_suggestion used by "People You May Know Module" also".
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_activity_notificationtypes')
      ->where('type = ?', 'friend_suggestion');
    $page_id_temp = $select->query()->fetchObject();
    if(empty($page_id_temp))
    {
      $db->insert('engine4_activity_notificationtypes', array(
        'type' => 'friend_suggestion',
        'module'    => 'suggestion',
        'body'    => '{item:$subject} has suggested to you a {item:$object:friend}.',
        'is_request' => 1,
        'handler'   => 'suggestion.widget.request-friend'
      ));
    }
    else {
	  	$db->update('engine4_activity_notificationtypes', array(
	  			'module'    => 'suggestion',
		      'handler' => 'suggestion.widget.request-friend'
		    ), array('type =?' => 'friend_suggestion'));
    }

    // Insert in "engine4_core_mailtemplates" table for email.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_mailtemplates')
      ->where('type = ?', 'notify_suggest_friend');
    $page_id_temp = $select->query()->fetchObject();
    if(empty($page_id_temp))
    {
      $db->insert('engine4_core_mailtemplates', array(
        'type' => 'notify_suggest_friend',
        'vars'    => '[suggestion_sender], [suggestion_entity], [email]',
      ));
    }

		$activity_name = sha1("suggestion");
		$activity_string = substr($activity_name, 5, 6) . '_' . substr($activity_name, 15, 6) . '_' . substr($activity_name, 25, 6);
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_settings')
      ->where('name = ?', 'suggestion.licensekey');
    $page_id_temp = $select->query()->fetchObject();
		if(empty($page_id_temp))
		{
	    $db->insert('engine4_core_settings', array(
	      'name' => 'suggestion.licensekey',
	      'value'    => $activity_string,
	    ));
		}

    parent::onInstall();
  }

  function onDisable()
  {
  	$db     = $this->getDb();
    $db->delete('engine4_suggestion_albums');
    $db->delete('engine4_suggestion_photos');
    $db->delete('engine4_suggestion_suggestions');
    $db->delete('engine4_activity_notifications', array('object_type = ?' => 'suggestion'));
    parent::onDisable();
  }

  function onEnable()
  {
  	$db     = $this->getDb();
  	// Check that "People You May Know" plugin should be disable.
    $select = new Zend_Db_Select($db);
   	$select
      ->from('engine4_core_modules')
      ->where('name = ?', 'peopleyoumayknow')
      ->where('enabled =?', 1);
    $page_id_temp = $select->query()->fetchObject();
    if(!empty($page_id_temp))
    {
    	$base_url = Zend_Controller_Front::getInstance()->getBaseUrl();
    	echo '<span style="color:red">Note: You already have the "People you may know / Friend Suggestions & Inviter" module/plugin enabled. Please disable the "People you may know / Friend Suggestions & Inviter" module/plugin before enable this plugin.</span> <br/> <a href="' . $base_url . '/manage">Click here</a> to go Manage Packages.';die;
    }
  	else {
	  	// Update "friend_suggestion" notification type.
	    $select = new Zend_Db_Select($db);
	   	$select
	      ->from('engine4_activity_notificationtypes')
	      ->where('type = ?', 'friend_suggestion');
	    $page_id_temp = $select->query()->fetchObject();
	  	if(!empty($page_id_temp))
	  	{
		  	$db->update('engine4_activity_notificationtypes', array(
			      'module' => 'suggestion',
			      'handler' => 'suggestion.widget.request-friend'
			    ), array('type =?' => 'friend_suggestion'));
	  	}

	  	// Update "friend_request" notification type.
	    $select = new Zend_Db_Select($db);
	   	$select
	      ->from('engine4_activity_notificationtypes')
	      ->where('type = ?', 'friend_request');
	    $page_id_temp = $select->query()->fetchObject();
	  	if(!empty($page_id_temp))
	  	{
		  	$db->update('engine4_activity_notificationtypes', array(
			      'handler' => 'suggestion.widget.request-accept'
			    ), array('type =?' => 'friend_request'));
	  	}
  	}
   parent::onEnable();
  }
}
?>