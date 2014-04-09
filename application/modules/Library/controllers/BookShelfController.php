<?php

class Library_BookShelfController extends Core_Controller_Action_Standard
{
  public function init()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
  }
  
  public function indexAction()
  {
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    $paginators = Engine_Api::_()->library()->getBookshelfPaginator($user_id);
    $this->view->paginator = $paginators;
    $this->view->user_id = $user_id;
  }
  
  /*
  public function shareAction()
  {
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    $status = $this->_getParam('status');
    $bookshelf_id = $this->_getParam('bookshelf_id');
    // check permission
    $bookshelf = Engine_Api::_()->getDbtable('bookshelfs', 'library')->find($bookshelf_id)->current();
    if($bookshelf->user_id == $user_id){
        
    }
  }
  */
  
  public function viewAction()
  {
    //$viewer = Engine_Api::_()->user()->getViewer();
    //$user_id = $viewer->getIdentity();
    $profile_id = $this->_getParam('user_id');
    $paginators = Engine_Api::_()->library()->getBookshelfPaginator($profile_id);
    $this->view->paginator = $paginators;
    
    // list booksheft of user with status of booksheft = 1(public)
  }
  
  public function downloadAction()
  {
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    
    $response = $this->_response;
    $this->_helper->layout->disableLayout();
    $this->_helper->viewRenderer->setNoRender();
    $this->_helper->layout->setLayout('admin-simple');
    
    // check valid
    if(strlen($this->getRequest()->getParam('fid')) < 15)
    {
        $response->setBody('Hacking.');
        return;
    }
    
    // Check session
    if(substr($this->getRequest()->getParam('fid'),0,7) != substr(base64_encode($user_id.Zend_Session::getId()),0,7))
    {
        $response->setBody('You do not have permission to download this file.');
        return;
    }
    
    // Lay url
    $url = base64_decode(substr($this->getRequest()->getParam('fid'),15));
    
    $table_book = Engine_Api::_()->getDbTable('books','library');
    
    // Kiem tra credit cua quyen sach    
    $book_credit = $table_book->fetchRow("url = '" . $url ."'");
    //ZEND_DEBUG::dump($book_credit->file_type); exit;
    $bookshelf_select = Engine_Api::_()->getDbtable('bookshelfs', 'library')
                    ->select()
                    ->where('book_id = ?', $book_credit->book_id)
                    ->where('user_id = ?', $user_id);
    $bookshelf = Engine_Api::_()->getDbtable('bookshelfs', 'library')->fetchRow($bookshelf_select);
    $this->view->credit= $book_credit->credit;
    // Lay credit hien co cua user
    //$user_credit = Engine_Api::_()->activitypoints()->getPointsBalance($user_id);
    $table_user_credit = Engine_Api::_()->getDbTable('credits','credit');
    $user_credit = $table_user_credit->fetchAll('user_id = ' . $user_id )->current();
    
    $pos = strpos($url,'.'); 
    $file = APPLICATION_PATH.'/public/library_book/files/' . base64_decode(str_replace(' ','-',substr($url,0,$pos))) . '.' . substr($url,$pos+1);    
    //$file_size = filesize($file);
    // Check post
    if( $this->getRequest()->isPost())
    {
		//Zend_Debug::dump($file); exit;
        // Chua download thi moi tru tien
        if($bookshelf->downloaded==1 || $book_credit['credit']==0){
            
            //$bits = @file_get_contents($file);
            if (file_exists($file)) {
                $db = Engine_Db_Table::getDefaultAdapter();
                $db->beginTransaction();
                $book_credit->download_count ++;
                $result = $book_credit->save();
                //Zend_Debug::dump($result); exit;
                $db->commit();
                
                $this->download($file);
                
            } else{
                $response->setBody('Sorry, we could not find requested download file.');   
            }
            
        } else {
            
            //$bits = @file_get_contents($file);
            if (file_exists($file)) {
                
                if($book_credit['credit']!=0){
                        
                        $modules = Engine_Api::_()->getDbtable('modules', 'core')->fetchRow("name = 'activitypoints'");
                        if(count($modules) && $modules->enabled){
                            $check_valid  = Engine_Api::_()->activitypoints()->downloadBook($user_id, $book_credit['credit']);
                            if(!$check_valid){
                                $response->setBody('Sorry, Your credit is less than this book credit.');
                                return;
                            } else {
                                
                                $db = Engine_Db_Table::getDefaultAdapter();
                                $db->beginTransaction();
                                try
                                {   
                                    $book_credit->download_count ++;
                                    $book_credit->save();
                                    $bookshelf->downloaded = 1;
                                    $bookshelf->save();
                                    $db->commit();
                                    
                                    $this->download($file);
                                    
            					} 
                                catch( Exception $e )
                                {
                                    $db->rollBack();
                                    throw $e;
                                }
                            }
                        } else {
                            $db = Engine_Db_Table::getDefaultAdapter();
                            $db->beginTransaction();
                            try
                            {   
                                $book_credit->download_count ++;
                                $book_credit->save();
                                $bookshelf->downloaded = 1;
                                $bookshelf->save();
                                $db->commit();
                                $this->download($file);
                                
        					} 
                            catch( Exception $e )
                            {
                                $db->rollBack();
                                throw $e;
                            }
                        }
                    
                  }
            } else{
                $response->setBody('Sorry, we could not find requested download file.');   
            }
        }
    }
    // Output
    $this->renderScript('book-shelf/download.tpl');
    
  }
  
  function download($file){
    
    set_time_limit(99999999); 
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename='.basename($file));
    header('Content-Transfer-Encoding: binary');
    header('Expires: 0');
    header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
    header('Pragma: public');
    header('Content-Length: ' . filesize($file));
    ob_clean();
    flush();
    $chunksize = 1 * (1024 * 1024); // how many bytes per chunk
    $file_size = filesize($file);
	if ($file_size > $chunksize) {
	  $handle = fopen($file, 'rb');
	  $buffer = '';
	  while (!feof($handle)) {
		$buffer = fread($handle, $chunksize);
		echo $buffer;
		ob_flush();
		flush();
	  }
	  fclose($handle);
	} else {
	  readfile($file);
	}
    exit;
    
  }
  
  public function addAction()
  {
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $book_id = $this->_getParam('book_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $result = Engine_Api::_()->library()->addBookShelf($book_id, $user_id);
      //Zend_Debug::dump($result); exit();
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_($result)),
        'layout' => 'default-simple',
        'parentRefresh' => true,
        'smoothboxClose' => 3000,
      ));
    }
    
    // Output
    $this->renderScript('book-shelf/add.tpl');
  }
  
  public function removeAction()
  {
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    $this->_helper->layout->setLayout('admin-simple');
    $confirm = $this->_getParam('confirm', false);
    $book_id = $this->_getParam('book_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      $result = Engine_Api::_()->library()->removeBookShelf($book_id, $user_id);
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_($result)),
        'layout' => 'default-simple',
        'parentRefresh' => true,
        'smoothboxClose'=> true
      ));
    }
    // Output
    $this->renderScript('book-shelf/remove.tpl');
  }
  
  
}