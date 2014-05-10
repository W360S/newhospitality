<?php

/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @version    $Id: IndexController.php 7244 2010-09-01 01:49:53Z john $
 * @author     Sami
 */

/**
 * @category   Application_Extensions
 * @package    Event
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.net/license/
 * @author     Sami
 */
class Event_IndexController extends Core_Controller_Action_Standard {

    protected $_navigation;

    public function init() {

        if (!$this->_helper->requireAuth()->setAuthParams('event', null, 'view')->isValid())
            return;

        $this->getNavigation();

        $id = $this->_getParam('event_id', $this->_getParam('id', null));
        if ($id) {
            $event = Engine_Api::_()->getItem('event', $id);
            if ($event) {
                Engine_Api::_()->core()->setSubject($event);
            }
        }
    }

    public function browseAction() {
        //Zend_Debug::dump($paginator);exit();
        $request = $this->getRequest();

        $filter = $request->getParam('filter', 'future');
        if ($filter != 'past' && $filter != 'future') {
            $filter = 'future';
        }

        $this->view->filter = $filter;

        $navigation = $this->getNavigation();
        foreach ($navigation->getPages() as $page) {
            if (($page->label == "Upcoming Events" && $filter == "future") || ($page->route == "event_past" && $filter == "past")) {
                $page->active = true;
            }
        }
        // Create form
        $this->view->formFilter = $formFilter = new Event_Form_Filter_Browse();
        $defaultValues = $formFilter->getValues();

        $viewer = Engine_Api::_()->user()->getViewer();
        if (!$viewer || !$viewer->getIdentity()) {
            $formFilter->removeElement('view');
        }

        // Populate form options
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'event');
        $select = $categoryTable->select()
                ->order('priority ASC');
        foreach ($categoryTable->fetchAll($select) as $category) {
            $formFilter->category_id->addMultiOption($category->category_id, $category->title);
        }

        // Populate form data
        //fix paginator
        $tmp = $request->getParams();
        // $tmp = $request->getAllParams();
        if (key_exists("amp;order", $tmp)) {
            $tmp["order"] = $tmp["amp;order"];
        }
        if (key_exists("amp;view", $tmp)) {
            $tmp["view"] = $tmp["amp;view"];
        }
        if (key_exists("amp;category_id", $tmp)) {
            $tmp["category_id"] = $tmp["amp;category_id"];
        }
        if ($formFilter->isValid($tmp)) {

            $this->view->formValues = $values = $formFilter->getValues();
            //Zend_Debug::dump($tmp); exit;
        } else {
            $formFilter->populate($defaultValues);
            $this->view->formValues = $values = array();
        }

        //$this->view->formValues = $values = $formFilter->getValues();
        //Zend_Debug::dump($tmp);
        // Prepare data
        $table = Engine_Api::_()->getItemTable('event');
        $tableName = $table->info('name');
        $select = $table->select()->where("search = 1");

        // Do friends only
        if ($viewer->getIdentity() && @$values['view'] == 'friends') {
            $user_list = array();
            foreach ($viewer->membership()->getMembersInfo(true) as $memberinfo) {
                $user_list[] = $memberinfo->user_id;
            }
            $select->where('user_id IN(\'' . join("', '", $user_list) . '\')');
        }
        //Zend_Debug::dump($values);
        // Do query stuff
        if (!empty($values['text'])) {
            //$db = $table->getAdapter();  

            $select->where("`{$tableName}`.title LIKE ? OR `{$tableName}`.description LIKE ? OR `{$tableName}`.host LIKE ? OR `{$tableName}`.location LIKE ?", '%' . $values['text'] . '%');
        }

        if (!empty($values['category_id'])) {

            $select->where('category_id = ?', $values['category_id']);
            $this->view->category_id = $values['category_id'];
            //Zend_Debug::dump($values['category_id']);
        }

        if (!empty($values['order'])) {
            $select->order($values['order']);
        } else {
            $select->order('creation_date DESC');
        }

