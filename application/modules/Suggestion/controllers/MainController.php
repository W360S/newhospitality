<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: MainController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_MainController extends Core_Controller_Action_User
{ 
  //Action Perform for Viewall. This function is called when a user clicks on "X" for a particular entry
  public function suggestionDisableAction()
  {
   //RECIEVE VALUE FROM AJAX
    $entity_id = (int) $this->_getParam('entity_id');
    $this->view->display_suggestion = $suggestion_count = (int) $this->_getParam('suggestion_display_count');
    $this->view->div_id = $div_id = (string) $this->_getParam('div_id');    
    $display_suggestion = (string) $this->_getParam('friend_displayed_suggestions');
    
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
   	//INSERT INFO IN DATABASE
   	$reject_suggestion = Engine_Api::_()->getItemTable('rejected');
   	$sugg = $reject_suggestion->createRow();
   	$sugg->owner_id = $user_id;
   	$sugg->entity = 'friend';
   	$sugg->entity_id = $entity_id;
   	$sugg->save();
    
    // "4" : because the friend suggestions are given till 3rd level
    // "1" : because this function is called via AJAX when a user clicks on "X" for an entry and only 1 new entry should be returned.
    $this->view->sugg_array = $new_user_array = Engine_Api::_()->suggestion()->suggestion_path($user_id, 4, $display_suggestion, 1);    

   	if(!empty($new_user_array))
   	{
	   	$this->view->new_user_obj = $new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
   	}
 }
  
	/* This function all when open the popup in the case of group and when cancel any friend.
	* @return Complete information for next (new) group suggestion.
	*/
	public function suggestionGroupAction()
	{
	 $div_id = (int) $this->_getParam('group_div_id');
	 $group_id = (int) $this->_getParam('session_group_id');
	 $userhome_users = (string) $this->_getParam('group_dis_sugg');
	
	 $new_user_array = Engine_Api::_()->suggestion()->group_suggestion($group_id, $userhome_users, 1);
	 $new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	 
	 $suggestion_home_user_id = $new_user_info[0]->user_id;
	 $suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'member_photo'));
	 $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle());
	
	 $suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newgroupSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'group\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	 
	 $suggestion_checkbox = '<input type="checkbox" onclick="groupSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	 
	 //RESPONCE FROM AJAX   
	 $suggestion_home_display = '<div class="suggestion_pop_friend"> ' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	 
	 $this->view->status = true;
	 $this->view->new_grp_popup_display = $suggestion_home_display;
	 $this->view->new_grp_popup_entityid = $suggestion_home_user_id;
	}
	 
	 /* This function all when open the popup in the case of event and when cancel any friend.
	 * @return Complete information for next (new) event suggestion.
	 */
	 public function suggestionEventAction()
	 {
	   $div_id = (int) $this->_getParam('event_div_id');
	   $event_id = (int) $this->_getParam('session_event_id');
	   $userhome_users = (string) $this->_getParam('event_popup_sugg');
	
	   $new_user_array = Engine_Api::_()->suggestion()->event_suggestion($event_id, $userhome_users, 1);
	   $new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   $suggestion_home_user_id = $new_user_info[0]->user_id;
	   $suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'member_photo'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle());
	
	   $suggestion_home_cancel = '<a class="suggest_cancel" title="' . $this->translate('Do not show this suggestion') . '" href="javascript:void(0);" onclick="neweventSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   $suggestion_checkbox = '<input type="checkbox" onclick="eventSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	   $suggestion_home_display = '<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   $this->view->status = true;
	   $this->view->new_event_popup_display = $suggestion_home_display;
	   $this->view->new_event_popup_entityid = $suggestion_home_user_id;
	 }
	 
	 /* This function all when open the popup in the case of blog and when cancel any friend.
	 * @return Complete information for next (new) blog suggestion.
	 */
	 public function suggestionBlogAction()
	 {
	  	$div_id = (int) $this->_getParam('blog_div_id');
	    $blog_id = (int) $this->_getParam('session_blog_id');
	    $userhome_users = (string) $this->_getParam('blog_dis_sugg');
	
	   	$new_user_array = Engine_Api::_()->suggestion()->blog_suggestion($blog_id, $userhome_users, 1);
	   	$new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   	$suggestion_home_user_id = $new_user_info[0]->user_id;
	   	$suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'popularmembers_thumb'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle()) . '<br />';
	
	   	$suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newblogSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   	$suggestion_checkbox = '<input type="checkbox" onclick="blogSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	    $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   	$this->view->status = true;
	   	$this->view->new_blog_popup_display = $suggestion_home_display;
	   	$this->view->new_blog_popup_entityid = $suggestion_home_user_id;
	 }
	 
	 /* This function all when open the popup in the case of album and when cancel any friend.
	 * @return Complete information for next (new) album suggestion.
	 */
	 public function suggestionAlbumAction()
	 {
	  	$div_id = (int) $this->_getParam('album_div_id');
	    $album_id = (int) $this->_getParam('session_album_id');
	    $userhome_users = (string) $this->_getParam('album_dis_sugg');
	
	   	$new_user_array = Engine_Api::_()->suggestion()->album_suggestion($album_id, $userhome_users, 1);
	   	$new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   	$suggestion_home_user_id = $new_user_info[0]->user_id;
	   	$suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'popularmembers_thumb'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle()) . '<br />';
	
	   	$suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newalbumSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   	$suggestion_checkbox = '<input type="checkbox" onclick="albumSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	    //RESPONCE FROM AJAX   
	    $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   	$this->view->status = true;
	   	$this->view->new_album_popup_display = $suggestion_home_display;
	   	$this->view->new_album_popup_entityid = $suggestion_home_user_id;
	 }
	  
	 /* This function all when open the popup in the case of classified and when cancel any friend.
	 * @return Complete information for next (new) classified suggestion.
	 */
	 public function suggestionClassifiedAction()
	 {
	   $div_id = (int) $this->_getParam('classified_div_id');
	   $classified_id = (int) $this->_getParam('session_classified_id');
	   $userhome_users = (string) $this->_getParam('classified_dis_sugg');
	
	   $new_user_array = Engine_Api::_()->suggestion()->classified_suggestion($classified_id, $userhome_users, 1);
	   $new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   $suggestion_home_user_id = $new_user_info[0]->user_id;
	   $suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'member_photo'));
	   $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle());
	
	   $suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newclassifiedSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   $suggestion_checkbox = '<input type="checkbox" onclick="classifiedSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	   $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   $this->view->status = true;
	   $this->view->new_classified_popup_display = $suggestion_home_display;
	   $this->view->new_classified_popup_entityid = $suggestion_home_user_id;
	 }
	  
	 /* This function all when open the popup in the case of video and when cancel any friend.
	 * @return Complete information for next (new) video suggestion.
	 */
	 public function suggestionVideoAction()
	 {
	   $div_id = (int) $this->_getParam('video_div_id');
	   $video_id = (int) $this->_getParam('session_video_id');
	   $userhome_users = (string) $this->_getParam('video_dis_sugg');
	
	   $new_user_array = Engine_Api::_()->suggestion()->video_suggestion($video_id, $userhome_users, 1);
	   $new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   $suggestion_home_user_id = $new_user_info[0]->user_id;
	   $suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'member_photo'));
	   $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle());
	
	   $suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newvideoSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   $suggestion_checkbox = '<input type="checkbox" onclick="videoSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	   $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   $this->view->status = true;
	   $this->view->new_video_popup_display = $suggestion_home_display;
	   $this->view->new_video_popup_entityid = $suggestion_home_user_id;
	 }
	 
	 /* This function all when open the popup in the case of music and when cancel any friend.
	 * @return Complete information for next (new) music suggestion.
	 */
	 public function suggestionMusicAction()
	 {
	  	$div_id = (int) $this->_getParam('music_div_id');
	    $music_id = (int) $this->_getParam('session_music_id');
	    $userhome_users = (string) $this->_getParam('music_dis_sugg');
	
	   	$new_user_array = Engine_Api::_()->suggestion()->music_suggestion($music_id, $userhome_users, 1);
	   	$new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   	$suggestion_home_user_id = $new_user_info[0]->user_id;
	   	$suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'member_photo'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle()) . '<br />';
	
	   	$suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newmusicSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   	$suggestion_checkbox = '<input type="checkbox" onclick="musicSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	   	$suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   	$this->view->status = true;
	   	$this->view->new_music_popup_display = $suggestion_home_display;
	   	$this->view->new_music_popup_entityid = $suggestion_home_user_id;
	 }
	 
	  /* This function all when open the popup in the case of poll and when cancel any friend.
	 * @return Complete information for next (new) poll suggestion.
	 */
	 public function suggestionPollAction()
	 {
	  	$div_id = (int) $this->_getParam('poll_div_id');
	    $poll_id = (int) $this->_getParam('session_poll_id');
	    $userhome_users = (string) $this->_getParam('poll_dis_sugg');
	
	   	$new_user_array = Engine_Api::_()->suggestion()->poll_suggestion($poll_id, $userhome_users, 1);
	   	$new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   	$suggestion_home_user_id = $new_user_info[0]->user_id;
	   	$suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'popularmembers_thumb'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle()) . '<br />';
	
	   	$suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newpollSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   	$suggestion_checkbox = '<input type="checkbox" onclick="pollSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	    $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   	$this->view->status = true;
	   	$this->view->new_poll_popup_display = $suggestion_home_display;
	   	$this->view->new_poll_popup_entityid = $suggestion_home_user_id;
	 }
	 
	  /* This function all when open the popup in the case of forum and when cancel any friend.
	 * @return Complete information for next (new) forum suggestion.
	 */
	 public function suggestionForumAction()
	 {
	  	$div_id = (int) $this->_getParam('forum_div_id');
	    $forum_id = (int) $this->_getParam('session_forum_id');
	    $userhome_users = (string) $this->_getParam('forum_dis_sugg');
	
	   	$new_user_array = Engine_Api::_()->suggestion()->forum_suggestion($forum_id, $userhome_users, 1);
	   	$new_user_info = Engine_Api::_()->suggestion()->suggestion_users_information($new_user_array, '');
	   
	   	$suggestion_home_user_id = $new_user_info[0]->user_id;
	   	
	   	$suggestion_home_image = $this->view->htmlLink($new_user_info[0]->getHref(), $this->view->itemPhoto($new_user_info[0], 'thumb.icon'), array('class' => 'popularmembers_thumb'));
	    $suggestion_home_displayname = $this->view->htmlLink($new_user_info[0]->getHref(), $new_user_info[0]->getTitle()) . '<br />';
	
	   	$suggestion_home_cancel = '<a class="suggest_cancel" href="javascript:void(0);" onclick="newforumSuggestion(\'' . $new_user_info[0]->user_id . '\', \'' . $div_id . '\', \'' . $new_user_info[0]->getTitle() . '\');"></a>';
	   
	   	$suggestion_checkbox = '<input type="checkbox" onclick="forumSelect(\'check_' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->user_id . '\', \'' . $new_user_info[0]->getTitle() . '\')" name="check_'.$new_user_info[0]->user_id.'" value="'.$new_user_info[0]->user_id.'" id="check_'.$new_user_info[0]->user_id.'" />';
	   
	  //RESPONCE FROM AJAX   
	    $suggestion_home_display ='<div class="suggestion_pop_friend">' . $suggestion_checkbox . '<div class="popup_member_photo">' . $suggestion_home_image . '</div><div class="title">' . $suggestion_home_cancel . '<b>' . $suggestion_home_displayname .'</b></div></div>';
	   
	   	$this->view->status = true;
	   	$this->view->new_forum_popup_display = $suggestion_home_display;
	   	$this->view->new_forum_popup_entityid = $suggestion_home_user_id;
	 }
	 
	 	/** This function use for delete the value from "suggestion" table in the case of, if click on Ignore button from "viewall page" or "view page" .
	 * @return Message.
	 */ //$table = Engine_Api::_()->getDbtable('suggestions', 'suggestion')->delete(array('suggestion_id = ?'=>$sugg_id));
	 public function suggestionCancelAction()
	 {
	    //RECIEVE VALUE FROM AJAX
	    $sugg_ids = (string) $this->_getParam('sugg_id');
	    $entity = (string) $this->_getParam('entity');
	    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
	    
	    $sender_id_array = explode(",", $sugg_ids);
	    //$sugg_row_obj = Engine_Api::_()->getDbtable('suggestions', 'suggestion');
	    foreach ($sender_id_array as $sugg_id)
	    {    
				// Delete from "Notification table" from update tab.
				Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_id, 'object_type = ?' => 'suggestion'));
				Engine_Api::_()->getDbtable('suggestions', 'suggestion')->delete(array('suggestion_id = ?'=>$sugg_id));
	    }
	    
	    $this->view->status = true;
	    $this->view->sugg_page = $entity;
	 		$this->view->suggestion_msg = 'Suggestion has been removed successfully.';
	 }
	 
	 
	 	/** This function use in "All widget" suggestion, this function cancel value which has been selected and redirect the randum genrated function .
	 * @return Redirect to the other function which returning the value.
	 */
	 public function mixInfoAction()
	 {
	 	 // Get the value which set in core.js.
	   $mix_id = (int) $this->_getParam('sugg_id');
	   $display_sugg_str = (string) $this->_getParam('displayed_sugg');
	   $this->view->div_id = $div_id = (string) $this->_getParam('widget_div_id');
	   $fun_name = (string) $this->_getParam('fun_name');
	   $this->view->page_name = $page_name = (string) $this->_getParam('page_name');
	   $this->view->display_suggestion = (int) $this->_getParam('display_suggestion');
	   $this->view->sugg_baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();// Set base url which are used in view file.
	   $sugg_object_array = array();
	   
	   //Insert entry in the data base.
	   $user = Engine_Api::_()->user()->getViewer();
	   $listTable = Engine_Api::_()->getItemTable('rejected');
	   $list = $listTable->createRow();
	   $list->owner_id = $user->getIdentity();
	   $list->entity = $fun_name;
	   $list->entity_id = $mix_id;
	   $list->save();
	   
	   //Only for the mix widget.
	   if($page_name == 'mix' || $page_name == 'new')
	   {
	   	 // Get the new randomly picked up suggestion
		   $mix_array = Engine_Api::_()->suggestion()->mix_suggestions($display_sugg_str, 1, 'logged_in');
		   // Condition : If "mix_loggedin_suggestions" return no record.
		   if(!empty($mix_array))
		   {
			   // New suggestion type
			   $mix_key = array_keys($mix_array[0]);   
			   $sugg_randum_key = explode("_", $mix_key[0]);
			   // $mix_array[0] : Array of which value are return.
			   $function_name = $sugg_randum_key[0] . '_info';
			   $module_name = $sugg_randum_key[0];
		   }
		   else {
		   	 $function_name = $fun_name . '_info';
		   	 $module_name = $fun_name;
		   }
		   // Here make the object of display suggestion.
			 if(!empty($mix_array))
			 {
			 		// Find out the suggestion which will be show in "Mix Widget".
				 $sugg_object_array[$module_name] = Engine_Api::_()->suggestion()->$function_name($mix_array[0]);
				 $this->view->sugg_object = $sugg_object_array;
			 }
			 else {
			 		// There are not suggestion available in data base.
		   	 $sugg_object_array[$fun_name] = array('msg');
		   	 $this->view->sugg_object = $sugg_object_array;
			 }
	   }
	   //For all widget leaving MIX Suggestion Widget.
	   else
	   {
	   	 $function_name = $fun_name . '_loggedin_suggestions';
	   	 // In the case of "Friend (Prople you may know)" call differ function.
	   	 if($fun_name == 'friend')
	   	 {
	   	 		// Findout the display User only for the friend.
					$explode_display_str = explode(",", $display_sugg_str);
					$friend_dis_str = '';
					foreach($explode_display_str as $row_explode_str)
					{
					  $friend_explode = explode("_", $row_explode_str);
					  if($friend_explode[0] == 'friend')
					  {
						  $friend_dis_str .= "," . $friend_explode[1];
					  }
					}
					$friend_dis_str = ltrim($friend_dis_str, ",");
					$dis_message = $friend_dis_str;
					//$this->view->abc = $dis_message;
	   	 	  $sugg_array = Engine_Api::_()->suggestion()->suggestion_path($user->getIdentity(), 4, $dis_message, 1);
	   	 }
	   	 // In the case of all widget insted of "Friend Suggestion".
	   	 else {
	   	 		$sugg_array = Engine_Api::_()->suggestion()->$function_name($display_sugg_str, 1, $fun_name);
	   	 }
	   	 if(!empty($sugg_array))
	   	 {
		   	 $function_name = $fun_name . '_info';
			   // Here make the object of display suggestion.	   
			   $sugg_object_array[$fun_name] = Engine_Api::_()->suggestion()->$function_name($sugg_array);
			   $this->view->sugg_object = $sugg_object_array;
	   	 }
	   	 else {
	   	 	$sugg_object_array[$fun_name] = array('msg');
	   	 	$this->view->sugg_object = $sugg_object_array;
	   	 }
	   }
	   // Find the "Number of Mutual Friend" which Call by "Friend Suggestion Widget" and "Mix Suggestion Widget".
	   if($page_name == 'mix' || $page_name == 'friend')
	   {
	     if($fun_name == 'friend')
	     {
	     	 $mutual_friend_array = array();
	     	 // Find out the Suggested friend id.
	     	 if($page_name == 'mix' && !empty($mix_array[0])) {
		     	 	$found_value_in_array = array_values($mix_array[0]);
		     	 	$suggested_friend_id = $found_value_in_array[0];
	     	 }
	     	 elseif ($page_name == 'friend' && !empty($sugg_array))
	     	 {
	     	 	  $suggested_friend_id = $sugg_array[0];
	     	 }
	     	 else {
	     	 	 $suggested_friend_id = 0;
	     	 }
	     	 // This queary return the number of mutual friend which are suggested.
			   		$friendsTable = Engine_Api::_()->getDbtable('membership', 'user');
			   $friendsName = $friendsTable->info('name');
			
			   $select = new Zend_Db_Select($friendsTable->getAdapter());
			   $select
			     ->from($friendsName, 'COUNT(' . $friendsName . '.user_id) AS friends_count')
			     ->join($friendsName, "`{$friendsName}`.`user_id`=`{$friendsName}_2`.user_id", null)
			     ->where("`{$friendsName}`.resource_id = ?", $suggested_friend_id) // Id of Loggedin user friend.
			     ->where("`{$friendsName}_2`.resource_id = ?", $user->getIdentity()) // Loggedin user Id.
			     ->where("`{$friendsName}`.active = ?", 1)
			     ->where("`{$friendsName}_2`.active = ?", 1)
			     ->group($friendsName . '.resource_id');
			   $fetch_mutual_friend = $select->query()->fetchAll();
			   if(!empty($fetch_mutual_friend))
			   {
			   	 $mutual_friend_array[$suggested_friend_id] = $fetch_mutual_friend[0]['friends_count'];
			   	 $this->view->mutual_friend_array = $mutual_friend_array;
			   }
	     }
	   }   
	 }
	 
		// This function call from notification page when click on Ignore button. 
	 public function notificationCancelAction()
	 {
    //RECIEVE VALUE FROM AJAX
    $notification_id = (int) $this->_getParam('notification_id');
    $object_id = (int) $this->_getParam('object_id');
    //$sugg_id = Engine_Api::_()->getItem('notifications', $notification_id)->object_id;
    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('notification_id = ?' => $notification_id));
    Engine_Api::_()->getItem('suggestion', $object_id)->delete();
	 }
}