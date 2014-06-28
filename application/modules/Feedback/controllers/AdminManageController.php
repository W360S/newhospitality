<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminManageController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_AdminManageController extends Core_Controller_Action_Admin
{
  public function indexAction()
  {
		// SHOW TABS
   	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
         ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_manage');

    //GET MANAGE FILTER FORM     
    $this->view->formFilter = $formFilter = new Feedback_Form_Admin_Manage_Filter();
    $page = $this->_getParam('page',1);
    $this->view->page = $page;
		
    $tableUser = $this->_helper->api()->getItemTable('user')->info('name');
    $tableCategory = $this->_helper->api()->getItemTable('categories')->info('name');
    $tableSeverity = $this->_helper->api()->getItemTable('severities')->info('name');
    $tableStatus = $this->_helper->api()->getItemTable('status')->info('name');
    $table = $this->_helper->api()->getDbtable('feedbacks', 'feedback');
    $rName = $table->info('name');
    $select = $table->select()
    								->setIntegrityCheck(false)
										->from($rName)
										->joinLeft($tableUser, "$rName.owner_id = $tableUser.user_id", 'username')
    								->joinLeft($tableCategory, "$rName.category_id = $tableCategory.category_id", 'category_name')
    								->joinLeft($tableSeverity, "$rName.severity_id = $tableSeverity.severity_id", 'severity_name')
    								->joinLeft($tableStatus, "$rName.stat_id = $tableStatus.stat_id", 'stat_name');
    //PROCESS FROM 
    $values = array();
    if( $formFilter->isValid($this->_getAllParams()) ) {
    	$values = $formFilter->getValues();
    }

    //SHOW CATEGORY
    $this->view->categories = $categories = Engine_Api::_()->feedback()->getCategories();
    
    //SHOW SEVERITY
    $this->view->severities = $severities = Engine_Api::_()->feedback()->getSeverities();
    
    //SHOW STATUS
    $this->view->status = $status = Engine_Api::_()->feedback()->getStatus();
    
    foreach( $values as $key => $value ) {
    	if( null === $value ) {
        unset($values[$key]);
      }
    }

    $values = array_merge(array(
      'order' => 'feedback_id',
      'order_direction' => 'DESC',
    ), $values);
   
    $this->view->assign($values); 
    
    $select->order(( !empty($values['order']) ? $values['order'] : 'feedback_id' ) . ' ' . ( !empty($values['order_direction']) ? $values['order_direction'] : 'DESC' ));
    
		// MAKE PAGINATOR
    $this->view->paginator = $paginator = Zend_Paginator::factory($select);
    $this->view->paginator->setItemCountPerPage(50);
    $this->view->paginator = $paginator->setCurrentPageNumber( $page );
  }
 
  	//ACTION FOR BLOCK USER
 	public function blockuserAction()
 	{ 
 
 		//SHOW TABS
   	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
         ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_blockuser'); 

    $this->view->formFilter = $formFilter = new Feedback_Form_Admin_Manage_Filterblockuser();
    $page = $this->_getParam('page',1);
    $this->view->page = $page;

    //GET INFO FOR SHOW LISTING FROM user and blockusers TABLE
    $tmTable = Engine_Api::_()->getDbtable('blockusers', 'feedback');
    $tmName =  $tmTable->info('name');     
    $rName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    $select = $tmTable->select()
				    				  ->setIntegrityCheck(false)
				    				  ->from($rName)
				    				  ->joinLeft($tmName, "$tmName.blockuser_id = $rName.user_id");

    //Process form
    $values = array();
    if( $formFilter->isValid($this->_getAllParams()) ) {
      $values = $formFilter->getValues();
    }

    foreach( $values as $key => $value ) {
    	if( null === $value ) {
        	unset($values[$key]);
      }
    }

    $values = array_merge(array(
      'order' => 'user_id',
      'order_direction' => 'DESC',
    ), $values);
    
    $this->view->assign($values);

    //Set up select info
    $select->order(( !empty($values['order']) ? $values['order'] : 'user_id' ) . ' ' . ( !empty($values['order_direction']) ? $values['order_direction'] : 'DESC' ));

    if( !empty($values['username']) ) {
     	$select->where('username LIKE ?', '%' . $values['username'] . '%');
    }

    if( !empty($values['email']) ) {
     	$select->where('email LIKE ?', '%' . $values['email'] . '%');
    }

    if( !empty($values['level_id']) ) {
     	$select->where('level_id = ?', $values['level_id'] );
    }
 
    //Make paginator
    $this->view->paginator = $paginator = Zend_Paginator::factory($select);
    $this->view->paginator = $paginator->setCurrentPageNumber( $page );

 	}
 
  //ACTION FOR EDIT STATUS
  public function changeStatAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Feedback_Form_Admin_Manage_Stat();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));
		$feedback = Engine_Api::_()->getItem('feedback', $this->_getParam('id'));
    $stat['stat_id'] = $feedback->stat_id;
    $stat['status_body'] = $feedback->status_body;
    
    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues();
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
     
      try {
        // edit status in the database
        $feedback->stat_id = $values['stat_id'];
 				$feedback->status_body = $values['status_body'];
        $feedback->setFromArray($values);
        $feedback->save();
        $db->commit();
      }

      catch( Exception $e ) {
        $db->rollBack();
        throw $e;
      }
      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh'=> 10,
          'messages' => array('')
      ));
    }
	
    if( !($id = $this->_getParam('id')) ) {
     	die('No identifier specified');
    }

    $form->setField($stat);

    // OUTPUT
    $this->renderScript('admin-manage/form.tpl');
  }
  
  //ACTION FOR MULTI DELETE FEEDBACK
  public function multiDeleteAction()
  {
		if ($this->getRequest()->isPost()) {
      $values = $this->getRequest()->getPost();
      foreach ($values as $key=>$value) {
        if ($key == 'delete_' . $value) {
          $feedback = Engine_Api::_()->getItem('feedback', (int)$value);
          $feedback_id = $feedback->feedback_id;
          
        	//DELETE VOTES 
       		$table   = Engine_Api::_()->getItemTable('vote');
					$select  = $table->select()
                     	 		 ->from($table->info('name'), 'vote_id')
    				 	 						 ->where('feedback_id = ?', $feedback_id);						
        	$rows = $table->fetchAll($select)->toArray();
        	if(!empty($rows)) {
        		$vote_id = $rows[0]['vote_id'];		
	    			$vote = Engine_Api::_()->getItem('vote', $vote_id);
        		$vote->delete();
        	}
        	
	    		//DELETE IMAGE
   	    	$table   = Engine_Api::_()->getItemTable('feedback_image');
					$select  = $table->select()
                    	 	 ->from($table->info('name'), 'image_id')
    					 	 				 ->where('feedback_id = ?', $feedback_id);						
        	$rows = $table->fetchAll($select)->toArray();
        	if(!empty($rows)) {
        		foreach($rows as $key => $image_ids) {
		        	$image_id = $image_ids['image_id'];
			    		$image = Engine_Api::_()->getItem('feedback_image', $image_id);
		        	$image->delete();
        		}
        	} 
	        	
		    	//DELETE ALBUM 
	   	    $table   = Engine_Api::_()->getItemTable('feedback_album');
					$select  = $table->select()
	                    	 	 ->from($table->info('name'), 'album_id')
	    					 	 				 ->where('feedback_id = ?', $feedback_id);						
        	$rows = $table->fetchAll($select)->toArray();
        	if(!empty($rows)) {
	        	$album_id = $rows[0]['album_id'];		
		    		$album = Engine_Api::_()->getItem('feedback_album', $album_id);
	        	$album->delete();
        	}
          	
        	$feedback->delete();
            	
        }
      }
    }
    return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
  }
}
?>
