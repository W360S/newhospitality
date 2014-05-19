<?php

class Experts_AdminSettingsController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('experts_admin_main', array(), 'experts_admin_main_settings');

    $settings = Engine_Api::_()->getApi('settings', 'core');

    $this->view->form = $form = new Experts_Form_Admin_Global();
    $form->experts_page->setValue($settings->getSetting('experts_page', 25));
    if( $this->getRequest()->isPost()&& $form->isValid($this->getRequest()->getPost()))
    {
      $values = $form->getValues();
       foreach ($values as $key => $value){
        Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value);
      }
    }
  }
  
  /* manage categories*/  
  public function categoriesAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('experts_admin_main', array(), 'experts_admin_main_categories');
    
    $this->view->categories = Engine_Api::_()->experts()->getCategories();
  }


  public function addCategoryAction()
  {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');

    // Generate and assign form
    $form = $this->view->form = new Experts_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));
    // Check post
    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
    {
      // we will add the category
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        // add category to the database
        // Transaction
        $table = Engine_Api::_()->getDbtable('categories', 'experts');

        // insert the album category into the database
        $row = $table->createRow();
       // $row->user_id   =  1;
        $row->category_name = $values["label"];
        $row->priority = $values["priority"];
        $row->save();

        $db->commit();
      }

      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }

      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh'=> 10,
          'messages' => array('')
      ));
    }

    // Output
    $this->renderScript('admin-settings/form.tpl');
  }

  public function deleteCategoryAction()
  {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    //$this->view->expert_id=$id;
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        // xoa expertscategories
        $tableExpertsCategories = Engine_Api::_()->getDbtable('expertscategories', 'experts');
        $where_experts_categories = $tableExpertsCategories->getAdapter()->quoteInto('category_id = ?', $id);
        $tableExpertsCategories->delete($where_experts_categories);
        
        // xoa categories
        $category = Engine_Api::_()->getDbtable('categories', 'experts')->find($id)->current();
        $category->delete();
        
        $db->commit();
      }

      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_('Category has been deleted successfull.')),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
    }

    // Output
    $this->renderScript('admin-settings/delete.tpl');
  }

  public function editCategoryAction()
  {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Experts_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    // Check post
    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
    {
      // Ok, we're good to add field
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
        // edit category in the database
        // Transaction
        $row = Engine_Api::_()->experts()->getCategory($values["id"]);

        $row->category_name = $values["label"];
        $row->priority = $values["priority"];
        $row->save();
        $db->commit();
      }

      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh'=> 10,
          'messages' => array('')
      ));
    }

    // Must have an id
    if( !($id = $this->_getParam('id')) )
    {
      die('No identifier specified');
    }

    // Generate and assign form
    $category = Engine_Api::_()->experts()->getCategory($id);
    $form->setField($category);

    // Output
    $this->renderScript('admin-settings/form.tpl');
  }
  
  
  
}

