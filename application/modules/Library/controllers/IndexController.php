<?php
/*
    Change function viewAction()
    Check if mem has been add book to shelf then hide button 
*/
class Library_IndexController extends Core_Controller_Action_Standard
{
  public function init()
  {
     //if( Engine_Api::_()->user()->getViewer()->getIdentity() == 0 ) return;
     //if( !$this->_helper->requireUser()->isValid() ) return;
  }

  public function likeAction()
  {
	$viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();

	$book_id = $this->_getParam('book_id');
	
	$table  = Engine_Api::_()->getDbTable('likes', 'library');
    $rName = $table->info('name');
    $select = $table->select()
                    ->from($rName)
                    ->where($rName.'.book_id = ?', $book_id);
    $row = $table->fetchAll($select);
    $total = count($row);

	$data = array();
	

    $select1 = $table->select()
                    ->from($rName)
                    ->where($rName.'.book_id = ?', $book_id)
                    ->where($rName.'.user_id = ?', $user_id);
    $row1 = $table->fetchRow($select1);
    if (empty($row1)) {
      // create rating
      Engine_Api::_()->getDbTable('likes', 'library')->insert(array(
        'book_id' => $book_id,
        'user_id' => $user_id
      ));
	$data[] = array(
	  'total' => $total + 1
	);
	   return $this->_helper->json($data);
	  $data = Zend_Json::encode($data);
      $this->getResponse()->setBody($data);
    } else {
		$data[] = array(
		'total' => $total
		);
		 return $this->_helper->json($data);
	  $data = Zend_Json::encode($data);
      $this->getResponse()->setBody($data);
	}

	
  }

  public function indexAction()
  {
    $cat_id = trim($this->_getParam('cat_id'));
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    $category_name_exist= $this->_getParam('category_name');
    
    if(!empty($category_name_exist)){
        $this->view->category_name= Engine_Api::_()->library()->getCategory($this->_getParam('cat_id'));
    }
    $keyword = $this->_getParam('keyword');
    $order = $this->_getParam('order');
    
    $page = $this->_getParam('page',1);
    
    $paginators = Engine_Api::_()->library()->getLibraryPaginator($arr_cats, $keyword, $order, '1', $page);
    $this->view->paginator = $paginators;

	
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
    $select = $categoryTable->select()
      ->order('priority ASC');
      
    
    $this->view->categories = $categoryTable->fetchAll($select);
	//Zend_Debug::dump($paginators);exit;
    //$this->view->arr_cats = $arr_cats;
    $request_keyword = Zend_Controller_Front::getInstance()->getRequest()->getParam("keyword");
    if(!empty($request_keyword) || count($arr_cats)){
        $breadcrumb = 'Search';
    } else {
        $breadcrumb = 'All books';
    }
    $this->view->breadcrumb = $breadcrumb;
  }
  
  public function ajaxBookAction(){
    $this->_helper->layout->disableLayout();
    
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    $cat_id = trim($this->_getParam('cat_id'));
    
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    
    $keyword = $this->_getParam('keyword');
    $order = $this->_getParam('order');
    $page= $this->_getParam('page');
     
    //$page = $this->_getParam('page',1);
    $paginators = Engine_Api::_()->library()->getLibraryPaginator($arr_cats, $keyword, $order, '1', $page);
    $this->view->paginator = $paginators;
   
  }

  public function ajaxBookshelfAction(){
    $this->_helper->layout->disableLayout();
    

	$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    $paginators = Engine_Api::_()->library()->getBookshelfPaginator($user_id);
    $this->view->paginator = $paginators;
    $this->view->user_id = $user_id;
   
  }
  
  public function commentAction()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
    
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    $book_id = $this->_getParam('book_id', null);
    $paginators = Engine_Api::_()->library()->getPublicCommentsPaginator($book_id);
    
