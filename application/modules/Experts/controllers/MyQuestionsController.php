<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: ProfileController.php 7244 2010-09-01 01:49:53Z john $
 * @author     John
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 */
class Experts_MyQuestionsController extends Core_Controller_Action_Standard {

    public function init() {
        //if( Engine_Api::_()->user()->getViewer()->getIdentity() == 0 ) return;
        if (!$this->_helper->requireUser()->isValid())
            return;
    }

    public function indexAction() {
        $user_id = $this->_getParam('user_id');
        if (intval($user_id) > 0) {
            $user_id = $this->_getParam('user_id');
        } else {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        }

        $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name');
        $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
        $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');

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
                            engine4_experts_questions.*")
                )
                ->joinLeft($questionsName, 'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id', array())
                ->joinLeft($categoriesName, 'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id', array())
                ->where('engine4_experts_questions.user_id = ?', $user_id)
                //->where('engine4_experts_questions.status = ?', $status)
                ->group('engine4_experts_questionscategories.question_id')
                ->order('engine4_experts_questions.created_date DESC');

        $this->view->view_user = $this->_getParam('view_user');
        $this->view->status = $status;
        $paginator = $this->view->paginator = Zend_Paginator::factory($questions_select);
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($this->_getParam('page'));
    }

    public function detailAction() {
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $question_id = intval($this->_getParam('question_id'));

        $userName = Engine_Api::_()->getDbtable('users', 'user')->info('name');
        $questionsName = Engine_Api::_()->getDbtable('questions', 'experts')->info('name');
        $answerName = Engine_Api::_()->getDbtable('answers', 'experts')->info('name');
        $questionsCatName = Engine_Api::_()->getDbtable('questionscategories', 'experts')->info('name');
        $categoriesName = Engine_Api::_()->getDbtable('categories', 'experts')->info('name');
        $recipientsName = Engine_Api::_()->getDbtable('recipients', 'experts')->info('name');
        $filesName = Engine_Api::_()->getDbtable('files', 'storage')->info('name');

        $questions_select = Engine_Api::_()->getDbtable('questionscategories', 'experts')->select()
                ->setIntegrityCheck(false)
                ->from($questionsCatName, new Zend_Db_Expr("GROUP_CONCAT(Distinct(engine4_experts_categories.category_name) SEPARATOR ', ') as category, 
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
                ->joinLeft($questionsName, 'engine4_experts_questions.question_id=engine4_experts_questionscategories.question_id', array())
                ->joinLeft($categoriesName, 'engine4_experts_categories.category_id=engine4_experts_questionscategories.category_id', array())
                ->joinLeft($recipientsName, 'engine4_experts_recipients.question_id=engine4_experts_questionscategories.question_id', array())
                ->joinLeft($userName, 'engine4_users.user_id=engine4_experts_questions.user_id', array())
                ->joinLeft($filesName, 'engine4_storage_files.file_id = engine4_experts_questions.file_id', array())
                ->where('engine4_experts_questions.question_id = ?', $question_id)
                ->group('engine4_experts_questionscategories.question_id');

        $data_question = Engine_Api::_()->getDbtable('questionscategories', 'experts')->fetchRow($questions_select);

        if (isset($data_question)) {
            $viewer = $this->_helper->api()->user()->getViewer();
            $this->view->viewer_id = $viewer->getIdentity();
            $this->view->rating_count = Engine_Api::_()->experts()->ratingCount($question_id);
            $this->view->rated = Engine_Api::_()->experts()->checkRated($question_id, $viewer->getIdentity());
            //$this->view->categories =  Engine_Api::_()->experts()->getCategoriesOfQuestion($question_id);
            $this->view->selected_experts = Engine_Api::_()->experts()->getExpertsOfQuestion($question_id);
            $this->view->answers = $answers = Engine_Api::_()->experts()->getAnswersOfQuestion($question_id);
            //Zend_Debug::dump($answers);
            $this->view->data = $data_question;
            $total_rating = Engine_Api::_()->experts()->getRatings($question_id);
            $tt = 0;
            if (!empty($total_rating)) {
                foreach ($total_rating as $tt_rating) {
                    $tt+= $tt_rating['rating'];
                }
            }
            //Zend_Debug::dump($tt);exit();
            $this->view->tt_rating = $tt;
            $this->view->question_id = $question_id;
        } else {
            return $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function composeAction() {
        $select_categories = Engine_Api::_()->getDbtable('categories', 'experts')->select()
                ->setIntegrityCheck(false)
                ->from('engine4_experts_categories')
                ->where('engine4_experts_categories.category_id in (select Distinct(category_id) from engine4_experts_expertscategories)');
        $categories = Engine_Api::_()->getDbtable('categories', 'experts')->fetchAll($select_categories);

        $this->view->categories1 = $categories;

        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->_request->isPost()) {
            $title = Engine_Api::_()->experts()->cleanTitle($this->getRequest()->getPost('title'));

            //$html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $this->getRequest()->getPost('description'));
			$html =		preg_replace('/<script\b[^>]*>(.*?)<\/script>/is', "", $this->getRequest()->getPost('description'));
            $content = $html;

            // get category ids            
            $cats = $this->getRequest()->getPost('expert_category');
            //$expert_id    =  (int) $this->getRequest()->getPost('compose_select_experts');
            //$arr_cats     =   array();
            //$arr_cats     =   explode(",",$cats);
            //Zend_Debug::dump($cats);exit;
            // get experts ids
            //$exp_cats    =   $this->getRequest()->getPost('check_select_experts');
            $arr_cats = array($cats);
            //$arr_exp     =   explode(",",$exp_cats);

            $check_file = true;

            if ($_FILES['file']['size']) {

                $adapter = new Zend_File_Transfer_Adapter_Http();
                $adapter->addValidator('Extension', false, array('extension' => 'txt,png,pneg,jpg,jpeg,gif,doc,docx,rar', 'case' => true));
                $check_file = $adapter->isValid();
                if ($check_file == false) {
                    echo '{"message": "extension"}';
                    exit();
                } else {
                    if ($_FILES['file']['size'] > 5242880) {
                        echo '{"message": "file"}';
                        exit();
                    }
                }
            }

            if (!empty($title) && !empty($content) && $check_file) {
                $this->_helper->layout->disableLayout();
                $this->_helper->viewRenderer->setNoRender();

                // process data
                $db = Engine_Db_Table::getDefaultAdapter();
                $db->beginTransaction();
                try {
                    $table = $this->_helper->api()->getDbtable('questions', 'experts');
                    $quetion = $table->createRow();
                    // Add question
                    $question_val = array(
                        "title" => $title,
                        "content" => $content,
                        "user_id" => $user_id,
                        "created_date" => date('Y-m-d H:i:s'),
                        "status" => 1,
                        "status_lasted_by" => $user_id
                    );

                    $quetion->setFromArray($question_val);
                    $new_id_question = $quetion->save();
                    // Add attachment
                    if ($_FILES['file']['size']) {

                        $quetion->setFiles($_FILES['file']);
                        $quetion->save();
                    }
                    
                    $owner = Engine_Api::_()->getApi('core', 'user')->getUser($user_id);
                
                    // Add action
                    $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');
                    $action = $activityApi->addActivity($owner, $quetion, 'question_create');
                    if ($action) {
                        $activityApi->attachActivity($action, $quetion);
                    }else{

                    }

                    // Add categories
                    Engine_Api::_()->experts()->createCategoriesQuestion($arr_cats, $new_id_question);

                    // Add Recipients
                    //Engine_Api::_()->experts()->createRecipients($arr_exp, $new_id_question);
                    // send email to experts 
                    $link = 'http://'
                            . $_SERVER['HTTP_HOST']
                            . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                                'module' => 'experts',
                                'controller' => 'my-experts',
                                'action' => 'detail',
                                'question_id' => $new_id_question
                                    ), 'default', true);
                    $link = "<h2><a href='{$link}'>Click to view detail question.</a></h2>";

                    $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                    $from = $user_data['email'];
                    $from_name = $user_data['displayname'];
                    $subject = "[{$_SERVER['HTTP_HOST']}] (Experts) - New question has been created: " . $title;
                    $body = $content;

                    $db->commit();
                    $this->_helper->redirector->gotoRoute(array('action' => 'index'));
                    //  print_r('{"message": "success"}');die;
                } catch (Exception $e) {
                    $db->rollBack();
                    throw $e;
                }
            }

            // dunghd add code 10/02/2010
            $this->view->title = $this->_request->getPost('title');
            $this->view->description = $this->_request->getPost('description');
        }
    }

    // update question, chi thuc hien update 1 lan
    public function addDetailAction() {
        // kiem tra neu chua add detail && thuoc cau hoi cua user && va cau hoi chua finish && canceled
        if ($this->_request->isPost()) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $question_id = $this->_getParam('question_id');
            $check_question = Engine_Api::_()->getDbtable('questions', 'experts')->find($question_id)->current();
            //Zend_debug::dump($check_question); exit;
            $detail = Engine_Api::_()->experts()->cleanHtml($this->getRequest()->getPost('add_detail'));

            if (!empty($detail)) {

                $db = Engine_Db_Table::getDefaultAdapter();
                //$db->beginTransaction();

                try {
                    //Zend_debug::dump(1 ); exit;
                    $check_question->add_detail = $detail;
                    $check_question->save();
                    //Zend_debug::dump(1 ); exit;
                    //$db->commit();
                    /*
                      return $this->_forward('success', 'utility', 'core', array(
                      'messages' => array(Zend_Registry::get('Zend_Translate')->_('Question has been updated successfull.')),
                      'layout' => 'default-simple',
                      'parentRefresh' => true,
                      ));
                     */
                } catch (Exception $e) {
                    $db->rollBack();
                    throw $e;
                }
            }
        }
        $this->renderScript('my-questions/add-detail.tpl');
    }

    /**
     * Cau hoi moi post len thi co trang thai pendding = 1
     * Cau hoi da co experts tra loi thi co trang thai answered = 2
     * Cau hoi da duoc giai quyet thi co trang thai closed = 3
     * Cau hoi user hoac experts tu choi co trang thai cancelled = 4
     */
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
        $confirm = $this->_getParam('confirm', false);
        $ids_array = explode(",", $ids);
        $this->view->count = count($ids_array);

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $ids_array = explode(",", $this->_getParam('ids', null));
            foreach ($ids_array as $id) {
                Engine_Api::_()->experts()->closeQuestion($id, $user_id);
            }
            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function deleteSelectedAction() {
        // Mot question duoc chap nhan delete khi cau hoi cua user hoac thuoc expert quan ly
        // va Question phai o trang thai pending
        // hoac Question phai o trang thai closed
        // hoac Question phai o trang thai cancelled
        $this->view->ids = $ids = $this->_getParam('delete_ids', null);
        $confirm = $this->_getParam('confirm', false);
        $ids_array = explode(",", $ids);
        $this->view->count = count($ids_array);

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $ids_array = explode(",", $this->_getParam('ids', null));
            foreach ($ids_array as $id) {
                Engine_Api::_()->experts()->deleteQuestion($id, $user_id);
            }
            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function cancelAction() {
        $this->_helper->layout->setLayout('admin-simple');
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
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
        $this->renderScript('my-questions/cancel.tpl');
    }

    public function closeAction() {
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // Check post
        if ($this->getRequest()->isPost()) {
            Engine_Api::_()->experts()->closeQuestion($question_id, $user_id);

            return $this->_forward('success', 'utility', 'core', array(
                        'smoothboxClose' => 0,
                        'refresh' => 0,
                        'parentRefresh' => true,
                        'layout' => 'default-simple',
                        'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been closed successfull.')),
                        'redirect' => array('action' => 'index')
            ));
        }
        // Output
        $this->renderScript('my-questions/close.tpl');
    }

    public function deleteAction() {
        $confirm = $this->_getParam('confirm', false);
        $question_id = $this->_getParam('question_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // Check post
        if ($this->getRequest()->isPost()) {
            Engine_Api::_()->experts()->deleteQuestion($question_id, $user_id);
            return $this->_forward('success', 'utility', 'core', array(
                        'smoothboxClose' => 0,
                        'refresh' => 0,
                        'parentRefresh' => true,
                        'layout' => 'default-simple',
                        'messages' => array(Zend_Registry::get('Zend_Translate')->_('This question has been deleted successfull.')),
                        'redirect' => array('action' => 'index')
            ));
        }
        // Output
        $this->renderScript('my-questions/delete.tpl');
    }

}
