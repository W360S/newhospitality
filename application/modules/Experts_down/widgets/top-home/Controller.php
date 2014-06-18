<?php
class Experts_Widget_TopHomeController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
	
	$ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
		$questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
		$userTable = Engine_Api::_()->getDbtable('users', 'user');
		$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
		$questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
		$categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
			
		$questions_select = $questionTable->select()
		->setIntegrityCheck(false)
		->from($questionTable->info('name'), new Zend_Db_Expr("engine4_experts_questions.*, engine4_users.username,COUNT(Distinct(engine4_experts_answers.answer_id)) as cnt_answer,
		GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '&&') as category,
		GROUP_CONCAT(Distinct(engine4_experts_categories.category_id) SEPARATOR '&&') as category_id
		"))
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
		->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		->joinInner($questionsCatName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
		->joinInner($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
		->group('engine4_experts_questions.question_id')
		->order('engine4_experts_questions.created_date desc');
		$data = $questionTable->fetchAll($questions_select);
		
		$paginator = $this->view->paginator = Zend_Paginator::factory($data);
		$request = Zend_Controller_Front::getInstance()->getRequest();
		$paginator->setItemCountPerPage(10);
		$paginator->setCurrentPageNumber($request->getParam('page'));
		$paginator->setPageRange(10);
  }
}