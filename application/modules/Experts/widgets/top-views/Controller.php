<?php
class Experts_Widget_TopViewsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $userTable = Engine_Api::_()->getDbtable('users', 'user');
        
    $questions_select = $questionTable->select()
    ->setIntegrityCheck(false)
    ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating'))
    ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
    ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
    ->where('engine4_experts_questions.status in (2,3)')
    ->group('engine4_experts_questions.question_id')
    ->order('engine4_experts_questions.view_count desc')
    ->limit(15);
    $data = $questionTable->fetchAll($questions_select);
    $this->view->data = $data;
  }
}