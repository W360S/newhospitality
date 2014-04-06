<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Menus.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_Plugin_Menus
{
  public function onMenuInitialize_SuggestionFindFriend($row)
  {  	
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
  		$route = 'friends_suggestions_viewall';
  	}
  	else {
  		$route = '';
  	}
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    if( $viewer->getIdentity() )
    {
      return array(
        'label' => $row->label,
        'icon' => $row->params['icon'],
        'route' => 'friends_suggestions_viewall'
      );
    }
    return false;
  }
  
  public function onMenuInitialize_SuggestionExploreSuggestion($row)
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
  		$route = 'sugg_explore_friend';
  	}
  	else {
  		$route = '';
  	}
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    if( $viewer->getIdentity() )
    {
      return array(
        'label' => $row->label,
        'icon' => $row->params['icon'],
        'route' => 'sugg_explore_friend'
      );
    }
    return false;
  }
  
  public function onMenuInitialize_SuggestionFriendProfile($row)
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
  		$route = 'friends_suggestions_viewall';
  	}
  	else {
  		$route = '';
  	}
    $viewer = Engine_Api::_()->user()->getViewer();
    $subject = Engine_Api::_()->core()->getSubject();
  	if($subject->authorization()->isAllowed($viewer, 'edit'))
  	{
      return array(
        'label' => $row->label,
        'icon' => $row->params['icon'],
        'route' => 'friends_suggestions_viewall'
      );
  	}
  }
}