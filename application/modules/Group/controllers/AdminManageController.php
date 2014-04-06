<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: AdminManageController.php 7244 2010-09-01 01:49:53Z john $
 * @author     Jung
 */

/**
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Group_AdminManageController extends Core_Controller_Action_Admin
{

  public function indexAction()
  {
    //Search Form
    $this->view->search_form = $search_form = new Group_Form_Admin_Search();
    $defaultValues = $search_form->getValues();
    
     // Populate form options
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'group');
    $select = $categoryTable->select()
      ->order('priority ASC');
    foreach( $categoryTable->fetchAll($select) as $category ) {
      $search_form->category_id->addMultiOption($category->category_id, $category->title);
    }
    
    if ($this->getRequest()->isPost()) { 
        
      // redirect to GET route to prevent POST-back-button fo-paw
      $search_value = 0;
      $this->_helper->redirector->gotoRouteAndExit(array(
        'page' => 1,
        'group_search' => $this->getRequest()->getPost('group_search'),
        'category_id' => intval($this->getRequest()->getPost('category_id'))
      ));
      
    } else {
        
      $search_form->getElement('group_search')->setValue($this->_getParam('group_search'));
      $search_form->getElement('category_id')->setValue(intval($this->_getParam('category_id')));
    }
    
    $text_search = $this->_getParam('group_search');
    $category_id = intval($this->_getParam('category_id'));
    
    
    $table = Engine_Api::_()->getItemTable('group');
    $tableName = $table->info('name');
    $select = $table->select();
    $select->order("group_id Desc");
    if( !empty($text_search) ) {
     //$db = $table->getAdapter();  
     $select->where("`{$tableName}`.title LIKE ? OR `{$tableName}`.description LIKE ?", '%'.$text_search.'%');
    }
    
    if( !empty($category_id)) {
      $select->where('category_id = ?', $category_id);
    }
    
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('group_admin_main', array(), 'group_admin_main_manage');
    
    $page = $this->_getParam('page',1);
    
    $this->view->paginator = Zend_Paginator::factory($select);
    
    $this->view->paginator->setItemCountPerPage(30);
    $this->view->paginator->setCurrentPageNumber($page);
    
  }

 public function deleteselectedAction()
 {
	$this->view->ids = $ids = $this->_getParam('ids', null);
	$confirm = $this->_getParam('confirm', false);
	$this->view->count = count(explode(",", $ids));

	// Save values
	if( $this->getRequest()->isPost() && $confirm == true )
	{
		$ids_array = explode(",", $ids);
		foreach( $ids_array as $id ){
			$group = Engine_Api::_()->getItem('group', $id);
			if( $group ) $group->delete();
		}

		$this->_helper->redirector->gotoRoute(array('action' => 'index'));
	}

 }
 
 public function deleteAction()
 {
	// In smoothbox
	$this->_helper->layout->setLayout('admin-simple');
	$id = $this->_getParam('id');
	$this->view->group_id=$id;
	// Check post
	if( $this->getRequest()->isPost())
	{
		$db = Engine_Db_Table::getDefaultAdapter();
		$db->beginTransaction();

		try
		{
			$group = Engine_Api::_()->getItem('group', $id);
			$group->delete();
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
	$this->renderScript('admin-manage/delete.tpl');
 }
}