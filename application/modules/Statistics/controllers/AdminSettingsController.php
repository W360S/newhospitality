<?php
/**
 * VietHospitality
 *
 * @category   Application_Extensions
 * @package    Statistics
 
 * @version    1.0
 * @author     huynhnv
 * @status     done
 */

class Statistics_AdminSettingsController extends Core_Controller_Action_Admin {

  public function indexAction()
  {
    
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('news_admin_main', array(), 'news_admin_main_settings');

    $this->view->form  = $form = new News_Form_Admin_Global();
    
    if( $this->getRequest()->isPost() && $form->isValid($this->_getAllParams()) )
    {
      $values = $form->getValues();
      //Zend_Debug::dump($values, 'value');
      foreach ($values as $key => $value){
        Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value);
      }
    }
  }
  public function helpAction() {
    
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                    ->getNavigation('statistics_admin_main', array(), 'statistics_admin_main_help');
    $this->view->categories = Engine_Api::_()->getApi('setting', 'statistics')->getCategories();
   
  }
  public function addCategoryAction() {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');

    // Generate and assign form
    $form = $this->view->form = new Statistics_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));
    // Check post
    if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
      // we will add the category
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        // add category to the database
        // Transaction
        $table = Engine_Api::_()->getDbtable('categories', 'statistics');
        $viewer = Engine_Api::_()->user()->getViewer();
        $user_id= $viewer->getIdentity();
        // insert the category into the database
        $row = $table->createRow();
        
        $row->name = $values["label"];
        $row->priority = $values["priority"];
        $row->user_id= $user_id;
        $row->created = date('Y-m-d H:i:s');
        $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($values['label']);
        $row->alias= $slug;
        $row->save();
        if( !empty($values['photo']) ) {
            //Zend_Debug::dump($form->photo, 'php');exit();
            $row->setPhotos($form->photo);
            $row->save();
        } 
        $db->commit();
      } catch (Exception $e) {
        $db->rollBack();
        throw $e;
      }
      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh' => 10,
          'messages' => array('')
      ));
    }

    // Output
    $this->renderScript('admin-settings/form.tpl');
  }
  public function editCategoryAction() {
    // In smoothbox
    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Statistics_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    // Check post
    if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
      // Ok, we're good to add field
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        // edit category in the database
        // Transaction
        $row = Engine_Api::_()->getApi('setting', 'statistics')->getCategory($values["id"]);
        //$row = Engine_Api::_()->getItem('statistics_category', $values["id"]);
        //Zend_Debug::dump($row);//exit;
        $viewer= Engine_Api::_()->user()->getViewer();
        $user_id= $viewer->getIdentity();
        $row->name = $values["label"];
        //$row->description= $values['description'];
        $row->priority = $values["priority"];
        $row->user_id= $user_id;
        $row->modified= date('Y-m-d H:i:s');
        $slug= Engine_Api::_()->getApi('alias', 'core')->convert2Alias($values['label']);
        $row->alias= $slug;
        $row->save();
        if( !empty($values['photo']) ) {
            //Zend_Debug::dump($form->photo, 'php');exit();
            $row->setPhotos($form->photo);
            $row->save();
        }   
        $db->commit();
      } catch (Exception $e) {
        $db->rollBack();
        throw $e;
      }
      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh' => 10,
          'messages' => array('')
      ));
    }

    // Must have an id
    if (!($id = $this->_getParam('id'))) {
      die('No identifier specified');
    }

    // Generate and assign form
    $category = Engine_Api::_()->getApi('setting', 'statistics')->getCategory($id);
    $form->setField($category);

    // Output
    $this->renderScript('admin-settings/form.tpl');
  }
}