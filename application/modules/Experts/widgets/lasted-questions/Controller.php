<?php
class Experts_Widget_LastedQuestionsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $ratingTable    = Engine_Api::_()->getDbtable('ratings', 'experts');
	$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
    $questionTable  = Engine_Api::_()->getDbtable('questions', 'experts');
    $userTable      = Engine_Api::_()->getDbtable('users', 'user');
    $answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
	$questionscategoryTable    = Engine_Api::_()->getDbtable('questionscategories', 'experts');
	$categoryTable    = Engine_Api::_()->getDbtable('categories', 'experts');
    
    $questions_select = $questionTable->select()
    ->setIntegrityCheck(false)
    ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username'))
   ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
    ->order('engine4_experts_questions.created_date desc')
	->where('engine4_experts_questions.question_id not in (SELECT engine4_experts_answers.question_id FROM engine4_experts_answers)');
    //->limit(3);
    $data = $questionTable->fetchAll($questions_select);
	
	
	$paginator = $this->view->paginator = Zend_Paginator::factory($data);
	$request = Zend_Controller_Front::getInstance()->getRequest();
	$paginator->setItemCountPerPage(5);
	$paginator->setCurrentPageNumber($request->getParam('page'));
	// $paginator->setPageRange(2);
	//zend_debug::dump($data); exit;

  }
}