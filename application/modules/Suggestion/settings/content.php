<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: content.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

// Fetch all plugin which are enable.
$enabledModuleNames = Engine_Api::_()->getDbtable('modules', 'core')->getEnabledModuleNames();

//Condition for "Group" plugin. The Groups suggestion widget should be shown in admin layout editor only if the Groups plugin is enabled on site. Otherwise, we change its heading.
if(in_array("group", $enabledModuleNames) == 1)
{
	$group = array(
	'title' => $this->view->translate('Recommended Groups'),
	'description' => $this->view->translate('This widget shows the Group Suggestions.'),
	'category' => $this->view->translate( 'Suggestions'),
	'type' => 'widget',
	'name' => 'Suggestion.suggestion-group',
	'defaultParams' => array(
		'title' => $this->view->translate('Recommended Groups')
	 )
  );
}
else {
	$group = array(
	'title' => $this->view->translate('Recommended Groups [Disabled]'),
	'description' => $this->view->translate('This widget is disabled because the Group Module has not been enabled on this site.'),
	'category' => $this->view->translate( 'Suggestions'),
	'type' => 'widget',
	'name' => 'Suggestion.suggestion-group',
	'defaultParams' => array(
		'title' => $this->view->translate('Recommended Groups [Disabled]')
	 )
  );
}

//Condition for "Classified" plugin.
if(in_array("classified", $enabledModuleNames) == 1)
{
	$classified = 	array(
		'title' => $this->view->translate('Recommended Classifieds'),
		'description' => $this->view->translate('This widget shows the Classified Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-classified',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Classifieds')
		)
	);
}
else {
	$classified = 	array(
		'title' => $this->view->translate('Recommended Classifieds [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Classified Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-classified',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Classifieds [Disabled]')
		)
	);
}

//Condition for "Video" plugin.
if(in_array("video", $enabledModuleNames) == 1)
{
	$video = 	array(
		'title' => $this->view->translate('Recommended Videos'),
		'description' => $this->view->translate('This widget shows the Video Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-video',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Videos')
		)
	);
}
else {
	$video = 	array(
		'title' => $this->view->translate('Recommended Videos [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Video Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-video',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Videos [Disabled]')
		)
	);
}

//Condition for "Blog" plugin.
if(in_array("blog", $enabledModuleNames) == 1)
{
	$blog = 	array(
		'title' => $this->view->translate('Recommended Blogs'),
		'description' => $this->view->translate('This widget shows the Blog Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-blog',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Blogs')
		)
	);
}
else {
	$blog = 	array(
		'title' => $this->view->translate('Recommended Blogs [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Blog Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-blog',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Blogs [Disabled]')
		)
	);
}

//Condition for "Event" plugin.
if(in_array("event", $enabledModuleNames) == 1)
{
	$event = 	array(
		'title' => $this->view->translate('Recommended Events'),
		'description' => $this->view->translate('This widget shows the Event Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-event',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Events')
		)
	);
}
else {
	$event = 	array(
		'title' => $this->view->translate('Recommended Events [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Event Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-event',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Events [Disabled]')
		)
	);
}

//Condition for "Album" plugin.
if(in_array("album", $enabledModuleNames) == 1)
{
	$album = 	array(
		'title' => $this->view->translate('Recommended Albums'),
		'description' => $this->view->translate('This widget shows the Album Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-album',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Albums')
		)
	); 
}
else {
	$album = 	array(
		'title' => $this->view->translate('Recommended Albums [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Album Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-album',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Albums [Disabled]')
		)
	);
}

//Condition for "Music" plugin.
if(in_array("music", $enabledModuleNames) == 1)
{
	$music = 	array(
		'title' => $this->view->translate('Recommended Music'),
		'description' => $this->view->translate('This widget shows the Music Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-music',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Music')
		)
	);
}
else {
	$music = 	array(
		'title' => $this->view->translate('Recommended Music [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Music Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-music',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Music [Disabled]')
		)
	);
}

//Condition for "poll" plugin.
if(in_array("poll", $enabledModuleNames) == 1)
{
	$poll = 	array(
		'title' => $this->view->translate('Recommended Polls'),
		'description' => $this->view->translate('This widget shows the Poll Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-poll',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Polls')
		)
	);
}
else {
	$poll = 	array(
		'title' => $this->view->translate('Recommended Polls [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Poll Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-poll',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Polls [Disabled]')
		)
	);
}

//Condition for "forum" plugin.
if(in_array("forum", $enabledModuleNames) == 1)
{
	$forum = 	array(
		'title' => $this->view->translate('Recommended Forum Topics'),
		'description' => $this->view->translate('This widget shows the Forum Topic Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-forum',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Forum Topics')
		)
	);
}
else {
	$forum = 	array(
		'title' => $this->view->translate('Recommended Forum Topics [Disabled]'),
		'description' => $this->view->translate('This widget is disabled because the Forum Module has not been enabled on this site.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-forum',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommended Forum Topics [Disabled]')
		)
	);
}
	
return array(
	$group,
	$classified,
	$video,
	$blog,
	$event,
	$album,
	$music,
	$poll,
	$forum,
	
	array(
		'title' => $this->view->translate('People you may know'),
		'description' => $this->view->translate('This widget shows the Friend Suggestions.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-friend',
		'defaultParams' => array(
			'title' => $this->view->translate('People you may know')
		)
	),
	 
	array(
		'title' => $this->view->translate('Recommendations'),
		'description' => $this->view->translate('The suggestions shown in this widget are a mix of the various suggestion types. You may configure settings for this widget from the Mixed Suggestions tab of the Suggestions section of Admin Panel.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.suggestion-mix',
		'defaultParams' => array(
			'title' => $this->view->translate('Recommendations')
		)
	),
	
	array(
		'title' => $this->view->translate('Explore Suggestions'),
		'description' => $this->view->translate('This widget shows the Mixed Suggestions to a user. The suggestions shown in this widget are a mix of the various suggestion types. You may configure settings for this widget from the Mixed Suggestions tab of the Suggestions section of Admin Panel. The primary place for this widget is at the left side of Explore Suggestions Page.'),
		'category' => $this->view->translate( 'Suggestions'),
		'type' => 'widget',
		'name' => 'Suggestion.explore-friend',
		'defaultParams' => array(
			'title' => $this->view->translate('Explore Suggestions')
		)
	)	
) 
?>