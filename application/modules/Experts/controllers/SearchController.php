<?php

class Experts_SearchController extends Core_Controller_Action_Standard
{
  public function init()
  {
     //if( Engine_Api::_()->user()->getViewer()->getIdentity() == 0 ) return;
     if( !$this->_helper->requireUser()->isValid() ) return;
  }
  public function indexAction(){
    // lay tham so
    
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

    
		
    
  }
  
}