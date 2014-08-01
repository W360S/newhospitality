<?php

class Experts_Widget_MyExpertsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    // Ki?m tra dang nh?p
    
    $status = Zend_Controller_Front::getInstance()->getRequest()->getParam("status");
    if(!in_array($status, array(1,2,3,4))) $status = 1;
    //$expert_id = Zend_Controller_Front::getInstance()->getRequest()->getParam("expert_id");
   
    //$user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    //$check_expert = Engine_Api::_()->getDbtable('experts', 'experts')->find($expert_id)->current();
    
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
   
    
    // Th?ng các câu h?i theo status   
    $questionName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name');
    $recipientName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');  
     
	$count_select = Engine_Api::_()->getDbtable('recipients', 'experts')->select()
      ->setIntegrityCheck(false)
      ->from($recipientName, new Zend_Db_Expr('engine4_experts_questions.status, engine4_experts_recipients.*, count(engine4_experts_questions.status) as cnt_status'))
      ->joinInner($questionName,'engine4_experts_questions.question_id=engine4_experts_recipients.question_id',array())
      ->where('engine4_experts_recipients.user_id = ?', $user_id)
      ->group('engine4_experts_questions.status');
    
    $data = Engine_Api::_()->getDbTable('questions', 'experts')->fetchAll($count_select);
    $this->view->data = $data;
    $this->view->status = $status;
    
  }
}