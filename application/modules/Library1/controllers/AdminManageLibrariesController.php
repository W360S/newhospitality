<?php

class Library_AdminManageLibrariesController extends Core_Controller_Action_Admin
{
  /* list library*/  
  public function indexAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('library_admin_main', array(), 'library_admin_main_manage_libraries');
    $cat_id = trim($this->_getParam('cat_id'));
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    $keyword = $this->_getParam('keyword');
    $order = $this->_getParam('order');
    
    //$page = $this->_getParam('page',1);
    $paginators = Engine_Api::_()->library()->getLibraryPaginator($arr_cats, $keyword, $order, '1,0');
    
    $this->view->categories = Engine_Api::_()->library()->getCategories();
    $this->view->paginator = $paginators;
    $this->view->paginator->setItemCountPerPage(15);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
    
  }
  
  public function createAction()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
	$this->view->form = $form = new Library_Form_Admin_Create();
    
    // Populate options
    $categories = Engine_Api::_()->getDbtable('categories', 'library')->fetchAll();
    $arr_cat = array();
    if($categories->count()){
        foreach($categories as $item){
            $arr_cat[$item['category_id']] = $item['name'];
        }
    }
    // set categories to element
    $form->categories->addMultiOptions($arr_cat);
	
	// If not post or form not valid, return
	if( $this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost()) )
	{
	  $db = Engine_Api::_()->getDbtable('books', 'library')->getAdapter();
      $db->beginTransaction();
	  
	  try
	  {
		// Create book
		$viewer = Engine_Api::_()->user()->getViewer();
	    $table = $this->_helper->api()->getDbtable('books', 'library');
		$book = $table->createRow();
		$values = $form->getValues();
        
        //Zend_Debug::dump($_FILES['url']['type']); exit();
        
        $url = $values['url'];
        
        $pos = strpos($url,'.');
        $new_url = base64_encode(time() . '_' . str_replace(' ','-',substr($url,0,$pos))) . '.' . substr($url,$pos+1);
        @rename(APPLICATION_PATH.'/public/library_book/files/' . $url,APPLICATION_PATH.'/public/library_book/files/' . time() . '_' . str_replace(' ','-',$values['url']));
        $url = $new_url;
        
        $book_val = array(
            "title"=>$values['title'], 
            "isbn"=>$values['isbn'],
            "author"=>$values['author'],
            "user_id" => Engine_Api::_()->user()->getViewer()->getIdentity(),
            "credit"=>$values['credit'],
            "description"=>$values['description'],
            "created_date"=>date('Y-m-d H:i:s'),
            "url"=>$url,
            "file_type"=>$_FILES['url']['type']
        );
		
        $book->setFromArray($book_val);
		$result_book = $book->save();
		//end save form book
		
        // Add photo
		if( !empty($values['photo']) ) {
		    $book->setPhotos($form->photo);
			$book->save();
		}
        
        // Add categories
        Engine_Api::_()->library()->createCategoriesBook($values["categories"], $result_book);
        
		// Commit
		$db->commit();

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
    $this->view->form = $form = new Library_Form_Admin_Edit();
    $this->view->book_id = $this->_getParam('book_id');
    
    // get categories
    $categories = Engine_Api::_()->getDbtable('categories', 'library')->fetchAll();
    $arr_cat = array();
    if($categories->count()){
        foreach($categories as $item){
            $arr_cat[$item['category_id']] = $item['name'];
        }
    }
    // set categories to element
    $form->categories->addMultiOptions($arr_cat);
    
    $selected_categories = Engine_Api::_()->library()->getCategoriesOfBook($this->_getParam('book_id'));
    $selected_arr_cat = array();
    if($selected_categories->count()){
        foreach($selected_categories as $item){
            $selected_arr_cat[$item['category_id']] = $item['category_id'];
        }
    }
    $form->categories->setValue($selected_arr_cat);
    
    $book = Engine_Api::_()->getDbtable('books', 'library')->find($this->_getParam('book_id'))->current();
	
	if( !Engine_Api::_()->core()->hasSubject('book') )
	{
	  Engine_Api::_()->core()->setSubject($book);
	}

	if( !$this->_helper->requireSubject()->isValid() ) return;

	//Save entry
	if( !$this->getRequest()->isPost())
	{
	  // etc
	  $form->populate($book->toArray());
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
	  // update categories
      Engine_Api::_()->library()->updateCategoriesBook($values["categories"], $this->_getParam('book_id'));
      
      // update photo
      if( !empty($values['photo']) ) {
        // get old data
        $old_photo_data = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($book->photo_id);
        Engine_Api::_()->library()->deleteImages($old_photo_data);
        
        $book->setPhotos($form->photo);
      }
      
      // update file
      if( !empty($values['url']) ) {
        // get old data
        $pos = strpos($book->url,'.'); 
        @unlink(APPLICATION_PATH.'/public/library_book/files/' . base64_decode(substr($book->url,0,$pos)) . '.' . substr($book->url,$pos+1));
        
        $pos = strpos($values['url'],'.');
        $new_url = base64_encode(time() . '_' . str_replace(' ','-',substr($values['url'],0,$pos))) . '.' . substr($values['url'],$pos+1);
        @rename(APPLICATION_PATH.'/public/library_book/files/' . $values['url'],APPLICATION_PATH.'/public/library_book/files/' . time() . '_' . str_replace(' ','-',$values['url']));
        $url = $new_url;
        
      } else {
        $url = $book->url;
      }
      //Zend_DEbug::dump($values); exit;
      $book->setFromArray($values);
      $book->url = $url;
      
      $book->save();
	  $db->commit();
	  return $this->_helper->redirector->gotoRoute(array('action' => 'index'));

	}
	catch( Exception $e )
	{
	  $db->rollBack();
	  throw $e;
	}
    
  }
  
  public function viewAction(){
    $this->view->book_id = $book_id = $this->_getParam('book_id', null);
    
    $book = Engine_Api::_()->library()->getBook($book_id);
    
    $paginators = Engine_Api::_()->library()->getCommentsPaginator($book_id);
    $this->view->book = $book;
    $this->view->rating_count = Engine_Api::_()->library()->countRatings($book_id);
    $this->view->paginator = $paginators;
    $this->view->paginator->setItemCountPerPage(15);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
  }
  
  public function detailCommentAction(){
    $comment_id = $this->_getParam('comment_id', null);
    $comment = Engine_Api::_()->getDbtable('comments', 'library')->find($comment_id)->current();
    $this->view->comment = $comment;
    $this->_helper->layout->setLayout('admin-simple');
    $this->renderScript('admin-manage-libraries/detail-comment.tpl');
  }
  
  public function deleteSelectedAction()
  {
    $this->view->ids = $ids = $this->_getParam('ids', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $ids_array = explode(",", $ids);
      foreach( $ids_array as $id ){
        $book = Engine_Api::_()->getDbtable('books', 'library')->find($id)->current();
        if( $book ) Engine_Api::_()->library()->deleteBook($book->book_id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function deleteAction(){
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $book_id = $this->_getParam('book_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $result = Engine_Api::_()->library()->deleteBook($book_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_($result)),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
    }
    // Output
    $this->renderScript('admin-manage-libraries/delete.tpl');
  }
  
  
  
  public function deleteImageAction()
  {
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $book_id = $this->_getParam('book_id');
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
       Engine_Api::_()->library()->deleteImages($images);
       // Cap nhat database
       $row = Engine_Api::_()->getDbtable('books', 'library')->find($book_id)->current();
       $row->photo_id = null;
       $row->save();
       
       $db->commit();
      }

      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_('Image of book has been deleted successfull.')),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
        
    }
    // Output
    $this->renderScript('admin-manage-libraries/delete-image.tpl');
  }
  
  public function deleteCommentsSelectedAction()
  {
    $this->view->delete_ids = $delete_ids = $this->_getParam('delete_ids', null);
    $this->view->book_id = $book_id = $this->_getParam('book_id', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $delete_ids));
    
    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $ids_array = explode(",", $delete_ids);
      foreach( $ids_array as $id ){
        $comment = Engine_Api::_()->getDbtable('comments', 'library')->find($id)->current();
        if( $comment ) Engine_Api::_()->library()->deleteComment($comment->comment_id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'view','book_id'=>$book_id));
    }
  }
  
  public function approveCommentsSelectedAction()
  {
    $this->view->approve_ids = $approve_ids = $this->_getParam('approve_ids', null);
    $this->view->book_id = $book_id = $this->_getParam('book_id', null);
    $confirm = $this->_getParam('confirm', false);
    $this->view->count = count(explode(",", $approve_ids));

    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $ids_array = explode(",", $approve_ids);
      foreach( $ids_array as $id ){
        $comment = Engine_Api::_()->getDbtable('comments', 'library')->find($id)->current();
        if( $comment ) Engine_Api::_()->library()->approveComment($comment->comment_id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'view','book_id'=>$book_id));
    }
  }
  
  public function deleteCommentAction(){
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $comment_id = $this->_getParam('comment_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
     $result = Engine_Api::_()->library()->deleteComment($comment_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_($result)),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
    }
    // Output
    $this->renderScript('admin-manage-libraries/delete-comment.tpl');
  }
  
  public function approveCommentAction(){
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $comment_id = $this->_getParam('comment_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $result = Engine_Api::_()->library()->approveComment($comment_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_($result)),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
      
    }
    // Output
    $this->renderScript('admin-manage-libraries/approve-comment.tpl');
  }
}