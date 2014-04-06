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
class Suggestion_Widget_SuggestionmusicController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {	
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.music.wid');
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			//Fetch music.
			if($user_id != 0)
			{ //@todo : admin value
				$this->view->music_display = $music = Engine_Api::_()->suggestion()->music_loggedin_suggestions('', $number_of_sugg, 'music');
			}
			else 
			{
				//@todo : admin value
				$this->view->music_display = $music = Engine_Api::_()->suggestion()->music_loggedout_suggestions('', $number_of_sugg, 'music');
				// Anonymous users are not to be shown the crosses
				$this->view->signup_user = $this->view->translate("sign_up");
			}
			if(!empty($music))
			{
				$this->view->music_info = Engine_Api::_()->suggestion()->music_info($music);
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