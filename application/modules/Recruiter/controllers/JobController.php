<?php

class Recruiter_JobController extends Core_Controller_Action_Standard {

    public function createAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        //check profile company
        $companyTable = Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $select = $companyTable->select()->where('user_id =?', Engine_Api::_()->user()->getViewer()->getIdentity());
        $profile = $companyTable->fetchRow($select);
        if (empty($profile)) {
            $this->view->profile = 0;
            return;
        }
        $this->view->profile = 1;
        $this->view->form = $form = new Recruiter_Form_Job_Create();
        // Populate options
        //industries= categories
        $categories = Engine_Api::_()->getDbtable('categories', 'recruiter')->fetchAll();
        $arr_cat_indus = array();
        if ($categories->count()) {
            foreach ($categories as $item) {
                $arr_cat_indus[$item['category_id']] = $item['name'];
            }
        }
        //$this->view->arr_cats= $arr_cat;
        $form->categories->addMultiOptions($arr_cat_indus);
        //carrer
        $industries = Engine_Api::_()->getDbtable('industries', 'recruiter')->fetchAll();
        $arr_cat = array();
        if ($industries->count()) {
            foreach ($industries as $item) {
                $arr_cat[$item['industry_id']] = $item['name'];
            }
        }
        //$this->view->arr_cats= $arr_cat;
        $form->industries->addMultiOptions($arr_cat);

        //contact via
        $contacts = Engine_Api::_()->getDbtable('contacts', 'recruiter')->fetchAll();
        $arr_contact_via = array();
        if ($contacts->count()) {
            foreach ($contacts as $item) {
                $arr_contact_via[$item['contact_id']] = $item['name'];
            }
        }
        $form->contact_via->addMultiOptions($arr_contact_via);

        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries = $countryTable->fetchAll();
        foreach ($countries as $country) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        $country_id = $countries[0]->country_id;

        //if no country then???, so city???
        //City init

        $cities = Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        foreach ($cities as $city) {
            $form->city_id->addMultiOption($city->city_id, $city->name);
        }
        //types
        $types = Engine_Api::_()->getDbtable('types', 'recruiter')->fetchAll();
        $arr_type = array();
        if ($types->count()) {
            foreach ($types as $item) {
                $arr_type[$item['type_id']] = $item['name'];
            }
        }


        $form->types->addMultiOptions($arr_type);
        //degree level
        $levelDegreeTable = Engine_Api::_()->getDbtable('degrees', 'resumes');
        foreach ($levelDegreeTable->fetchAll() as $level) {
            $form->degree_id->addMultiOption($level->degree_id, $level->name);
        }

        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();

        if ($this->getRequest()->isPost() && $form->isValid($this->getRequest()->getPost())) {
            //Zend_Debug::dump($this->getRequest()->getPost());exit;
            $db = Engine_Api::_()->getDbtable('jobs', 'recruiter')->getAdapter();
            $db->beginTransaction();

            try {
                // Create book
                $viewer = Engine_Api::_()->user()->getViewer();
                $table = $this->_helper->api()->getDbtable('jobs', 'recruiter');
                $recruiter = $table->createRow();
                $values = $form->getValues();
                $arr_industry = $values["industries"];
                $data = array(
                    "position" => $values['position'],
                    "user_id" => Engine_Api::_()->user()->getViewer()->getIdentity(),
                    "num" => $values['num'],
                    "year_experience" => $values['year_experience'],
                    "country_id" => $values['country_id'],
                    "city_id" => $values['city_id'],
                    "description" => $values['description'],
                    "skill" => $values['skill'],
                    "salary" => $values['salary'],
                    "deadline" => $values['deadline'],
                    "contact_name" => $values['contact_name'],
                    "contact_address" => $values['contact_address'],
                    "contact_phone" => $values['contact_phone'],
                    "contact_email" => $values['contact_email'],
                    "creation_date" => date('Y-m-d H:i:s'),
                    "modified_date" => date('Y-m-d H:i:s'),
                    "status" => 1,
                    "num_apply" => 0,
                    "view_count" => 0,
                    "reject" => 0,
                    "code" => "JOB" . "-" . time(),
                    "degree_id" => $values['degree_id']
                );

                $recruiter->setFromArray($data);
                $result_recruiter = $recruiter->save();
                // Add carrer
                Engine_Api::_()->getApi('job', 'recruiter')->createIndustries($values["industries"], $result_recruiter);
                //Add industries
                Engine_Api::_()->getApi('job', 'recruiter')->createCategories($values["categories"], $result_recruiter);
                //Add contact via
                if (count($values["contact_via"])) {
                    Engine_Api::_()->getApi('job', 'recruiter')->createContacts($values["contact_via"], $result_recruiter);
                }
                //Add type
                Engine_Api::_()->getApi('job', 'recruiter')->createTypes($values["types"], $result_recruiter);
                // Commit
                $db->commit();

                $link = 'http://'
                        . $_SERVER['HTTP_HOST']
                        . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'recruiter',
                            'controller' => 'job',
                            'action' => 'view-job',
                            'id' => $recruiter->job_id
                                ), 'default', true);
                $link = "<h2><a href='{$link}'>Click to view detail job.</a></h2>";
                $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                $from = $user_data['email'];
                $from_name = $user_data['displayname'];

                $content = "Please wait admin approve your job.";

