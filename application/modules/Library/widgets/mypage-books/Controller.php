<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Library
 * @version    1
 * @author     huynhnv
 * @function: List book in mypage
 */
class Library_Widget_MypageBooksController extends Engine_Content_Widget_Abstract{
	
	public function indexAction(){
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
        ->order('engine4_library_books.view_count desc')
        ->limit(5);
        
        $this->view->data = $bookcategoriesTable->fetchAll($select);
        
	}
}