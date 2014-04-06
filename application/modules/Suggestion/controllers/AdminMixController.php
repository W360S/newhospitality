<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminMixController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_AdminMixController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {  
  	$suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
  	if(!empty($suggestion_field_cat))
  	{
    	$this->view->navigation = Engine_Api::_()->getApi('menus', 'core')->getNavigation('sugg_admin_main', array(), 'suggestion_admin_main_mix');
  	}
  	$this->view->form = $form = new Suggestion_Form_Admin_Mix();
    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()))
    {
      $values = $form->getValues();
      $serial_array = array();
      foreach ($values as $key => $value)
      {
      	if($key == 'sugg_mix_wid')
      	{
      		Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value);
      	}
      	elseif ($value == 1)
      	{
      		$serial_array[] = $key;
      	}
      }
      $serialize_string = serialize($serial_array);
      Engine_Api::_()->getApi('settings', 'core')->setSetting('mix_serialize', $serialize_string);
    }
  }
}