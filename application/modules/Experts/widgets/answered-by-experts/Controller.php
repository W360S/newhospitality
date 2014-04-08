<?php

class Experts_Widget_AnsweredByExpertsController extends Engine_Content_Widget_Abstract
{
  public function indexAction()
  {
    //$user_id = intval($this->_getParam('user_id'));
    $user_name = Zend_Controller_Front::getInstance()->getRequest()->getParam("username");
    
    if(!empty($user_name)){
        $users_select = Engine_Api::_()->getDbTable('users','user')->select()
                     ->setIntegrityCheck(false)   
                     ->from(Engine_Api::_()->getDbTable('users','user')->info('name'), new Zend_Db_Expr('user_id'))
                     ->where('username = ?', $user_name);
                     
        $users =   Engine_Api::_()->getDbTable('users','user')->fetchAll($users_select)->current();    
        if(count($users)){
            $user_id = $users->user_id;
        }
    }
    $user = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
    $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
    $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
    $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
    $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
    $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
    $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    
     $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
    ->setIntegrityCheck(false)
    ->from($questionsCatName, 
          new Zend_Db_Expr("(SELECT count(engine4_experts_ratings.question_id) FROM engine4_experts_ratings WHERE engine4_experts_ratings.question_id = engine4_experts_questions.question_id) as cnt_rating,
                            (SELECT username FROM engine4_users where user_id = engine4_experts_questions.status_lasted_by) as lasted_by,
                            engine4_experts_questionscategories.*, 
                            engine4_experts_questions.*,
                            engine4_experts_questions.status as question_status,
                            engine4_experts_questions.view_count as question_view_count,
                            engine4_users.*
                            ")
      )
    ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
    ->joinLeft($recipientsName,'engine4_experts_recipients.question_id=engine4_experts_questionscategories.question_id',array())
    ->joinLeft($usersName,'engine4_users.user_id=engine4_experts_questions.user_id',array())
    ->joinLeft($answerName,'engine4_experts_questionscategories.question_id=engine4_experts_answers.question_id',array())
    ->group('engine4_experts_questionscategories.question_id')
    ->where('engine4_experts_questions.status in (?)', array(2,3))
    ->where('engine4_experts_answers.user_id = ?', $user_id)
    ->order('engine4_experts_questions.created_date Desc');
    
    $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
    $paginator->setItemCountPerPage(5);
    $paginator->setCurrentPageNumber( $this->_getParam('page') );
    $this->view->user = $user;
    $this->view->user_id= $user_id;
  }
}