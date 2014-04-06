<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: Controller.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_Widget_SuggestionEventController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.event.wid');
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			//Fetch group.
			if($user_id != 0)
			{
				$this->view->event_display = $event = Engine_Api::_()->suggestion()->event_loggedin_suggestions('', $number_of_sugg, 'event');
			}
			else 
			{
				$this->view->event_display = $event = Engine_Api::_()->suggestion()->event_loggedout_suggestions('', $number_of_sugg, 'event');
				$this->view->event_signup_user = $this->view->translate("sign_up");
			}
			if(!empty($event))
			{
				$this->view->event_info = Engine_Api::_()->suggestion()->event_info($event);
			}
			else {
				return $this->setNoRender();
			}
  	}
  	else {
  		return $this->setNoRender();
  	}
  }
}
?>