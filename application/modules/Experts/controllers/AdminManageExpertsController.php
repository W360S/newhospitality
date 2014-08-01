<?php

class Experts_AdminManageExpertsController extends Core_Controller_Action_Admin
{
  public function init()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
  }  
  /* list experts*/  
  public function indexAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('experts_admin_main', array(), 'experts_admin_main_manage_experts');
    
    $cat_id = trim($this->_getParam('cat_id'));
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    $keyword = $this->_getParam('keyword');
    $order = $this->_getParam('order');
    
    $experts_select = Engine_Api::_()->experts()->getExpertsList($keyword, $arr_cats, $order);
    $this->view->paginator = Zend_Paginator::factory($experts_select);
    $this->view->paginator->setItemCountPerPage(15);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
    $this->view->categories = Engine_Api::_()->experts()->getAdminCatExpert();
    
  }
  
  public function viewAction()
  {
    $expert_id = intval($this->_getParam('expert_id'));
    $cat_id = trim($this->_getParam('cat_id'));
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    $keyword = $this->_getParam('keyword');
    $status = $this->_getParam('status');
    $order = $this->_getParam('order');
    
    // lay thong tin chi tiet cua experts
    $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
    $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
    $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
    $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
    $expertsCatName = Engine_Api::_()->getDbtable('expertscategories', 'experts')->info('name');
    $storageName = Engine_Api::_()->getDbtable('files', 'storage')->info('name');
    
    $experts_select = Engine_Api::_()->getDbtable('expertscategories', 'experts')->select()
    ->setIntegrityCheck(false)
    ->from($expertsCatName, 
          new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/> ') as category, 
                            GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                            (SELECT Count(Distinct(question_id)) FROM engine4_experts_recipients where engine4_experts_recipients.user_id = engine4_experts_experts.user_id) as cnt_question,
                            (SELECT Count(Distinct(question_id)) FROM engine4_experts_answers where engine4_experts_answers.user_id = engine4_experts_experts.user_id) as cnt_answered,
                            engine4_experts_experts.*,
                            engine4_users.*,
                            engine4_storage_files.storage_path, engine4_storage_files.name as storage_name
                            ")
           )
    ->joinLeft($expertsName,'engine4_experts_experts.expert_id = engine4_experts_expertscategories.expert_id',array())     
    ->joinLeft($recipientsName,'engine4_experts_recipients.user_id = engine4_experts_experts.user_id',array())
    ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_experts.user_id',array())
    ->joinLeft($categoriesName,'engine4_experts_categories.category_id = engine4_experts_expertscategories.category_id',array())
    ->joinLeft($answerName,'engine4_experts_answers.user_id = engine4_experts_experts.user_id',array())
    ->joinLeft($storageName,'engine4_storage_files.file_id = engine4_experts_experts.file_id',array())
    ->group('engine4_experts_categories.category_id')
    ->where('engine4_experts_experts.expert_id = ?',$expert_id);
    
    $data_expert = Engine_Api::_()->getDbtable('expertscategories', 'experts')->fetchAll($experts_select)->current();
    //Zend_Debug::dump($data_expert); exit;
    // lay cac cau hoi thuoc expert do
    if($data_expert->expert_id){
        $this->view->data = $data_expert;
        $question_select = Engine_Api::_()->experts()->getAdminQuestionOfExpert($data_expert->user_id, $keyword, $arr_cats, $order, $status);
        $this->view->paginator = Zend_Paginator::factory($question_select);
        $this->view->paginator->setItemCountPerPage(15);
        $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
        //$this->view->categories = Engine_Api::_()->experts()->getAdminCatExpert();
    }
    
  }
  
  public function createAction()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
	$this->view->form = $form = new Experts_Form_Admin_Experts_Create();
    
    // Populate options
    $categories = Engine_Api::_()->getDbtable('categories', 'experts')->fetchAll();
    $arr_cat = array();
    if($categories->count()){
        foreach($categories as $item){
            $arr_cat[$item['category_id']] = $item['category_name'];
        }
    }
    // set categories to element
    $form->categories->addMultiOptions($arr_cat);
	
	// If not post or form not valid, return
	if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
	{
	  $db = Engine_Api::_()->getDbtable('experts', 'experts')->getAdapter();
      $db->beginTransaction();
	  
	  try
	  {
		// Create experts
		$viewer = Engine_Api::_()->user()->getViewer();
	    $values = $form->getValues();
        
        $recipients = preg_split('/[,. ]+/', $values['toValues']);
        $recipients = array_unique($recipients);
        
        if(count($recipients)){
            foreach($recipients as $item){
                $experts_val = array(
                    "occupation"=>$values['occupation'],
                    "user_id" => $item,
                    "experience"=>$values['experience'],
                    "company"=>$values['company'],
                    "description"=>$values['description'],
                    "created_date"=>date('Y-m-d H:i:s'),
                );
                
                $table = $this->_helper->api()->getDbtable('experts', 'experts');
		        $experts = $table->createRow();
                
                $experts->setFromArray($experts_val);
        		$result_experts = $experts->save();
        		//end save form experts
        		/*
                // Add photo
        		if( !empty($values['photo']) ) {
        		    $experts->setPhotos($form->photo);
        			$experts->save();
        		}
                */
                // Add attachment
        		if( !empty($values['file']) ) {
        			$experts->setFiles($form->file);
                    $experts->save();
        		}   
        		
                // Add categories
                Engine_Api::_()->experts()->createCategoriesExperts($values["categories"], $result_experts);
                
        		// Commit
        		$db->commit();
            }
        }
        
		// Redirect
		return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
	  }

	  catch( Exception $e )
	  {
		$db->rollBack();
		throw $e;
	  }
	}
  }
  
  public function editAction()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
    $this->view->form = $form = new Experts_Form_Admin_Experts_Edit();
    $this->view->expert_id = $this->_getParam('expert_id');
    
    // get categories
    $categories = Engine_Api::_()->getDbtable('categories', 'experts')->fetchAll();
    $arr_cat = array();
    if($categories->count()){
        foreach($categories as $item){
            $arr_cat[$item['category_id']] = $item['category_name'];
        }
    }
    // set categories to element
    $form->categories->addMultiOptions($arr_cat);
    
    $selected_categories = Engine_Api::_()->experts()->getCategoriesOfExperts($this->_getParam('expert_id'));
    $selected_arr_cat = array();
    if($selected_categories->count()){
        foreach($selected_categories as $item){
            $selected_arr_cat[$item['category_id']] = $item['category_id'];
        }
    }
    $form->categories->setValue($selected_arr_cat);
    
    $experts = Engine_Api::_()->getDbtable('experts', 'experts')->find($this->_getParam('expert_id'))->current();
	
	if( !Engine_Api::_()->core()->hasSubject('experts') )
	{
	  Engine_Api::_()->core()->setSubject($experts);
	}

	if( !$this->_helper->requireSubject()->isValid() ) return;

	//Save entry
	if( !$this->getRequest()->isPost())
	{
	  // etc
	  $form->populate($experts->toArray());
	  return;
	}

	if( !$form->isValid($this->getRequest()->getPost()) )
	{
	  return;
	}

	// Process
	$values = $form->getValues();
	
	$db = Engine_Db_Table::getDefaultAdapter();
	$db->beginTransaction();
	try
	{
	  $experts->setFromArray($values);
	  $experts->save();
	  
      // update categories
      Engine_Api::_()->experts()->updateCategoriesExperts($values["categories"], $this->_getParam('expert_id'));
      
      /*
      // update photo
      if( !empty($values['photo']) ) {
        // get old data
        $old_photo_data = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($experts->photo_id);
        Engine_Api::_()->experts()->deleteImages($old_photo_data);
        $experts->setPhotos($form->photo);
        $experts->save();
      }
      */
      // update file
      if( !empty($values['file']) ) {
        // get old data
        Engine_Api::_()->experts()->deleteFile($experts->file_id, $this->_getParam('expert_id'));
        $experts->setFiles($form->file);
        $experts->save();
      }

	  $db->commit();
	  return $this->_helper->redirector->gotoRoute(array('action' => 'index'));

	}
	catch( Exception $e )
	{
	  $db->rollBack();
	  throw $e;
	}
    
  }
  
  /**
   * Delete experts
   */
  public function deleteAction()
  {
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $expert_id = $this->_getParam('expert_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      Engine_Api::_()->experts()->deleteExperts($expert_id);
      
      $this->_forward('success', 'utility', 'core', array(
          'smoothboxClose' => 10,
          'parentRefresh'=> 10,
          'messages' => array('')
      ));
    }
    // Output
    $this->renderScript('admin-manage-experts/delete.tpl');
  }
  
  public function deleteSelectedAction()
  {
    $this->view->ids = $ids = $this->_getParam('delete_ids', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
        
      $ids_array = explode(",", $ids);
      
      foreach( $ids_array as $id ){
        Engine_Api::_()->experts()->deleteExperts($id);
      }

      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  
  public function deleteFileAction()
  {
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $expert_id = $this->_getParam('expert_id');
    $file_id = $this->_getParam('file_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
       // Delete file
       Engine_Api::_()->experts()->deleteFile($file_id);
       // Update database
       $row = Engine_Api::_()->experts()->getExpertsItem($expert_id);
       $row->file_id = null;
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
    $this->renderScript('admin-manage-experts/delete-file.tpl');
  }
  
  /*
  public function emailSelectedAction()
  {
    
  }
  
  public function deleteImageAction()
  {
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $expert_id = $this->_getParam('expert_id');
    $photo_id = $this->_getParam('photo_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();

      try
      {
       // Xoa anh
       $images = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($photo_id);
       Engine_Api::_()->experts()->deleteImages($images);
       // Cap nhat database
       $row = Engine_Api::_()->experts()->getExpertsItem($expert_id);
       $row->photo_id = null;
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
    $this->renderScript('admin-manage-experts/delete-image.tpl');
  }
  */
}

