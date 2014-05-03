<?php

class Activitypoints_AdminLevelsController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {

    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('activitypoints_admin_main', array(), 'activitypoints_admin_main_levels');

    $level_id = $this->_getParam('level_id', 1);
    
    $level = Engine_Api::_()->getItem('authorization_level', $level_id);

    if( !$level instanceof Authorization_Model_Level ) {
      $level = Engine_Api::_()->getItemTable('authorization_level')->getDefaultLevel();
      $level_id = $level->level_id;
    }
    

    // Make form
    $this->view->form = $form = new Activitypoints_Form_Admin_Level();

    $form->level_id->setValue($level_id);
    $permissionsTable = Engine_Api::_()->getDbtable('permissions', 'authorization');

    if( !$this->getRequest()->isPost() )
    {
      $form->populate($permissionsTable->getAllowed('activitypoints', $level_id, array_keys($form->getValues())));
      return;
    }

   // Check validitiy
    if( !$form->isValid($this->getRequest()->getPost()) ) {
      return;
    }


    // Process

    $values = $form->getValues();

    $db = $permissionsTable->getAdapter();
    $db->beginTransaction();

    try
    {
      
      $permissionsTable->setAllowed('activitypoints', $level_id, $values);
      
      // Commit
      $db->commit();
      
      $form->addNotice("Changed successfully saved.");
    }

    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }

  }

}