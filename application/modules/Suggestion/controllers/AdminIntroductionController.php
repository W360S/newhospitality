<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminIntroductionController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */

class Suggestion_AdminIntroductionController extends Core_Controller_Action_Admin
{
	// Saves the data of the Admin form for Site Introduction
  public function indexAction()
  { 
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
    	$this->view->navigation = Engine_Api::_()->getApi('menus', 'core')->getNavigation('sugg_admin_main', array(), 'suggestion_introduction');
  	}
      
  	$this->view->form = $form = new Suggestion_Form_Admin_Introduction();
    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()))
    {
	    $values = $form->getValues();
	    // Insert value in core setting table.
	    Engine_Api::_()->getApi('settings', 'core')->setSetting('sugg_admin_introduction', $values['sugg_admin_introduction']);
	    // Insert bgcolor in "Core_Settings".
	    Engine_Api::_()->getApi('settings', 'core')->setSetting('sugg_bg_color', $values['sugg_bg_color']);
	    // insert value in "suggestion_introductions"
	  	$intro_obj = Engine_Api::_()->getItem('introduction', 1);
	  	$intro_obj->content = $values['content'];
	  	$intro_obj->save();
	  	$this->view->is_msg = 1;
    }
  }
}