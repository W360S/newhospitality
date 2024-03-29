<?php

class Library_Api_Core extends Core_Api_Abstract
{
    static $title_tags = array();
    
    static $content_tags = array();
    
	function truncate($text, $length = 100, $ending = '...', $exact = true, $considerHtml = false) {
        if (is_array($ending)) {
            extract($ending);
        }
        if ($considerHtml) {
            if (mb_strlen(preg_replace('/<.*?>/', '', $text)) <= $length) {
                return $text;
            }
            $totalLength = mb_strlen($ending);
            $openTags = array();
            $truncate = '';
            preg_match_all('/(<\/?([\w+]+)[^>]*>)?([^<>]*)/', $text, $tags, PREG_SET_ORDER);
            foreach ($tags as $tag) {
                if (!preg_match('/img|br|input|hr|area|base|basefont|col|frame|isindex|link|meta|param/s', $tag[2])) {
                    if (preg_match('/<[\w]+[^>]*>/s', $tag[0])) {
                        array_unshift($openTags, $tag[2]);
                    } else if (preg_match('/<\/([\w]+)[^>]*>/s', $tag[0], $closeTag)) {
                        $pos = array_search($closeTag[1], $openTags);
                        if ($pos !== false) {
                            array_splice($openTags, $pos, 1);
                        }
                    }
                }
                $truncate .= $tag[1];

                $contentLength = mb_strlen(preg_replace('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', ' ', $tag[3]));
                if ($contentLength + $totalLength > $length) {
                    $left = $length - $totalLength;
                    $entitiesLength = 0;
                    if (preg_match_all('/&[0-9a-z]{2,8};|&#[0-9]{1,7};|&#x[0-9a-f]{1,6};/i', $tag[3], $entities, PREG_OFFSET_CAPTURE)) {
                        foreach ($entities[0] as $entity) {
                            if ($entity[1] + 1 - $entitiesLength <= $left) {
                                $left--;
                                $entitiesLength += mb_strlen($entity[0]);
                            } else {
                                break;
                            }
                        }
                    }

                    $truncate .= mb_substr($tag[3], 0, $left + $entitiesLength);
                    break;
                } else {
                    $truncate .= $tag[3];
                    $totalLength += $contentLength;
                }
                if ($totalLength >= $length) {
                    break;
                }
            }
        } else {
            if (mb_strlen($text) <= $length) {
                return $text;
            } else {
                $truncate = mb_substr($text, 0, $length - strlen($ending));
            }
        }
        if (!$exact) {
            $spacepos = mb_strrpos($truncate, ' ');
            if (isset($spacepos)) {
                if ($considerHtml) {
                    $bits = mb_substr($truncate, $spacepos);
                    preg_match_all('/<\/([a-z]+)>/', $bits, $droppedTags, PREG_SET_ORDER);
                    if (!empty($droppedTags)) {
                        foreach ($droppedTags as $closingTag) {
                            if (!in_array($closingTag[1], $openTags)) {
                                array_unshift($openTags, $closingTag[1]);
                            }
                        }
                    }
                }
                $truncate = mb_substr($truncate, 0, $spacepos);
            }
        }

        $truncate .= $ending;

        if ($considerHtml) {
            foreach ($openTags as $tag) {
                $truncate .= '</' . $tag . '>';
            }
        }

        return $truncate;
    }

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
          ->joinLeft($categoryBooksTable->info('name'),'engine4_library_categories.category_