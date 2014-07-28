<?php

class Experts_MyExpertsController extends Core_Controller_Action_Standard {

    public function init() {
        if (!$this->_helper->requireUser()->isValid())
            return;
    }

    public function indexAction() {

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
                ->from($questionsCatName, new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR '<br/>') as category, 
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
                ->joinLeft($questionsName, 'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id', array())
                ->joinLeft($categoriesName, 'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id', array())
                ->joinLeft($answerName, 'engine4_experts_questionscategories.question_id=engine4_experts_answers.question_id', array())
                ->where('engine4_experts_answers.user_id = ?', $user_id)
                //->where('engine4_experts_questions.status = ?', $status)
                ->group('engine4_experts_questionscategories.question_id')
                ->order('engine4_experts_questions.created_date DESC');

        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);

        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($this->_getParam('page'));
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
                ->joinLeft($usersName, 'engine4_experts_questions.user_id=engine4_users.user_id', array())
                ->joinLeft($filesName, 'engine4_storage_files.file_id = engine4_experts_questions.file_id', array())
                ->where('engine4_experts_questions.question_id = ?', $question_id);

        $data_question = Engine_Api::_()->getDbtable('questions', 'experts')->fetchRow($questions_select);
        $check_valid_answer = Engine_Api::_()->experts()->checkValidAnswer($user_id, $question_id);

        //answered if is post and status of question is pending or answered
        // if ($this->_request->isPost() && in_array($data_question->status, array(1,2))){
        if ($this->_request->isPost()) {

            $html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $this->getRequest()->getPost('description'));
            $content = $html;

            $check_file = true;
            if ($_FILES['file']['size']) {
                $adapter = new Zend_File_Transfer_Adapter_Http();
                $adapter->addValidator('Size', false, array('max' => 5242880))  // 5mb
                        ->addValidator('Extension', false, array('extension' => 'txt,png,pneg,jpg,jpeg,gif,doc,docx,rar', 'case' => true));
                $check_file = $adapter->isValid();
            }

