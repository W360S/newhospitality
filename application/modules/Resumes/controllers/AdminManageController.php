<?php

class Resumes_AdminManageController extends Core_Controller_Action_Admin {

    public function indexAction() {

        $this->view->navigation = $navigation = Engine_Api::_()->getApi('menus', 'core')
                ->getNavigation('resume_admin_main', array(), 'resume_admin_main_manage');
        $table = Engine_Api::_()->getDbtable('resumes', 'resumes');
        $select = $table->select()->order('creation_date DESC');
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($page);
    }

    public function deleteAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->resume_id = $id;
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                //delete skill other if exist
                Engine_Api::_()->getApi('core', 'resumes')->deleteSkillOther($id);
                //delelte skill language
                Engine_Api::_()->getApi('core', 'resumes')->deleteSkillLanguage($id);
                //delete reference
                Engine_Api::_()->getApi('core', 'resumes')->deleteReference($id);
                //delete Education
                Engine_Api::_()->getApi('core', 'resumes')->deleteEducation($id);
                //delete Experience
                Engine_Api::_()->getApi('core', 'resumes')->deleteExperience($id);
                //delete search
                Engine_Api::_()->getApi('core', 'resumes')->deleteSearch($id);
                //delete job if applied
                Engine_Api::_()->getApi('core', 'resumes')->deleteJobApplied($id);
                //delete resume
                Engine_Api::_()->getApi('core', 'resumes')->deleteResume($id);

                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('')
            ));
        }
        // Output
        $this->renderScript('admin-manage/delete.tpl');
    }

    public function deleteselectedAction() {
        $this->view->ids = $ids = $this->_getParam('ids', null);
        $confirm = $this->_getParam('confirm', false);
        $this->view->count = count(explode(",", $ids));

        // Save values
        if ($this->getRequest()->isPost() && $confirm == true) {
            $ids_array = explode(",", $ids);
            foreach ($ids_array as $id) {

                //delete skill other if exist
                Engine_Api::_()->getApi('core', 'resumes')->deleteSkillOther($id);
                //delelte skill language
                Engine_Api::_()->getApi('core', 'resumes')->deleteSkillLanguage($id);
                //delete reference
                Engine_Api::_()->getApi('core', 'resumes')->deleteReference($id);
                //delete Education
                Engine_Api::_()->getApi('core', 'resumes')->deleteEducation($id);
                //delete Experience
                Engine_Api::_()->getApi('core', 'resumes')->deleteExperience($id);
                //delete search
                Engine_Api::_()->getApi('core', 'resumes')->deleteSearch($id);
                //delete job if applied
                Engine_Api::_()->getApi('core', 'resumes')->deleteJobApplied($id);
                //delete resume
                Engine_Api::_()->getApi('core', 'resumes')->deleteResume($id);
            }

            $this->_helper->redirector->gotoRoute(array('action' => 'index'));
        }
    }

    public function approveAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->resume_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $resume = Engine_Api::_()->getItem('resume', $id);
                $resume->approved = 1;
                $resume->resolved_by = $viewer->getIdentity(); //luu nguoi approved
                $resume->save();
                
                $owner = Engine_Api::_()->getApi('core', 'user')->getUser($resume->user_id);
                
                // Add action
                $activityApi = Engine_Api::_()->getDbtable('actions', 'activity');
                $action = $activityApi->addActivity($owner, $resume, 'resume_create');
                if ($action) {
                    $activityApi->attachActivity($action, $resume);
                }else{
                    
                }

                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => 10,
                'parentRefresh' => 10,
                'messages' => array('Approve Success')
            ));
        }
        // Output
        $this->renderScript('admin-manage/approve.tpl');
    }

}
