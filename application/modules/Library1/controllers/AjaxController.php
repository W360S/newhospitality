<?php
class Library_AjaxController extends Core_Controller_Action_Standard
{
  public function commentsAction(){
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
        $book_id = $this->_request->getParam("book_id");
        
        $commenttable = Engine_Api::_()->getDbtable('comments', 'library');
        $usertable = Engine_Api::_()->getDbtable('users', 'user');
        $rName = $commenttable->info('name');
        $uName = $usertable->info('name');
        $select = $commenttable->select()
            ->setIntegrityCheck(false)
            ->from($rName, new Zend_Db_Expr('engine4_library_comments.*, engine4_users.username'))
            ->joinLeft($uName,'engine4_users.user_id = engine4_library_comments.user_id',array())
            ->where('engine4_library_comments.book_id = ?',$book_id)
            ->order('created_date desc');
        
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(15);
        $paginator->setCurrentPageNumber( $this->_getParam('page') );
        $this->renderScript('_comments.tpl');
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }
  
  public function homeTabAction(){
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $ratingTable = Engine_Api::_()->getDbtable('ratings', 'library');
        $commentTable = Engine_Api::_()->getDbtable('comments', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
        $commentName = $commentTable->info('name');
        $ratingName = $ratingTable->info('name');
       
		$select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
            (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id  and engine4_library_comments.status = 1) as cnt_comment
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->group('engine4_library_books.book_id')
        
        ->order('created_date desc')
        ->limit(15)
        ;
        $records= $bookcategoriesTable->fetchAll($select);
        $paginator = $this->view->paginator = Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(3);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(5);
        //$this->renderScript('home-tab.tpl');
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }


  
}