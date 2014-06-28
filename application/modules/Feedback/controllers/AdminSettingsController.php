<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: AdminSettingsController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_AdminSettingsController extends Core_Controller_Action_Admin
{
  public function indexAction()
  { 
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      	 ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_settings');

      	 
    $this->view->form = $form = new Feedback_Form_Admin_Global();

		if( $this->getRequest()->isPost()&& $form->isValid($this->getRequest()->getPost())) {
      $values = $form->getValues();
      
	    $return_lsettings = Engine_Api::_()->feedback()->feedback_lsettings($values['feedback_license_key'], 'feedbacks');
	      
	    if (!empty($return_lsettings))
	    {	    	
	      $this->view->status = false;
	
	      $error = $return_lsettings;
	      $error = Zend_Registry::get('Zend_Translate')->_($error);
	      
	      $form->getDecorator('errors')->setOption('escape', false);
	      $form->addError($error);
	      return;
    	}
    	else {
    		$session = new Zend_Session_Namespace();
  	    $temp_globalsettings = $session->temp_globalsettings;
    	  if($temp_globalsettings == 1) {  
       		$values = $form->getValues();
	    		$values['feedbackbutton_visible'] = 1;
	      	foreach ($values as $key => $value) {
	        	Engine_Api::_()->getApi('settings', 'core')->setSetting($key, $value);
	      	}
    	  }
    	}
  	}
  }
  
  public function statisticAction()
  { 
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      	 ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_statistic');
      	 
    //COUNT TOTAL PUBLIC FEEDBACK 	 
    $table  = Engine_Api::_()->getDbTable('feedbacks', 'feedback');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.feedback_private = ?', 'private');
    $row = $table->fetchAll($select);
    $this->view->total_public = $total_public = count($row);
    
    //COUNT TOTAL PRIVATE FEEDBACK  	 
    $table  = Engine_Api::_()->getDbTable('feedbacks', 'feedback');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.feedback_private = ?', 'public');
    $row = $table->fetchAll($select);
    $this->view->total_private = $total_private = count($row);
    
    //COUNT TOTAL FEEDBACK
    $this->view->total_feedback = $total_public + $total_private;
    
    //COUNT TOTAL ANONYMOUS FEEDBACK  	 
    $table  = Engine_Api::_()->getDbTable('feedbacks', 'feedback');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.owner_id = ?', 0);
    $row = $table->fetchAll($select);
    $this->view->total_anonymous = $total_public = count($row);
    
    //COUNT TOTAL VOTES AND COMMENTS 	 
    $table  = Engine_Api::_()->getDbTable('feedbacks', 'feedback');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName, array('SUM(total_votes) AS total_votes', 'SUM(comment_count) AS total_comments'));
    $row = $table->fetchAll($select)->toArray();
    $this->view->total_votes = $row[0]['total_votes'];
    $this->view->total_comments = $row[0]['total_comments'];     
      	 
  }   	 
  
  //ACTION FOR RETURN CATEGORY
  public function categoriesAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      	 ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_categories');

    $this->view->categories = Engine_Api::_()->feedback()->getCategories();
  }

    //ACTION FOR RETURN BLOCK IPS
  public function blockipsAction()
  { 
  	//SHOW TABS
   	$this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
         ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_blockips'); 

    $this->view->formFilter = $formFilter = new Feedback_Form_Admin_Manage_Filter();     
    $page = $this->_getParam('page',1);
    $this->view->page = $page;

    //GET INFO FOR SHOW LISTING FROM user and blockusers TABLE
    $tmTable = Engine_Api::_()->getDbtable('blockips', 'feedback');
    $tmName =  $tmTable->info('name');     
    $select = $tmTable->select()
				    				  ->setIntegrityCheck(false)
				    				  ->from($tmName);
				    				  
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
      'order' => 'blockip_id',
      'order_direction' => 'DESC',
    ), $values);
    
    $this->view->assign($values);

    $select->order(( !empty($values['order']) ? $values['order'] : 'blockip_id' ) . ' ' . ( !empty($values['order_direction']) ? $values['order_direction'] : 'DESC' ));

    $this->view->blockips = $paginator = Zend_Paginator::factory($select);
    $this->view->blockips = $paginator->setCurrentPageNumber( $page );
  
  }

  //ACTION FOR RETURN SEVERITY
  public function severitiesAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      	 ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_severities');

    $this->view->severities = Engine_Api::_()->feedback()->getSeverities();
  }
  
  //ACTION FOR RETURN STATUS
  public function statusAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      	 ->getNavigation('feedback_admin_main', array(), 'feedback_admin_main_status');

    $this->view->status = Engine_Api::_()->feedback()->getStatus();
  }
  
  //ACTION FOR ADD NEW CATEGORY
  public function addCategoryAction()
  {

    $this->_helper->layout->setLayout('admin-simple');

    $form = $this->view->form = new Feedback_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
    	$values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        //ADD CATEGORY TO THE DATABASE
        $table = Engine_Api::_()->getDbtable('categories', 'feedback');

        // INSERT THE FEEDBACK IN TO THE DATABASE
        $row = $table->createRow();
        $row->user_id   =  1;
        $row->category_name = $values["label"];
        $row->save();

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

    $this->renderScript('admin-settings/form.tpl');
  }

  //ACTION FOR ADD NEW BLOCK IP
  public function addBlockipAction()
  {

    $this->_helper->layout->setLayout('admin-simple');

    $form = $this->view->form = new Feedback_Form_Admin_Blockip();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
    	$values = $form->getValues(); 

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

	    try{
        //ADD IP TO THE DATABASE
        //TRANSCATION
        $table = Engine_Api::_()->getDbtable('blockips', 'feedback');

        //INSERT THE FEEDBACK IN TO THE DATABASE
        $row = $table->createRow();
        $row->blockip_comment = $values['blockip_comment'];
        $row->blockip_feedback = $values['blockip_feedback'];
        $row->blockip_address = $values["label"];
        $row->save();
			
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

    $this->renderScript('admin-settings/form.tpl');
  }

  //ACTION FOR ADD NEW SEVERITY
  public function addSeverityAction()
  {

    $this->_helper->layout->setLayout('admin-simple');

    $form = $this->view->form = new Feedback_Form_Admin_Severity();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try{
        // ADD SEVERITY TO THE DATABASE
        $table = Engine_Api::_()->getDbtable('severities', 'feedback');

        // INSERT THE SEVERITY IN TO THE DATABASE
        $row = $table->createRow();
        $row->user_id   =  1;
        $row->severity_name = $values["label"];
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

    $this->renderScript('admin-settings/form.tpl');
  }
  
  //ACTION FOR ADD NEW STATUS
  public function addstatAction()
  {
  
    $this->_helper->layout->setLayout('admin-simple');

  	$form = $this->view->form = new Feedback_Form_Admin_Stat();
  	$form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues(); 

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        // ADD STATUS TO THE DATABASE

        $table = Engine_Api::_()->getDbtable('status', 'feedback');

        // INSERT THE STATUS IN TO THE DATABASE
        $row = $table->createRow();
        $row->user_id   =  1;
        $row->stat_name = $this->_getParam('label');
        $stat_color = $this->_getParam('myInput'); 
        if(!empty($stat_color)) {
        	$row->stat_color = $stat_color; 
        }  
        $row->save();

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
  }
  
  //ACTION FOR DELETE CATEGORY 
  public function deleteCategoryAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->feedback_id=$id;

    if( $this->getRequest()->isPost()) {
    	$db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        $row = Engine_Api::_()->feedback()->getCategory($id);
        // DELETE CATEGORY FROM DATABASE
        $row->delete();

        $feedbackTable = $this->_helper->api()->getDbtable('feedbacks', 'feedback');
        $select = $feedbackTable->select()->where('category_id = ?', $id);
        $feedbacks = $feedbackTable->fetchAll($select);

        // CREATE PERMISSION
        foreach( $feedbacks as $feedback ) {
          	$feedback->category_id = 0;
          	$feedback->save();
        }

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

    $this->renderScript('admin-settings/delete.tpl');
  }

  //ACTION FOR DELETE BLOCK IP 
  public function deleteBlockipAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');

    if( $this->getRequest()->isPost()) {
    	$db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        $row = Engine_Api::_()->feedback()->getBlockip($id);
        // DELETE IP FROM DATABASE
        $row->delete();
        
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

    $this->renderScript('admin-settings/delete.tpl');
  }

  //ACTION FOR DELETE SEVERITY 
  public function deleteSeverityAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->feedback_id=$id;

    if( $this->getRequest()->isPost()) {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        $row = Engine_Api::_()->feedback()->getSeverity($id);
        // DELETE SEVERITY FROM DATABASE
        $row->delete();

        $feedbackTable = $this->_helper->api()->getDbtable('feedbacks', 'feedback');
        $select = $feedbackTable->select()->where('severity_id = ?', $id);
        $feedbacks = $feedbackTable->fetchAll($select);

        // CREATE PERMISSION
        foreach( $feedbacks as $feedback ) {
          $feedback->severity_id = 0;
          $feedback->save();
        }

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

    $this->renderScript('admin-settings/delete.tpl');
  }
  
  public function deleteStatAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->feedback_id=$id;

    if( $this->getRequest()->isPost()) {
    	$db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        $row = Engine_Api::_()->feedback()->getStat($id);
        // DELETE STATUS FROM DATABASE
        $row->delete();

        $feedbackTable = $this->_helper->api()->getDbtable('feedbacks', 'feedback');
        $select = $feedbackTable->select()->where('stat_id = ?', $id);
        $feedbacks = $feedbackTable->fetchAll($select);

        foreach( $feedbacks as $feedback ) {
          	$feedback->stat_id = 0;
          	$feedback->save();
       	}

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

    // Output
    $this->renderScript('admin-settings/delete.tpl');
  }
  
  //ACTION FOR EDIT CATEGORY
  public function editCategoryAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Feedback_Form_Admin_Category();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));


    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {

        $row = Engine_Api::_()->feedback()->getCategory($values["id"]);

        $row->category_name = $values["label"];
        $row->save();
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

    $category = Engine_Api::_()->feedback()->getCategory($id);
    $form->setField($category);

    $this->renderScript('admin-settings/form.tpl');
  }
  
  //ACTION FOR EDIT BLOCK IP
  public function editBlockipAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Feedback_Form_Admin_Blockip();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {

        $row = Engine_Api::_()->feedback()->getBlockip($values["id"]);

        $row->blockip_address = $values["label"];
        $row->blockip_comment = $values['blockip_comment'];
        $row->blockip_feedback = $values['blockip_feedback'];
        $row->save();
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

    $blockip = Engine_Api::_()->feedback()->getBlockip($id);
    $form->setField($blockip);

    $this->renderScript('admin-settings/form.tpl');
  }
  
    //ACTION FOR EDIT SEVERITY
  public function editSeverityAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $form = $this->view->form = new Feedback_Form_Admin_Severity();
    $form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $values = $form->getValues();

      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {

        $row = Engine_Api::_()->feedback()->getSeverity($values["id"]);
        $row->severity_name = $values["label"];
        $row->save();
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

    $severity = Engine_Api::_()->feedback()->getSeverity($id);
    $form->setField($severity);

    $this->renderScript('admin-settings/form.tpl');
  }
  
  //ACTION FOR EDIT STATUS
  public function editstatAction()
  {

    $this->_helper->layout->setLayout('admin-simple');
    $id = $this->_getParam('id');
    $this->view->status = $status = Engine_Api::_()->feedback()->getStat($id); 
    $this->view->stat_name = $status->stat_name;
    $this->view->stat_color = $status->stat_color;
 
  	$form = $this->view->form = new Feedback_Form_Admin_Stat();
  	$form->setAction($this->getFrontController()->getRouter()->assemble(array()));

    if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) ) {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try {
        // ADD STATUS TO THE DATABASE
        $table = Engine_Api::_()->getDbtable('status', 'feedback');

   		// INSERT THE STATUS IN TO THE DATABASE
        $row = $table->createRow();
        $row->user_id   =  1;
       	$row = Engine_Api::_()->feedback()->getStat($id);
        $row->stat_name = $this->_getParam('label');
        $stat_color = $this->_getParam('myInput'); 
        if(!empty($stat_color)) {
        	$row->stat_color = $stat_color; 
        }  
        $row->save();

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
  }

}
?>
