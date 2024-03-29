<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: AdminSettingsController.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    Activity
 * @copyright  Copyright 2006-2010 webligo Developments
 * @license    http://www.socialengine.com/license/ */
class Activity_AdminSettingsController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
    // Make form
    $this->view->form = $form = new Activity_Form_Admin_Settings_General();

    // Populate settings
    $settings = Engine_Api::_()->getApi('settings', 'core');
    $values = $settings->activity;
    unset($values['allowed']);
    $form->populate($values);


    if( !$this->getRequest()->isPost() ) {
      return;
    }
    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }


    // Process
    $values = $form->getValues();
    
    // Save settings
    $settings->activity = $values;
    
    $form->addNotice('Your changes have been saved.');
  }

  public function typesAction()
  {
    $selectedType = $this->_getParam('type');

    // Make form
    $this->view->form = $form = new Activity_Form_Admin_Settings_ActionType();

    // Populate settings
    $actionTypesTable = Engine_Api::_()->getDbTable('actionTypes', 'activity');
    $actionTypes = $actionTypesTable->fetchAll();
    $multiOptions = array();
    foreach( $actionTypes as $actionType ) {
      $multiOptions[$actionType->type] = 'ADMIN_ACTIVITY_TYPE_' . strtoupper($actionType->type);
    }
    $form->type->setMultiOptions($multiOptions);

    if( !$selectedType || !isset($multiOptions[$selectedType]) ) {
      $selectedType = key($multiOptions);
    }
    $selectedTypeObject = null;
    foreach( $actionTypes as $actionType ) {
      if( $actionType->type == $selectedType ) {
        $selectedTypeObject = $actionType;
        $form->populate($actionType->toArray());
        // Process mulitcheckbox
        $displayable = array();
        if( 4 & (int) $actionType->displayable ) {
          $displayable[] = 4;
        }
        if( 2 & (int) $actionType->displayable ) {
          $displayable[] = 2;
        }
        if( 1 & (int) $actionType->displayable ) {
          $displayable[] = 1;
        }
        $form->populate(array(
          'displayable' => $displayable,
        ));
      }
    }


    if( !$this->getRequest()->isPost() ) {
      return;
    }
    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }


    // Process
    $values = $form->getValues();
    $values['displayable'] = array_sum($values['displayable']);

    // Check type
    if( !$selectedTypeObject ||
        !isset($multiOptions[$selectedTypeObject->type]) ||
        $selectedTypeObject->type != $values['type'] ) {
      return $form->addError('Please select a valid type');
    }

    unset($values['type']);

    // Save
    $selectedTypeObject->setFromArray($values);
    $selectedTypeObject->save();

    $form->addNotice('Your changes have been saved.');
  }
  
  public function notificationsAction()
  {
    
    error_reporting(E_ALL);
    ini_set('display_errors', TRUE);
    
    // Build the different notification types
    $modules = Engine_Api::_()->getDbtable('modules', 'core')->getModulesAssoc();
    $notificationTypes = Engine_Api::_()->getDbtable('notificationTypes', 'activity')->getNotificationTypes();
    $notificationSettings = Engine_Api::_()->getDbtable('notificationTypes', 'activity')->getDefaultNotifications();

    $notificationTypesAssoc = array();
    $notificationSettingsAssoc = array();
    foreach( $notificationTypes as $type ) {
      if( in_array($type->module, array('core', 'activity', 'fields', 'authorization', 'messages', 'user')) ) {
        $elementName = 'general';
        $category = 'General';
      } else if( isset($modules[$type->module]) ) {
        $elementName = preg_replace('/[^a-zA-Z0-9]+/', '-', $type->module);
        $category = $modules[$type->module]->title;
      } else {
        $elementName = 'misc';
        $category = 'Misc';
      }

      $notificationTypesAssoc[$elementName]['category'] = $category;
      $notificationTypesAssoc[$elementName]['types'][$type->type] = 'ACTIVITY_TYPE_' . strtoupper($type->type);

      if( in_array($type->type, $notificationSettings) ) {
        $notificationSettingsAssoc[$elementName][] = $type->type;
      }
    }

    ksort($notificationTypesAssoc);
    
    $notificationTypesAssoc = array_filter(array_merge(array(
      'general' => array(),
      'misc' => array(),
    ), $notificationTypesAssoc));

    
    $this->view->form = $form = new Engine_Form(array(
       'title' => 'Default Email Notifications',
       'description' => 'This page allows you to specify the default email notifications for new users.',
     ));
    
    foreach( $notificationTypesAssoc as $elementName => $info ) {
      $form->addElement('MultiCheckbox', $elementName, array(
        'label' => $info['category'],
        'multiOptions' => $info['types'],
        'value' => (array) @$notificationSettingsAssoc[$elementName],
      ));
    }
    
    // init submit
    $form->addElement('Button', 'submit', array(
      'label' => 'Save Changes',
      'type' => 'submit',
      'ignore' => true,
    ));
    
    // Check method
    if( !$this->getRequest()->isPost() ) {
      return;
    }

    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }
    
    $values = array();
    foreach( $form->getValues() as $key => $value ) {
      if( !is_array($value) ) continue;
      
      foreach( $value as $skey => $svalue ) {
        if( !isset($notificationTypesAssoc[$key]['types'][$svalue]) ) {
          continue;
        }
        $values[] = $svalue;
      }
    }
    
    Engine_Api::_()->getDbtable('notificationTypes', 'activity')->setDefaultNotifications($values);
    $form->addNotice('Your changes have been saved.');
  }
}