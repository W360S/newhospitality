<?php

class Experts_Widget_MyQuestionsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    // Ki?m tra dang nh?p
    $status = Zend_Controller_Front::getInstance()->getRequest()->getParam("status");
    if(!in_array($status, array(1,2,3,4))) $status = 1;
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    
    // Th?ng các câu h?i theo status   
    $questionName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
     
	$count_select = Engine_Api::_()->getDbtable('questions', 'experts')->select()
      ->setIntegrityCheck(false)
      ->from($questionName, new Zend_Db_Expr('engine4_experts_questions.status, count(engine4_experts_questions.status) as cnt_status'))
      ->where('engine4_experts_questions.user_id = ?', $user_id)
      ->group('engine4_experts_questions.status');
    
    $data = Engine_Api::_()->getDbTable('questions', 'experts')->fetchAll($count_select);
    $this->view->data = $data;
    $this->view->status = $status;
  }
}