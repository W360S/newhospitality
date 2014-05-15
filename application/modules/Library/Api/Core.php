<?php

class Library_Api_Core extends Core_Api_Abstract
{
    static $title_tags = array();
    
    static $content_tags = array();
    
    public function cleanTitle($html)
    {
        $chain = new Zend_Filter();
        $chain->addFilter(new Zend_Filter_StripTags(self::$title_tags));
        $chain->addFilter(new Zend_Filter_StringTrim());
        $html = $chain->filter($html);
        
        $tmp = $html;
        while (1) {
        	// Try and replace an occurence of javascript
        	$html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $html);
        	
        	// If nothing changes this iteration then break loop
        	if ($html == $tmp)
        		break;
        		
        	$tmp = $html;
        }
        
        return $html;
    } 
    
    
    public function cleanHtml($html)
    {
        $chain = new Zend_Filter();
        $chain->addFilter(new Zend_Filter_StripTags(self::$content_tags));
        $chain->addFilter(new Zend_Filter_StringTrim());
        $html = $chain->filter($html);
        
        $tmp = $html;
        while (1) {
        	// Try and replace an occurence of javascript
        	$html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $html);
        	
        	// If nothing changes this iteration then break loop
        	if ($html == $tmp)
        		break;
        		
        	$tmp = $html;
        }
        
        return $html;
    } 
    
    public function countComments($book_id){
        $commentTable = Engine_Api::_()->getDbtable('comments', 'library');
        $rName = $commentTable->info('name');
        
        $count_comment = $commentTable->select()
        ->from($rName)
        ->where($rName.'.book_id = ?', $book_id);
        
        $row = $commentTable->fetchAll($count_comment);
        $total = count($row);
        return $total;
    }
    
    public function countRatings($book_id){
        $ratingTable = Engine_Api::_()->getDbtable('ratings', 'library');
        $rName = $ratingTable->info('name');
        
        $count_rating = $ratingTable->select()
        ->from($rName)
        ->where($rName.'.book_id = ?', $book_id);
        
        $row = $ratingTable->fetchAll($count_rating);
        $total = count($row);
        return $total;
    }
    
    public function getBookshelfPaginator($user_id, $status='0')
    {
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
        $ratingTable = Engine_Api::_()->getDbtable('ratings', 'library');
        $commentTable = Engine_Api::_()->getDbtable('comments', 'library');
        $bookshelfTable = Engine_Api::_()->getDbtable('bookshelfs', 'library');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
        $ratingName = $ratingTable->info('name');
        $commentName = $commentTable->info('name');
        $bookshelfName = $bookshelfTable->info('name');
        
        $select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_library_bookshelfs.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
            (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id  and engine4_library_comments.status = ('{$status}')) as cnt_comment
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
        ->joinLeft($bookshelfName,'engine4_library_bookshelfs.book_id = engine4_library_bookscategories.book_id',array())
        ->where('engine4_library_bookshelfs.user_id = ?',$user_id)
        ->where('engine4_library_bookshelfs.status in (?)',$status)
        ->group('engine4_library_books.book_id')
        ->order('engine4_library_bookshelfs.created_date Desc');
        $paginator = Zend_Paginator::factory($select);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(5);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        return $paginator;
    }
    
    public function getLibraryPaginator($cat = null, $keyword=null, $order=null, $status = '1', $page)
    {
        $paginator = Zend_Paginator::factory($this->getLibraryList($cat,$keyword,$order, $status));
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
        return $paginator;
    }
    
    function getLibraryList($cat = null, $keyword=null, $order = null, $status = '1')
    {
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
        
        $order_search = 'created_date desc';
        switch($order)
        {
            case 'created_date':
                $order_search = 'created_date desc';
                break;
            case 'download':
                $order_search = 'download_count desc';
                break;
            case 'view':
                $order_search = 'view_count desc';
                break;
        } 
        
        // truong hop co cat_id
        if(count($cat)){
            
            $select = $bookcategoriesTable->select()
            ->setIntegrityCheck(false)
            ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
                GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
                GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
                (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
                (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id and engine4_library_comments.status in ('{$status}')) as cnt_comment
                "))
            ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
            ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
            ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
            ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
            ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
            ->where('engine4_library_bookscategories.category_id in (?)', $cat)
            ->where('engine4_library_books.title LIKE ? or engine4_library_books.description LIKE ? or engine4_library_books.author LIKE ? or engine4_library_books.isbn LIKE ?', "%".$keyword."%")
            ->group('engine4_library_books.book_id')
            ->order($order_search);
        
        // truong hop ko co cat_id    
        } else {
            $select = $bookcategoriesTable->select()
            ->setIntegrityCheck(false)
            ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
                GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
                GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
                (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
                (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id  and engine4_library_comments.status = ('{$status}')) as cnt_comment
                "))
            ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
            ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
            ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
            ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
            ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
            ->where('engine4_library_books.title LIKE ? or engine4_library_books.description LIKE ? or engine4_library_books.author LIKE ? or engine4_library_books.isbn LIKE ?', "%".$keyword."%")
            ->group('engine4_library_books.book_id')
            ->order($order_search);
        }
        return $select;
    }
    
    public function getPublicCommentsPaginator($book_id = null)
    {
        $commenttable = Engine_Api::_()->getDbtable('comments', 'library');
        $usertable = Engine_Api::_()->getDbtable('users', 'user');
        $rName = $commenttable->info('name');
        $uName = $usertable->info('name');
        $select = $commenttable->select()
            ->setIntegrityCheck(false)
            ->from($rName, new Zend_Db_Expr('engine4_library_comments.*, engine4_users.user_id, engine4_users.username, engine4_users.photo_id'))
            ->joinLeft($uName,'engine4_users.user_id = engine4_library_comments.user_id',array())
            ->where('engine4_library_comments.book_id = ?',$book_id)
            ->where('engine4_library_comments.status = ?',1)
            ->order('created_date ASC');
        
        $paginator = Zend_Paginator::factory($select);
        //$this->view->paginator = $paginators;
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(5);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        return $paginator;
    }
    
    
    public function getCommentsPaginator($book_id = null)
    {
        $commenttable = Engine_Api::_()->getDbtable('comments', 'library');
        $usertable = Engine_Api::_()->getDbtable('users', 'user');
        $rName = $commenttable->info('name');
        $uName = $usertable->info('name');
        $select = $commenttable->select()
            ->setIntegrityCheck(false)
            ->from($rName, new Zend_Db_Expr('engine4_library_comments.*, engine4_users.user_id, engine4_users.username'))
            ->joinLeft($uName,'engine4_users.user_id = engine4_library_comments.user_id',array())
            ->where('engine4_library_comments.book_id = ?',$book_id)
            ->order('created_date desc');
        
        $paginator = Zend_Paginator::factory($select);
        //$this->view->paginator = $paginators;
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        
        return $paginator;
    }
    
    function getTopDownloads(){
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
        $ratingTable = Engine_Api::_()->getDbtable('ratings', 'library');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
        $ratingName = $ratingTable->info('name');
        
        $select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->group('engine4_library_books.book_id')
        ->order('engine4_library_books.download_count Desc')
        ->limit(6);
        return $bookcategoriesTable->fetchAll($select);
    }
    
    function getTopViews(){
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
        $ratingTable = Engine_Api::_()->getDbtable('ratings', 'library');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
        $ratingName = $ratingTable->info('name');
        
        $select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->group('engine4_library_books.book_id')
        ->order('engine4_library_books.view_count Desc')
        ->limit(7);
        return $bookcategoriesTable->fetchAll($select);
    }
    
    public function getOtherBooks($book_id){
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
        
        $old_select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
            (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id and engine4_library_comments.status = 1) as cnt_comment
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->where('engine4_library_bookscategories.category_id in (select category_id from engine4_library_bookscategories where book_id = ?)', $book_id)
        ->where('engine4_library_books.book_id < ?', $book_id)
        ->group('engine4_library_books.book_id')
        ->limit(3);
        
        
        $new_select = $bookcategoriesTable->select()
        ->setIntegrityCheck(false)
        ->from($bookcategoriesName, new Zend_Db_Expr("engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, 
            GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, 
            GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids,
            (SELECT count(engine4_library_ratings.book_id) FROM engine4_library_ratings WHERE engine4_library_ratings.book_id = engine4_library_books.book_id) as cnt_rating,
            (SELECT count(engine4_library_comments.book_id) FROM engine4_library_comments WHERE engine4_library_comments.book_id = engine4_library_books.book_id and engine4_library_comments.status = 1) as cnt_comment
            "))
        ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
        ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
        ->joinLeft($commentName,'engine4_library_bookscategories.book_id = engine4_library_comments.book_id',array())
        ->joinLeft($ratingName,'engine4_library_bookscategories.book_id = engine4_library_ratings.book_id',array())
        ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
        ->where('engine4_library_bookscategories.category_id in (select category_id from engine4_library_bookscategories where book_id = ?)', $book_id)
        ->where('engine4_library_books.book_id > ?', $book_id)
        ->group('engine4_library_books.book_id')
        ->limit(2);
        
        $select = $bookcategoriesTable->select()
        ->union(array($new_select,$old_select));
        
        $other_books = $bookcategoriesTable->fetchAll($select);
        return $other_books;
    }
    
    
    public function getEbook($book_id){
        
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
         
    	$select = $booktable->select()
            ->setIntegrityCheck(false)
            ->from($bookName, new Zend_Db_Expr('engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids'))
            ->joinLeft($bookcategoriesName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
            ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
            ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
            ->where('engine4_library_books.book_id = ?',$book_id)
            ->group('engine4_library_books.book_id');
            
        $data = $booktable->fetchRow($select); 
        return $data;
    }
    
    
    public function getBook($book_id){
        
        $booktable = Engine_Api::_()->getDbtable('books', 'library');
        $bookcategoriesTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library');
        $storageTable =  Engine_Api::_()->getDbtable('files', 'storage');
             
        $bookName = $booktable->info('name');
        $bookcategoriesName = $bookcategoriesTable->info('name');
        $categoryName = $categoryTable->info('name');
        $storageName = $storageTable->info('name');
         
    	$select = $bookcategoriesTable->select()
            ->setIntegrityCheck(false)
            ->from($bookcategoriesName, new Zend_Db_Expr('engine4_library_books.*, engine4_storage_files.storage_path, engine4_library_bookscategories.*, GROUP_CONCAT(Distinct(engine4_library_categories.name)) as category, GROUP_CONCAT(Distinct(engine4_library_categories.category_id)) as category_ids'))
            ->joinLeft($bookName,'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
            ->joinLeft($categoryName,'engine4_library_bookscategories.category_id = engine4_library_categories.category_id',array())
            ->joinLeft($storageName,'engine4_storage_files.parent_file_id = engine4_library_books.photo_id and engine4_storage_files.type = "thumb.normal"',array())
            ->where('engine4_library_books.book_id = ?',$book_id)
            ->group('engine4_library_books.book_id');
            
        $data = $categoryTable->fetchRow($select); 
        return $data;
    }
    
    public function getCategories()
    {
       
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'library'); 
        $bookTable = Engine_Api::_()->getDbtable('books', 'library');
        $categoryBooksTable = Engine_Api::_()->getDbtable('bookscategories', 'library');
         
    	$categories_select = $categoryTable->select()
          ->setIntegrityCheck(false)
          ->from($categoryTable->info('name'), new Zend_Db_Expr('engine4_library_categories.*, count(engine4_library_books.book_id) as cnt_book'))
          ->joinLeft($categoryBooksTable->info('name'),'engine4_library_categories.category_id = engine4_library_bookscategories.category_id',array())
          ->joinLeft($bookTable->info('name'),'engine4_library_books.book_id = engine4_library_bookscategories.book_id',array())
          ->group('engine4_library_categories.category_id')
          ->order('priority asc');
    
        $data = $categoryTable->fetchAll($categories_select);    
        return $data;
        
    }
    
    public function getCategory($category_id)
    {
        return Engine_Api::_()->getDbtable('categories', 'library')->find($category_id)->current();
    }
    
    // rating for question
    public function getRatings($book_id)
    {
        $table  = Engine_Api::_()->getDbTable('ratings', 'library');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.book_id = ?', $book_id);
        $row = $table->fetchAll($select);
        return $row;
    }
    
    public function checkRated($book_id, $user_id)
    {
        $table  = Engine_Api::_()->getDbTable('ratings', 'library');
        
        $rName = $table->info('name');
        $select = $table->select()
                     ->setIntegrityCheck(false)
                        ->where('book_id = ?', $book_id)
                        ->where('user_id = ?', $user_id)
                        ->limit(1);
        $row = $table->fetchAll($select);
        
        if (count($row)>0) return true;
        return false;
    }
    
    public function setRating($book_id, $user_id, $rating){
        $table  = Engine_Api::_()->getDbTable('ratings', 'library');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.book_id = ?', $book_id)
                        ->where($rName.'.user_id = ?', $user_id);
        $row = $table->fetchRow($select);
        if (empty($row)) {
          // create rating
          Engine_Api::_()->getDbTable('ratings', 'library')->insert(array(
            'book_id' => $book_id,
            'user_id' => $user_id,
            'rating' => $rating
          ));
        }
    }
    
    public function ratingCount($book_id){
        $table  = Engine_Api::_()->getDbTable('ratings', 'library');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.book_id = ?', $book_id);
        $row = $table->fetchAll($select);
        $total = count($row);
        return $total;
    }
    
    public function createCategoriesBook($categories = array(), $book_id){
        if(count($categories)) {
            foreach($categories as $item){
                $row = Engine_Api::_()->getDbtable('bookscategories', 'library')->createRow();
                $row->setFromArray(array("book_id"=>$book_id, "category_id"=>intval($item)));
                $row->save();
            }
        }
    }
    
    public function getCategoriesOfBook($book_id=null){
        if($book_id){
            $table = Engine_Api::_()->getDbTable('bookscategories', 'library');
            $select = $table->select()
            ->where('book_id = ?', $book_id)
            ->group("category_id");
            return $table->fetchAll($select);
        }
    }
    
    public function updateCategoriesBook($new_categories = array(), $book_id){
        // update here
        if(count($new_categories) && $book_id){
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try
            {
               // delete  old categories
               $this->deleteCategoriesOfBook($book_id);
               $db->commit(); 
               // create new data
               $this->createCategoriesBook($new_categories, $book_id);
            }
            
            catch( Exception $e )
            {
                $db->rollBack();
                throw $e;
            } 
        }
    }
    
    public function deleteCategoriesOfBook($book_id){
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('bookscategories', 'library');
        $where = $table->getAdapter()->quoteInto('book_id = ?', $book_id);
        $table->delete($where);
    }
    
    public function deleteCommentsOfBook($book_id){
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('comments', 'library');
        $where = $table->getAdapter()->quoteInto('book_id = ?', $book_id);
        $table->delete($where);
    }
    
    public function deleteBookShelf($book_id){
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('bookshelfs', 'library');
        $where = $table->getAdapter()->quoteInto('book_id = ?', $book_id);
        $table->delete($where);
    }
    
    public function deleteRatingsOfBook($book_id){
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('ratings', 'library');
        $where = $table->getAdapter()->quoteInto('book_id = ?', $book_id);
        $table->delete($where);
    }
    
    function deleteImages($images){
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        if(count($images)){
          $db = Engine_Db_Table::getDefaultAdapter();
          $db->beginTransaction();
            
          try
          {
           foreach($images as $item){
              $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($item['file_id'])->current();
              $storage->delete();
              @unlink($path . $item['storage_path']);
           }
           $db->commit();
           
          }
          catch( Exception $e )
          {
            $db->rollBack();
            throw $e;
          } 
        }
    }
    
    function deleteComment($comment_id){
      $comment = Engine_Api::_()->getDbtable('comments', 'library')->find($comment_id)->current();
      // Delete book
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      $result = 'Delete comment not successfull.';
      try
      {
        $comment->delete();
        $db->commit();
        $result = 'Delete comment successfull.';
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      return $result;
    }
    
    function approveComment($comment_id){
      $comment = Engine_Api::_()->getDbtable('comments', 'library')->find($comment_id)->current();
      // Delete book
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      $result = 'Approve comment not successfull.';
      try
      {
        $comment->status = 1;
        $comment->save();
        $db->commit();
        $result = 'Approve comment successfull.';
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      return $result;
    }
    
    function deleteBook($book_id){
      $book = Engine_Api::_()->getDbtable('books', 'library')->find($book_id)->current();
      // Delete photo
      $images = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($book->photo_id);
      $this->deleteImages($images);
               
      // Delete file
      $pos = strpos($book->url,'.');
      @unlink(APPLICATION_PATH.'/public/library_book/files/' . base64_decode(substr($book->url,0,$pos)) . '.' . substr($book->url,$pos+1));
      
      // Delete book
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      $result = 'Delete book not successfull.';
      try
      {
        $book->delete();
        // delete categories of experts
        $this->deleteCategoriesOfBook($book_id);
        $this->deleteCommentsOfBook($book_id);
        $this->deleteRatingsOfBook($book_id);
        $this->deleteBookShelf($book_id);
        
        $db->commit();
        $result = 'Delete book successfull.';
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
      return $result;
    }
    
    function addBookShelf($book_id, $user_id){
        $bookshelf_select = Engine_Api::_()->getDbtable('bookshelfs', 'library')
                    ->select()
                    ->where('book_id = ?', $book_id)
                    ->where('user_id = ?', $user_id);
        $bookshelf = Engine_Api::_()->getDbtable('bookshelfs', 'library')->fetchRow($bookshelf_select);
        $result = 'Already exist this book in your bookshelf.';
        if(!count($bookshelf)){
            $row = Engine_Api::_()->getDbtable('bookshelfs', 'library')->createRow();
            $row->setFromArray(array("book_id"=>$book_id, "user_id"=>$user_id,'created_date'=>date('Y-m-d H:i:s')));
            $row->save();
            $result = 'This book has been added successfull to your bookshelf.';
        }
        return $result;           
    }
    
    function removeBookShelf($book_id, $user_id){
        $bookshelf_select = Engine_Api::_()->getDbtable('bookshelfs', 'library')
                            ->select()
                            ->where('book_id = ?', $book_id)
                            ->where('user_id = ?', $user_id);
        $bookshelf = Engine_Api::_()->getDbtable('bookshelfs', 'library')->fetchRow($bookshelf_select);
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        $result = 'Error. You have not permisssion to remove this book. ';
        try
        {
            $bookshelf->delete();
            $db->commit();
            $result = 'This book has been removed successfull in your bookshelf.';
        }
        catch( Exception $e )
        {
            $db->rollBack();
            throw $e;
        }
        return $result;
    }
    
    public function bookShelfCount($user_id){
        $table  = Engine_Api::_()->getDbTable('bookshelfs', 'library');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.user_id = ?', $user_id);
        $row = $table->fetchAll($select);
        $total = count($row);
        return $total;
    }
    //2012-04-27
    public function myBookShelf($user_id){
        $table  = Engine_Api::_()->getDbTable('bookshelfs', 'library');
        $rName = $table->info('name');
        $select = $table->select()
                        ->from($rName)
                        ->where($rName.'.user_id = ?', $user_id);
        $row = $table->fetchAll($select);
        //Zend_Debug::dump($row);exit;
        return $row;
    }
  
}