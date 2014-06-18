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
    ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating, COUNT(engine4_experts_answers.question_id) as cnt_answer'))
    ->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
	->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
    ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
    ->joinLeft($questionscategoryTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
	->group('engine4_experts_questions.question_id')
    ->order('engine4_experts_questions.created_date desc');
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