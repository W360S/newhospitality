<?php 
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: manifest.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

return array(
  // Package -------------------------------------------------------------------
  
    'package' => array(
    'type' => 'module',
    'name' => 'suggestion',
    'version' => '4.0.5',
    'path' => 'application/modules/Suggestion',
    'repository' => 'null',
    'meta' => array(
      'title' => 'Suggestions / Recommendations',
      'description' => 'This plugin provides you the best tools to increase user engagement on your Social Network. This highly customizable plugin enables your site to recommend various content and friends to users, just like Facebook does, and is arguably the most useful social graph feature for your Social Network. The algorithms behind the suggestions are based on user relevance, and highlight content and people that the users might actually be interested in.',
      'author' => 'SocialEngineAddOns',
      'date' => 'Tuesday, 17 Aug 2010 18:33:08 +0000',
      'copyright' => 'Copyright 2009-2010 BigStep Technologies Pvt. Ltd.'
    ),
    'actions' => array(
    	'install',
      'upgrade',
      'refresh',
      'enable',
      'disable',
    ),
    'callback' => array(
      'path' => 'application/modules/Suggestion/settings/install.php',
      'class' => 'Suggestion_Installer',
    ),
    'directories' => array(
    	'application/modules/Suggestion',
    ),
    'files' => array(
      'application/languages/en/suggestion.csv',
    ),
  ),
  
  // Hooks ---------------------------------------------------------------------
  'hooks' => array(
    array(
      'event' => 'onUserDeleteBefore',
      'resource' => 'Suggestion_Plugin_Core',
    ),
    array(
      'event' => 'addActivity',
      'resource' => 'Suggestion_Plugin_Core',
    ),
    array(
      'event' => 'onUserCreateAfter',
      'resource' => 'Suggestion_Plugin_Core',
    ),
    array(
      'event' => 'onItemDeleteAfter',
      'resource' => 'Suggestion_Plugin_Core',
    )
  ),
  // Items ---------------------------------------------------------------------
  'items' => array(
    'suggestion',
    'rejected',
    'groupinfo',
    'eventinfo',
    'like',
    'comment',
    'tag',
    'rating',
    'recipient',    
    'suggestion_photo',
    'suggestion_album',
    'introduction'
  ),
  // Routes --------------------------------------------------------------------
  'routes' => array(
    'friends_request_viewall' => array(
  		'route' => 'suggestions/friendrequest',
  		'defaults' => array(
  			'module' => 'suggestion',
      	'controller' => 'index',
      	'action' => 'friendrequest'
  		)
  	),
  	'friends_suggestions_viewall' => array(
  		'route' => 'suggestions/friends_suggestions',
  		'defaults' => array(
  			'module' => 'suggestion',
      	'controller' => 'index',
      	'action' => 'viewfriendsuggestion'
  		)
  	),
  	
		'suggestions_display' => array(
			'route' => 'suggestions/viewall',
			'defaults' => array(
				'module' => 'suggestion',
	    	'controller' => 'index',
	    	'action' => 'viewall'
			)
		),
  	
    'received_suggestion' => array(
      'route' => 'suggestions/view/:sugg_id',
      'defaults' => array(
        'module' => 'suggestion',
        'controller' => 'index',
        'action' => 'view'
      )
    ),
    
		'suggestion_admin_widget_setting' => array(
		      'route' => 'admin/suggestion/settings/id/:sugg_select',
		      'defaults' => array(
		        'module' => 'suggestion',
		        'controller' => 'admin-settings',
		        'action' => 'index'     
		      )
		 ),
  
  	'sugg_explore_friend' => array(
  		'route' => 'suggestions/explore',
  		'defaults' => array(
  			'module' => 'suggestion',
      	'controller' => 'index',
      	'action' => 'explore'
  		)
  	)
  )
)
?>