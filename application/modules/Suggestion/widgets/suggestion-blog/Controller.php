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
class Suggestion_Widget_SuggestionBlogController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.blog.wid');
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			//Fetch blog.
			if($user_id != 0)
			{ //@todo : admin value
				$this->view->blog_display = $blog = Engine_Api::_()->suggestion()->blog_loggedin_suggestions('', $number_of_sugg, 'blog');
			}
			else 
			{
				$this->view->blog_display = $blog = Engine_Api::_()->suggestion()->blog_loggedout_suggestions('', $number_of_sugg, 'blog');
				// Anonymous users are not to be shown the crosses
				$this->view->signup_user = $this->view->translate("sign_up");
			}
			if(!empty($blog))
			{
				$this->view->blog_info = Engine_Api::_()->suggestion()->blog_info($blog);
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