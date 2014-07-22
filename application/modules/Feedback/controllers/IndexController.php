<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Feedback
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: IndexController.php 2010-07-08 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Feedback_IndexController extends Core_Controller_Action_Standard {

    public function init() {
        $this->view->viewer_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $this->view->navigation = $this->getNavigation();
    }

    //ACTION FOR SHOW ALL AVAILABLE FEEDBACK
    public function browseAction() {

        //CHECK THAT FEEDBACK FORUM SHOULD BE VISIBLE OR NOT
        $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
        if (empty($show_browse)) {
            return $this->_forward('requireauth', 'error', 'core');
        }

        //FIND LOGGED IN USER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();

        $this->view->is_msg = (int) $this->_getParam('success_msg');


        //PUBLIC CAN VIEW FEEDBACK OR NOT
        $feedback_public = Engine_Api::_()->getApi('settings', 'core')->feedback_public;
        if ($feedback_public == 0 && empty($viewer_id)) {
            return $this->_forward('requireauth', 'error', 'core');
        }

        $check_anonymous_vote = (int) $this->_getParam('check_anonymous_vote');
        if ($check_anonymous_vote == 1) {
            if (!$this->_helper->requireUser()->isValid())
                return;
        }
        if ($viewer_id == 0) {
            $browse_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('check_browse_id' => 1), 'feedback_browse');
            $this->view->browse_url = $browse_url;

            $check_browse_id = (int) $this->_getParam('check_browse_id');
            if ($check_browse_id == 1) {
                if (!$this->_helper->requireUser()->isValid())
                    return;
            }
        }

        //GET FEEDBACK TITLE, OWNER INFORMATION AND TABS
        $this->view->owner = $owner = Engine_Api::_()->getItem('user', $this->_getParam('user_id'));
        $this->view->navigation = $this->getNavigation();

        //GENERATE SEARCH FORM
        $this->view->form = $form = new Feedback_Form_Search();

        //GENERATE MOST VOTED SEARCH FORM
        $this->view->formmostvoted = $formmostvoted = new Feedback_Form_Searchmostvoted();

        //SHOW CATEGORY
        $this->view->categories = $categories = Engine_Api::_()->feedback()->getCategories();
        foreach ($categories as $category) {
            $form->category->addMultiOption($category->category_id, $category->category_name);
        }

        //SHOW STATUS 
        $this->view->show_status = $status = Engine_Api::_()->feedback()->getStatus();
        foreach ($status as $stat) {
            $form->stat->addMultiOption($stat->stat_id, $stat->stat_name);
        }

        //PROCESS SEARCH FORM
        $form->isValid($this->getRequest()->getPost());
        $values = $form->getValues();

        //PROCESS MOST VOTED SEARCH FORM
        $formmostvoted->isValid($this->getRequest()->getPost());
        $values_mostvoted = $formmostvoted->getValues();
        if (!empty($values_mostvoted['orderby_mostvoted'])) {
            $values['orderby'] = 'total_votes';
        }

        $values['feedback_private'] = "public";
        $values['can_vote'] = "1";
        $values['viewer_id'] = $viewer_id;

        $form->populate($values);
        $this->view->assign($values);

        //GET PAGINATOR
        $this->view->paginator = $paginator = Engine_Api::_()->feedback()->getFeedbacksPaginator($values);
        $items_per_page = Engine_Api::_()->getApi('settings', 'core')->feedback_page;
        $paginator->setItemCountPerPage($items_per_page);
        $this->view->paginator = $paginator->setCurrentPageNumber($values['page']);

        //MINING OF FEEDBACK ORDER BY total_votes
        $table = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
        $tableName = $table->info('name');
        $select = $table->select()
                ->setIntegrityCheck(false)
                ->from($tableName, array('feedback_id', 'feedback_title', 'owner_id', 'total_votes', 'comment_count', 'views'))
                ->where('feedback_private != ?', 'private')
                ->order('total_votes DESC')
                ->limit(4);
        $this->view->voteFeedback = $voteFeedback = $table->fetchAll($select);
        $this->view->vote = count($voteFeedback);
    }

    //ACTION FOR SHOW USERS FEEDBACK
    public function manageAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;

        $this->view->show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;

        //FIND LOGGED IN USER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();

        //GET VALUE FOR CHECKING THAT PICTURES UPLOAD IS ALLOW OR NOT
        $this->view->allow_upload = Engine_Api::_()->getApi('settings', 'core')->feedback_allow_image;

        //PROCESS SEARCH FORM
        $this->view->form = $form = new Feedback_Form_Search();

        $form->isValid($this->getRequest()->getPost());
        $values = $form->getValues();

        $form->populate($values);
        $this->view->assign($values);

        //SHOW CATEGORY
        $this->view->categories = $categories = Engine_Api::_()->feedback()->getCategories();
        foreach ($categories as $category) {
            $form->category->addMultiOption($category->category_id, $category->category_name);
        }

        //SHOW STATUS 
        $this->view->show_status = $status = Engine_Api::_()->feedback()->getStatus();
        foreach ($status as $stat) {
            $form->stat->addMultiOption($stat->stat_id, $stat->stat_name);
        }

        //PROCESS SEARCH FORM
        $form->isValid($this->getRequest()->getPost());
        $values = $form->getValues();
        $values['user_id'] = $viewer_id;
        $values['viewer_id'] = $viewer_id;
        $values['can_vote'] = "1";

        //GET PAGINATOR
        $this->view->paginator = $paginator = Engine_Api::_()->feedback()->getFeedbacksPaginator($values);
        $items_per_page = Engine_Api::_()->getApi('settings', 'core')->feedback_page;
        $paginator->setItemCountPerPage($items_per_page);
        $this->view->paginator = $paginator->setCurrentPageNumber($values['page']);

        $this->_helper->content
                ->setContentName(30) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //ACTION FOR CREATE  FEEDBACK
    public function createAction() {
        
        $viewer = Engine_Api::_()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();

        $show_button = Engine_Api::_()->getApi('settings', 'core')->feedbackbutton_visible;
        if ($show_button != 1) {
            return $this->_forward('requireauth', 'error', 'core');
        }



        $this->view->show_browse = $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;

        //GET VALUE FOR CHECKING THAT WHO CAN CREATE FEEDBACK
        $this->view->feedback_post = $feedback_post = Engine_Api::_()->getApi('settings', 'core')->feedback_post;

        //CHECK IF IP BLOCK BY ADMIN FOR POSTING FEEDBACK
        $tmTable = Engine_Api::_()->getitemTable('blockip');
        $tmName = $tmTable->info('name');

        $checkPost = $tmTable->select()
                ->setIntegrityCheck(false)
                ->from($tmName, array('blockip_address', 'blockip_feedback'))
                ->where('blockip_address = ?', $_SERVER['REMOTE_ADDR']);
        $rows = $tmTable->fetchAll($checkPost)->toArray();
        if (!empty($rows)) {
            $this->view->check_blockip_feedback = $rows[0]['blockip_feedback'];
        }
        //CHECK IF USER BLOCK BY ADMIN FOR POSTING FEEDBACK
        $userBlock = Engine_Api::_()->getItem('blockuser', $viewer_id);
        if (!empty($userBlock)) {
            $this->view->check_block_feedback = $userBlock->block_feedback;
        }
        $this->view->navigation = $this->getNavigation();
        $this->view->form = $form = new Feedback_Form_Create();

        //IF LOGGED IN USER POST FEEDBACK THAN REMOVE email AND name FILED FROM FORM
        if ($viewer_id != 0 || !empty($viewer_id)) {
            $form->removeElement('anonymous_email');
            $form->removeElement('anonymous_name');
        } else {
            $form->removeElement('default_visibility');
        }
        if (empty($show_browse)) {
            $form->removeElement('default_visibility');
        }


        //IF NOT POST OR FORM NOT VALID, RETUREN
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            $table = Engine_Api::_()->getItemTable('feedback');
            $db = $table->getAdapter();
            $db->beginTransaction();

            try {
                //Create feedback
                if (!empty($viewer_id)) {
                    $values = array_merge($form->getValues(), array(
                        'owner_type' => $viewer->getType(),
                        'owner_id' => $viewer_id,
                            ));
                } else {
                    $values = array_merge($form->getValues(), array(
                        'owner_type' => 'null',
                        'owner_id' => 0,
                            ));
                }
                $feedback = $table->createRow();
                $feedback->setFromArray($values);

                //CHECKS FOR DEFAULT VISIBILITY	
                $feedback_default_visibility = Engine_Api::_()->getApi('settings', 'core')->feedback_default_visibility;
                $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
                if (!empty($show_browse)) {
                    if ($feedback_default_visibility == 'private' || empty($viewer_id)) {
                        $access = 'private';
                    } else {
                        $access = $values['default_visibility'];
                    }
                } else {
                    $access = 'private';
                }
                $feedback->feedback_private = $access;
                $feedback->ip_address = $_SERVER['REMOTE_ADDR'];
                $feedback->browser_name = $_SERVER['HTTP_USER_AGENT'];
                $feedback->feedback_slug = trim(preg_replace('/-+/', '-', preg_replace('/[^a-z0-9-]+/i', '-', strtolower($values['feedback_title']))), '-');

                if ($access == 'private') {
                    $feedback->search = 0;
                } else {
                    $feedback->search = 1;
                }

                $feedback->feedback_description = nl2br($values['feedback_description']);

                $feedback->save();

                //GIVE AUTHENTICATION THAT EVERY ONE CAN COMMENT
                $auth = Engine_Api::_()->authorization()->context;
                $roles = array('owner', 'owner_member', 'owner_member_member', 'owner_network', 'everyone');
                $auth_view = "everyone";
                $viewMax = array_search($auth_view, $roles);
                foreach ($roles as $i => $role) {
                    $auth->setAllowed($feedback, $role, 'view', ($i <= $viewMax));
                }


                $roles = array('owner', 'owner_member', 'owner_member_member', 'owner_network', 'everyone');
                $auth_comment = "everyone";
                $commentMax = array_search($auth_comment, $roles);
                foreach ($roles as $i => $role) {
                    $auth->setAllowed($feedback, $role, 'comment', ($i <= $commentMax));
                }

                $db->commit();

                //GET VALUE FOR CHECKING THAT ADMIN GET EMAIL ALERT OR NOT
                $feedback_email_notify = Engine_Api::_()->getApi('settings', 'core')->feedback_email_notify;

                //EMAIL WORK START FROM HERE
                if ($feedback_email_notify) {
                    if (!empty($feedback->owner_id)) {
                        $owner_id = $feedback->owner_id;
                        $owner = Engine_Api::_()->getItem('user', $owner_id);
                        $owner_name = $owner->username;
                    } else {
                        $owner_name = 'Anonymous user';
                    }
                    $creation_date = $feedback->truncateDate();
                    //$email = Engine_Api::_()->getApi('settings', 'core')->core_mail['from'];
                    // Engine_Api::_()->getApi('mail', 'core')->sendSystem($email, 'notify_feedback_create', array(
                    //     'feedback_title' => $feedback->feedback_title,
                    //     'feedback_owner' => $owner_name,
                    //     'feedback_status' => $feedback->feedback_private,
                    //     'feedback_date' => $creation_date,
                    //     'email' => $email,
                    //     'link' => 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('feedback_id' => $feedback->feedback_id, 'user_id' => $feedback->owner_id, 'slug' => $feedback->feedback_slug), 'feedback_detail_view')
                    // ));
                }

                //REDIRECT TO IMAGE UPLOAD PAGE IF
                $allow_upload = Engine_Api::_()->getApi('settings', 'core')->feedback_allow_image;
                if ($allow_upload == 1) {
                    $session = new Zend_Session_Namespace();
                    $session->feedback_success = $feedback->feedback_id;
                    return $this->_helper->redirector->gotoRoute(array('feedback_id' => $feedback->feedback_id), 'feedback_success', true);
                } elseif (!empty($viewer_id)) {
                    $url = $this->_helper->url->url(array(), 'feedback_manage');
                } elseif (!empty($show_browse)) {
                    $url = $this->_helper->url->url(array('success_msg' => 1), 'feedback_browse');
                } else {
                    $url = $this->_helper->url->url(array(), 'core_home');
                }

                if ($allow_upload != 1) {
                    $this->_forward('success', 'utility', 'core', array(
                        'smoothboxClose' => true,
                        'parentRedirect' => $url,
                        'parentRedirectTime' => '15',
                        'format' => 'smoothbox',
                        'messages' => Zend_Registry::get('Zend_Translate')->_('You have successfully created feedback.')
                    ));
                }
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }

        $this->view->show_status = $status = Engine_Api::_()->feedback()->getStatus();

        //MINING OF FEEDBACK ORDER BY total_votes
        $table = Engine_Api::_()->getitemtable('feedback');
        $tableName = $table->info('name');
        $tableVote = Engine_Api::_()->getitemtable('vote')->info('name');

        $select = $table->select()
                ->setIntegrityCheck(false)
                ->from($tableName, array('feedback_id', 'feedback_title', 'owner_id', 'total_votes', 'comment_count', 'views', 'stat_id', 'featured'))
                ->joinLeft($tableVote, "$tableVote.feedback_id = $tableName.feedback_id AND $tableVote.voter_id = $viewer_id ", 'vote_id')
                ->where('feedback_private != ?', 'private')
                ->order('total_votes DESC')
                ->order('comment_count DESC')
                ->order('views DESC')
                ->order('creation_date DESC')
                ->order('modified_date DESC')
                ->limit(5);
        $this->view->voteFeedback = $voteFeedback = $table->fetchAll($select);
    }

    //ACTION FOR EDIT FEEDBACK 
    public function editAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;

        //GET LOGGED IN USER INFORMATION 
        $viewer_id = $this->_helper->api()->user()->getViewer()->getIdentity();

        $this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $this->_getParam('feedback_id'));

        if (!empty($viewer_id)) {
            $this->view->user_level = $user_level = Engine_Api::_()->user()->getViewer()->level_id;

            if ($user_level != 1 && $feedback->owner_id != $viewer_id) {
                return $this->_forward('requireauth', 'error', 'core');
            }
        }

        if (!Engine_Api::_()->core()->hasSubject('feedback')) {
            Engine_Api::_()->core()->setSubject($feedback);
        }

        //Get navigation
        $navigation = $this->getNavigation(true);
        $this->view->navigation = $navigation;

        $this->view->form = $form = new Feedback_Form_Edit();

        //Save feedback entry
        $saved = $this->_getParam('saved');
        if (!$this->getRequest()->isPost() || $saved) {
            if ($saved) {
                $url = $this->_helper->url->url(array('user_id' => $viewer->getIdentity(), 'feedback_id' => $feedback->getIdentity()), 'feedback_entry_view');
                $savedChangesNotice = Zend_Registry::get('Zend_Translate')->_("Your changes were saved. Click %s to view your feedback.", '<a href="' . $url . '">here</a>');
                $form->addNotice($savedChangesNotice);
            }

            $form->populate($feedback->toArray());

            return;
        }
        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }

        $values = $form->getValues();

        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try {
            $feedback->setFromArray($values);
            $feedback->modified_date = new Zend_Db_Expr('NOW()');

            //CHECKS FOR DEFAULT VISIBILITY	
            $feedback_default_visibility = Engine_Api::_()->getApi('settings', 'core')->feedback_default_visibility;
            $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
            if (!empty($show_browse)) {
                if ($feedback_default_visibility == 'private') {
                    $access = 'private';
                } else {
                    $access = $values['feedback_private'];
                }
            } else {
                $access = 'private';
            }
            $feedback->feedback_private = $access;
            $feedback->feedback_slug = trim(preg_replace('/-+/', '-', preg_replace('/[^a-z0-9-]+/i', '-', strtolower($values['feedback_title']))), '-');

            if ($access == 'private') {
                $feedback->search = 0;
            } else {
                $feedback->search = 1;
            }
            $feedback->feedback_description = nl2br($values['feedback_description']);
            $feedback->save();

            $db->commit();

            return $this->_redirect("feedbacks/manage");
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    public function successAction() {

        $this->view->show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
        $this->_helper->layout->setLayout('default-simple');
        $session = new Zend_Session_Namespace();
        $check_session = $session->feedback_success;
        $feedback_id = (int) $this->_getParam('feedback_id');
        if ($check_session != $feedback_id) {
            unset($_SESSION ['Default']['mysession']);
            return $this->_forward('requireauth', 'error', 'core');
        } else {
            unset($_SESSION ['Default']['mysession']);
        }
        $this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);
        $this->view->owner_id = $feedback->owner_id;
        if ($this->getRequest()->isPost() && $this->getRequest()->getPost('confirm') == true) {
            return $this->_redirect("feedbacks/image/upload/owner_id/" . $feedback->owner_id . "/subject/feedback_" . $this->_getParam('feedback_id'));
        }
    }

    //ACTION FOR VIEW  FEEDBACK
    public function viewAction() {
        

        //FIND LOGGED IN USER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();

        //IF NON-LOGGED USER WANT TO VIEW COMMENTS
        $check_anonymous_comment = (int) $this->_getParam('check_anonymous_comment');
        if ($check_anonymous_comment == 1) {
            if (!$this->_helper->requireUser()->isValid())
                return;
        }
        if ($viewer_id == 0) {
            $paramalink_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('check_anonymous_comment' => 1), 'feedback_detail_view');
            $this->view->paramalink_url = $paramalink_url;
        }

        $this->view->show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;

        //FIND FEEDBACK OBJECT AND INFORMATION OF FEEDBACK TABLE
        $this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $this->_getParam('feedback_id'));

        if ($viewer_id == 0) {
            $view_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('feedback_id' => $feedback->feedback_id, 'user_id' => $feedback->owner_id, 'slug' => $feedback->feedback_slug, 'check_view_id' => 1), 'feedback_detail_view');
            $this->view->view_url = $view_url;

            $check_view_id = (int) $this->_getParam('check_view_id');
            if ($check_view_id == 1) {
                if (!$this->_helper->requireUser()->isValid())
                    return;
            }
        }


        //EXPLANATION OF FOLLOWING TWO CONDITIONS:-
        //PRIVATE FEEDBACK ARE VIEWED ONLY BY "OWNER" AND "SUPER-ADMIN(LEVEL-1 USER)":
        //IF USER IS NON-LOGGED IN THAN HIS VIEWER ID IS WILL BE ZERO.
        //ONLY SUPER ADMIN USER LEVEL WILL BE ONE.
        //OWNER ID IS ID OF USER, WHO CREATED THIS FEEDBACK; 
        //PRIVATE FEEDBACK NOT VIEWABLE TO NON-LOGGED IN USER  
        if ($feedback->feedback_private == 'private' && $viewer_id == 0) {
            return $this->_forward('requireauth', 'error', 'core');
        }

        //PRIVATE FEEDBACK ONLY VIEABLE BY OWNER AND SUPERADMIN
        if (!empty($viewer_id)) {
            $this->view->user_level = $user_level = Engine_Api::_()->user()->getViewer()->level_id;

            if ($user_level != 1 && $feedback->feedback_private == 'private' && $feedback->owner_id != $viewer_id) {
                return $this->_forward('requireauth', 'error', 'core');
            }
        }
        $this->view->allow_upload = Engine_Api::_()->getApi('settings', 'core')->feedback_allow_image;

        //CHECK IF IP BLOCK BY ADMIN FOR POSTING FEEDBACK
        $tmTable = Engine_Api::_()->getitemTable('blockip');
        $tmName = $tmTable->info('name');
        $ip_can_post = 0;
        $checkPost = $tmTable->select()
                ->setIntegrityCheck(false)
                ->from($tmName, array('blockip_address', 'blockip_comment'))
                ->where('blockip_address = ?', $_SERVER['REMOTE_ADDR']);
        $rows = $tmTable->fetchAll($checkPost)->toArray();
        if (!empty($rows) && ($rows[0]['blockip_comment'] == 1)) {
            $this->view->ip_can_comment = 1;
        } else {
            $this->view->ip_can_comment = 0;
        }

        //CHECK IF USER BLOCK BY ADMIN FOR POSTING FEEDBACK
        $userBlock = Engine_Api::_()->getItem('blockuser', $viewer_id);
        if (!empty($userBlock)) {
            if ($userBlock->block_comment == 1) {
                $this->view->can_comment = 1;
            }
        } else {
            $this->view->can_comment = 0;
        }

        $this->view->owner = $owner = $feedback->getOwner();

        //CODE FOR SAME CATEGORY FEEDBACK
        $tmTable = Engine_Api::_()->getDbtable('feedbacks', 'feedback');
        $tmName = $tmTable->info('name');

        $selectUserFeeds = $tmTable->select()
                ->setIntegrityCheck(false)
                ->from($tmName, array('feedback_title', 'owner_id', 'feedback_description', 'views', 'creation_date', 'modified_date', 'comment_count', 'feedback_id', 'total_votes'))
                ->where('feedback_id != ?', $feedback->feedback_id)
                ->where('category_id = ?', $feedback->category_id)
                ->where('feedback_private != ?', 'private')
                ->order('creation_date ASC')
                ->limit(4);
        $this->view->feedbackUser = $feedbackUser = $tmTable->fetchAll($selectUserFeeds);
        $this->view->feedbackUserTotal = count($feedbackUser);

        //INCREMENT FEEDBACK VIEWS
        $feedback->views++;
        $feedback->save();

        //GET TOTAL NUMBER OF PARTICIPANTS
        $table = Engine_Api::_()->getDbTable('comments', 'core');
        $select = $table->select()
                ->setIntegrityCheck(false)
                ->from($table->info('name'), array('COUNT(`resource_id`) AS count'))
                ->where('resource_id = ?', $feedback->feedback_id)
                ->where('resource_type = ?', 'feedback')
                ->group('poster_id');
        $participants = Zend_Paginator::factory($select);
        $this->view->participants_total = $participants->getTotalItemCount();

        //SHOW PICTURES
        $tmTable = Engine_Api::_()->getItemtable('feedback_image');
        $tmName = $tmTable->info('name');

        $selectImage = $tmTable->select()
                ->setIntegrityCheck(false)
                ->from($tmName, array('image_id', 'user_id', 'album_id', 'file_id'))
                ->where('feedback_id = ?', $feedback->feedback_id);
        $this->view->paginator = $tmTable->fetchAll($selectImage);

        //CODE FOR VIEWER VOTE
        $tmTable = Engine_Api::_()->getitemTable('vote');
        $tmName = $tmTable->info('name');

        $checkVote = $tmTable->select()
                ->setIntegrityCheck(false)
                ->from($tmName, array('vote_id'))
                ->where('voter_id = ?', $viewer_id)
                ->where('feedback_id = ?', $feedback->feedback_id);
        $rows = $tmTable->fetchAll($checkVote)->toArray();

        if (!empty($rows)) {
            $this->view->vote = $rows['0']['vote_id'];
        } else {
            $this->view->vote = 0;
        }

        // FEEDBACK CATEGORY
        if ($feedback->category_id != 0) {
            $this->view->category = Engine_Api::_()->feedback()->getCategory($feedback->category_id);
        }

        // FEEDBACK STATUS
        if ($feedback->stat_id != 0) {
            $this->view->stat = Engine_Api::_()->feedback()->getStat($feedback->stat_id);
        }
        //REPORT CODE	
        $this->view->feedback_report = $feedback_report = Engine_Api::_()->getApi('settings', 'core')->feedback_report;
        $this->view->feedback_private = $feedback->feedback_private;
        if ($feedback_report == 1 && !empty($viewer_id)) {
            $report = $this->view->report = Engine_Api::_()->getItem('feedback', $feedback->feedback_id);
            if (!empty($report)) {
                Engine_Api::_()->core()->setSubject($report);
            }
            if (!$this->_helper->requireSubject()->isValid())
                return;
        }
        //END REPORT CODE	

        $this->_helper->content
                ->setContentName(30) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //ACTION FOR SHOW USER FEEDBACK LIST
    public function listAction() {

        //FIND LOGGED IN USER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->viewer_id = $viewer_id = $viewer->getIdentity();
        $this->view->owner = $owner = Engine_Api::_()->getItem('user', $this->_getParam('user_id'));

        $this->view->show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;

        if ($viewer_id == 0) {
            $list_url = 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('user_id' => $owner->user_id, 'check_list_id' => 1), 'feedback_view');
            $this->view->list_url = $list_url;

            $check_list_id = (int) $this->_getParam('check_list_id');
            if ($check_list_id == 1) {
                if (!$this->_helper->requireUser()->isValid())
                    return;
            }
        }

        //CREATE TABS
        $this->view->navigation = $this->getNavigation();

        // GENERATE SEARCH FORM
        $this->view->form = $form = new Feedback_Form_Search();

        // SHOW CATEGORY
        $this->view->categories = $categories = Engine_Api::_()->feedback()->getCategories();
        foreach ($categories as $category) {
            $form->category->addMultiOption($category->category_id, $category->category_name);
        }

        // SHOW STATUS
        $this->view->show_status = $status = Engine_Api::_()->feedback()->getStatus();

        // PROCESS SEARCH FORM
        $form->isValid($this->getRequest()->getPost());
        $values = $form->getValues();
        $values['viewer_id'] = $viewer_id;
        $values['user_id'] = $owner->getIdentity();
        $values['feedback_private'] = "public";
        $values['can_vote'] = "1";
        $this->view->assign($values);

        // GET PAGINATOR
        $this->view->paginator = $paginator = Engine_Api::_()->feedback()->getFeedbacksPaginator($values);
        $items_per_page = Engine_Api::_()->getApi('settings', 'core')->feedback_page;
        $paginator->setItemCountPerPage($items_per_page);
        $this->view->paginator = $paginator->setCurrentPageNumber($values['page']);
    }

    //ACTION FOR DELETE FEEDBACK
    public function deleteAction() {
        // CHECK USER VALIDATION
        if (!$this->_helper->requireUser()->isValid())
            return;

        $this->view->navigation = $this->getNavigation();
        $feedback_id = $this->_getParam('feedback_id');
        // GET VIEWER INFORMATION
        $viewer = $this->_helper->api()->user()->getViewer();
        $this->view->feedback = $feedback = Engine_Api::_()->getItem('feedback', $feedback_id);

        //GET USER LEVEL
        $user_level = Engine_Api::_()->user()->getViewer()->level_id;

        // CHECK THAT VIEWER CAN DELETE FEEDBACK OR NOT
        if ($viewer->getIdentity() != $feedback->owner_id && $user_level != 1) {
            return $this->_forward('requireauth', 'error', 'core');
        }

        // DELETE FEEDBACK FROM DATATBASE
        if ($this->getRequest()->isPost() && $this->getRequest()->getPost('confirm') == true) {

            //DELETE VOTES 
            $table = Engine_Api::_()->getItemTable('vote');
            $select = $table->select()
                    ->from($table->info('name'), 'vote_id')
                    ->where('feedback_id = ?', $feedback_id);
            $rows = $table->fetchAll($select)->toArray();
            if (!empty($rows)) {
                $vote_id = $rows[0]['vote_id'];
                $vote = Engine_Api::_()->getItem('vote', $vote_id);
                $vote->delete();
            }

            //DELETE IMAGE 
            $table = Engine_Api::_()->getItemTable('feedback_image');
            $select = $table->select()
                    ->from($table->info('name'), 'image_id')
                    ->where('feedback_id = ?', $feedback_id);
            $rows = $table->fetchAll($select)->toArray();
            if (!empty($rows)) {
                foreach ($rows as $key => $image_ids) {
                    $image_id = $image_ids['image_id'];
                    $image = Engine_Api::_()->getItem('feedback_image', $image_id);
                    $image->delete();
                }
            }

            //DELETE ALBUM 
            $table = Engine_Api::_()->getItemTable('feedback_album');
            $select = $table->select()
                    ->from($table->info('name'), 'album_id')
                    ->where('feedback_id = ?', $feedback_id);
            $rows = $table->fetchAll($select)->toArray();
            if (!empty($rows)) {
                $album_id = $rows[0]['album_id'];
                $album = Engine_Api::_()->getItem('feedback_album', $album_id);
                $album->delete();
            }

            $feedback->delete();

            return $this->_redirect("feedbacks/manage");
        }
    }

    //CREATING TABS
    protected $_navigation;

    public function getNavigation() {
        if ($this->_helper->api()->user()->getViewer()->getIdentity()) {
            $tabs = array();

            //CHECK THAT FEEDBACK FORUM TAB SHOULD BE VISIBLE OR NOT
            $show_browse = Engine_Api::_()->getApi('settings', 'core')->feedback_show_browse;
            if (!empty($show_browse)) {
                $tabs[] = array(
                    'label' => 'Browse Feedbacks',
                    'route' => 'feedback_browse',
                    'action' => 'browse',
                    'controller' => 'index',
                    'module' => 'feedback'
                );
            }

            $tabs[] = array(
                'label' => 'My Feedbacks',
                'route' => 'feedback_manage',
                'action' => 'manage',
                'controller' => 'index',
                'module' => 'feedback'
            );

            $tabs[] = array(
                'label' => 'Create New Feedback',
                'route' => 'feedback_create',
                'action' => 'create',
                'controller' => 'index',
                'module' => 'feedback',
                'class' => 'smoothbox',
                'width' => '',
            );

            if (is_null($this->_navigation)) {
                $this->_navigation = new Zend_Navigation();
                $this->_navigation->addPages($tabs);
            }
            return $this->_navigation;
        }
    }

}

?>