                $body = $content;
                $html = <<<EOF
            <table width="620" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:8px">
                        <tr><td bgcolor="#028eb9" style="padding: 10px;color:#fff">Hospitality.vn</td></tr>
        				<tr>
                            <td bgcolor="#E0E0E0" style="background-color: #E0E0E0; padding: 1px;">
        						<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#fff" style="background-color: #fff;padding: 0 0 25px 0">
                                    <tr><td style="padding-bottom: 10px;"><img src="application/modules/Recruiter/externals/images/logo-email.gif" width="281" height="85" alt="hospitality.vn" align="top" style="background-color: #fff; display: block; padding: 1px;" /></td></tr>
        							<tr valign="top">
                                        <td style="padding: 10px 30px;color:#4c4c4c;font-size:12px">
        									Bạn nhận được lời mời tham gia mạng nhân lực ngành du lịch khách sạn <a href="#" style="text-decoration:none;color:#028eb9">Hospitality.vn</a> từ <a href="#" style="text-decoration:none;color:#028eb9">Kevin Bui</a> Bạn có thể tham gia bằng cách click vào liên kết dưới đây:
        								</td>
                                    </tr>
        							
        							<tr>
        								<td style="padding: 10px 0;font-size:12px" align="center"><a href="#"style="text-decoration:none;color:#028eb9">http://hospitality.vn/signup/index/code/38d9bb7/email/ngocvinhxt%40mgmail.com</a></td>
        							</tr>
                                </table>
        					</td>
                        </tr>
                        <tr><td style="padding: 13px;color:#4c4c4c;font-size:12px" align="center">You are being invited to join our social network. Trân trọng, Nhóm phát triển Hospitality.vn </td></tr>
                    </table>
        		</td>
            </tr>
        </table>
EOF;
                // Main params
                $defaultParams = array(
                    'host' => $_SERVER['HTTP_HOST'],
                    'email' => $user_data->email,
                    'date' => time(),
                    'object_link' => $link,
                    'object_description' => $html
                );
                // Send
                try {
                    Engine_Api::_()->getApi('mail', 'core')->sendSystem($user_data, 'create_job', $defaultParams);
                } catch (Exception $e) {
                    // Silence exception
                }
                //thêm: gửi mail cho người được quản lý categories khi tạo job
                /*
                  + Lấy danh sách người quản lý categories.
                  + Gửi.
                 */
                $table_modules = Engine_Api::_()->getDbtable('modules', 'user');
                $arr_users = $table_modules->fetchAll(
                        $table_modules
                                ->select()
                                ->where('industry_id IN(?)', $arr_industry)
                );
                $arr_send_mail_users = array();
                if (!empty($arr_users)) {
                    foreach ($arr_users as $us) {
                        $arr_send_mail_users[$us['user_id']] = $us['user_id'];
                    }
                }
                try {
                    foreach ($arr_send_mail_users as $item) {
                        $manage_job = Engine_Api::_()->getDbtable('users', 'user')->find($item)->current();
                        // Main params
                        $defaultParams = array(
                            'host' => $_SERVER['HTTP_HOST'],
                            'email' => $manage_job->email,
                            'date' => time(),
                            'object_link' => $link,
                            'object_description' => "Please read and approve his job"
                        );
                        Engine_Api::_()->getApi('mail', 'core')->sendSystem($manage_job, 'send_mail_manage_job', $defaultParams);
                    }
                } catch (Exception $e) {
                    // Silence exception
                }
                // Redirect
                //return $this->_helper->redirector->gotoRoute(array('id' => $recruiter->getIdentity()), 'view-job', true);
                return $this->_helper->redirector->gotoRoute(array('action' => 'manage'));
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function editAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $job_id = $this->_getParam('job_id');
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        $this->view->job = $job;
        $this->view->form = $form = new Recruiter_Form_Job_Edit();
        //industries
        $categories = Engine_Api::_()->getDbtable('categories', 'recruiter')->fetchAll();
        $arr_cat_indus = array();
        if ($categories->count()) {
            foreach ($categories as $item) {
                $arr_cat_indus[$item['category_id']] = $item['name'];
            }
        }
        // set categories to element
        $form->categories->addMultiOptions($arr_cat_indus);
        // get categories
        $industries = Engine_Api::_()->getDbtable('industries', 'recruiter')->fetchAll();
        $arr_cat = array();
        if ($industries->count()) {
            foreach ($industries as $item) {
                $arr_cat[$item['industry_id']] = $item['name'];
            }
        }
        // set carrer to element
        $form->industries->addMultiOptions($arr_cat);
        //set industries- categories
        $selected_cats = Engine_Api::_()->getApi('job', 'recruiter')->getCategoryOfJob($job_id);
        $selected_arr_cats = array();
        if ($selected_cats->count()) {
            foreach ($selected_cats as $item) {
                $selected_arr_cats[$item['category_id']] = $item['category_id'];
            }
        }
        $form->categories->setValue($selected_arr_cats);
        //carrer
        $selected_categories = Engine_Api::_()->getApi('job', 'recruiter')->getIndustryOfJob($job_id);
        $selected_arr_cat = array();
        if ($selected_categories->count()) {
            foreach ($selected_categories as $item) {
                $selected_arr_cat[$item['industry_id']] = $item['industry_id'];
            }
        }
        $form->industries->setValue($selected_arr_cat);
        //types
        $types = Engine_Api::_()->getDbtable('types', 'recruiter')->fetchAll();
        $arr_type = array();
        if ($types->count()) {
            foreach ($types as $item) {
                $arr_type[$item['type_id']] = $item['name'];
            }
        }


