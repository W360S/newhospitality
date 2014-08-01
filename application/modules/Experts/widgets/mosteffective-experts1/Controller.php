<?php
class Experts_Widget_MosteffectiveExpertsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name'); 
    $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
    $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');

  $previous_date = date("Y-m-d", strtotime("-6 months"));

	$experts_select = Engine_Api::_()->getDbtable('answers', 'experts')->select()
      ->setIntegrityCheck(false)
      ->from($answerName, new Zend_Db_Expr(
        'engine4_experts_answers.user_id,engine4_experts_experts.*, 
        count(DISTINCT(question_id)) as answered,
        engine4_users.*')
        )
      ->joinLeft($expertsName,'engine4_experts_experts.user_id = engine4_experts_answers.user_id',array())
      ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_answers.user_id',array())
      ->group('engine4_experts_answers.user_id')
      ->order('answered desc')
      // ->order('engine4_experts_answers.created_date desc')
      ->where('engine4_experts_answers.created_date > ?', $previous_date)
      ->limit(5);          

    // print_r($experts_select);die;
    
    $data = Engine_Api::_()->getDbTable('answers', 'experts')->fetchAll($experts_select);
    $categoryTable = Engine_Api::_()->getDbtable('categories', 'experts');
    $select = $categoryTable->select()
      ->order('priority ASC');
    $categories = $categoryTable->fetchAll($select);
	$this->view->list_experts = $data;
    $this->view->categories = $categories;
    //Zend_Debug::dump($data); exit;
  }
}