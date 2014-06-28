<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_AdminController extends Core_Controller_Action_Admin
{
	protected $_navigation;

  //ACTION FOR MAKE THE FEEDBACK FEATURED/UNFEATURED
  public function featuredAction() 
  {
  	$id = $this->_getParam('id');   	
   	$db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
     	$feedback = Engine_Api::_()->getItem('feedback', $id);
     	if($feedback->featured == 0) {
   			$feedback->featured = 1;	
   		}
   		else {
   			$feedback->featured = 0;
   		}
   		$feedback->save();
 			$db->commit();
		}
  	catch( Exception $e ) {
    	$db->rollBack();
    	throw $e;
  	}  
  	$this->_redirect("admin/feedback/manage/index/page/".$this->_getParam('page'));   
 	}
  
 	//ACTION FOR BLOCK IP COMMENT
  public function blockipcommentAction() 
  {
  	
  	$id = $this->_getParam('id');   	
   	$db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
     	$blockip = Engine_Api::_()->getItem('blockip', $id);
     	if($blockip->blockip_comment == 0) {
   			$blockip->blockip_comment = 1;	
   		}
   		else {
   			$blockip->blockip_comment = 0;
   		}
   		$blockip->save();
 			$db->commit();
		}
  	catch( Exception $e ) {
    	$db->rollBack();
    	throw $e;
  	}  
  	$this->_redirect("admin/feedback/settings/blockips/page/".$this->_getParam('page'));   
 	}
  
 		//ACTION FOR BLOCK IP COMMENT
  public function blockipfeedbackAction() 
  {
  	
  	$id = $this->_getParam('id');   	
   	$db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
     	$blockip = Engine_Api::_()->getItem('blockip', $id);
     	if($blockip->blockip_feedback == 0) {
   			$blockip->blockip_feedback = 1;	
   		}
   		else {
   			$blockip->blockip_feedback = 0;
   		}
   		$blockip->save();
 			$db->commit();
		}
  	catch( Exception $e ) {
    	$db->rollBack();
    	throw $e;
  	}  
  	$this->_redirect("admin/feedback/settings/blockips/page/".$this->_getParam('page'));   
 	}
  
 	
  //ACTION FOR BLOCK USER COMMENT
  public function blockcommentAction() 
  {
  	$id = $this->_getParam('id'); 
  	
  	//GET USER
  	$table   = Engine_Api::_()->getItemTable('blockuser'); 
		$select  = $table->select()
                     ->setIntegrityCheck(false)
                     ->from($table->info('name'), array('COUNT(*) AS count'))
    				 				 ->where('blockuser_id = ?', $id);
    $rows = $table->fetchAll($select)->toArray();
    $user_total = $rows[0]['count'];
  	
   	$db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
     	if($user_total == 0) {
     		$userBlock = Engine_Api::_()->getItemTable('blockuser');
      	$userBlock = $table->createRow();
      	$userBlock->blockuser_id = $id;
      	$userBlock->block_comment = 1;
     	}
     	else {
        $userBlock = Engine_Api::_()->getItem('blockuser', $id);
       	if($userBlock->block_comment == 0) {
   	    	$userBlock->block_comment = 1;	
   	  	}
   	  	else {
   				$userBlock->block_comment = 0;
   	  	}
   		}
   		$userBlock->save();
 			$db->commit();
	 	}
   	catch( Exception $e ){
    	$db->rollBack();
     	throw $e;
   	}  
  	$this->_redirect("admin/feedback/manage/blockuser/page/".$this->_getParam('page'));   
 	}
  
  //ACTION FOR BLOCK USER COMMENT
  public function blockfeedbackAction() 
  {
  	$id = $this->_getParam('id'); 
  	
  	//GET USER
  	$table   = Engine_Api::_()->getItemTable('blockuser'); 
		$select  = $table->select()
                     ->setIntegrityCheck(false)
                     ->from($table->info('name'), array('COUNT(*) AS count'))
    				 				 ->where('blockuser_id = ?', $id);
    $rows = $table->fetchAll($select)->toArray();
    $user_total = $rows[0]['count'];
  	
   	$db = Engine_Db_Table::getDefaultAdapter();
    $db->beginTransaction();
    try {
     	if($user_total == 0) {
	     	$userBlock = Engine_Api::_()->getItemTable('blockuser');
      	$userBlock = $table->createRow();
      	$userBlock->blockuser_id = $id;
      	$userBlock->block_feedback = 1;
     	}
     	else {
        $userBlock = Engine_Api::_()->getItem('blockuser', $id);
         if($userBlock->block_feedback == 0) {
   	    	$userBlock->block_feedback = 1;	
   	  	}
   	  	else {
   		  	$userBlock->block_feedback = 0;
   	  	}
   		}
   		$userBlock->save();
 			$db->commit();
	 	}
   	catch( Exception $e ){
    	$db->rollBack();
     	throw $e;
   	}  
  	$this->_redirect("admin/feedback/manage/blockuser/page/".$this->_getParam('page'));
 	}
  
  //ACTION FOR DELTE THE FEEDBACK
  public function deleteAction()
  { 

		$this->_helper->layout->setLayout('admin-simple');
		$feedback_id = $this->_getParam('id');
		$this->view->feedback_id = $feedback_id;
	
		if( $this->getRequest()->isPost()) {
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();
			try {
				$feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
			 	
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
		$this->renderScript('admin-manage/delete.tpl');
	}
	
 //ACTION FOR DELTE THE FEEDBACK
  public function visibilityAction()
  { 

		$this->_helper->layout->setLayout('admin-simple');
		$feedback_id = $this->_getParam('id');
		$this->view->visibility = $visibility = $this->_getParam('visible');
		$this->view->feedback_id = $feedback_id;
	
		if( $this->getRequest()->isPost()) {
			$db = Engine_Db_Table::getDefaultAdapter();
			$db->beginTransaction();
			try {
				$feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
			 	
				if($feedback->feedback_private == 'public') {
					$feedback->feedback_private = 'private';
				}
				else {
					$feedback->feedback_private = 'public';
				}
      
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
		$this->renderScript('admin-manage/visibility.tpl');
	}
	
	//ACTION FOR SHOW DETAIL OF FEEDBACK
  public function detailAction()
  {

		$this->_helper->layout->setLayout('admin-simple');
		$id = $this->_getParam('id');
		$this->view->feedback_id=$id;
		
		//SEND FEEDBACK DETAIL TO TPL FILE
		$this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $id);
		$this->view->categories = $categories = Engine_Api::_()->feedback()->getCategories();
		$this->view->severities = $severities = Engine_Api::_()->feedback()->getSeverities();
		$this->view->show_status = $status = Engine_Api::_()->feedback()->getStatus();
		$this->view->ip_address = $feedback->ip_address;
		$this->view->browser_name = $feedback->browser_name;
		
		$this->renderScript('admin/detail.tpl');
	}
	
  //CREATE TABS
  public function getNavigation($active = false)
  { 
    if( is_null($this->_navigation) ) {
    	$navigation = $this->_navigation = new Zend_Navigation();

	    if( $this->_helper->api()->user()->getViewer()->getIdentity() ) {
	        $navigation->addPage(array(
	          'label' => 'View Feedbacks',
	          'route' => 'feedback_admin',
	          'module' => 'feedback',
	          'controller' => 'admin',
	          'action' => 'view'
	        ));
	
	        $navigation->addPage(array(
	          'label' => 'Global Settings',
	          'route' => 'feedback_admin',
	          'module' => 'feedback',
	          'controller' => 'admin',
	          'action' => 'settings',
	          'active' => $active
	          
	        ));
			}
    }
    return $this->_navigation;
  }
}
?>
