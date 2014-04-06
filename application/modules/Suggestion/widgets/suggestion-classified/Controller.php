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
class Suggestion_Widget_SuggestionClassifiedController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.classified.wid');
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			//Fetch classified.
			if($user_id != 0)
			{ //@todo : admin value
				$this->view->classified_display = $classified = Engine_Api::_()->suggestion()->classified_loggedin_suggestions('', $number_of_sugg, 'classified');
			}
			else 
			{
				$this->view->classified_display = $classified = Engine_Api::_()->suggestion()->classified_loggedout_suggestions('', $number_of_sugg, 'classified');
				// Anonymous users are not to be shown the crosses
				$this->view->signup_user = $this->view->translate("sign_up");
			}
			if(!empty($classified))
			{
				$this->view->classified_info = Engine_Api::_()->suggestion()->classified_info($classified);
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