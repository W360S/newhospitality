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
class Suggestion_Widget_SuggestionMixController extends Engine_Content_Widget_Abstract
{  	
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
	  	// Pass the base url to index.tpl.
	  	$this->view->base_url = Zend_Controller_Front::getInstance()->getBaseUrl();
	  	// Geting number of display suggestion which are set by admin?
	  	$number_of_sugg = Engine_Api::_()->getApi('settings', 'core')->getSetting('sugg.mix.wid');
	  	$this->view->sugg_baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();// Set base url which are used in view file.
			$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
			$mix_array = array();
			$mutual_friend_array = array();
			
			if($user_id != 0)
			{ 
				$this->view->mix_wid_dis_num  = $mix_sugg = Engine_Api::_()->suggestion()->mix_suggestions('', $number_of_sugg, 'logged_in');
				if(!empty($mix_sugg))
				{
					// For find out the "Number of Mutual Friend".
					foreach ($mix_sugg as $friend_info)
					{
						// Find out the key of friend.
						$friend_key = array_keys($friend_info);
						// In the "$friend_array", there are array where in 0 location "Module Name" and 1 location "Friend id".
						$friend_array = explode("_", $friend_key[0]);
						if($friend_array[0] == 'friend')
						{
							// Queary return the number of mutual friend which will display in "Mix Widget".
					    $friendsTable = Engine_Api::_()->getDbtable('membership', 'user');
					    $friendsName = $friendsTable->info('name');
					
					    $select = new Zend_Db_Select($friendsTable->getAdapter());
					    $select
					      ->from($friendsName, 'COUNT(' . $friendsName . '.user_id) AS friends_count')
					      ->join($friendsName, "`{$friendsName}`.`user_id`=`{$friendsName}_2`.user_id", null)
					      ->where("`{$friendsName}`.resource_id = ?", $friend_array[1]) // Id of Loggedin user friend.
					      ->where("`{$friendsName}_2`.resource_id = ?", $user_id) // Loggedin user Id.
					      ->where("`{$friendsName}`.active = ?", 1)
					      ->where("`{$friendsName}_2`.active = ?", 1)
					      ->group($friendsName . '.resource_id');
					    $fetch_mutual_friend = $select->query()->fetchAll();
					    if(!empty($fetch_mutual_friend))
					    {
					    	$mutual_friend_array[$friend_array[1]] = $fetch_mutual_friend[0]['friends_count'];
					    }
						}
					}
					$this->view->mutual_friend_array = $mutual_friend_array;
				}
			}
			else 
			{
				$this->view->mix_suggestion = $mix_sugg = Engine_Api::_()->suggestion()->mix_suggestions('', $number_of_sugg, 'logged_out');
				// Anonymous users are not to be shown the crosses
				$this->view->signup_user = $this->view->translate('sign_up');
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
				return $this->setNoRender();
			}
  	}
  	else {
  		return $this->setNoRender();
  	}
  }
}
?>