            if (!empty($content) && $check_file) {

                // process data
                $db = Engine_Db_Table::getDefaultAdapter();
                $db->beginTransaction();

                try {
                    $table = $this->_helper->api()->getDbtable('answers', 'experts');
                    $answers = $table->createRow();

                    // Add question
                    $answer_val = array(
                        "content" => $content,
                        "title" => $data_question->title,
                        "created_date" => date('Y-m-d H:i:s'),
                        "user_id" => $user_id,
                        "question_id" => $question_id
                    );

                    $answers->setFromArray($answer_val);
                    $new_id_question = $answers->save();

                    // Add attachment
                    if ($_FILES['file']['size']) {
                        $answers->setFiles($_FILES['file']);
                        $answers->save();
                    }
                    //Zend_Debug::dump($_FILES['file']); exit;
                    // update status question to answered = 2
                    if ($data_question->status == 1) {
                        $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
                        $question->status = 2;
                        $question->status_lasted_by = $user_id;
                        $question->save();
                    }

                    $owner = Engine_Api::_()->getApi('core', 'user')->getUser($user_id);

                    // Add action
                    $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');
                    $action = $activityApi->addActivity($owner, $answers, 'answer_create');
                    if ($action) {
                        $activityApi->attachActivity($action, $answers);
                    } else {
                        
                    }

                    // Add notification s
                    // @TODO: bangvndng test
                    // @TODO: bangvndng test email
                    // Notifications
                    $notifyApi = Engine_Api::_()->getDbtable('notifications', 'activity');
                    $question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
                    // owner of the question
                    $actionOwner = Engine_Api::_()->getItemByGuid('user' . "_" . $question->user_id);
                    $viewer = Engine_Api::_()->user()->getViewer();

                    // Add notification for owner of activity (if user and not viewer)
                    if ($question->user_id != $viewer->getIdentity()) {
                        $notifyApi->addNotification($actionOwner, $viewer, $question, 'question_answered', array(
                            'label' => 'post'
                        ));
                    }

                    // Add a notification for all users that commented or like except the viewer and poster
                    // @todo we should probably limit this
                    foreach ($question->getAllAnsweredUsers() as $notifyUser) {
                        if ($notifyUser->getIdentity() != $viewer->getIdentity() && $notifyUser->getIdentity() != $actionOwner->getIdentity()) {
                            $notifyApi->addNotification($notifyUser, $viewer, $question, 'question_also_answered', array(
                                'label' => 'post'
                            ));
                        }
                    }

                    /*
                    // Add a notification for all users that commented or like except the viewer and poster
                    // @todo we should probably limit this
                    foreach ($action->likes()->getAllLikesUsers() as $notifyUser) {
                        if ($notifyUser->getIdentity() != $viewer->getIdentity() && $notifyUser->getIdentity() != $actionOwner->getIdentity()) {
                            $notifyApi->addNotification($notifyUser, $viewer, $action, 'liked_commented', array(
                                'label' => 'post'
                            ));
                        }
                    }
                    */

                    $db->commit();
                    $this->_helper->redirector->gotoRoute(array('controller' => 'index', 'action' => 'detail', 'question_id' => $question_id));
                } catch (Exception $e) {
                    $db->rollBack();
                    throw $e;
                }
            }  // endif  
        } // endif

        if (($check_valid_answer) && isset($data_question)) {
            $viewer = $this->_helper->api()->user()->getViewer();

            $this->view->viewer_id = $viewer->getIdentity();
            $this->view->rating_count = Engine_Api::_()->experts()->ratingCount($data_question->getIdentity());
            $this->view->rated = Engine_Api::_()->experts()->checkRated($data_question->getIdentity(), $viewer->getIdentity());
            $total_rating = Engine_Api::_()->experts()->getRatings($question_id);
            $tt = 0;
            if (!empty($total_rating)) {
                foreach ($total_rating as $tt_rating) {
                    $tt+= $tt_rating['rating'];
                }
            }
            //Zend_Debug::dump($tt);exit();
            $this->view->tt_rating = $tt;
            $this->view->categories = Engine_Api::_()->experts()->getCategoriesOfQuestion($question_id);
            $this->view->answers = $answers = Engine_Api::_()->experts()->getAnswersOfQuestion($question_id);
            //Zend_Debug::dump( Engine_Api::_()->experts()->getAnswersOfQuestion($question_id)); exit;
            //Zend_Debug::dump($answers);exit;
            $this->view->data = $data_question;
        } else {
            return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function cancelSelectedAction() {
        // Mot question duoc chap nhan cancel khi cau hoi cua user hoac thuoc expert quan ly
        // va Question phai o trang thai pending
        $this->view->ids = $ids = $this->_getParam('cancel_ids', null);
        $confirm = $this->_getParam('confirm', false);
        $ids_array = explode(",", $ids);
        $this->view->count = count($ids_array);

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $ids_array = explode(",", $this->_getParam('ids', null));
            //$experts_id = $this->_getParam('cancel_experts_id', null);
            foreach ($ids_array as $id) {
                Engine_Api::_()->experts()->cancelQuestion($id, $user_id);
            }

            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function closeSelectedAction() {
        // Mot question duoc chap nhan close khi cau hoi cua user hoac thuoc expert quan ly
        // va Question phai o trang thai answered
        $this->view->ids = $ids = $this->_getParam('close_ids', null);
        //$this->view->experts_id = $experts_id = $this->_getParam('close_experts_id', null);
        $confirm = $this->_getParam('confirm', false);
        $ids_array = explode(",", $ids);
        $this->view->count = count($ids_array);

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $ids_array = explode(",", $this->_getParam('ids', null));
            //$experts_id = $this->_getParam('close_experts_id', null);
            foreach ($ids_array as $id) {
                Engine_Api::_()->experts()->closeQuestion($id, $user_id);
            }
            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function deleteSelectedAction() {
        $this->view->ids = $ids = $this->_getParam('delete_ids', null);
        //$this->view->experts_id = $experts_id = $this->_getParam('delete_experts_id', null);
        $confirm = $this->_getParam('confirm', false);
        $ids_array = explode(",", $ids);
        $this->view->count = count($ids_array);

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $ids_array = explode(",", $this->_getParam('ids', null));
            //$experts_id = $this->_getParam('delete_experts_id', null);

            foreach ($ids_array as $id) {
                Engine_Api::_()->experts()->deleteQuestion($id, $user_id);
            }
            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function cancelAction() {
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
        //$expert_id = $this->_getParam('expert_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // Check post
        if ($this->getRequest()->isPost()) {
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

    public function closeAction() {
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
        //$expert_id = $this->_getParam('expert_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // Check post
        if ($this->getRequest()->isPost()) {
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

    public function deleteAction() {
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
        //$expert_id = $this->_getParam('expert_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

        // Check post
        if ($this->getRequest()->isPost()) {
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
