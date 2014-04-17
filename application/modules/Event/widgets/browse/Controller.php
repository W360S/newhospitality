<?php

class Event_Widget_BrowseController extends Engine_Content_Widget_Abstract {

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

    public function indexAction() {
        
        $request = Zend_Controller_Front::getInstance()->getRequest();
        
        $filter = $request->getParam('filter', 'future');
        if ($filter != 'past' && $filter != 'future'){
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
    }

}
