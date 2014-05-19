<?php

class Experts_MyExpertsController extends Core_Controller_Action_Standard
{
  public function init()
  {
     if( !$this->_helper->requireUser()->isValid() ) return;
  }
  
  public function indexAction()
  {
    
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    //$users = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
    
    //$status = $this->_getParam('status');
    
    //if(!in_array($status,array(1,2,3,4))) $status = 1;
     // get data
     $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
     $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
     $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
     $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
     $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
     
      $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
      ->setIntegrityCheck(false)
      ->from($questionsCatName, 
              new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/>') as category, 
                                GROUP_CONCAT(Distinct(engine4_experts_categories.category_id)) as category_ids,
                                (SELECT 
                                    GROUP_CONCAT(
                                        CONCAT(
                                            '<a class=experts_selected href=# value= ',
                                            (SELECT username FROM engine4_users where user_id = engine4_experts_recipients.user_id),
                                            '>expert</a>',
                                            '(',
                                            (SELECT count(question_id) FROM engine4_experts_answers WHERE user_id = engine4_experts_recipients.user_id and question_id = engine4_experts_questionscategories.question_id),
                                            ')'
                                         )
                                         SEPARATOR ' <br/>'
                                    )
                                 FROM engine4_experts_recipients WHERE engine4_experts_recipients.question_id = engine4_experts_questionscategories.question_id
                                ) as experts,
                                (SELECT username FROM engine4_users where user_id = engine4_experts_questions.status_lasted_by) as lasted_by,
                                engine4_experts_questionscategories.*, 
                                engine4_experts_questions.*
								")
            )
      ->joinLeft($questionsName,'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id',array())
      ->joinLeft($categoriesName,'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id',array())
      ->joinLeft($answerName,'engine4_experts_questionscategories.question_id=engine4_experts_answers.question_id',array())
      ->where('engine4_experts_answers.user_id = ?', $user_id)
      //->where('engine4_experts_questions.status = ?', $status)
      ->group('engine4_experts_questionscategories.question_id')
      ->order('engine4_experts_questions.created_date DESC');
      
      $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
      
      $paginator->setItemCountPerPage(10);
      $paginator->setCurrentPageNumber( $this->_getParam('page') );
      //$this->view->expert_id = $expert_id;
      //$this->view->expert_name = $check_expert->name;
      $this->view->status = $status;
    
  }
  
  
  public function detailAction() {
    
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    $question_id = intval($this->_getParam('question_id'));
    
    // lay du lieu cua cau hoi
    $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name'); 
    $usersName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
    $filesName = Engine_Api::_()->getDbtable('files', 'storage')->info('name');
    
    $questions_select = Engine_Api::_()->getDbtable('questions', 'experts')->select()
    ->setIntegrityCheck(false)
    ->from($questionsName, new Zend_Db_Expr('engine4_users.username, engine4_experts_questions.*, engine4_storage_files.*'))
    ->joinLeft($usersName,'engine4_experts_questions.user_id=engine4_users.user_id',array())
    ->joinLeft($filesName,'engine4_storage_files.file_id = engine4_experts_questions.file_id',array())
    ->where('engine4_experts_questions.question_id = ?', $question_id);
    
    $data_question = Engine_Api::_()->getDbtable('questions', 'experts')->fetchRow($questions_select);
    $check_valid_answer = Engine_Api::_()->experts()->checkValidAnswer($user_id, $question_id);
    
    //answered if is post and status of question is pending or answered
   // if ($this->_request->isPost() && in_array($data_question->status, array(1,2))){
	  if ($this->_request->isPost()){
        
        $html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $this->getRequest()->getPost('description'));
        $content      =   $html;
        
        $check_file = true;
        if($_FILES['file']['size']){
            $adapter = new Zend_File_Transfer_Adapter_Http();
            $adapter->addValidator('Size',false,array('max' => 5242880))  // 5mb
            ->addValidator('Extension',false,array('extension' => 'txt,png,pneg,jpg,jpeg,gif,doc,docx,rar','case' => true));
            $check_file = $adapter->isValid();
        } 
        
        if (!empty($content) && $check_file) {
            
            // process data
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            
            try
            {
                $table = $this->_helper->api()->getDbtable('answers', 'experts');
                $answers = $table->createRow();
                
                // Add question
                $answer_val = array(
                    "content"=>$content,
                    "created_date"=>date('Y-m-d H:i:s'),
                    "user_id"=>$user_id,
                    "question_id"=>$question_id
                );
                
                $answers->setFromArray($answer_val);
                $new_id_question = $answers->save();
                
                // Add attachment
                if( $_FILES['file']['size'] ) {
                    $answers->setFiles($_FILES['file']);
                    $answers->save();
                }
                //Zend_Debug::dump($_FILES['file']); exit;
                // update status question to answered = 2
                if($data_question->status == 1){
                    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
                    $question->status = 2;
                    $question->status_lasted_by = $user_id;
                    $question->save();
                }
                
                // send email:
                $usersTable = Engine_Api::_()->getDbtable('users', 'user');
                $questionTable = Engine_Api::_()->getDbtable('questions', 'experts');
                $recipientsTable = Engine_Api::_()->getDbTable('recipients', 'experts');
                
                // User post question
                $poster_select = $questionTable->select()
                ->setIntegrityCheck(false)
                ->from($questionTable->info('name'),new Zend_Db_Expr('engine4_experts_questions.*, engine4_users.*'))
                ->joinLeft($usersTable->info('name'),'engine4_experts_questions.user_id=engine4_users.user_id',array())
                ->where('engine4_experts_questions.question_id = ?', $question_id);
                
                $poster = $questionTable->fetchAll($poster_select)->current();
                
                // get information of answere
                $answere = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                
                /* Email to experts and user */
                
                // get experts of question
                $select = $recipientsTable->select()
                ->from($recipientsTable->info('name'),new Zend_Db_Expr('engine4_users.user_id, engine4_users.email, engine4_users.displayname'))
                ->joinLeft($usersTable->info('name'),'engine4_experts_recipients.user_id=engine4_users.user_id',array())
                ->where($recipientsTable->info('name').'.question_id = ?', $question_id);
                
                $recipient = $recipientsTable->fetchAll($select);
                
                $email = array();
                
                foreach($recipient as $item){
                   $email[] = $item['email'];
                }
                
                $subject = "[{$_SERVER['HTTP_HOST']}] (Experts) - Question {$poster->title} has been answered: ";
                
                $user_link = 'http://'
                  . $_SERVER['HTTP_HOST']
                  . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                      'module'      =>  'experts',
                      'controller'  =>  'my-questions',
                      'action'      =>  'detail',
                      'status'      =>  2,
                      'question_id' =>  $question_id
                    ), 'default', true);
                $user_link = "<h2><a href='{$user_link}'>Click to view detail question.</a></h2>";
                $user_body = $content;
                
                $expert_link = 'http://'
                  . $_SERVER['HTTP_HOST']
                  . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                      'module' => 'experts',
                      'controller' => 'my-experts',
                      'action' => 'detail',
                      'status'=>2,
                      'question_id' => $question_id
                    ), 'default', true);
                $expert_link = "<h2><a href='{$expert_link}'>Click to view detail question.</a></h2>";
                $expert_body = $content;
                
                /*
                foreach($recipient as $item){
                   $email[] = $item['email'];
                }*/
                
                try {
                    /*
                    foreach($recipient as $item){
                        
                        $expert_data = Engine_Api::_()->getDbtable('users', 'user')->find($item->user_id)->current();
                        
                        // Main params
                        $defaultParams = array(
                            'host' => $_SERVER['HTTP_HOST'],
                            'email' => $expert_data->email,
                            'date' => time(),
                            
                            'poster'=> $poster->displayname,
                            'sender_title'=> $answere->displayname,
                            'object_title'=> $subject,
                            'object_link' => $expert_link, 
                            'object_description' => $expert_body
                        );
                        
                        Engine_Api::_()->getApi('mail', 'core')->sendSystem($expert_data, 'experts_answer', $defaultParams);
                        
                        
                    } // endforeach
                    
                    $defaultParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $poster->email,
                        'date' => time(),
                        'sender_title'=> $answere->displayname, 
                        'object_title'=> $subject,
                        'object_link' => $user_link, 
                        'object_description' => $user_body
                    );
                    
                    Engine_Api::_()->getApi('mail', 'core')->sendSystem($poster, 'expert_answer', $defaultParams);
					*/
                
                } catch( Exception $e ) {
                    $db->rollBack();
	                throw $e;
                }
                
              
                $db->commit();
				$this->_helper->redirector->gotoRoute(array('controller'=>'index','action' => 'detail','question_id'=>$question_id));
            }
            catch( Exception $e )
            {
              $db->rollBack();
              throw $e;
            }
            
        }  // endif  
        
    } // endif
    
    if( ($check_valid_answer) && isset($data_question)){
        $viewer = $this->_helper->api()->user()->getViewer();
        
        $this->view->viewer_id = $viewer->getIdentity();
        $this->view->rating_count = Engine_Api::_()->experts()->ratingCount($data_question->getIdentity());
        $this->view->rated = Engine_Api::_()->experts()->checkRated($data_question->getIdentity(), $viewer->getIdentity());
        $total_rating= Engine_Api::_()->experts()->getRatings($question_id);
		$tt=0;
		if(!empty($total_rating)){
			foreach($total_rating as $tt_rating){
				$tt+= $tt_rating['rating'];
			}
		}
		//Zend_Debug::dump($tt);exit();
		$this->view->tt_rating= $tt;
        $this->view->categories =  Engine_Api::_()->experts()->getCategoriesOfQuestion($question_id);
        $this->view->answers = $answers= Engine_Api::_()->experts()->getAnswersOfQuestion($question_id);
        //Zend_Debug::dump( Engine_Api::_()->experts()->getAnswersOfQuestion($question_id)); exit;
        //Zend_Debug::dump($answers);exit;
        $this->view->data = $data_question;
    } else {
        return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
    
  }
  
  public function cancelSelectedAction()
  {
    // Mot question duoc chap nhan cancel khi cau hoi cua user hoac thuoc expert quan ly
    // va Question phai o trang thai pending
    $this->view->ids = $ids = $this->_getParam('cancel_ids', null);
    $confirm = $this->_getParam('confirm', false);
    $ids_array = explode(",", $ids);
    $this->view->count = count($ids_array);
    
    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
      $ids_array = explode(",",$this->_getParam('ids', null));
      //$experts_id = $this->_getParam('cancel_experts_id', null);
      foreach($ids_array as $id){
        Engine_Api::_()->experts()->cancelQuestion($id, $user_id);
      }
      
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function closeSelectedAction()
  {
    // Mot question duoc chap nhan close khi cau hoi cua user hoac thuoc expert quan ly
    // va Question phai o trang thai answered
    $this->view->ids = $ids = $this->_getParam('close_ids', null);
    //$this->view->experts_id = $experts_id = $this->_getParam('close_experts_id', null);
    $confirm = $this->_getParam('confirm', false);
    $ids_array = explode(",", $ids);
    $this->view->count = count($ids_array);
    
    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
      $ids_array = explode(",",$this->_getParam('ids', null));
      //$experts_id = $this->_getParam('close_experts_id', null);
      foreach($ids_array as $id){
        Engine_Api::_()->experts()->closeQuestion($id, $user_id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function deleteSelectedAction()
  {
    $this->view->ids = $ids = $this->_getParam('delete_ids', null);
    //$this->view->experts_id = $experts_id = $this->_getParam('delete_experts_id', null);
    $confirm = $this->_getParam('confirm', false);
    $ids_array = explode(",", $ids);
    $this->view->count = count($ids_array);
    
    // Save values
    if( $this->getRequest()->isPost() && $confirm == true )
    {
      $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
      $ids_array = explode(",",$this->_getParam('ids', null));
      //$experts_id = $this->_getParam('delete_experts_id', null);
      
      foreach($ids_array as $id){
        Engine_Api::_()->experts()->deleteQuestion($id, $user_id);
      }
      $this->_helper->redirector->gotoRoute(array('action' => 'index'));
    }
  }
  
  public function cancelAction(){
    $confirm = $this->_getParam('confirm', false);
    $question_id = $this->_getParam('question_id');
    //$expert_id = $this->_getParam('expert_id');
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    // Check post
    if( $this->getRequest()->isPost())
    {
      Engine_Api::_()->experts()->cancelQuestion($question_id, $user_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been cancelled successfull.')),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
    }
    // Output
    $this->renderScript('my-experts/cancel.tpl');
  }
  
  public function closeAction(){
    $confirm = $this->_getParam('confirm', false);
    $question_id = $this->_getParam('question_id');
    //$expert_id = $this->_getParam('expert_id');
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    // Check post
    if( $this->getRequest()->isPost())
    {
      Engine_Api::_()->experts()->closeQuestion($question_id, $user_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been closed successfull.')),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
    }
    // Output
    $this->renderScript('my-experts/close.tpl');
  }
  
  public function deleteAction(){
    $confirm = $this->_getParam('confirm', false);
    $question_id = $this->_getParam('question_id');
    //$expert_id = $this->_getParam('expert_id');
    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
    
    // Check post
    if( $this->getRequest()->isPost())
    {
      Engine_Api::_()->experts()->deleteQuestion($question_id, $user_id);
      
      return $this->_forward('success', 'utility', 'core', array(
        'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been deleted successfull.')),
        'layout' => 'default-simple',
        'parentRefresh' => true,
      ));
      
    }
    // Output
    $this->renderScript('my-experts/delete.tpl');
  }
  
}