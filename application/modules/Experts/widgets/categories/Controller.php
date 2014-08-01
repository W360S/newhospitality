<?php
class Experts_Widget_CategoriesController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts'); 
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $categoryQuestionsTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
     
	$categories_select = $categoryTable->select()
      ->setIntegrityCheck(false)
      ->from($categoryTable->info('name'), new Zend_Db_Expr('engine4_experts_categories.*, count(engine4_experts_questions.question_id) as cnt_question'))
      ->joinLeft($categoryQuestionsTable->info('name'),'engine4_experts_categories.category_id = engine4_experts_questionscategories.category_id',array())
      ->joinLeft($questionTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id ',array())
      ->group('engine4_experts_categories.category_id')
      ->order('priority asc');
    
    $data = $categoryTable->fetchAll($categories_select);
	$this->view->data = $data;
  }
}