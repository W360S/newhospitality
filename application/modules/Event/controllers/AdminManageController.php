<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: AdminManageController.php 7244 2010-09-01 01:49:53Z john $
 * @author     Jung
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Event_AdminManageController extends Core_Controller_Action_Admin
{

  public function indexAction()
  {
    
    //Search Form
    $this->view->search_form = $search_form = new Event_Form_Admin_Search();
    $defaultValues= $search_form->getValues();
    
     // Populate form options
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'event');
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
        'event_search' => $this->getRequest()->getPost('event_search'),
        'category_id' => intval($this->getRequest()->getPost('category_id')),
        'event_type' => intval($this->getRequest()->getPost('event_type'))
      ));
      
    } else {
        
      $search_form->getElement('event_search')->setValue($this->_getParam('event_search'));
      $search_form->getElement('category_id')->setValue(intval($this->_getParam('category_id')));
      $search_form->getElement('event_type')->setValue(intval($this->_getParam('event_type')));  
    }
    
    $text_search = $this->_getParam('event_search');
    $category_id = intval($this->_getParam('category_id'));
    $event_type = intval($this->_getParam('event_type'));
                            
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('event_admin_main', array(), 'event_admin_main_manage');
    
    $table = Engine_Api::_()->getItemTable('event');
    $tableName = $table->info('name');
    $select = $table->select();
    $select->order("event_id Desc");
    if( !empty($text_search) ) {
     //$db = $table->getAdapter();  
     $select->where("`{$tableName}`.title LIKE ? OR `{$tableName}`.description LIKE ? OR `{$tableName}`.host LIKE ? OR `{$tableName}`.location LIKE ?", '%'.$text_search.'%');
     
    }
    
    if( !empty($category_id)) {
        
      $select->where('category_id = ?', $category_id);
    }
    
    if( $event_type == 2 )
    {
      $select->where("endtime < FROM_UNIXTIME(?)", time());
    }
    
    if ($event_type == 1)
    {
      $select->where("endtime > FROM_UNIXTIME(?)", time());
    }
    
    $page = $this->_getParam('page',1);
    $this->view->paginator = Zend_Paginator::factory($select);
    $this->view->paginator->setItemCountPerPage(30);
    $this->view->paginator->setCurrentPageNumber($page);
  
  }

  public function deleteAction()
	{
		// In smoothbox
		$this->_helper->layout->setLayout('admin-simple');
		$id = $this->_getParam('id');
		$this->view->event_id=$id;
		// Check post
		if( $this->getRequest()->isPost())
		{
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();

			try
			{
				$event = Engine_Api::_()->getItem('event', $id);
				$event->delete();
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
				$event = Engine_Api::_()->getItem('event', $id);
				if( $event ) $event->delete();
			}

			$this->_helper->redirector->gotoRoute(array('action' => 'index'));
		}

	}
}