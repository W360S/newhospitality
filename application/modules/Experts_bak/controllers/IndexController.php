<?php

class Experts_IndexController extends Core_Controller_Action_Standard
{
  public function init()
  {
     if( !$this->_helper->requireUser()->isValid() ) return;
  }
  
  public function indexAction(){
	    
  }
  
  public function answeredByExpertsAction(){
   
    $user_id = intval($this->_getParam('user_id'));
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
    $paginator->setItemCountPerPage(10);
    $paginator->setCurrentPageNumber( $this->_getParam('page') );
    $this->view->user = $user;
  }
  
  public function categoryAction(){
    $ratingTable = Engine_Api::_()->getDbtable('ratings', 'experts');
    $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
    $catquestionTable = Engine_Api::_()->getDbtable('questionscategories', 'experts');
    $userTable = Engine_Api::_()->getDbtable('users', 'user');
    $category_id = intval($this->_getParam('category_id'));
	$answerTable    = Engine_Api::_()->getDbtable('answers', 'experts');
    //Zend_Debug::dump($category_id); exit;
    if($category_id){
        $questions_select = $questionTable->select()
        ->setIntegrityCheck(false)
        ->from($questionTable->info('name'), new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.username, COUNT(engine4_experts_ratings.question_id) as cnt_rating, COUNT(DISTINCT(engine4_experts_answers.question_id)) as cnt_answer'))
        ->joinLeft($ratingTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_ratings.question_id',array())
        ->joinLeft($userTable->info('name'),'engine4_experts_questions.user_id = engine4_users.user_id',array())
		->joinLeft($answerTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_answers.question_id',array())
        ->joinLeft($catquestionTable->info('name'),'engine4_experts_questions.question_id = engine4_experts_questionscategories.question_id',array())
        //->where('engine4_experts_questions.status in (2,3)')
        ->where('engine4_experts_questionscategories.category_id = ?',$category_id)
        ->group('engine4_experts_questions.question_id')
        ->order('created_date desc');
        $category = Engine_Api::_()->getDbtable('categories', 'experts')->find($category_id)->current();
        //$this->view->category_name = $category->category_name;
		$this->view->category_id = $category_id;
        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
        $paginator->setItemCountPerPage(10);
		$paginator->category_name = $category->category_name;
		$paginator->category_id = $category_id;
        $paginator->setCurrentPageNumber( $this->_getParam('page') );
    } else {
        return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function profileAction(){
    
    $user_id = intval($this->_getParam('user_id'));
    $user_name = $this->_getParam('username');
    
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
    
    $expert_data = Engine_Api::_()->getDbTable('experts','experts')->fetchAll('user_id = ' . $user_id )->current();
    
    if(count($expert_data)){
        $expertTableName = Engine_Api::_()->getDbtable('experts', 'experts');
        $userTableName = Engine_Api::_()->getDbtable('users', 'user');
        $answerTableName = Engine_Api::_()->getDbtable('answers', 'experts');
        
        $expert_select = $expertTableName->select()
        ->setIntegrityCheck(false)
        ->from($expertTableName->info('name'), new Zend_Db_Expr('engine4_experts_experts.*, engine4_users.*, COUNT(DISTINCT(question_id)) as cnt_answers'))
        ->joinleft($answerTableName->info('name'),'engine4_experts_answers.user_id = engine4_experts_experts.user_id', array())
        ->joinleft($userTableName->info('name'),'engine4_users.user_id = engine4_experts_experts.user_id', array())
        ->where('engine4_experts_experts.user_id = ?', $user_id)
        ->group('engine4_experts_answers.user_id');
        
        $data = $expertTableName->fetchRow($expert_select);
        $categories = Engine_Api::_()->experts()->getCategoriesExperts($expert_data->expert_id);
        $this->view->data = $data;
        $this->view->categories = $categories;
    } else {
        return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function detailAction(){
    
    $question_id = intval($this->_getParam('question_id'));
    //thiết lập title for page
        $subject = null;
        if( !Engine_Api::_()->core()->hasSubject() ){
            $subject = Engine_Api::_()->getItem('experts_question', $question_id);
            if( $subject && $subject->getIdentity())
            {
              Engine_Api::_()->core()->setSubject($subject);
            }
        }
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
                            engine4_users.user_id as userid,
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
    $asked_by = Engine_Api::_()->getDbtable('users', 'user')->find($data_question->userid)->current();
    
    if(isset($data_question)){
        $viewer = $this->_helper->api()->user()->getViewer();
		$this->view->viewer_id = $viewer->getIdentity();
        $this->view->rating_count = Engine_Api::_()->experts()->ratingCount($question_id);
        $this->view->rated = Engine_Api::_()->experts()->checkRated($question_id, $viewer->getIdentity());
        //$this->view->categories =  Engine_Api::_()->experts()->getCategoriesOfQuestion($question_id);
        $total_rating= Engine_Api::_()->experts()->getRatings($question_id);
		$tt=0;
		if(!empty($total_rating)){
			foreach($total_rating as $tt_rating){
				$tt+= $tt_rating['rating'];
			}
		}
		//Zend_Debug::dump($tt);exit();
		$this->view->tt_rating= $tt;
        $this->view->answers = Engine_Api::_()->experts()->getAnswersOfQuestion($question_id);
        $this->view->data = $data_question;
        $this->view->asked_by = $asked_by;
        $related_questions = Engine_Api::_()->experts()->getRelatedQuestion($question_id);
        $this->view->related_old_questions = $related_questions['old'];
        $this->view->related_new_questions = $related_questions['new'];
		//
		
		//Zend_Debug::dump($question_id); 
        $update_count = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
        $update_count->view_count++;
        $update_count->save();
    } else {
        return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
    
  }
  
  public function rateAction()
  {
    $viewer = Engine_Api::_()->user()->getViewer();
    $user_id = $viewer->getIdentity();
    
    $rating = $this->_getParam('rating');
    $question_id =  $this->_getParam('question_id');

    
    $table = Engine_Api::_()->getDbtable('ratings', 'experts');
    $db = $table->getAdapter();
    $db->beginTransaction();

    try
    {

      Engine_Api::_()->experts()->setRating($question_id, $user_id, $rating);
      
      $total = Engine_Api::_()->experts()->ratingCount($question_id);
      
      $total_rating= Engine_Api::_()->experts()->getRatings($question_id);  
      $tt= 0;
      if(!empty($total_rating)){
        foreach($total_rating as $tt_rating){
            $tt+= $tt_rating['rating'];
        }
      }       
      $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
      $rating = $tt / $total;
      $question->rating = $rating;
      $question->total= $total;
      $question->save();

      $db->commit();
    }

    catch( Exception $e )
    {
      $db->rollBack();
      throw $e;
    }
    
    $data = array();
    $data[] = array(
      'total' => $total,
      'rating' => $rating,
    );
    return $this->_helper->json($data);
    $data = Zend_Json::encode($data);
    $this->getResponse()->setBody($data);
  }

}