<?php

class Experts_SearchController extends Core_Controller_Action_Standard
{
  public function init()
  {
     //if( Engine_Api::_()->user()->getViewer()->getIdentity() == 0 ) return;
     if( !$this->_helper->requireUser()->isValid() ) return;
  }
  public function indexAction(){
    // lay tham so
    
    $keyword = $this->_getParam('keyword');
    $type_search = $this->_getParam('typesearch');
    
    $cats = trim($this->_getParam('cats'));
    $arr_cats = array();
    if(intval($cats) !=0){
        $arr_cats = explode(",",$cats);
    }
   
    // neu la search question
    if( $type_search == 1 ){
        
        $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
        $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
         
        $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
          ->setIntegrityCheck(false)
          ->from($questionsCatName, new Zend_Db_Expr(' engine4_experts_questionscategories.category_id,engine4_experts_categories.category_name, engine4_experts_questions.*'))
          ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
          ->joinLeft($categoriesName,'engine4_experts_questionscategories.category_id=engine4_experts_categories.category_id',array())
          ->where('engine4_experts_questions.title LIKE ? or engine4_experts_questions.content LIKE ?', "%".$keyword."%")
          ->where('engine4_experts_questions.status in (?)', array(2,3))
          ->group('engine4_experts_questionscategories.question_id')
          ->order('engine4_experts_questions.view_count desc');
        if(count($arr_cats))  {
            $questions_select->where('engine4_experts_questionscategories.category_id in (?)', $arr_cats);
        }
        
        //$results_seach = Engine_Api::_()->getDbTable('questionscategories', 'experts')->fetchAll($questions_select);
        $this->view->type_search = 1;
        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
        $paginator->setItemCountPerPage(15);
        $paginator->setCurrentPageNumber( $this->_getParam('page') );
        //Zend_Debug::dump(Zend_Paginator::factory($results_seach));exit;
    }
    
    // neu la search experts
    if( $type_search == 2 ){
        
        $expertsName = Engine_Api::_()->getDbtable('experts', 'experts')->info('name');
        //$answersName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
        $expertsCatName = Engine_Api::_()->getDbtable('expertscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
        $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
         
        $experts_select = Engine_Api::_()->getDbtable('expertscategories', 'experts')->select()
          ->setIntegrityCheck(false)
          ->from($expertsCatName, new Zend_Db_Expr('engine4_users.*, engine4_experts_expertscategories.category_id, engine4_experts_categories.category_name, engine4_experts_experts.*'))
          ->joinLeft($expertsName,'engine4_experts_experts.expert_id = engine4_experts_expertscategories.expert_id',array())
          ->joinLeft($categoriesName,'engine4_experts_expertscategories.category_id = engine4_experts_categories.category_id',array())
          ->joinLeft($usersName,'engine4_users.user_id = engine4_experts_experts.user_id',array())
          ->where('engine4_users.displayname LIKE ? or engine4_users.username LIKE ? or engine4_experts_experts.description LIKE ?', "%".$keyword."%")
          ->group('engine4_experts_expertscategories.expert_id');
        if(count($arr_cats))  {
            $experts_select->where('engine4_experts_expertscategories.category_id in (?)', $arr_cats);
        }  
        //$results_seach = Engine_Api::_()->getDbTable('questionscategories', 'experts')->fetchAll($experts_select);
        //Zend_Debug::dump($results_seach); exit;
        $this->view->type_search = 2;
        $paginator = $this->view->paginator = Zend_Paginator::factory($experts_select);
        $paginator->setItemCountPerPage(15);
        $paginator->setCurrentPageNumber( $this->_getParam('page') );
    }
    
        
  }
  
}