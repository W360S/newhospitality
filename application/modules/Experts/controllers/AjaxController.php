<?php
class Experts_AjaxController extends Core_Controller_Action_Standard
{
 
  
  public function lastedTabAction(){
    $this->_helper->layout->disableLayout();
     $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
		$ratingTable    = Engine_Api::_()->getDbtable('ratings', 'experts');
		$questionTable  = Engine_Api::_()->getDbtable('questions', 'experts');
		$userTable      = Engine_Api::_()->getDbtable('users', 'user');
		$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
       
		$select =  $questionTable->select()
		->setIntegrityCheck(false)
		->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating,
		COUNT(engine4_experts_answers.question_id) as cnt_answer
		'))
		->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
		->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		->group('engine4_experts_questions.question_id')
		->order('engine4_experts_questions.created_date desc')
		->limit(3);

        $records= $questionTable->fetchAll($select);
        $paginator = $this->view->paginator = Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(2);
    
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }

  public function topviewTabAction(){
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
		$ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
		$questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
		$userTable = Engine_Api::_()->getDbtable('users', 'user');
		$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
			
		$questions_select = $questionTable->select()
		->setIntegrityCheck(false)
		->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating,
		COUNT(engine4_experts_answers.question_id) as cnt_answer
		'))
		->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
		->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		//->where('engine4_experts_questions.status in (2,3)')
		->group('engine4_experts_questions.question_id')
		->order('engine4_experts_questions.view_count desc')
		->limit(3);
		$data = $questionTable->fetchAll($questions_select);
		
		$paginator = $this->view->paginator = Zend_Paginator::factory($data);
		$request = Zend_Controller_Front::getInstance()->getRequest();
		$paginator->setItemCountPerPage(10);
		$paginator->setCurrentPageNumber($request->getParam('page'));
		$paginator->setPageRange(2);
        

    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }


  public function topratingTabAction(){
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       
		$ratingTable    = Engine_Api::_()->getDbtable('ratings', 'experts');
		$questionTable  = Engine_Api::_()->getDbtable('questions', 'experts');
		$userTable      = Engine_Api::_()->getDbtable('users', 'user');
		$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
       
		$select =  $questionTable->select()
		->setIntegrityCheck(false)
		->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating,
		COUNT(engine4_experts_answers.question_id) as cnt_answer
		'))
		->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
		->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		//->where('engine4_experts_questions.status in (2,3)')
		->group('engine4_experts_questions.question_id')
		->order('cnt_answer desc')
		->limit(3);

        $records= $questionTable->fetchAll($select);
        $paginator = $this->view->paginator = Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(2);
        

    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }

  public function categoryTabAction(){
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       $category_id = intval($this->_getParam('category_id'));
	   $ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
		$questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
		$catquestionTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
		$userTable = Engine_Api::_()->getDbtable('users', 'user');
		$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
	   $questions_select = $questionTable->select()
        ->setIntegrityCheck(false)
        ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating,
	   COUNT(engine4_experts_answers.question_id) as cnt_answer
	   '))
        ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
        ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
        ->joinLeft($catquestionTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
        //->where('engine4_experts_questions.status in (2,3)')
        ->where('engine4_experts_questionscategories.category_id = ?',$category_id)
        ->group('engine4_experts_questions.question_id')
        ->order('created_date desc');
        $category = Engine_Api::_()->getDbtable('categories', 'experts')->find($category_id)->current();
        //$this->view->category_name = $category->category_name;
		//$this->view->category_id = $category_id;
        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
        $paginator->setItemCountPerPage(10);
		$paginator->category_name = $category->category_name;
		$paginator->category_id = $category_id;
        $paginator->setCurrentPageNumber( $this->_getParam('page') );
		$paginator->category_id=1;
    
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }

  public function searchTabAction(){
    $this->_helper->layout->disableLayout();
    //$this->_helper->viewRenderer->setNoRender(TRUE);
    if ($this->_request->isXmlHttpRequest()) {
       $keyword = $this->_getParam('keyword');
   
    $cats = trim($this->_getParam('cats'));
    $arr_cats = array();
    if(intval($cats) !=0){
        $arr_cats = explode(",",$cats);
    }
   
	$ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $catquestionTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
    $userTable = Engine_Api::_()->getDbtable('users', 'user');
    $category_id = intval($this->_getParam('category_id'));
	$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
    //Zend_Debug::dump($category_id); exit;
        $questions_select = $questionTable->select()
        ->setIntegrityCheck(false)
        ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating, COUNT(DISTINCT(engine4_experts_answers.question_id)) as cnt_answer'))
        ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
        ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
        ->joinLeft($catquestionTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
        ->where('engine4_experts_questions.title LIKE ? or engine4_experts_questions.content LIKE ?', "%".$keyword."%")
        //->where('engine4_experts_questionscategories.category_id = ?',$category_id)
        ->group('engine4_experts_questions.question_id')
        ->order('created_date desc');

		if(count($arr_cats))  {
			$questions_select->where('engine4_experts_questionscategories.category_id in (?)', $arr_cats);
		}
        $category = Engine_Api::_()->getDbtable('categories', 'experts')->find($category_id)->current();
        //$this->view->category_name = $category->category_name;
		$this->view->category_id = $category_id;
        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
        $paginator->setItemCountPerPage(10);
		$paginator->category_name = $category->category_name;
		$paginator->category_id = $category_id;
        $paginator->setCurrentPageNumber( $this->_getParam('page') );

    
    } else {
        //truy cap truc tiep thi cho ve trang chu
        return $this->_helper->redirector->gotoRoute(array(), 'default', true);
    }
  }
  
}