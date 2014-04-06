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
class Suggestion_Widget_ExploreFriendController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Pass the base url to index.tpl.
	  	$this->view->base_url = Zend_Controller_Front::getInstance()->getBaseUrl();
	  	// Geting number of display suggestion which are set by admin?  	
	  	$this->view->sugg_baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();// Set base url which are used in view file.
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$mix_array = array();
			
			if($user_id != 0)
			{ 
				$this->view->mix_wid_dis_num  = $mix_sugg = Engine_Api::_()->suggestion()->mix_suggestions('', 30, 'logged_in');
			}
			else {
				return $this->setNoRender();
			}
			// Final mix widget array with randum value.
			if(!empty($mix_sugg))
			{
				foreach($mix_sugg as $row_mix_sugg)
				{
					// Hold the value with key for detail.
					$widget_value_array = $row_mix_sugg;
					$array_sugg_key = array_keys($row_mix_sugg);
					if(!empty($array_sugg_key[0])) // Condition for undefine offset.
					{
						$row_mix = explode("_", $array_sugg_key[0]);
						$function_name = $row_mix[0] . '_info';
						$mix_array[$row_mix[0] . '_' . $row_mix[1]] = Engine_Api::_()->suggestion()->$function_name($widget_value_array);
					}
				}
			}
			if(!empty($mix_array))
			{
				$this->view->mix_display_sugg = $mix_array; 			
			}
			else 
			{
				$this->view->empty_message = $empty_message = "<div class='tip'><span> " . $this->view->translate("You do not have any suggestions currently.") . "</span></div>";
			}
  	}
  	else {
  		return $this->setNoRender();
  	}
  }
}
?>