<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminSettingsController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_AdminSettingsController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
    	$this->view->navigation = Engine_Api::_()->getApi('menus', 'core')->getNavigation('sugg_admin_main', array(), 'suggestion_admin_settings');
  	}
      
    $level_id = $this->_getParam('sugg_select');// Get user level id.
    if(empty($level_id))
    {
    	$level_id = 'friend';
    }
  	$this->view->form = $form = new Suggestion_Form_Admin_Widgetitem();
  	if (!empty($form->sugg_select)) {
  	  $form->sugg_select->setValue($level_id);  	
  	}
  	$form_array = array('friend' => 'friend', 'group' => 'group', 'classified' => 'classified', 'video' => 'video', 'blog' => 'blog', 'event' => 'event', 'album' => 'album', 'music' => 'music', 'poll' => 'poll', 'forum' => 'forum');
  	// Condition for friend.
	  	foreach ($form_array as $form_key => $form_value)
	  	{
	  		if($form_key != $level_id)
	  		{
		   		$form->removeElement('sugg_' . $form_value . '_wid');
		   		$form->removeElement('after_' . $form_value . '_create');
		   		$form->removeElement('after_' . $form_value . '_join');
	  		}
	  	}
	  	if($level_id != 'friend')
	  	{
	  		$form->removeElement('sugg_friend_wid');
	  		$form->removeElement('send_friend_popup');
	  		$form->removeElement('accept_friend_popup');
	  	}
    if( $this->getRequest()->isPost()&& $form->isValid($this->getRequest()->getPost()))
    {
      $values = $form->getValues();
      foreach ($values as $key => $value)
      {
      	if($key != 'sugg_select')
      	{
        	Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value);
      	}
      }
    }
  }
}