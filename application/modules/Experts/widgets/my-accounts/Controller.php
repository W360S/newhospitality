<?php

class Experts_Widget_MyAccountsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    $this->view->cnt_questions  = Engine_Api::_()->experts()->myQuestionsCount($user_id);
    $this->view->cnt_experts = Engine_Api::_()->experts()->myExpertCount($user_id);
    //$this->view->check_expert = Engine_Api::_()->experts()->ExpertsCount($user_id);
   
  }
}