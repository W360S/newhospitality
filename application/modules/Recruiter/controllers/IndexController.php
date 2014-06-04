<?php

class Recruiter_IndexController extends Core_Controller_Action_Standard {

    public function indexAction() {
        $this->view->someVar = 'someVal';

        $this->_helper->content
                ->setContentName(44) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    public function createProfileAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $this->view->form = $form = new Recruiter_Form_Profile_Create();
        // Populate options
        $industries = Engine_Api::_()->getDbtable('categories', 'recruiter')->fetchAll();
        $arr_cat = array();
        if ($industries->count()) {
            foreach ($industries as $item) {
                $arr_cat[$item['category_id']] = $item['name'];
            }
        }
        // set categories to element
        $form->industries->addMultiOptions($arr_cat);
        
        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();
        
        // If not post or form not valid, return
        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            $db = Engine_Api::_()->getDbtable('recruiters', 'recruiter')->getAdapter();
            $db->beginTransaction();

            try {
                // Create book
                $viewer = Engine_Api::_()->user()->getViewer();
                $table = $this->_helper->api()->getDbtable('recruiters', 'recruiter');
                $recruiter = $table->createRow();
                $values = $form->getValues();

                //Zend_Debug::dump($_FILES['url']['type']); exit();


                $data = array(
                    "company_name" => $values['company_name'],
                    "user_id" => Engine_Api::_()->user()->getViewer()->getIdentity(),
                    "company_size" => $values['company_size'],
                    "address" => $values['address'],
                    "website" => $values['website'],
                    "phone" => $values['phone'],
                    "description" => $values['description'],
                    "creation_date" => date('Y-m-d H:i:s'),
                    "modified_date" => date('Y-m-d H:i:s'),
                    "code" => "PRCP" . "-" . time()
                );

                $recruiter->setFromArray($data);
                $result_recruiter = $recruiter->save();
                //end save form book
                // Add photo
                if (!empty($values['logo'])) {
                    $recruiter->setPhotos($form->logo);
                    $recruiter->save();
                }

                // Add industries
                Engine_Api::_()->recruiter()->createIndustries($values["industries"], $result_recruiter);

                // Commit
                $db->commit();

                // Redirect
                return $this->_helper->redirector->gotoRoute(array('id' => $recruiter->getIdentity()), 'view-profile', true);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function viewProfileAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $profile_id = $this->_getParam('id');
        //thiết lập title for page
        $subject = null;
        if (!Engine_Api::_()->core()->hasSubject()) {
            $subject = Engine_Api::_()->getItem('recruiter', $profile_id);
            if ($subject && $subject->getIdentity()) {
                Engine_Api::_()->core()->setSubject($subject);
            }
        }
        $profile = Engine_Api::_()->getItem('recruiter', $profile_id);
        $industries = Engine_Api::_()->getApi('core', 'recruiter')->getIndustries($profile_id);
        $this->view->industries = $industries;
        $this->view->profile = $profile;
        $this->view->user_id = $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        //Zend_Debug::dump($profile_id);exit;
        //liet ke danh sach cong viec cua cong ty
        $table = Engine_Api::_()->getItemTable('job');
        $db = $table->getAdapter();
        $rName = $table->info('name');
        $select = $table->select()
                ->where('status =?', 2)
                ->where('deadline >?', date('Y-m-d H:i:s'))
                ->where('user_id =?', $profile->user_id)
                ->order('creation_date DESC')
        ;

        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator_jobs = Zend_Paginator::factory($select);

        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
        
        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    public function editProfileAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $this->view->form = $form = new Recruiter_Form_Profile_Edit();
        $this->view->profile_id = $profile_id = $this->_getParam('profile_id');

        // get categories
        $industries = Engine_Api::_()->getDbtable('categories', 'recruiter')->fetchAll();
        $arr_cat = array();
        if ($industries->count()) {
            foreach ($industries as $item) {
                $arr_cat[$item['category_id']] = $item['name'];
            }
        }
        // set categories to element
        $form->industries->addMultiOptions($arr_cat);

        $selected_categories = Engine_Api::_()->getApi('core', 'recruiter')->getIndustryOfProfile($profile_id);
        $selected_arr_cat = array();
        if ($selected_categories->count()) {
            foreach ($selected_categories as $item) {
                $selected_arr_cat[$item['industry_id']] = $item['industry_id'];
            }
        }
        $form->industries->setValue($selected_arr_cat);

        $recruiter = Engine_Api::_()->getDbtable('recruiters', 'recruiter')->find($profile_id)->current();

        if (!Engine_Api::_()->core()->hasSubject('recruiter')) {
            Engine_Api::_()->core()->setSubject($recruiter);
        }

        if (!$this->_helper->requireSubject()->isValid())
            return;
        
        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();

        //Save entry
        if (!$this->getRequest()->isPost()) {
            // etc
            $form->populate($recruiter->toArray());
            return;
        }

        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }

        // Process
        $values = $form->getValues();

        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try {
            // update categories
            Engine_Api::_()->getApi('core', 'recruiter')->updateIndustries($values["industries"], $profile_id);

            // update photo
            if (!empty($values['logo'])) {
                // get old data
                $old_photo_data = Engine_Api::_()->getDbtable('files', 'storage')->listAllPhoto($recruiter->photo_id);
                Engine_Api::_()->getApi('core', 'recruiter')->deleteImages($old_photo_data);

                $recruiter->setPhotos($form->logo);
            }


            $recruiter->setFromArray($values);

            $recruiter->save();
            $db->commit();
            return $this->_helper->redirector->gotoRoute(array('id' => $recruiter->getIdentity()), 'view-profile', true);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    public function deleteProfileAction() {
        if ($this->_request->isXmlHttpRequest()) {
            $profile_id = $this->getRequest()->getPost('profile_id');
            $result = Engine_Api::_()->getApi('core', 'recruiter')->deleteProfile($profile_id);
            echo $result;
            exit;
        }
    }

    public function employerAction() {
        
    }

    //list all articals
    public function articleAction() {
        $table = Engine_Api::_()->getDbtable('articals', 'recruiter');
        $select = $table->select()->order('created DESC');
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
    }

    //view artical
    public function viewArticleAction() {
        $artical_id = $this->_getParam('id');
        $artical = Engine_Api::_()->getItem('artical', $artical_id);

        $this->view->artical = $artical;
        // get other articals
        $other_news = Engine_Api::_()->getApi('job', 'recruiter')->getOtherArticals($artical_id, $artical->category_id);


        $this->view->other_old_articals = $other_news['old'];
        $this->view->other_new_articals = $other_news['new'];
        //Zend_Debug::dump($other_news['new']);exit;
    }

    public function companyAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            //get user_id has many candidate applied
            $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
            $select = $table->select()
                    ->order('num_apply DESC')
                    ->group('user_id')
            ;
            $jobs = $table->fetchAll($select);
            $user_ids = array();
            if (count($jobs)) {
                foreach ($jobs as $job) {
                    $user_ids[$job->user_id] = $job->user_id;
                }
            }
            //get company
            $tbCompany = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
            $sl = $tbCompany->select()
                    ->where('user_id IN(?)', $user_ids)
            ;
            //$profiles= $tbCompany->fetchAll($sl);
            $this->view->profiles = $profiles = Zend_Paginator::factory($sl);
            if (count($profiles) < 0) {
                $this->setNoRender();
            }
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $profiles->setItemCountPerPage(20);
            $profiles->setCurrentPageNumber($request->getParam('page'));
            $profiles->setPageRange(5);
        }
    }