        if ($filter == "past") {
            $select->where("endtime < FROM_UNIXTIME(?)", time());
        }
        //if ($filter == "future")
        else {
            $select->where("endtime > FROM_UNIXTIME(?)", time());
        }
        //echo "<pre>".$select; exit;
        //Zend_Debug::dump($values['text']); exit;
        // check to see if request is for specific user's listings
        $user_id = $request->getParam('user');
        if ($user_id)
            $params = array('user' => $user_id);

        // Other stuff
        $this->view->page = $page = $request->getParam('page', 1);

        $paginator = $this->view->paginator = Zend_Paginator::factory($select);

        $paginator->setItemCountPerPage(16);
        $paginator->setCurrentPageNumber($page);
        $this->view->text = $values['text'];

        $this->_helper->content
                ->setContentName(30) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    public function manageAction() {
        // Create form
        //if (!$this->_helper->requireAuth()->setAuthParams(null, null, 'edit')->isValid())
            //return;
        
        $this->_helper->content
                ->setContentName(30) // page_id
                // ->setNoRender()
                ->setEnabled();
        
        $this->view->formFilter = $formFilter = new Event_Form_Filter_Manage();
        $defaultValues = $formFilter->getValues();
        // Populate form options
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'event');
        $select = $categoryTable->select()
                ->order('priority ASC');
        foreach ($categoryTable->fetchAll($select) as $category) {
            $formFilter->category_id->addMultiOption($category->category_id, $category->title);
        }
        // Populate form data

        $tmp = $this->_getAllParams();
        if (key_exists("amp;category_id", $tmp)) {
            $tmp["category_id"] = $tmp["amp;category_id"];
        }
        if (key_exists("amp;view", $tmp)) {
            $tmp["view"] = $tmp["amp;view"];
        }
        if (key_exists("amp;text", $tmp)) {
            $tmp["text"] = $tmp["amp;text"];
        }
        $values['text'] = $tmp['text'];
        $values['view'] = $tmp['view'];
        $values['category_id'] = $tmp['category_id'];


        if ($formFilter->isValid($this->_getAllParams())) {
            $formValues = $formFilter->getValues();
        } else {
            $formFilter->populate($defaultValues);
            $formValues = array();
        }
        //$values['category_id']= $values['category_id'];

        $viewer = $this->_helper->api()->user()->getViewer();
        $table = $this->_helper->api()->getDbtable('events', 'event');
        $tableName = $table->info('name');
        //zend_Debug::dump($viewer); exit;
        // Only mine

        if (@$values['view'] == 2) {
            $select = $table->select()
                    ->where('user_id = ?', $viewer->getIdentity());
        } else {
            $membership = Engine_Api::_()->getDbtable('membership', 'event');
            $select = $membership->getMembershipsOfSelect($viewer);
        }

        if (!empty($values['category_id'])) {
            $select->where('category_id = ?', $values['category_id']);
            //$this->view->category_id= $values['category_id'];
        }