        $form->types->addMultiOptions($arr_type);
        //set type to element
        $selected_types = Engine_Api::_()->getApi('job', 'recruiter')->getTypeOfJob($job_id);
        $selected_arr_type = array();
        if ($selected_types->count()) {
            foreach ($selected_types as $item) {
                $selected_arr_type[$item['type_id']] = $item['type_id'];
            }
        }
        $form->types->setValue($selected_arr_type);
        //contact via
        $contacts = Engine_Api::_()->getDbtable('contacts', 'recruiter')->fetchAll();
        $arr_contact_via = array();
        if ($contacts->count()) {
            foreach ($contacts as $item) {
                $arr_contact_via[$item['contact_id']] = $item['name'];
            }
        }
        $form->contact_via->addMultiOptions($arr_contact_via);
        //set contact via to element
        $selected_contacts = Engine_Api::_()->getApi('job', 'recruiter')->getContacViaOfJob($job_id);
        $selected_arr_contact = array();
        if ($selected_contacts->count()) {
            foreach ($selected_contacts as $item) {
                $selected_arr_contact[$item['contact_id']] = $item['contact_id'];
            }
        }
        $form->contact_via->setValue($selected_arr_contact);

        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries = $countryTable->fetchAll();
        foreach ($countries as $country) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        //$country_id= $countries[0]->country_id;
        $country_id = $job->country_id;

        //if no country then???, so city???
        //City init

        $cities = Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        foreach ($cities as $city) {
            $form->city_id->addMultiOption($city->city_id, $city->name);
        }
        //degree level
        //level
        $levelDegreeTable = Engine_Api::_()->getDbtable('degrees', 'resumes');
        foreach ($levelDegreeTable->fetchAll() as $level) {
            $form->degree_id->addMultiOption($level->degree_id, $level->name);
        }
        if (!Engine_Api::_()->core()->hasSubject('job')) {
            Engine_Api::_()->core()->setSubject($job);
        }

