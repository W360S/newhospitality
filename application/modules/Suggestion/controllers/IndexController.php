<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions 
 * @package    Suggestion
 * @copyright  Copyright 2009-2010 BigStep Technologies Pvt. Ltd.
 * @license    http://www.socialengineaddons.com/license/
 * @version    $Id: IndexController.php (var) 2010-08-17 9:40:21Z SocialEngineAddOns $
 * @author     SocialEngineAddOns
 */
class Suggestion_IndexController extends Core_Controller_Action_Standard {

    public function friendrequestAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        if (!Engine_Api::_()->core()->hasSubject()) {
            Engine_Api::_()->core()->setSubject(Engine_Api::_()->user()->getViewer());
        }

        $viewer = Engine_Api::_()->user()->getViewer();
        $this->view->requests = Engine_Api::_()->getDbtable('notifications', 'activity')->getRequestFriendPaginator($viewer);
    }

    // Function for view all page which are linked by "suggestion home" widget.
    public function viewfriendsuggestionAction() {



        if (!$this->_helper->requireUser()->isValid())
            return;
        if (!Engine_Api::_()->core()->hasSubject()) {
        Engine_Api::_()->core()->setSubject(Engine_Api::_()->user()->getViewer());
        }
        
        $this->_helper->content
                ->setContentName(48) // page_id
                // ->setNoRender()
                ->setEnabled();

        //Current user Id
        $this->view->user_id = $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // The users being currently suggested/displayed in the widget
        $this->view->suggestion_viewfriend_user_combind_path = $suggestion_viewfriend_user_combind_path = Engine_Api::_()->suggestion()->suggestion_path($user_id, 4, '', 21);
        // Pass the base url for searching.
        $this->view->baseurl = Zend_Controller_Front::getInstance()->getBaseUrl();
        if (!empty($suggestion_viewfriend_user_combind_path)) {
            $this->view->suggestion_viewfriend_users_info = Engine_Api::_()->suggestion()->suggestion_users_information($suggestion_viewfriend_user_combind_path, '');
        } else {
            $this->view->message = "<div class='tip'><span>" . $this->view->translate("You do not have any more friend suggestions.") . "</span></div>";
        }
        $viewer = Engine_Api::_()->user()->getViewer();
        $this->view->notifications = $notifications = Engine_Api::_()->getDbtable('notifications', 'activity')->getNotificationsPaginator($viewer);
        $this->view->requests = Engine_Api::_()->getDbtable('notifications', 'activity')->getRequestsPaginator($viewer);
    }

    // When "click on add friend" & "click on few friend" then for popup.
    public function requestsendAction() {

        // "$send_friend_id" set when open the popup of friend.
        $send_friend_id = $this->_getParam("send_friend_id");
        $this->view->search_true = false;
        $few_friend_indicator = '';
        // $id set only in the case of "Few Friend Suggestion" use in "Mix Suggestion Widget".
        $this->view->friend_status = $few_id = $this->_getParam('few_id');
        if (isset($few_id)) {
            $send_friend_id = $few_id;
            $few_friend_indicator = 'few_friend';
        }
        if (isset($send_friend_id)) {
            $this->view->send_friend_id = $send_friend_id;
        } else {
            $send_friend_id = 0;
        }
        //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

        if (!empty($_GET['task'])) {
            $this->view->search_true = true;
        }

        if (!empty($_GET['selected_checkbox'])) {
            $this->view->selected_checkbox = $_GET['selected_checkbox'];
            $show_selected = explode(",", $_GET['selected_checkbox']);
            array_shift($show_selected);

            foreach ($show_selected as $value) {
                $selected_array = explode("-", $value);
                $friend_request_id_array[] = $selected_array[1];
            }

            $this->view->friends_count = $selected_friend_count = count($friend_request_id_array);
        } else {
            $this->view->selected_checkbox = '';
            $this->view->friends_count = $selected_friend_count = 0;
        }

        $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
        $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


        //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
        if (!empty($_GET['show_selected'])) {
            $search = '';
            $this->view->show_selected = $selected_friend_show = 1;
            $this->view->send_friend_id = $send_friend_id = $_GET['action_id'];
        }
        //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
        else {
            if (empty($send_friend_id)) {
                $this->view->send_friend_id = $send_friend_id = $_GET['action_id'];
            }

            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
            $sugg_popups_limit = 0;

            if ($few_friend_indicator == 'few_friend') {
                $this->view->members = $add_friend_suggestion = Engine_Api::_()->suggestion()->few_friend_suggestion($user_id, $send_friend_id, '', $sugg_popups_limit, $search);
                $this->view->page_status = 'few';
                $add_friend_suggestion->setCurrentPageNumber($page);
                $add_friend_suggestion->setItemCountPerPage(50);
            } else {
                $this->view->members = $add_friend_suggestion = Engine_Api::_()->suggestion()->add_friend_suggestion($user_id, $send_friend_id, '', $sugg_popups_limit, 'add_friend', $search);
                $this->view->page_status = 'friend';
                $add_friend_suggestion->setCurrentPageNumber($page);
                $add_friend_suggestion->setItemCountPerPage(100);
            }

            $friend_request_id_array = array();
            foreach ($add_friend_suggestion as $friends_row) {
                $friend_request_id_array[] = $friends_row['user_id'];
            }
            $this->view->show_selected = $selected_friend_show = 0;
        }
        $this->view->suggestion_add_friend_combind_path = $friend_request_id_array;

        //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
        if (!empty($friend_request_id_array)) {
            if ($selected_friend_show) {
                $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($friend_request_id_array, $selected_friend_show, '');
                $selected_friends->setCurrentPageNumber($page);
                $selected_friends->setItemCountPerPage(100);
            } else {
                $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($friend_request_id_array, $selected_friend_show, '');
            }

            if ($this->getRequest()->isPost()) {
                $user_displayname = Engine_Api::_()->user()->getViewer()->displayname; // Use for Email.		  	
                $sugg_friend_send = $this->getRequest()->getPost();
                foreach ($sugg_friend_send as $key_post => $value_post) {
                    // In the case of few friend we are sending friend suggestions to the selected friend.
                    if ($few_friend_indicator == 'few_friend') {
                        $owner_id = $this->getRequest()->getPost('friend');
                        $entity_id = $value_post;
                    }
                    // In the case of add friend suggestion we are sending friend suggestion to my friends for selected friend.
                    else {
                        $owner_id = $value_post;
                        $entity_id = $this->getRequest()->getPost('friend');
                    }
                    if (strpos($key_post, 'check_') !== FALSE) {
                        $listTable = Engine_Api::_()->getItemTable('suggestion');
                        $db = $listTable->getAdapter();
                        $db->beginTransaction();
                        try {
                            $list = $listTable->createRow();
                            $list->owner_id = $owner_id;
                            $list->sender_id = $user_id;
                            $list->entity = 'friend';
                            $list->entity_id = $entity_id;
                            $list->save();
                            // Add in the notification table for show in the "update".
                            $owner_obj = Engine_Api::_()->getItem('user', $owner_id);
                            $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                            // $owner_obj : Object which are geting suggestion.
                            // $sender_obj : Object which are sending suggestion.
                            // $list : Object from which table we'll link.
                            // suggestion_friend :notification type.
                            Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'friend_suggestion');
                            // EMAIL WORK START FROM HERE.
                            $entity_displayname = Engine_Api::_()->getItem('user', $entity_id)->displayname;
                            $owner_email = Engine_Api::_()->getItem('user', $owner_id)->email;
                            $email = Engine_Api::_()->getApi('settings', 'core')->core_email_from;
                            Engine_Api::_()->getApi('mail', 'core')->sendSystem($owner_email, 'notify_suggest_friend', array(
                                'suggestion_sender' => $user_displayname,
                                'suggestion_entity' => $entity_displayname,
                                'email' => $email,
                                'queue' => true,
                                'link' => 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('sugg_id' => $list->suggestion_id), 'received_suggestion')));
                            $db->commit();
                        } catch (Exception $e) {
                            $db->rollBack();
                            throw $e;
                        }
                    }
                }
                $this->_forward('success', 'utility', 'core', array(
                    'smoothboxClose' => true,
                    'parentRefresh' => true,
                    'messages' => array("Your suggestions have been sent.")
                        )
                );
            }
        } else if (empty($search)) {
            $friend_displayname = Engine_Api::_()->getItem('user', $send_friend_id)->displayname;
            $this->view->sugg_mess = $this->view->translate("All your friend are also friends with ") . $friend_displayname;
        }
    }

    // When "click on accept friend" then for popup.
    public function requestacceptAction() {
        // "$accept_friend_id" set when open the popup of accept friend.
        $accept_friend_id = $this->_getParam("sugg_accept_id");
        $this->view->search_true = false;
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) { // If the suggestion popup is submitted
            $sugg_friend_request = $this->getRequest()->getPost();
            foreach ($sugg_friend_request as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    // This function call for giving friend request of many people.
                    $this->addAction($value_post);
                }
                $this->_forward('success', 'utility', 'core', array(
                    'smoothboxClose' => true,
                    'parentRefresh' => true,
                    'messages' => array('Your friend requests have been sent.')
                        )
                );
            }
        } else {
            if (isset($accept_friend_id)) {
                $this->view->accept_friend_id = $accept_friend_id;
            } else {
                $accept_friend_id = 0;
            }
            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $request_accept_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($request_accept_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->accept_friend_id = $accept_friend_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($accept_friend_id)) {
                    $this->view->accept_friend_id = $accept_friend_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $add_friend_suggestion = Engine_Api::_()->suggestion()->add_friend_suggestion($user_id, $accept_friend_id, '', $sugg_popups_limit, 'accept_request', $search);
                $add_friend_suggestion->setCurrentPageNumber($page);
                $add_friend_suggestion->setItemCountPerPage(50);
                $request_accept_id_array = array();

                foreach ($add_friend_suggestion as $friends_row) {
                    $request_accept_id_array[] = $friends_row['user_id'];
                }
                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->suggestion_add_friend_combind_path = $request_accept_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($request_accept_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($request_accept_id_array, $selected_friend_show, '');
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($request_accept_id_array, $selected_friend_show, '');
                }
            }
        }
    }

    // Handel the group suggestion popup.
    public function groupAction() {
        // "$group_id" set when open the popup of group.
        $group_id = $this->_getParam("group_sugge_id");
        $this->view->search_true = false;
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) { // If the suggestion popup is submitted
            $sugg_group_arr = $this->getRequest()->getPost();
            foreach ($sugg_group_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'group';
                    $list->entity_id = $this->getRequest()->getPost('group');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_group :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'group_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($group_id)) {
                $this->view->group_id = $group_id;
            } else {
                $group_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $group_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($group_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->group_id = $group_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($group_id)) {
                    $this->view->group_id = $group_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->group_suggestion($group_id, '', $sugg_popups_limit, $search);
                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $group_id_array = array();

                foreach ($fetch_member_myfriend as $group_row) {
                    $group_id_array[] = $group_row['user_id'];
                }
                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->group_combind_path = $group_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($group_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($group_id_array, $selected_friend_show, '');
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($group_id_array, $selected_friend_show, '');
                }
            }
        }
    }

    // Handel the Event suggestion popup.
    public function eventAction() {

        $this->view->search_true = false;
        // "$event_id" set when open the popup of event.
        $event_id = $this->_getParam("sugg_event_id");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_event_arr = $this->getRequest()->getPost();
            foreach ($sugg_event_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'event';
                    $list->entity_id = $this->getRequest()->getPost('event');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_event :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'event_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            //THIS IS WHEN FIRST TIME PAGE LOAD.
            $session = new Zend_Session_Namespace();
            if (isset($event_id)) {
                $this->view->event_id = $event_id;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $event_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($event_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->event_id = $event_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($event_id)) {
                    $this->view->event_id = $event_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->event_suggestion($event_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(1000);

                $event_id_array = array();

                foreach ($fetch_member_myfriend as $event_row) {
                    $event_id_array[] = $event_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->event_combind_path = $event_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($event_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($event_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(1000);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($event_id_array, $selected_friend_show);
                }
            }
        }
    }

    public function blogAction() {
        $this->view->search_true = false;
        // "$blog_id" set when open the popup of blog.
        $blog_id = $this->_getParam("sugg_blog_create");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_blog_arr = $this->getRequest()->getPost();
            foreach ($sugg_blog_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'blog';
                    $list->entity_id = $this->getRequest()->getPost('blog');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_blog :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'blog_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($blog_id)) {
                $this->view->blog_id = $blog_id;
            } else {
                $blog_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $blog_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($blog_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->blog_id = $blog_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($blog_id)) {
                    $this->view->blog_id = $blog_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->blog_suggestion($blog_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $blog_id_array = array();

                foreach ($fetch_member_myfriend as $blog_row) {
                    $blog_id_array[] = $blog_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->blog_combind_path = $blog_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($blog_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($blog_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($blog_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Handel the poll suggestion popup.
    public function pollAction() {
        $this->view->search_true = false;
        // "$poll_id" set when open the popup of poll.
        $poll_id = $this->_getParam("sugg_poll_create");

        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_poll_arr = $this->getRequest()->getPost();
            foreach ($sugg_poll_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'poll';
                    $list->entity_id = $this->getRequest()->getPost('poll');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_poll :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'poll_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($poll_id)) {
                $this->view->poll_id = $poll_id;
            } else {
                $poll_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $poll_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($poll_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->poll_id = $poll_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($poll_id)) {
                    $this->view->poll_id = $poll_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->poll_suggestion($poll_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $poll_id_array = array();

                foreach ($fetch_member_myfriend as $poll_row) {
                    $poll_id_array[] = $poll_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->poll_combind_path = $poll_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($poll_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($poll_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($poll_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Handel the forum suggestion popup.
    public function forumAction() {
        $this->view->search_true = false;
        // "$forum_id" set when open the popup of forum.
        $forum_id = $this->_getParam("sugg_forum");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_forum_arr = $this->getRequest()->getPost();
            foreach ($sugg_forum_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'forum';
                    $list->entity_id = $this->getRequest()->getPost('forum');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_forum :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'forum_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($forum_id)) {
                $this->view->forum_id = $forum_id;
            } else {
                $forum_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $forum_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($forum_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->forum_id = $forum_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($forum_id)) {
                    $this->view->forum_id = $forum_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->forum_suggestion($forum_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $forum_id_array = array();

                foreach ($fetch_member_myfriend as $forum_row) {
                    $forum_id_array[] = $forum_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->forum_combind_path = $forum_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($forum_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($forum_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($forum_id_array, $selected_friend_show);
                }
            }
        }
    }

// Handel the album suggestion popup.
    public function albumAction() {
        $this->view->search_true = false;
        // "$album_id" set when open the popup of album.
        $album_id = $this->_getParam("sugg_album_create");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_album_arr = $this->getRequest()->getPost();
            foreach ($sugg_album_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'album';
                    $list->entity_id = $this->getRequest()->getPost('album');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_album :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'album_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($album_id)) {
                $this->view->album_id = $album_id;
                //DELETE THE FRIEND SESSION ID.
            } else {
                $album_id = 0;
            }
            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $album_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($album_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->album_id = $album_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($album_id)) {
                    $this->view->album_id = $album_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->album_suggestion($album_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $album_id_array = array();

                foreach ($fetch_member_myfriend as $album_row) {
                    $album_id_array[] = $album_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->album_combind_path = $album_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($album_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($album_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($album_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Handel the classified suggestion popup.  
    public function classifiedAction() {
        $this->view->search_true = false;
        // "$classified_id" set when open the popup of classified.
        $classified_id = $this->_getParam("sugg_classified_create");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_classified_arr = $this->getRequest()->getPost();
            foreach ($sugg_classified_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'classified';
                    $list->entity_id = $this->getRequest()->getPost('classified');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_classified :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'classified_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($classified_id)) {
                $this->view->classified_id = $classified_id;
            } else {
                $classified_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $classified_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($classified_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->classified_id = $classified_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($classified_id)) {
                    $this->view->classified_id = $classified_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->classified_suggestion($classified_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $classified_id_array = array();

                foreach ($fetch_member_myfriend as $classified_row) {
                    $classified_id_array[] = $classified_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->classified_combind_path = $classified_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($classified_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($classified_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($classified_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Handel the video suggestion popup.
    public function videoAction() {
        $this->view->search_true = false;
        // "$video_id" set when open the popup of video.
        $video_id = $this->_getParam("sugg_video_create");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_video_arr = $this->getRequest()->getPost();
            foreach ($sugg_video_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'video';
                    $list->entity_id = $this->getRequest()->getPost('video');
                    $list->save();
                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_video :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'video_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($video_id)) {
                $this->view->video_id = $video_id;
            } else {
                $video_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $video_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($video_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->video_id = $video_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($video_id)) {
                    $this->view->video_id = $video_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->video_suggestion($video_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(1000);

                $video_id_array = array();

                foreach ($fetch_member_myfriend as $video_row) {
                    $video_id_array[] = $video_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->video_combind_path = $video_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($video_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($video_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(1000);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($video_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Handel the music suggestion popup.
    public function musicAction() {
        $this->view->search_true = false;
        // "$music_id" set when open the popup of music.
        $music_id = $this->_getParam("sugg_music_create");
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost()) {
            $sugg_music_arr = $this->getRequest()->getPost();
            foreach ($sugg_music_arr as $key_post => $value_post) {
                if (strpos($key_post, 'check_') !== FALSE) {
                    $listTable = Engine_Api::_()->getItemTable('suggestion');
                    $list = $listTable->createRow();
                    $list->owner_id = $value_post;
                    $list->sender_id = $user_id;
                    $list->entity = 'music';
                    $list->entity_id = $this->getRequest()->getPost('music');
                    $list->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $value_post);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_music :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $list, 'music_suggestion');
                }
            }
            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                //'parentRefresh' => true,
                'messages' => array("Your suggestions have been sent.")
                    )
            );
        } else {
            if (isset($music_id)) {
                $this->view->music_id = $music_id;
            } else {
                $music_id = 0;
            }

            //THIS IS WHEN DO SOME ACTIVITY ON THE SUGGESTION PAGE.

            if (!empty($_GET['task'])) {
                $this->view->search_true = true;
            }

            if (!empty($_GET['selected_checkbox'])) {
                $this->view->selected_checkbox = $_GET['selected_checkbox'];
                $show_selected = explode(",", $_GET['selected_checkbox']);
                array_shift($show_selected);

                foreach ($show_selected as $value) {
                    $selected_array = explode("-", $value);
                    $music_id_array[] = $selected_array[1];
                }

                $this->view->friends_count = $selected_friend_count = count($music_id_array);
            } else {
                $this->view->selected_checkbox = '';
                $this->view->friends_count = $selected_friend_count = 0;
            }

            $this->view->page = $page = !empty($_GET['page']) ? $_GET['page'] : 1;
            $this->view->search = $search = !empty($_GET['searchs']) ? $_GET['searchs'] : '';


            //IF THE REQUEST IS FOR SHOWING ONLY SELECTED FRIENDS.
            if (!empty($_GET['show_selected'])) {
                $search = '';
                $this->view->show_selected = $selected_friend_show = 1;
                $this->view->music_id = $music_id = $_GET['action_id'];
            }
            //IF THE REQUEST IS FOR SHOWING ALL FRIENDS.
            else {
                if (empty($music_id)) {
                    $this->view->music_id = $music_id = $_GET['action_id'];
                }

                $sugg_popups_limit = 0;
                $this->view->members = $fetch_member_myfriend = Engine_Api::_()->suggestion()->music_suggestion($music_id, '', $sugg_popups_limit, $search);

                $fetch_member_myfriend->setCurrentPageNumber($page);
                $fetch_member_myfriend->setItemCountPerPage(50);

                $music_id_array = array();

                foreach ($fetch_member_myfriend as $music_row) {
                    $music_id_array[] = $music_row['user_id'];
                }

                $this->view->show_selected = $selected_friend_show = 0;
            }

            $this->view->music_combind_path = $music_id_array;

            //HERE WE ARE CHECKING IF THE REQUEST IS FOR ONLY SHOW SELECTED FRIENDS THEN WE WILL MAKE PAGINATION OF USER OBJECT OTHERWISE WE WILL SIMPLY USER FETCHALL QUERY.
            if (!empty($music_id_array)) {
                if ($selected_friend_show) {
                    $this->view->suggest_user = $this->view->members = $selected_friends = Engine_Api::_()->suggestion()->suggestion_users_information($music_id_array, $selected_friend_show);
                    $selected_friends->setCurrentPageNumber($page);
                    $selected_friends->setItemCountPerPage(100);
                } else {
                    $this->view->suggest_user = Engine_Api::_()->suggestion()->suggestion_users_information($music_id_array, $selected_friend_show);
                }
            }
        }
    }

    // Function to handle the profile picture suggestion from one user to the other.
    public function profilePictureAction() {
        $id = $this->_getParam("id");
        $this->view->displayname = Engine_Api::_()->getItem('user', $id)->displayname;
        $this->view->form = $form = new Suggestion_Form_Photo();
        if ($this->getRequest()->isPost()) {
            $values = $form->getValues();
            $is_error = 0;

            if (isset($values['Filedata'])) { // When select the image.
                $this->getSession()->data = $form->getValues();
                $file = APPLICATION_PATH . '/public/temporary/' . $values['Filedata'];
                $path = dirname($file);
                $name = basename($file);
                $this->_resizeImages($form->Filedata->getFileName());
                $this->view->image_name = $name;
                //$_SESSION['ProfileSuggestionImage'] = $name;
                //$_SESSION['suggestionImage'] = $name;
            } else { // If click on the submit button.
                // Show error message if without select any image click on submit.
                if (empty($_POST['image'])) {
                    $error = $this->view->translate('Please choose a photo to suggest.');
                    $this->view->status = false;
                    $error = Zend_Registry::get('Zend_Translate')->_($error);
                    $form->getDecorator('errors')->setOption('escape', false);
                    $form->addError($error);
                    return;
                }

                $coordinates = $this->_getParam("coordinates");


                $suggestionTable = Engine_Api::_()->getItemTable('suggestion');
                $values = $form->getValues();
                $owner_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                // Begin database transaction
                $db = $suggestionTable->getAdapter();
                $db->beginTransaction();

                try {
                    $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                    // Insert value in "Received" data base.
                    $suggestionRow = $suggestionTable->createRow();
                    $suggestionRow->owner_id = $id;
                    $suggestionRow->sender_id = $user_id;
                    $suggestionRow->entity = 'photo';
                    $suggestionRow->save();

                    // Add in the notification table for show in the "update".
                    $owner_obj = Engine_Api::_()->getItem('user', $id);
                    $sender_obj = Engine_Api::_()->getItem('user', $user_id);
                    // $owner_obj : Object which are geting suggestion.
                    // $sender_obj : Object which are sending suggestion.
                    // $list : Object from which table we'll link.
                    // suggestion_picture :notification type.
                    Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($owner_obj, $sender_obj, $suggestionRow, 'picture_suggestion');
                    Engine_Api::_()->authorization()->context->setAllowed($suggestionRow, 'everyone', 'view', 'everyone');

                    // Set photo
                    if (!empty($_POST['image'])) {
                        $suggestionRow->setPhoto($_POST['image'], $coordinates);
                    }

                    $db->commit();
                } catch (Exception $e) {
                    $db->rollBack();
                    throw $e;
                }

                // After submit close the smoothbox.
                $this->_forward('success', 'utility', 'core', array(
                    'smoothboxClose' => true,
                    //'parentRefresh' => true,
                    'messages' => array("Your suggestions have been sent.")
                        )
                );
            }
        }
    }

    // This function is called in "profilePictureAction()" and creates images in "Temporary" folder in different sizes.
    protected function _resizeImages($file) {
        $name = basename($file);
        $path = dirname($file);

        // Resize image (main)
        $image = Engine_Image::factory();
        $image->open($file)
                ->resize(720, 720)
                ->write($path . '/m_' . $name)
                ->destroy();

        // Resize image (profile)
        $image = Engine_Image::factory();
        $image->open($file);

        $size = min($image->height, $image->width);
        $x = ($image->width - $size) / 2;
        $y = ($image->height - $size) / 2;

        $image->resample($x, $y, $size, $size, 200, 200)
                ->write($path . '/p_' . $name)
                ->destroy();

        // Resize image (icon.normal)
        $image = Engine_Image::factory();
        $image->open($file)
                ->resize(48, 120)
                ->write($path . '/in_' . $name)
                ->destroy();

        // Resize image (icon.square)
        $image = Engine_Image::factory();
        $image->open($file);

        $size = min($image->height, $image->width);
        $x = ($image->width - $size) / 2;
        $y = ($image->height - $size) / 2;

        $image->resample($x, $y, $size, $size, 48, 48)
                ->write($path . '/is_' . $name)
                ->destroy();
    }

    // This function is for the Viewall page of Suggestions.
    protected $sugg_display_object;

    public function viewallAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            if (isset($_REQUEST['type'])) {
                $this->view->type = $_REQUEST['type'];
            }
            // Sending base URL in view file.
            $this->view->sugg_baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();
            $sugg_display_object = array();
            // Call function from Api/core.php.
            $sugg_display = Engine_Api::_()->suggestion()->see_suggestion_display();
            // Call for number of user per widget.
            $this->view->sugg_count = Engine_Api::_()->suggestion()->sugg_display();
            if (!empty($sugg_display)) {
                foreach ($sugg_display as $row_all_sugg_dis) {
                    // Array should be blank for all upcomming entry.
                    $sugg_funn_array = array();
                    if ($row_all_sugg_dis['entity'] == 'photo') {
                        // In the case of photo we pass "suggestion_id" in the form of array.
                        $sugg_funn_array[] = $row_all_sugg_dis['suggestion_id'];
                        $function_name = $row_all_sugg_dis['entity'] . '_info';
                        $this->sugg_display_object[$row_all_sugg_dis['entity'] . '_' . $row_all_sugg_dis['entity_id'] . '_' . $row_all_sugg_dis['sender_id'] . '_' . $row_all_sugg_dis['suggestion_id']] = Engine_Api::_()->suggestion()->$function_name($sugg_funn_array);
                    } else {
                        // Other case we pass "entity_id" in the case of array.
                        $sugg_funn_array[] = $row_all_sugg_dis['entity_id'];
                        $function_name = $row_all_sugg_dis['entity'] . '_info';
                        $this->sugg_display_object[$row_all_sugg_dis['entity'] . '_' . $row_all_sugg_dis['entity_id'] . '_' . $row_all_sugg_dis['sender_id'] . '_' . $row_all_sugg_dis['suggestion_id']] = Engine_Api::_()->suggestion()->$function_name($sugg_funn_array);
                    }
                }
                // send value with object.  	
                $this->view->sugg_display_object = $this->sugg_display_object;
                $this->view->sugg_msg = '';
            } else {
                $this->view->sugg_msg = '<div class="tip"><span>Suggestion not found</span></div>';
            }
        }
    }

    // This function is for the view page of a single suggestion
    public function viewAction() {
        $suggestion_field_cat = Engine_Api::_()->getApi('settings', 'core')->getSetting('suggestion.field.cat');
        if (!empty($suggestion_field_cat)) {
            $this->view->sugg_baseUrl = Zend_Controller_Front::getInstance()->getBaseUrl();
            // Suggestion Id which are id of "suggestion" table.
            $sugg_id = $this->_getParam('sugg_id');
            $suggestion_obj = Engine_Api::_()->getItem('suggestion', $sugg_id);
            if (!empty($suggestion_obj)) {
                // Array for passing ide's in function which are written in api/core.php
                $sugg_id_array = array();
                if ($suggestion_obj->entity == 'photo') {
                    $sugg_id_array[] = $suggestion_obj->suggestion_id;
                } else {
                    $sugg_id_array[] = $suggestion_obj->entity_id;
                }
                $function_name = $suggestion_obj->entity . '_info';
                $suggestion_object[$suggestion_obj->entity] = Engine_Api::_()->suggestion()->$function_name($sugg_id_array);
                // Check if admin delete the suggestion from admin panel then we'll update "suggestion" & "notification" table.
                if (count($suggestion_object[$suggestion_obj->entity]) == 0) {
                    // Delete from "Notification Table".
                    Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $sugg_id, 'object_type = ?' => 'suggestion'));
                    // Delete from "Suggestion" table.
                    Engine_Api::_()->getItem('suggestion', $sugg_id)->delete();
                    //Zend_Debug::dump("nhay"); exit;
                    //return $this->_helper->redirector->gotoRoute(array('action' => 'viewall'));
                    $this->view->sugg_msg = '<div class="tip"><span>Suggestion not found</span></div>';
                } else {// If entry not deleted and object found of the giving suggestion.
                    $this->view->suggestion_object = $suggestion_object;
                    $sender_name = Engine_Api::_()->getItem('user', $suggestion_obj->sender_id);
                    $this->view->sender_name = $this->view->htmlLink($sender_name->getHref(), $sender_name->displayname);
                    $this->view->suggestion_id = $suggestion_obj->suggestion_id;
                    $this->view->photo_id = $suggestion_obj->entity_id;
                    $this->view->sugg_msg = '';
                }
            } else {
                //Zend_Debug::dump("loi va nhay"); exit;
                //return $this->_helper->redirector->gotoRoute(array('action' => 'viewall'));
                $this->view->sugg_msg = '<div class="tip"><span>Suggestion not found</span></div>';
            }
        }
    }

    //IF THE TASK IS TO SEND FRIENDSHIP REQUESTS.
    function addtofriendAction() {
        $friendsToAdd = $_POST['sitemembers'];
        foreach ($friendsToAdd as $friend) {
            $this->addAction($friend);
        }
    }

    //IF THE TASK IS TO JOIN THIS SITE.
    function invitetositeAction() {
        $friendsToJoin = $_POST['nonsitemembers'];
        $this->sendInvites($friendsToJoin);
    }

    //THIS FUNCTION IS USED TO SAVE THE FRIEND REQUEST, AND PERFORM ALLIED ACTIONS FOR NOTIFICATION UPDATES, ETC.
    public function addAction($id) {
        if (!$this->_helper->requireUser()->isValid())
            return;

        // Disable Layout.
        $this->_helper->layout->disableLayout(true);

        // Get id of friend to add
        $user_id = $id;
        if (null == $user_id) {
            $this->view->status = false;
            $this->view->error = Zend_Registry::get('Zend_Translate')->_('No member specified');
            return;
        }

        $viewer = $this->_helper->api()->user()->getViewer();
        $user = $this->_helper->api()->user()->getUser($user_id);

        // check that user is not trying to befriend 'self'
        if ($viewer->isSelf($user)) {
            return;
        }

        // check that user is already friends with the member
        if ($viewer->membership()->isMember($user)) {
            return;
        }

        // check that user has not blocked the member
        if ($viewer->isBlocked($user)) {
            return;
        }

        // Process
        $db = Engine_Api::_()->getDbtable('membership', 'user')->getAdapter();
        $db->beginTransaction();

        try {
            // check friendship verification settings
            // add membership if allowed to have unverified friendships
            //$user->membership()->setUserApproved($viewer);
            // else send request
            $user->membership()->addMember($viewer)->setUserApproved($viewer);


            // send out different notification depending on what kind of friendship setting admin has set
            /* ('friend_accepted', 'user', 'You and {item:$subject} are now friends.', 0, ''),
              ('friend_request', 'user', '{item:$subject} has requested to be your friend.', 1, 'user.friends.request-friend'),
              ('friend_follow_request', 'user', '{item:$subject} has requested to add you as a friend.', 1, 'user.friends.request-friend'),
              ('friend_follow', 'user', '{item:$subject} has added you as a friend.', 1, 'user.friends.request-friend'),
             */


            // if one way friendship and verification not required
            if (!$user->membership()->isUserApprovalRequired() && !$user->membership()->isReciprocal()) {
                // Add activity
                Engine_Api::_()->getDbtable('actions', 'activity')->addActivity($user, $viewer, 'friends_follow', '{item:$object} is now following {item:$subject}.');

                // Add notification
                Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($user, $viewer, $user, 'friend_follow');

                $message = "You are now following this member.";
            }

            // if two way friendship and verification not required
            else if (!$user->membership()->isUserApprovalRequired() && $user->membership()->isReciprocal()) {
                // Add activity
                Engine_Api::_()->getDbtable('actions', 'activity')->addActivity($user, $viewer, 'friends', '{item:$object} is now friends with {item:$subject}.');
                Engine_Api::_()->getDbtable('actions', 'activity')->addActivity($viewer, $user, 'friends', '{item:$object} is now friends with {item:$subject}.');

                // Add notification
                Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($user, $viewer, $user, 'friend_accepted');
            }

            // if one way friendship and verification required
            else if (!$user->membership()->isReciprocal()) {
                // Add notification
                Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($user, $viewer, $user, 'friend_follow_request');
            }

            // if two way friendship and verification required
            else if ($user->membership()->isReciprocal()) {
                // Add notification
                Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification($user, $viewer, $user, 'friend_request');
            }
            $this->view->status = true;
            $db->commit();
        } catch (Exception $e) {
            $db->rollBack();
            $this->view->status = false;
            $this->view->exception = $e->__toString();
        }
    }

    public function sendInvites($recipients) {
        $user = Engine_Api::_()->user()->getViewer();
        $settings = Engine_Api::_()->getApi('settings', 'core');
        $translate = Zend_Registry::get('Zend_Translate');
        $message = Engine_Api::_()->getApi('settings', 'core')->invite_message;
        $message = trim($message);
        if (is_array($recipients) && !empty($recipients)) {
            // Initiate objects to be used below
            $table = Engine_Api::_()->getDbtable('invites', 'invite');
            // Iterate through each recipient
            //$already_members       = Engine_Api::_()->invite()->findIdsByEmail($recipients);
            //$this->already_members = Engine_Api::_()->user()->getUserMulti($already_members);
            foreach ($recipients as $recipient) {
                // perform tests on each recipient before sending invite
                $recipient = trim($recipient);
                // watch out for poorly formatted emails
                if (!empty($recipient)) {
                    // Passed the tests, lets start inserting database entry
                    // generate unique invite code and confirm it truly is unique
                    do {
                        $invite_code = substr(md5(rand(0, 999) . $recipient), 10, 7);
                        $code_check = $table->select()->where('code = ?', $invite_code);
                    } while (null !== $table->fetchRow($code_check));

                    // per-user string formatting
                    $invite_url = "http://{$_SERVER['HTTP_HOST']}"
                            . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                                'module' => 'invite',
                                'controller' => 'signup',
                                'action' => $invite_code), 'default');

                    // insert the invite into the database
                    $db = Engine_Db_Table::getDefaultAdapter();
                    $db->beginTransaction();
                    try {
                        $row = $table->createRow();
                        $row->user_id = $user->getIdentity();
                        $row->recipient = $recipient;
                        $row->code = $invite_code;
                        $row->timestamp = date('Y-m-d H:i:s');
                        $row->message = $message;
                        $row->save();
                        $mail_settings = array(
                            'sender_title' => $user->getTitle(),
                            'email' => $recipient,
                            'message' => $message,
                            'object_link' => 'http://' . $_SERVER['HTTP_HOST'] . Zend_Controller_Front::getInstance()->getRouter()->assemble(array('code' => $invite_code, 'email' => $recipient), 'user_signup'));
                        // send email
                        //$user->invites_used++;
                        if ($settings->getSetting('user.signup.inviteonly') == 2) {
                            $mail_settings['code'] = $invite_code;
                            Engine_Api::_()->getApi('mail', 'core')->sendSystem(
                                    $recipient, 'invite_code', $mail_settings
                            );
                        } else {
                            $mail_settings['code'] = $row['code'];
                            Engine_Api::_()->getApi('mail', 'core')->sendSystem(
                                    $recipient, 'invite', $mail_settings
                            );
                        }
                        // mail sent, so commit
                        //$this->emails_sent++;
                        $db->commit();
                    } catch (Zend_Mail_Transport_Exception $e) {
                        $db->rollBack();
                    }
                } // end if (!array_key_exists($recipient, $already_members))
            } // end foreach ($recipients as $recipient)
        } // end if (is_array($recipients) && !empty($recipients))
        $user->save();
        return;
    }

// end public function sendInvites()
    // This action renders the content for the site introduction popup for newly signed up users
    public function introductionAction() {
        $session = new Zend_Session_Namespace();
        unset($session->new_user_create);
        unset($session->new_user_verify);
        $this->view->content = Engine_Api::_()->getItem('introduction', 1)->content;
    }

    // Ajax : call when confirm friend from notification page.
    protected $friend_detail;

    public function notificationacceptAction() {
        $friend_id = (int) $this->_getParam('friend_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        // Remove suggestion if user have from "suggestion table" & "notification table".
        $received_table = Engine_Api::_()->getItemTable('suggestion');
        $received_name = $received_table->info('name');
        $received_select = $received_table->select()
                ->from($received_name, array('suggestion_id'))
                ->where('owner_id = ?', $user_id)
                ->where('entity = ?', 'friend')
                ->where('entity_id = ?', $friend_id);
        $fetch_array = $received_select->query()->fetchAll();
        if (!empty($fetch_array)) {
            foreach ($fetch_array as $row_friend_array)
            // Delete from "Notification table" from update tab.
                Engine_Api::_()->getDbtable('notifications', 'activity')->delete(array('object_id = ?' => $row_friend_array['suggestion_id'], 'type = ?' => 'friend_suggestion'));
            // Remove suggestion from "suggestion table".
            Engine_Api::_()->getItem('suggestion', $row_friend_array['suggestion_id'])->delete();
        }
        // After deleting work on suggestion which will display on request listing page.
        //$this->addAction($friend_id);		
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $add_friend_suggestion = Engine_Api::_()->suggestion()->add_friend_suggestion($user_id, $friend_id, '', 4, 'accept_request', 'show_friend_suggestion');
        $friend_object = Engine_Api::_()->getItem('user', $friend_id);
        // If there are any suggestion available then make suggestion and return this.
        if (!empty($add_friend_suggestion)) {
            $suggestion_user = Engine_Api::_()->suggestion()->suggestion_users_information($add_friend_suggestion, '');
            $friend_link = '';
            foreach ($suggestion_user as $user_info) {
                $friend_link = $user_info->user_id;
                $photo = $this->view->htmlLink($user_info->getHref(), $this->view->itemPhoto($user_info, 'thumb.icon'), array('class' => 'thumb-img', 'target' => '_parent'));
                $title = $this->view->htmlLink($user_info->getHref(), $user_info->getTitle(), array('target' => '_parent'));
                $link = '<div id="userResponce_' . $user_info->user_id . '"><a onclick="friendSend(' . $user_info->user_id . ')" href="javascript:void(0);" class="buttonlink icon_friend_add" ><b>' . $this->view->translate("Add Friend") . '</b></a></div>';
                $friend_description = '<div id="user_' . $user_info->user_id . '" class="ajex-suggestion">' . $photo . '<div>' . $title . '</div>' . '' . $link . '</div>';
                $this->friend_detail .= $friend_description;
            }
            $friend_detail = '<b>' . $this->view->translate("You are now friends with ") . $this->view->htmlLink($friend_object->getHref(), $friend_object->getTitle() . '.') . $this->view->translate(" Next, ") . $this->view->htmlLink($friend_object->getHref(), 'view ' . $friend_object->getTitle() . "'s profile.") . '</b>';
            $friend_sub_detail = $this->view->translate("You may also know some of ") . $friend_object->getTitle() . $this->view->translate("'s friends:");
        }
        // If there are no suggestion available then only show message.
        else {
            $this->friend_detail = '';
            $friend_detail = '<b>' . $this->view->translate("You are now friends with ") . $this->view->htmlLink($friend_object->getHref(), $friend_object->getTitle() . '.') . $this->view->translate(" Next, ") . $this->view->htmlLink($friend_object->getHref(), 'view ' . $friend_object->getTitle() . "'s profile.") . '</b>';
            $friend_sub_detail = '';
        }
        $this->view->status = true;
        $this->view->friend_link = $this->friend_detail;
        $this->view->friend_detail = $friend_detail;
        $this->view->friend_sub_detail = $friend_sub_detail;
    }

    // Ajax : Request send to suggested friend from "Notification page".
    public function sendfriendAction() {
        $friend_id = (int) $this->_getParam('friend_id');
        $this->addAction($friend_id);
        $this->view->status = true;
        $this->view->responce = 'Friend Request sent';
    }

    // This is widgetized page where - we are display the mixed suggestion in the center and people you may know in right.
    public function exploreAction() {
        $this->_helper->content->render();
    }

    // Function call for "Mutual Friend Popup".
    public function mutualfriendAction() {
        $mutual_friendid_array = array();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $sugg_friend_id = $this->_getParam('sugg_friend_id');
        $friendsTable = Engine_Api::_()->getDbtable('membership', 'user');
        $friendsName = $friendsTable->info('name');

        $select = $friendsTable->select()
                ->setIntegrityCheck(false)
                ->from($friendsName, array('user_id'))
                ->join($friendsName, "`{$friendsName}`.`user_id`=`{$friendsName}_2`.user_id", null)
                ->where("`{$friendsName}`.resource_id = ?", $sugg_friend_id) // Id of Loggedin user friend.
                ->where("`{$friendsName}_2`.resource_id = ?", $user_id) // Loggedin user Id.
                ->where("`{$friendsName}`.active = ?", 1)
                ->where("`{$friendsName}_2`.active = ?", 1);
        $fetch_mutual_friend = $select->query()->fetchAll();
        if (!empty($fetch_mutual_friend)) {
            foreach ($fetch_mutual_friend as $mutual_friend_id) {
                $mutual_friendid_array[] = $mutual_friend_id['user_id'];
            }
            $this->view->friend_obj = Engine_Api::_()->suggestion()->suggestion_users_information($mutual_friendid_array, '');
        }
    }

}
