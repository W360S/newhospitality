<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminGlobalController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_AdminGlobalController extends Core_Controller_Action_Admin
{
 	public function globalAction()
  {
		$license_key = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion_licensekey');
		$lsetting_check = Engine_Api::_()->suggestion()->suggestion_license($license_key);
  	if(!empty($lsetting_check))
  	{
	  	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
	    	->getNavigation('sugg_admin_main', array(), 'suggestion_admin_global');

	  	$this->view->form = $form = new Suggestion_Form_Admin_Global();
	  	if( $this->getRequest()->isPost()&& $form->isValid($this->getRequest()->getPost()))
	  	{
	    	$values = $this->getRequest()->getPost();
	    	$is_error = 0;
	    	$suggestion_controllersettings_temp = Engine_Api::_()->suggestion()->suggestion_globalmain($values['suggestion_controllersettings']);

	   		if (!empty($suggestion_controllersettings_temp)) {
	    		$is_error = 1;
	     		$error = $suggestion_controllersettings_temp;

	     		$this->view->status = false;
	     		$error = Zend_Registry::get('Zend_Translate')->_($error);

	     		$form->getDecorator('errors')->setOption('escape', false);
	     		$form->addError($error);
	     		return;
	   		}
	   		else {
					$session = new Zend_Session_Namespace();
					$globalSetting = $session->temp_globalsettings;
					if($globalSetting == 1)
					{
						Engine_Api::_()->getApi('settings', 'core')->setSetting('suggestion.field.cat', 1);
						foreach ($values as $key => $value)
	    			{ $value_trim = trim($value);
	      			Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value_trim);
	    			}
	  				// Redirecting to "Global page" fir showing tab.
	  				$this->_helper->redirector->gotoRoute(array('route' => 'admin-default', 'action' => 'global', 'controller' => 'global'));
					}
	   		}
	  	}
  	}
  	return;
  }
}