<?php

class Experts_AdminManageQuestionsController extends Core_Controller_Action_Admin
{
  public function init()
  {
    if( !$this->_helper->requireUser()->isValid() ) return;
  }  
  /* list questions*/  
  public function indexAction()
  {
    $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
      ->getNavigation('experts_admin_main', array(), 'experts_admin_main_manage_questions');
    $cat_id = trim($this->_getParam('cat_id'));
    $arr_cats = array();
    if(intval($cat_id) !=0){
        $arr_cats = explode(",",$cat_id);
    }
    $keyword = $this->_getParam('keyword');
    $status = $this->_getParam('status');
    $order = $this->_getParam('order');
    
    //$page = $this->_getParam('page',1);
    $paginators = Engine_Api::_()->experts()->getAdminQuestionPaginator($arr_cats, $keyword, $order, $status);
    
    $this->view->categories = Engine_Api::_()->experts()->getAdminCatQuestion();
    $this->view->paginator = $paginators;
    $this->view->paginator->setItemCountPerPage(15);
    $this->view->paginator->setCurrentPageNumber($this->_getParam('page'));
  }
  
  public function viewAction()
  {
    $question_id = $this->_getParam('question_id');
    
    $userName = Engine_Api::_()->getDbtable('users', 'user')->info('name'); 
    $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
    $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
    $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
    $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
    $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
    $filesName = Engine_Api::_()->getDbtable('files', 'storage')->info('name');

    $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
    ->setIntegrityCheck(false)
    ->from($questionsCatName, 
          new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR ', ') as category, 
                            GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                            (SELECT 
                                GROUP_CONCAT(
                                    CONCAT(
                                        '<a class=experts_selected href=# value= ',
                                        (SELECT username FROM engine4_users where user_id = engine4_experts_recipients.user_id),
                                        '>expert</a>'
                                     )
                                     SEPARATOR ', '
                                )
                             FROM engine4_experts_recipients WHERE engine4_experts_recipients.question_id = engine4_experts_questionscategories.question_id
                            ) as experts,
                            engine4_experts_questionscategories.*, 
                            engine4_experts_questions.*,
                            engine4_users.username,
			                 engine4_storage_files.*
                            ")
        )
    ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
    ->joinLeft($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
    ->joinLeft($recipientsName,'engine4_experts_recipients.question_id=engine4_experts_questionscategories.question_id',array())
    ->joinLeft($userName,'engine4_users.user_id=engine4_experts_questions.user_id',array())
    ->joinLeft($filesName,'engine4_storage_files.file_id = engine4_experts_questions.file_id',array())
    ->where('engine4_experts_questions.question_id = ?', $question_id)
    ->group('engine4_experts_questionscategories.question_id');
    
    $data_question = Engine_Api::_()->getDbtable('questionscategories', 'experts')->fetchRow($questions_select);
    $viewer = $this->_helper->api()->user()->getViewer();
    $this->view->viewer_id = $viewer->getIdentity();
    $this->view->rating_count = Engine_Api::_()->experts()->ratingCount($question_id);
    $this->view->rated = Engine_Api::_()->experts()->checkRated($question_id, $viewer->getIdentity());
    //$this->view->categories =  Engine_Api::_()->experts()->getCategoriesOfQuestion($question_id);
    $this->view->answers = Engine_Api::_()->experts()->getAnswersOfQuestion($question_id);
    $this->view->data = $data_question;
  }
  
  public function deleteAction(){
    
    $question_id = $this->_getParam('question_id');
    
    // Check post
    if( $this->getRequest()->isPost())
    {
        
        Engine_Api::_()->experts()->adminDeleteQuestion($question_id);
        return $this->_forward('success', 'utility', 'core', array(
            'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been deleted successfull.')),
            'layout' => 'default-simple',
            'parentRefresh' => true,
        ));
      
    }
    // Output
    $this->renderScript('admin-manage-questions/delete.tpl');
  }
  
  public function deleteSelectedAction()
  {
    $this->view->delete_ids = $ids = $this->_getParam('delete_ids', null);
    $confirm = $this->_getParam('confirm', false);
    $ids_array = explode(",", $ids);
    $this->view->count = count($ids_array);
    
    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
      
      foreach($ids_array as $id){
        Engine_Api::_()->experts()->adminDeleteQuestion($id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
}