        if (!empty($values)) {
            $select->where("`{$tableName}`.title LIKE ? OR `{$tableName}`.description LIKE ? OR `{$tableName}`.host LIKE ? OR `{$tableName}`.location LIKE ?", '%' . $values['text'] . '%');
        }
        $select->order('creation_date DESC');
        //Zend_Debug::dump($values); exit;
        //echo "<pre>".$select; exit;
        $this->view->paginator = $paginator = Zend_Paginator::factory($select);
        $this->view->text = $values['text'];
        $this->view->view = $values['view'];
        //$this->view->category_id= $values['category_id'];

        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($this->_getParam('page'));
        $this->view->formValues = $values;
    }

    public function createAction() {
        if (!$this->_helper->requireUser->isValid())
            return;
        if (!$this->_helper->requireAuth()->setAuthParams('event', null, 'create')->isValid())
            return;

        $viewer = Engine_Api::_()->user()->getViewer();
        $parent_type = $this->_getParam('parent_type');
        $parent_id = $this->_getParam('parent_id', $this->_getParam('subject_id'));

        if ($parent_type == 'group' && Engine_Api::_()->hasItemType('group')) {
            $group = Engine_Api::_()->getItem('group', $parent_id);
            if (!$this->_helper->requireAuth()->setAuthParams($group, null, 'edit')->isValid()) {
                return;
            }
        } else {
            $parent_type = 'user';
            $parent_id = $viewer->getIdentity();
        }

        // Create form
        $this->view->form = $form = new Event_Form_Create(array(
            'parent_type' => $parent_type,
            'parent_id' => $parent_id
        ));

        // Populate form options
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'event');
        foreach ($categoryTable->fetchAll() as $category) {
            $form->category_id->addMultiOption($category->category_id, $category->title);
        }

        $this->_helper->content
                ->setContentName(32) // page_id
                // ->setNoRender()
                ->setEnabled();

        // Not post/invalid
        if (!$this->getRequest()->isPost()) {
            return;
        }
        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }


        // Process
        $values = $form->getValues();
        $values['user_id'] = $viewer->getIdentity();
        $values['parent_type'] = $parent_type;
        $values['parent_id'] = $parent_id;
        // Convert times
        //$oldTz = date_default_timezone_get();
        //date_default_timezone_set($viewer->timezone);
        $start = strtotime($values['starttime']);
        $end = strtotime($values['endtime']);
        //date_default_timezone_set($oldTz);
        //$start = strtotime($values['starttime']);
        //$end = strtotime($values['endtime']);
        if ($start == false || $end == false) {
            $form->addError("Start date or End date does not empty");
            return;
        }

        if ($start > $end) {
            $form->addError("Start date must be less than end date");
            return;
        }
        $values['starttime'] = date('Y-m-d H:i:s', $start);
        $values['endtime'] = date('Y-m-d H:i:s', $end);
        if ($parent_type == 'group' && Engine_Api::_()->hasItemType('group') && empty($values['host'])) {
            $values['host'] = $group->getTitle();
        }

        $db = Engine_Api::_()->getDbtable('events', 'event')->getAdapter();
        $db->beginTransaction();

        try {
            // Create event
            $table = $this->_helper->api()->getDbtable('events', 'event');
            $event = $table->createRow();

            $event->setFromArray($values);
            $event->save();

            // Add owner as member
            $event->membership()->addMember($viewer)
                    ->setUserApproved($viewer)
                    ->setResourceApproved($viewer);

            // Add owner rsvp
            $event->membership()
                    ->getMemberInfo($viewer)
                    ->setFromArray(array('rsvp' => 2))
                    ->save();

            // Add photo
            if (!empty($values['photo'])) {
                $event->setPhoto($form->photo);
            }

            // Set auth
            $auth = Engine_Api::_()->authorization()->context;

            if ($values['parent_type'] == 'group') {
                $roles = array('owner', 'member', 'parent_member', 'registered', 'everyone');
            } else {
                $roles = array('owner', 'member', 'owner_member', 'owner_member_member', 'owner_network', 'registered', 'everyone');
            }

            $viewMax = array_search($values['auth_view'], $roles);
            $commentMax = array_search($values['auth_comment'], $roles);
            $photoMax = array_search($values['auth_photo'], $roles);

            foreach ($roles as $i => $role) {
                $auth->setAllowed($event, $role, 'view', ($i <= $viewMax));
                $auth->setAllowed($event, $role, 'comment', ($i <= $commentMax));
                $auth->setAllowed($event, $role, 'photo', ($i <= $photoMax));
            }

            $auth->setAllowed($event, 'member', 'invite', $values['auth_invite']);

            // Add an entry for member_requested
            $auth->setAllowed($event, 'member_requested', 'view', 1);

            // Add action
            $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');

            $action = $activityApi->addActivity($viewer, $event, 'event_create');
            $activityApi->attachActivity($action, $event);

            // Commit
            $db->commit();

            // Redirect
            return $this->_helper->redirector->gotoRoute(array('id' => $event->getIdentity()), 'event_profile', true);
        } catch (Engine_Image_Exception $e) {
            $db->rollBack();
            $form->addError(Zend_Registry::get('Zend_Translate')->_('The image you selected was too large.'));
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    public function editAction() {
        if (!$this->_helper->requireUser->isValid())
            return;

        // Create form
        if (!($this->_helper->requireAuth()->setAuthParams(null, null, 'edit')->isValid() || $event->isOwner($viewer)))
            return;


        $this->view->form = $form = new Event_Form_Create(Array('event_id' => $event_id));

        $form->setAction(Zend_Controller_Front::getInstance()->getRouter()->assemble(array('action' => 'edit'), 'event_general'));

        if ($this->getRequest()->isPost()) {

            $form->isValid($this->getRequest()->getParams());
            $values = $form->getValues();
            $event->setFromArray($values);
            $event->save();

            if (!empty($values['photo'])) {
                $event->setPhoto($form->photo);
            }
            return $this->_helper->redirector->gotoRoute(array('id' => $event_id), 'event_profile', true);
        }
    }

    public function viewAction() {
        $this->view->event = $event = Engine_Api::_()->core()->getSubject();
        if (!$this->_helper->requireAuth()->setAuthParams($event, null, 'view')->isValid())
            return;


        $event_id = $this->view->event_id = $this->getRequest()->getParam('id');
    }

    public function leaveAction() {
        // Check auth
        if (!$this->_helper->requireUser()->isValid())
            return;
        if (!$this->_helper->requireSubject()->isValid())
            return;

        // Make form
        $this->view->form = $form = new Event_Form_Leave();

        // Process form
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            $viewer = $this->_helper->api()->user()->getViewer();
            $subject = $this->_helper->api()->core()->getSubject();
            $db = $subject->membership()->getReceiver()->getTable()->getAdapter();
            $db->beginTransaction();

            try {
                $subject->membership()->removeMember($viewer);
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            return $this->_forward('success', 'utility', 'core', array(
                        'messages' => array(Zend_Registry::get('Zend_Translate')->_('Event left')),
                        'layout' => 'default-simple',
                        'smoothboxClose' => true,
                        'parentRefresh' => true
            ));
        }
    }

    public function getNavigation($filter = false) {
        $this->view->navigation = $navigation = new Zend_Navigation();
        $navigation->addPages(array(
            array(
                'label' => "Upcoming Events",
                'route' => 'event_general',
            ),
            array(
                'label' => "Past Events",
                'route' => 'event_past'
        )));


        $viewer = Engine_Api::_()->user()->getViewer();
        if ($viewer->getIdentity()) {
            $navigation->addPages(array(
                array(
                    'label' => 'My Events',
                    'route' => 'event_general',
                    'action' => 'manage',
                    'controller' => 'index',
                    'module' => 'event'
                ),
                array(
                    'label' => 'Create New Event',
                    'route' => 'event_general',
                    'action' => 'create',
                    'controller' => 'index',
                    'module' => 'event'
            )));
        }
        return $navigation;
    }

    public function getuser() {
        // Get table info
        $table = Engine_Api::_()->getItemTable('user');
        $userTableName = $table->info('name');

        $user_id = Engine_Api::_()->getItem('blog', $this->_getParam('user_id'));

        // Contruct query
        $select = $table->select()
                ->from($userTableName)
                ->where("{$userTableName}.enabled = ?", 1)
                ->where("{$userTableName}.id = ?", $user_id)
                ->order("{$userTableName}.displayname ASC");



        // Build paginator
        $paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(10);
        $paginator->setPageRange(10);
        $paginator->setCurrentPageNumber($page);

        return true;
    }

}