        if (!$this->_helper->requireSubject()->isValid())
            return;
        //Save entry
        if (!$this->getRequest()->isPost()) {

            /*
              $country_id= $job->country_id;
              $city_id= $job->city_id;
              $this->view->country_id= $country_id;
              $this->view->city_id= $city_id;
             */
            $form->populate($job->toArray());
            return;
        }

        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }
        // Process
        $values = $form->getValues();

        $values['status'] = 1;
        //Zend_Debug::dump($values);exit;
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        try {
            //update industries
            Engine_Api::_()->getApi('job', 'recruiter')->updateCategoriesJob($values["categories"], $job_id);
            // update carrers
            Engine_Api::_()->getApi('job', 'recruiter')->updateIndustriesJob($values["industries"], $job_id);
            //update types
            Engine_Api::_()->getApi('job', 'recruiter')->updateTypesJob($values["types"], $job_id);
            //update contact vias
            Engine_Api::_()->getApi('job', 'recruiter')->updateContactViasJob($values["types"], $job_id);
            $job->setFromArray($values);

            $job->save();
            $db->commit();

            return $this->_helper->redirector->gotoRoute(array('action' => 'manage', 'job_id' => null));
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    //manage job
    public function manageAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user = Engine_Api::_()->user()->getViewer();

        $table = Engine_Api::_()->getItemTable('job');
        $select = $table->select()->where('user_id = ?', $user->getIdentity())
                ->order('creation_date DESC')
                ->order('num_apply DESC')
        ;
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //view job 
    public function viewJobAction() {
        //if( !$this->_helper->requireUser()->isValid() ) return;

        $job_id = $this->_getParam('id');
        //thiết lập title for page
        $subject = null;
        if (!Engine_Api::_()->core()->hasSubject()) {
            $subject = Engine_Api::_()->getItem('recruiter_job', $job_id);
            if ($subject && $subject->getIdentity()) {
                Engine_Api::_()->core()->setSubject($subject);
            }
        }
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $this->view->user_id = $user_id;
        //$job = Engine_Api::_()->getItem('job', $job_id);
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        //categories
        $categories = Engine_Api::_()->getApi('job', 'recruiter')->getJobCategories($job_id);
        $this->view->categories = $categories;

        //carrer
        $industries = Engine_Api::_()->getApi('job', 'recruiter')->getJobIndustries($job_id);
        $this->view->industries = $industries;

        $this->view->job = $job;
        $contact_vias = Engine_Api::_()->getApi('job', 'recruiter')->getJobContacts($job_id);
        //Zend_Debug::dump($contact_vias);exit;
        $this->view->contact_vias = $contact_vias;
        //type
        $types = Engine_Api::_()->getApi('job', 'recruiter')->getJobTypes($job_id);
        //Zend_Debug::dump($types);exit;
        $this->view->types = $types;
        //$user_id= Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($user_id != $job->user_id) {
            $job->view_count +=1;
            $job->save();
        }
        $this->_helper->content
                ->setContentName(40) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //delete job
    public function deleteJobAction() {
        if ($this->_request->isXmlHttpRequest()) {
            $job_id = $this->getRequest()->getPost('job_id');

            $result = Engine_Api::_()->getApi('job', 'recruiter')->deleteJob($job_id);
            echo $result;
            exit;
        }
    }

    //save job
    public function saveJobAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $job_id = $this->_getParam('job_id');
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if (!empty($job_id)) {

            //check job saved?
            $check = Engine_Api::_()->getApi('job', 'recruiter')->CheckJobSaved($job_id, $user_id);
            if ($check == 0) {
                //check job applied
                $ck = Engine_Api::_()->getApi('job', 'recruiter')->CheckJobApplied($job_id, $user_id);
                if ($ck == 0) {
                    //not yet applied
                    Engine_Api::_()->getApi('job', 'recruiter')->SaveJob($job_id, $user_id, 0);
                } else {
                    Engine_Api::_()->getApi('job', 'recruiter')->SaveJob($job_id, $user_id, 1);
                }
            }
        }
        //display job save

        $rows = Engine_Api::_()->getApi('job', 'recruiter')->ListJobSave($user_id);
        if (count($rows) > 0) {
            $job_ids = array();
            foreach ($rows as $row) {
                $job_ids[$row['job_id']] = $row['job_id'];
            }

            $table = Engine_Api::_()->getItemTable('job');
            $select = $table->select()->where('job_id IN(?)', $job_ids);
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(20);
            $paginator->setCurrentPageNumber($page);
            $this->view->viewer_id = $user_id;
        }
    }

    //delete jobs saved
    public function deleteselectedAction() {
        $this->view->ids = $ids = $this->_getParam('ids', null);
        $confirm = $this->_getParam('confirm', false);
        $this->view->count = count(explode(",", $ids));
        $ids_array = explode(",", $ids);
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->getRequest()->isPost() && $confirm == true) {
            $ids_array = explode(",", $ids);
            foreach ($ids_array as $id) {
                $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
                $select = $table->select()
                        ->where('user_id = ?', $user_id)
                        ->where('job_id = ?', $id);
                $savejob = $table->fetchRow($select);
                if ($savejob) {
                    $savejob->delete();
                }
            }
            $this->_helper->redirector->gotoRoute(array('action' => 'save-job', 'job_id' => null));
        }
    }

    //apply job
    public function applyJobAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $job_id = $this->_getParam('job_id');
        //check if applied job
        $table = $this->_helper->api()->getDbtable('applyJobs', 'recruiter');
        $select = $table->select()
                ->where('user_id =?', $user_id)
                ->where('job_id =?', $job_id);
        $row = $table->fetchRow($select);
        if (count($row) > 0) {
            $this->view->check = true;
        } else {


            //create form
            $this->view->form = $form = new Recruiter_Form_Job_Apply();
            $tableResume = Engine_Api::_()->getDbtable('resumes', 'resumes');
            $selectResume = $tableResume->select()
                    ->where('user_id=?', $user_id)
                    ->where('approved =?', 1);
            $resumes = $tableResume->fetchAll($selectResume);
            $arr_cat = array();
            if ($resumes->count()) {
                foreach ($resumes as $item) {
                    $arr_cat[$item['resume_id']] = $item['title'];
                }
            }
            $form->resume_id->addMultiOptions($arr_cat);

            if ($this->_request->isPost()) {
                $title = Engine_Api::_()->getApi('job', 'recruiter')->cleanTitle($this->getRequest()->getPost('title'));

                $html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $this->getRequest()->getPost('description'));
                $content = $html;


                $check_file = true;

                if ($_FILES['file']['size']) {

                    $adapter = new Zend_File_Transfer_Adapter_Http();
                    $adapter->addValidator('Extension', false, array('extension' => 'txt,png,pneg,jpg,jpeg,gif,doc,docx,rar', 'case' => true));
                    $check_file = $adapter->isValid();
                    /*
                      if($check_file== false){
                      echo '{"message": "extension"}';
                      exit();
                      }else{
                      if($_FILES['file']['size']>5242880){
                      echo '{"message": "file"}';
                      exit();
                      }
                      }
                     */
                    if ($_FILES['file']['size'] > 5242880) {
                        $form->addError("Size file is no more than 5Mb");
                    }
                }

                if (!empty($title) && $check_file) {

                    // process data
                    $db = Engine_Db_Table::getDefaultAdapter();
                    $db->beginTransaction();
                    try {
                        $table = $this->_helper->api()->getDbtable('applyJobs', 'recruiter');
                        $apply = $table->createRow();
                        // Add question
                        $data = array(
                            "title" => $title,
                            "content" => $content,
                            "user_id" => $user_id,
                            "creation_date" => date('Y-m-d H:i:s'),
                            "resume_id" => $this->getRequest()->getPost('resume_id'),
                            "job_id" => $job_id,
                            "rating" => 0,
                            "status" => 0
                        );

                        $apply->setFromArray($data);
                        $new_id_apply = $apply->save();
                        //increate num_apply +1;
                        $job_increate = Engine_Api::_()->getItem('job', $job_id);
                        $job_increate->num_apply +=1;
                        $job_increate->save();
                        // Add attachment
                        if ($_FILES['file']['size']) {
                            $apply->setFiles($_FILES['file']);
                            $apply->save();
                        }
                        //set status in table savejobs
                        //check if not save this job
                        $check_saved = Engine_Api::_()->getApi('job', 'recruiter')->CheckJobSaved($job_id, $user_id);
                        if ($check_saved == 1) {
                            Engine_Api::_()->getApi('job', 'recruiter')->setStatusJob($job_id, $user_id);
                        }


                        // send email to recruiter this job 

                        $link = 'http://'
                                . $_SERVER['HTTP_HOST']
                                . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                                    'module' => 'resumes',
                                    'controller' => 'resume',
                                    'action' => 'view',
                                    'resume_id' => $this->getRequest()->getPost('resume_id')
                                        ), 'default', true);
                        $link = "<h2><a href='{$link}'>Click to view detail resume.</a></h2>";

                        $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                        $from = $user_data['email'];
                        $from_name = $user_data['displayname'];
                        $subject = "[Viethospitality] (Apply job) - Someone has been applied: " . $title;

                        $body = $content;
                        $emails = array();

                        //get user create job
                        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();

                        $to_user = Engine_Api::_()->getDbtable('users', 'user')->find($job->user_id)->current();
                        $emails[] = $to_user->email;


                        //Engine_Api::_()->getApi('job', 'recruiter')->sendmail($from, $from_name, $subject, $body, $emails);

                        $db->commit();

                        // Main params
                        $defaultParams = array(
                            'host' => $_SERVER['HTTP_HOST'],
                            'email' => $to_user->email,
                            'date' => time(),
                            'object_link' => $link,
                            'object_description' => $body
                        );
                        // Send
                        try {
                            Engine_Api::_()->getApi('mail', 'core')->sendSystem($to_user, 'apply_job', $defaultParams);
                        } catch (Exception $e) {
                            // Silence exception
                        }
                        return $this->_helper->redirector->gotoRoute(array('action' => 'manage-apply', 'job_id' => NULL));
                    } catch (Exception $e) {
                        $db->rollBack();
                        throw $e;
                    }
                }
            }
        }
    }

    //manage applied job
    public function manageApplyAction() {
        $this->view->user_id = $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select = $table->select()
                ->where('user_id =?', $user_id);
        $jobapplies = $table->fetchAll($select);
        $job_ids = array();
        if (count($jobapplies) > 0) {
            foreach ($jobapplies as $jobapply) {
                $job_ids[$jobapply->applyjob_id] = $jobapply->job_id;
            }
            $tableJob = Engine_Api::_()->getItemTable('job');
            $selectJob = $tableJob->select()->where('job_id IN(?)', $job_ids)->order('creation_date DESC');
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($selectJob);

            $paginator->setItemCountPerPage(20);
            $paginator->setCurrentPageNumber($page);
        }
    }

    //delete applied job
    public function deleteApplyAction() {
        if ($this->_request->isXmlHttpRequest()) {
            $job_id = $this->getRequest()->getPost('job_id');
            $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();

            $result = Engine_Api::_()->getApi('job', 'recruiter')->deleteApplyJob($job_id, $user_id);
            echo $result;
            exit;
        }
    }

    public function candidateAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
    }

    public function addNoteAction() {
        $this->_helper->layout->disableLayout();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->_request->isXmlHttpRequest()) {
            $apply_id = $this->getRequest()->getPost('apply_id');
            $applyjob = Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($apply_id)->current();
            $description = $this->getRequest()->getPost('description');
            $applyjob->description = $description;
            $applyjob->status = 1;
            $applyjob->owner_id = $user_id;
            $applyjob->save();
            //lưu vào bảng engine4_recruiter_notes
            $db = Engine_Api::_()->getDbtable('notes', 'recruiter')->getAdapter();
            $db->beginTransaction();

            try {
                // Create book
                $viewer = Engine_Api::_()->user()->getViewer();
                $table = $this->_helper->api()->getDbtable('notes', 'recruiter');
                $recruiter = $table->createRow();
                $data = array(
                    "user_id" => $user_id,
                    "description" => $description,
                    "creation_date" => date('Y-m-d H:i:s'),
                    "modified_date" => date('Y-m-d H:i:s'),
                    "applyjob_id" => $apply_id
                );

                $recruiter->setFromArray($data);
                $recruiter->save();
                $db->commit();
                //lay du lieu ra ben view
                $select = $table->select()->where('user_id =?', $user_id)->where('applyjob_id =?', $apply_id)->order('note_id ASC');
                $notes = $table->fetchAll($select);
                $this->view->notes = $notes;
            } catch (Exception $e) {
                // Silence exception
            }
        }
    }

    public function delNoteAction() {
        $this->_helper->layout->disableLayout();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->_request->isXmlHttpRequest()) {
            $apply_id = $this->getRequest()->getPost('apply_id');
            $note_id = $this->getRequest()->getPost('note_id');

            $db = Engine_Api::_()->getDbtable('notes', 'recruiter')->getAdapter();
            $db->beginTransaction();

            try {

                $table = $this->_helper->api()->getDbtable('notes', 'recruiter');
                $note = $table->find($note_id)->current();
                $note->delete();
                $db->commit();
                //lay du lieu ra ben view
                $select = $table->select()->where('user_id =?', $user_id)->where('applyjob_id =?', $apply_id)->order('note_id ASC');
                $notes = $table->fetchAll($select);
                $this->view->notes = $notes;
            } catch (Exception $e) {
                // Silence exception
            }
        }
    }

    public function addCandidateAction() {
        $this->_helper->layout->disableLayout();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->_request->isXmlHttpRequest()) {
            $apply_id = $this->getRequest()->getPost('apply_id');
            $applyjob = Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($apply_id)->current();
            $applyjob->status = 1;
            $applyjob->owner_id = $user_id;
            $applyjob->save();
            $this->setNoRender();
        }
    }

    public function rateAction() {
        $viewer = Engine_Api::_()->user()->getViewer();
        $user_id = $viewer->getIdentity();

        $rating = $this->_getParam('rating');
        $applyjob_id = $this->_getParam('applyjob_id');


        $apply = Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($applyjob_id)->current();

        try {
            $apply->rating = $rating;
            $apply->save();
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }

        $data = array();
        $data[] = array(
            'rating' => $rating
        );
        return $this->_helper->json($data);
        $data = Zend_Json::encode($data);
        $this->getResponse()->setBody($data);
    }

    //view candidate of job
    public function viewCandidateAction() {
        $job_id = $this->_getParam('job_id');
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        $this->view->job = $job;
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $table_user = Engine_Api::_()->getDbTable('users', 'user');
        $table_experience = Engine_Api::_()->getDbTable('experiences', 'resumes');
        $select = $table
                ->select()
                //->setIntegrityCheck(false)
                //->from($table->info('name'))
                ->where($table->info('name') . ".job_id =?", $job_id)
                //->joinLeft($table_user->info('name'), $table_user->info('name'). ".user_id = ". $table->info('name') . ".user_id", array('displayname'))
                //->joinLeft($table_experience->info('name'), $table_experience->info('name'). ".resume_id = ". $table->info('name') . ".resume_id", 'SUM(num_year) AS num')
                ->order($table->info('name') . '.rating DESC')
        ;
        //Zend_Debug::dump($select->assemble());
        $this->view->paginator = $paginator = Zend_Paginator::factory($select);
        //Zend_Debug::dump(count($paginator)); exit;
        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
    }

    //delete apply job of candidate
    public function deleteApplyJobAction() {
        $applyjob_id = $this->getRequest()->getPost('applyjob_id');
        if ($this->_request->isXmlHttpRequest()) {


            $result = Engine_Api::_()->getApi('job', 'recruiter')->deleteApplyCandidate($applyjob_id);
            echo $result;
            exit;
        }
    }

    public function saveCandidateAction() {
        $owner_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $table_user = Engine_Api::_()->getDbTable('users', 'user');
        $table_experience = Engine_Api::_()->getDbTable('experiences', 'resumes');
        $select = $table
                ->select()
                ->setIntegrityCheck(false)
                ->from($table->info('name'))
                ->where($table->info('name') . ".owner_id =?", $owner_id)
                ->where($table->info('name') . ".status =?", 1)
                //->joinLeft($table_user->info('name'), $table_user->info('name'). ".user_id = ". $table->info('name') . ".user_id", array('displayname'))
                //->joinLeft($table_experience->info('name'), $table_experience->info('name'). ".resume_id = ". $table->info('name') . ".resume_id", 'SUM(num_year) AS num')
                ->order($table->info('name') . '.creation_date DESC')
                ->order($table->info('name') . '.rating DESC');
        $this->view->page = $page = $this->_getParam('page', 1);
        $this->view->paginator = $paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);

        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //delete save candidate
    public function deleteSaveCandidateAction() {
        $applyjob_id = $this->getRequest()->getPost('applyjob_id');
        if ($this->_request->isXmlHttpRequest()) {


            $result = Engine_Api::_()->getApi('job', 'recruiter')->deleteSaveCandidate($applyjob_id);
            echo $result;
            exit;
        }
    }

    //load ajax news job
    public function newsJobAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
            $select = $table->select()
                    ->from($table->info('name'))
                    ->where('status =?', 2)
                    ->where('deadline > ?', date('Y-m-d'))
                    ->limit(50)
                    ->order('creation_date DESC');
            $records = $table->fetchAll($select);
            $this->view->paginator = $paginator = Zend_Paginator::factory($records);
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($request->getParam('page'));
            $paginator->setPageRange(5);
        }
    }

    //load ajax hot job
    public function hotJobAction() {
        $this->_helper->layout->disableLayout();
        if ($this->_request->isXmlHttpRequest()) {
            $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
            $select = $table->select()
                    ->from($table->info('name'))
                    ->where('status =?', 2)
                    ->where('deadline > ?', date('Y-m-d'))
                    ->limit(50)
                    ->order('num_apply DESC');
            $records = $table->fetchAll($select);
            $this->view->paginator = $paginator = Zend_Paginator::factory($records);
            $request = Zend_Controller_Front::getInstance()->getRequest();
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($request->getParam('page'));
            $paginator->setPageRange(5);
        }
    }

    //admin view job 
    public function adminViewJobAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $job_id = $this->_getParam('id');

        //$job = Engine_Api::_()->getItem('job', $job_id);
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        $industries = Engine_Api::_()->getApi('job', 'recruiter')->getJobIndustries($job_id);
        $this->view->industries = $industries;
        $this->view->job = $job;
        $contact_vias = Engine_Api::_()->getApi('job', 'recruiter')->getJobContacts($job_id);
        //Zend_Debug::dump($contact_vias);exit;
        $this->view->contact_vias = $contact_vias;
        //type
        $types = Engine_Api::_()->getApi('job', 'recruiter')->getJobTypes($job_id);
        //Zend_Debug::dump($types);exit;
        $this->view->types = $types;
    }

    //member view applied job
    public function myApplyAction() {
        
    }

    //authoried to resolved
    public function assignAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user = Engine_Api::_()->user()->getViewer();
        //list danh sách industries công việc mà user được xử lý
        $table_module = Engine_Api::_()->getDbtable('modules', 'user');
        $select_module = $table_module->select()->where('user_id = ?', $user->getIdentity())
                ->where('name_module =?', 'job')
        ;
        $module_jobs = $table_module->fetchAll($select_module);
        $industries = array();
        foreach ($module_jobs as $job) {
            $industries[$job->module_id] = $job->industry_id;
        }
        $table_industry = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $rows = $table_industry->fetchAll(
                $table_industry
                        ->select()
                        ->where('industry_id IN(?)', $industries)
                        ->where('job_id > ?', 0)
                        ->group('job_id')
        );
        if (count($rows) > 0) {
            $job_ids = array();
            foreach ($rows as $row) {
                $job_ids[$row['job_id']] = $row['job_id'];
            }

            $table = Engine_Api::_()->getItemTable('job');
            /*
              status= 1=> Pending
              status= 2=> Active
              status= 3=> Expired
              reject= 1=>khong giai quyet
             */
            $select = $table->select()->where('job_id IN(?)', $job_ids)->where('status =?', 1)->where('reject =?', 0);
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($page);
            if (count($paginator) == 0) {
                return $this->_helper->redirector->gotoRoute(array('controller' => 'index', 'action' => 'index'));
            }
        }
    }

    //approve job
    public function approveAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $this->view->job_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $job = Engine_Api::_()->getItem('job', $id);
                $job->status = 2;
                //find user resolved
                $resolved_id = $viewer->getIdentity();
                //$resolved_by= Engine_Api::_()->getDbtable('users', 'user')->find($resolved_id)->current();
                //$resolved_name= $resolved_by->displayname;
                $job->resolved_by = $resolved_id;
                //$job->resolved_name= $resolved_name;
                //save
                $job->save();

                $db->commit();
                //gửi mail cho người tạo công việc
                $link = 'http://'
                        . $_SERVER['HTTP_HOST']
                        . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'recruiter',
                            'controller' => 'job',
                            'action' => 'view-job',
                            'id' => $job->job_id
                                ), 'default', true);
                $link = "<h2><a href='{$link}'>Click to view detail.</a></h2>";

                $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($job->user_id)->current();
                $from = $user_data['email'];
                $from_name = $user_data['displayname'];

                $content = "Your job has been approved.";

                $body = $content;
                // Main params
                $defaultParams = array(
                    'host' => $_SERVER['HTTP_HOST'],
                    'email' => $user_data->email,
                    'date' => time(),
                    'sender_title' => $user_data->displayname,
                    'object_link' => $link,
                    'object_description' => $body
                );
                // Send
                try {
                    Engine_Api::_()->getApi('mail', 'core')->sendSystem($user_data, 'approve_job', $defaultParams);
                } catch (Exception $e) {
                    // Silence exception
                }
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
        $this->renderScript('job/approve.tpl');
    }

    //reject
    public function rejectAction() {
        // In smoothbox
        $this->_helper->layout->setLayout('admin-simple');
        $id = $this->_getParam('id');
        $reason = $this->_getParam('reason_reject');
        $this->view->job_id = $id;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Check post
        if ($this->getRequest()->isPost()) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {
                $job = Engine_Api::_()->getItem('job', $id);
                $job->reject = $viewer->getIdentity();
                $job->reason = $reason;
                //lưu thông tin người reject để liệt kê trong cancelled jobs(resolved_by)
                $job->resolved_by = $viewer->getIdentity();
                $job->save();

                $db->commit();
                $link = 'http://'
                        . $_SERVER['HTTP_HOST']
                        . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                            'module' => 'recruiter',
                            'controller' => 'job',
                            'action' => 'view-job',
                            'id' => $id
                                ), 'default', true);
                $link = "<h2><a href='{$link}'>Click to view detail job.</a></h2>";
                $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
                $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
                $from = $user_data['email'];
                $from_name = $user_data['displayname'];

                $body = $reason;
                //get admin
                $tableUser = Engine_Api::_()->getDbtable('users', 'user');
                $select = $tableUser->select()
                        ->where('level_id =?', 1);
                $users = $tableUser->fetchAll($select);
                foreach ($users as $user) {
                    // Main params
                    $defaultParams = array(
                        'host' => $_SERVER['HTTP_HOST'],
                        'email' => $user->email,
                        'date' => time(),
                        'sender_title' => $user_data->displayname,
                        'object_link' => $link,
                        'object_description' => $body
                    );
                    // Send
                    try {
                        Engine_Api::_()->getApi('mail', 'core')->sendSystem($user, 'reject_job', $defaultParams);
                    } catch (Exception $e) {
                        // Silence exception
                    }
                }
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }

            $this->_forward('success', 'utility', 'core', array(
                'smoothboxClose' => true,
                'parentRefresh' => 10,
                'messages' => array('You have been reject resolve this job.')
            ));
        }
        // Output
        $this->renderScript('job/reject.tpl');
    }

    public function sendEmailAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $job_id = $this->_getParam('job_id');

        $this->view->form = $form = new Recruiter_Form_Job_Send();
        if ($this->_request->isPost()) {
            $email = $this->getRequest()->getPost('email');
            $title = Engine_Api::_()->getApi('job', 'recruiter')->cleanTitle($this->getRequest()->getPost('title'));

            $html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $this->getRequest()->getPost('description'));
            $content = $html;
            $cc_emails = $this->getRequest()->getPost('cc_email');
            $cc_email_send = array();
            $cc_email_send = explode(',', $cc_emails);
            //Zend_Debug::dump($cc_email_send);exit;
            $link = 'http://'
                    . $_SERVER['HTTP_HOST']
                    . Zend_Controller_Front::getInstance()->getRouter()->assemble(array(
                        'module' => 'recruiter',
                        'controller' => 'job',
                        'action' => 'view-job',
                        'id' => $job_id
                            ), 'default', true);
            $link = "<h2><a href='{$link}'>Click to view detail job.</a></h2>";
            $content = $content . "<br />" . $link . "<br />Best Regards,<br /> Social Network Administration";
            /*
              $user_data = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
              $from = $user_data['email'];
              $from_name = $user_data['displayname'];
              $defaultParams = array(
              'host' => $_SERVER['HTTP_HOST'],
              'email' => $email,
              'date' => time(),
              'sender_title'=> $from,
              'object_link' => $link,
              'object_description' => $content
              );
              // Send
              try {
              Engine_Api::_()->getApi('mail', 'core')->sendSystem($user_data,
              'send_mail_job', $defaultParams);
              } catch( Exception $e ) {
              // Silence exception
              }

             */
            //Cần giải quyết vấn đề send mail bên ngoài không phải của hệ thống.:). Nếu có sự thay đổi port hay thông tin thì phải change lại $config
            //require_once 'Zend/Mail/Transport/Smtp.php';
            $user = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
            $from = $user->email;
            $from_name = $user->displayname;
            // Get mail config
            $mailConfigFile = APPLICATION_PATH . '/application/settings/mail.php';
            $mailConfig = array();
            if (file_exists($mailConfigFile)) {
                $mailConfig = include $mailConfigFile;
            }
            $config = array(
                'port' => @$mailConfig['args'][1]['port'],
                'ssl' => @$mailConfig['args'][1]['ssl'],
                'auth' => 'login',
                'username' => @$mailConfig['args'][1]['username'],
                'password' => @$mailConfig['args'][1]['password']
            );

            $transport = new Zend_Mail_Transport_Smtp('smtp.gmail.com', $config);
            //$transport = new Zend_Mail_Transport_Smtp('localhost');
            $mail = new Zend_Mail('utf-8');
            //$mail->setBodyText($content);
            $mail->setBodyHtml($content);
            $mail->setFrom($from, $from_name);
            $mail->addTo($email, $email);
            //cc
            if (!empty($cc_email_send)) {
                foreach ($cc_email_send as $cc_email) {
                    $mail->addTo($cc_email, $cc_email);
                }
            }
            $mail->setSubject($title);
            $mail->send($transport);

            //cần quay trở lại trang trước đó.
            return $this->_helper->redirector->gotoRoute(array('action' => 'view-job', 'job_id' => null, 'id' => $job_id));
        }
    }

    //job tool approved
    public function jobStatusAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $user = Engine_Api::_()->user()->getViewer();
        $status = $this->_getParam('st');
        $this->view->status = $status;
        //dem so cong viec duoc giai quyet
        $table_module = Engine_Api::_()->getDbtable('modules', 'user');
        $select_module = $table_module->select()->where('user_id = ?', $user->getIdentity())
                ->where('name_module =?', 'job')
        ;
        $module_jobs = $table_module->fetchAll($select_module);
        $industries = array();
        if (count($module_jobs)) {
            foreach ($module_jobs as $job) {
                $industries[$job->module_id] = $job->industry_id;
            }
            $table_industry = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
            $rows = $table_industry->fetchAll(
                    $table_industry
                            ->select()
                            ->where('industry_id IN(?)', $industries)
                            ->where('job_id > ?', 0)
                            ->group('job_id')
            );
            if (count($rows) > 0) {
                $job_ids = array();
                foreach ($rows as $row) {
                    $job_ids[$row['job_id']] = $row['job_id'];
                }

                $table = Engine_Api::_()->getItemTable('job');
                /*
                  status= 1=> Pending
                  status= 2=> Active
                  status= 3=> Expired
                 */
                if ($status == 'approve') {
                    //jobs approved
                    $select_approved = $table->select()->where('job_id IN(?)', $job_ids)->where('resolved_by =?', $user->getIdentity())->where('status =?', 2)->where('reject =?', 0)->order('creation_date DESC');
                    $this->view->page = $page = $this->_getParam('page', 1);
                    $paginator = $this->view->paginator = Zend_Paginator::factory($select_approved);
                    $paginator->setItemCountPerPage(20);
                    $paginator->setCurrentPageNumber($page);
                } else if ($status == 'pending') {
                    $select_pending = $table->select()->where('job_id IN(?)', $job_ids)->where('status =?', 1)->where('reject =?', 0)->order('creation_date DESC');
                    $this->view->page = $page = $this->_getParam('page', 1);
                    //jobs pending
                    $paginator = $this->view->paginator = Zend_Paginator::factory($select_pending);
                    $paginator->setItemCountPerPage(20);
                    $paginator->setCurrentPageNumber($page);
                } else {
                    //jobs reject
                    $select_reject = $table->select()->where('job_id IN(?)', $job_ids)->where('reject =?', $user->getIdentity())->order('creation_date DESC');
                    $this->view->page = $page = $this->_getParam('page', 1);
                    $paginator = $this->view->paginator = Zend_Paginator::factory($select_reject);
                    $paginator->setItemCountPerPage(20);
                    $paginator->setCurrentPageNumber($page);
                }
            }
        }
    }

    //luu ung cu vien khi nha tuyen dung xem resume cua ho
    public function saveResumeAction() {
        $this->_helper->layout->disableLayout();
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id = $this->getRequest()->getPost('resume_id');
            $resume = Engine_Api::_()->getDbtable('resumes', 'resumes')->find($resume_id)->current();
            $table = $this->_helper->api()->getDbtable('candidates', 'recruiter');
            $select = $table->select()->where('resume_id =?', $resume_id)->where('user_id =?', $user_id);
            $rs = $table->fetchRow($select);
            if (count($rs) == 1) {
                //ton tai roi
                $this->view->res = 1;
            } else {
                //lưu vào bảng engine4_recruiter_notes
                $db = Engine_Api::_()->getDbtable('candidates', 'recruiter')->getAdapter();
                $db->beginTransaction();

                try {
                    // Create book
                    $viewer = Engine_Api::_()->user()->getViewer();

                    $recruiter = $table->createRow();
                    $data = array(
                        "user_id" => $user_id,
                        "per_id" => $resume->user_id,
                        "date_saved" => date('Y-m-d H:i:s'),
                        //"status"=> 1,
                        "resume_id" => $resume_id
                    );

                    $recruiter->setFromArray($data);
                    $recruiter->save();
                    $db->commit();
                    $this->view->res = 1;
                } catch (Exception $e) {
                    // Silence exception
                }
            }
        }
    }

    public function saveResumeCandidateAction() {
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $table = Engine_Api::_()->getDbtable('candidates', 'recruiter');

        $select = $table
                ->select()
                ->setIntegrityCheck(false)
                ->from($table->info('name'))
                ->where($table->info('name') . ".user_id =?", $user_id)
                //->where($table->info('name').".status =?", 1)
                ->order($table->info('name') . '.date_saved DESC');

        $this->view->page = $page = $this->_getParam('page', 1);
        $this->view->paginator = $paginator = Zend_Paginator::factory($select);
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
        
        $this->_helper->content
                ->setContentName(45) // page_id
                // ->setNoRender()
                ->setEnabled();
    }

    //delete save resume candidates
    public function deleteSaveResumeCandidateAction() {
        $candidate_id = $this->getRequest()->getPost('candidate_id');
        if ($this->_request->isXmlHttpRequest()) {


            $result = Engine_Api::_()->getApi('job', 'recruiter')->deleteSaveResumeCandidate($candidate_id);
            echo $result;
            exit;
        }
    }

}