    public function searchAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $search = $request->getParam('search');
            $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
            $select = $table->select()
                    ->order('num_apply DESC')
                    ->group('user_id')
            ;
            $jobs = $table->fetchAll($select);
            $user_ids = array();
            if (count($jobs)) {
                foreach ($jobs as $job) {
                    $user_ids[$job->user_id] = $job->user_id;
                }
            }
            //get company
            $tbCompany = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
            $sl = $tbCompany->select()
                    ->where('user_id IN(?)', $user_ids)
                    ->where("company_name LIKE ?", '%' . $search . '%');
            ;
            //$profiles= $tbCompany->fetchAll($sl);
            $this->view->profiles = $profiles = Zend_Paginator::factory($sl);
            $a = count($profiles);
            /*
              if(count($profiles)< 0){
              $this->setNoRender();
              }
             */
            $this->view->page = $page = $this->_getParam('page', 1);

            //Zend_Debug::dump($paginator);exit;
            $profiles->setItemCountPerPage(20);
            $profiles->setCurrentPageNumber($page);
        }
    }

    public function ajaxAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $search = $request->getParam('search');

            $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
            $select = $table->select()
                    ->order('num_apply DESC')
                    ->group('user_id')
            ;
            $jobs = $table->fetchAll($select);
            $user_ids = array();
            if (count($jobs)) {
                foreach ($jobs as $job) {
                    $user_ids[$job->user_id] = $job->user_id;
                }
            }
            //get company
            $tbCompany = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
            $sl = $tbCompany->select()
                    ->where('user_id IN(?)', $user_ids)
                    ->where("company_name LIKE ?", '%' . $search . '%');
            ;
            //$profiles= $tbCompany->fetchAll($sl);
            $this->view->profiles = $profiles = Zend_Paginator::factory($sl);
            /*
              if(count($profiles)< 0){
              $this->setNoRender();
              }
             */
            //$request = Zend_Controller_Front::getInstance()->getRequest();
            $profiles->setItemCountPerPage(20);
            $profiles->setCurrentPageNumber($request->getParam('page'));
            $profiles->setPageRange(5);
        }
    }

}
