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
class Suggestion_Widget_SuggestionVideoController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.video.wid');
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			//Fetch video.
			if($user_id != 0)
			{ //@todo : admin value
				$this->view->video_display = $video = Engine_Api::_()->suggestion()->video_loggedin_suggestions('', $number_of_sugg, 'video');
			}
			else 
			{
				//@todo : admin value
				$this->view->video_display = $video = Engine_Api::_()->suggestion()->video_loggedout_suggestions('', $number_of_sugg, 'video');
				// Anonymous users are not to be shown the crosses
				$this->view->signup_user = $this->view->translate("sign_up");
			}
			if(!empty($video))
			{
				$this->view->video_info = Engine_Api::_()->suggestion()->video_info($video);
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