    $this->view->paginator = $paginators;
  }
  
  public function viewAction()
  {
    //check book in shelf
    $books= Engine_Api::_()->library()->myBookShelf(Engine_Api::_()->user()->getViewer()->getIdentity());
    if(!empty($books)){
        $my_books= array();
        foreach($books as $_book){
            $my_books[$_book->book_id]= $_book->book_id;
        }
        $this->view->my_books= $my_books;
    }
    //end
    if ($this->_request->isPost()){
        $this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        
        $book_id = $this->_getParam('book_id');
        $content = Engine_Api::_()->library()->cleanHtml($this->getRequest()->getPost('description'));
        if(strlen($content)> 1000){
            echo '{"message": "content"}';
   			exit();
        }
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        
        try
        {
            $table = $this->_helper->api()->getDbtable('comments', 'library');
    		$comment = $table->createRow();
            // Add question
            $comment_val = array(
                "content"=>$content, 
                "user_id"=>$user_id,
                "book_id"=>$book_id,
                "created_date"=>date('Y-m-d H:i:s'),
                "status"=>1
            );
    		$comment->setFromArray($comment_val);

        $book = Engine_Api::_()->getItem('library_book', $book_id);
        $owner = Engine_Api::_()->getApi('core', 'user')->getUser($user_id);
        
        // Add action
        $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');
        $action = $activityApi->addActivity($owner, $book, 'book_comment');
        if ($action) {
            $activityApi->attachActivity($action, $book);
        }else{

        }

    		$comment->save();
            $db->commit();
            echo '{"message": "success"}';
   			exit();
            //return $this->_helper->redirector->gotoRoute(array('module'=>'library', 'controller'=>'index' , 'action' => 'view', 'book_id'=>$book_id));
        }
        catch( Exception $e )
        {
          $db->rollBack();
          throw $e;
        }
        
    } else {
        
        $this->view->book_id = $book_id = $this->_getParam('book_id', null);
        //thiết lập title for page
        $subject = null;
        if( !Engine_Api::_()->core()->hasSubject() ){
            $subject = Engine_Api::_()->getItem('library_book', $book_id);
            if( $subject && $subject->getIdentity())
            {
              Engine_Api::_()->core()->setSubject($subject);
            }
        }
        $book = Engine_Api::_()->library()->getBook($book_id);

        $other_books = Engine_Api::_()->library()->getOtherBooks($book_id);
        $this->view->other_books = $other_books;
        
        $update_count = Engine_Api::_()->getDbtable('books', 'library')->find($book_id)->current();
        $update_count->view_count++;
        $update_count->save();
        
        $paginators = Engine_Api::_()->library()->getPublicCommentsPaginator($book_id);
        $this->view->paginator = $paginators;
        $this->view->book = $book;
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer->getIdentity();
        $this->view->rating_count = Engine_Api::_()->library()->countRatings($book_id);
        $this->view->rated = Engine_Api::_()->library()->checkRated($book_id, $viewer->getIdentity());
        $total_rating= Engine_Api::_()->library()->getRatings($book_id);
		$tt=0;
		if(!empty($total_rating)){
			foreach($total_rating as $tt_rating){
				$tt+= $tt_rating['rating'];
			}
		}
		//Zend_Debug::dump($tt);exit();
		$this->view->tt_rating= $tt;
    }
  }
  
  public function rateAction()
  {
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    
    $rating = $this->_getParam('rating');
    $book_id =  $this->_getParam('book_id');

    $table = Engine_Api::_()->getDbtable('ratings', 'library');
    $db = $table->getAdapter();
    $db->beginTransaction();

    try
    {
      Engine_Api::_()->library()->setRating($book_id, $user_id, $rating);
      $total = Engine_Api::_()->library()->ratingCount($book_id);
      $total_rating= Engine_Api::_()->library()->getRatings($book_id);
      $tt= 0;
      if(!empty($total_rating)){
        foreach($total_rating as $tt_rating){
            $tt+= $tt_rating['rating'];
        }
      }
      $book = Engine_Api::_()->getDbtable('books', 'library')->find($book_id)->current();
            
      $rating = $tt / $total;
      $book->rating = $rating;
      $book->total= $total;
      $book->save();

      $db->commit();
    }

    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }
    
    $data = array();
    $data[] = array(
      'total' => $total,
      'rating' => $rating,
    );
    return $this->_helper->json($data);
    $data = Zend_Json::encode($data);
    $this->getResponse()->setBody($data);
  }
}
