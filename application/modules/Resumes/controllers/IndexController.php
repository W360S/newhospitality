<?php

class Resumes_IndexController extends Core_Controller_Action_Standard {

    public function indexAction() {

        //Zend_Debug::dump(111); exit;

        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select = $table->select()
                ->from($table->info('name'))
                ->where('status =?', 2)
//                        ->where('deadline > ?', date('Y-m-d'))
                ->limit(50)
                ->order('creation_date DESC');
        $records = $table->fetchAll($select);
        $this->view->paginator = $paginator = Zend_Paginator::factory($records);
        $request = Zend_Controller_Front::getInstance()->getRequest();
        $paginator->setItemCountPerPage(10);
        $paginator->setCurrentPageNumber($request->getParam('page'));
        $paginator->setPageRange(5);

        $this->_helper->content
                ->setContentName(36) // page_id
                // ->setNoRender()
                ->setEnabled();
        // $this->_helper->content->render();
    }

    public function resumeInfoAction() {

        if (!$this->_helper->requireUser()->isValid())
            return;
        $user = Engine_Api::_()->user()->getViewer();
        //check number resume created <=3
        $num_resume = Engine_Api::_()->getApi('core', 'resumes')->getListResume($user->user_id);
        $this->view->num_resume = $num_resume;

        $this->_helper->content
                ->setContentName(41) // page_id
                // ->setNoRender()
                ->setEnabled();
        
        if (!$this->getRequest()->isPost()) {
            return;
        }

        $title = $this->getRequest()->getPost('resume_title');
        $searchable = $this->getRequest()->getPost('searchable');

        //database
        $db = Engine_Api::_()->getDbtable('resumes', 'resumes')->getAdapter();
        $db->beginTransaction();
        try {
            // Create event
            $table = $this->_helper->api()->getDbtable('resumes', 'resumes');
            $resume = $table->createRow();

            $resume->title = $title;
            $resume->user_id = $user->user_id;
            $resume->enable_search = $searchable;
            $resume->creation_date = date('Y-m-d H:i:s');
            $resume->modified_date = date('Y-m-d H:i:s');
            $resume->reject = 0;
            $resume->code = "RSM" . "-" . time();
            $resume->save();
            // Commit
            $db->commit();
            //if $searchable=1 then save into core search
            if ($searchable == 1) {
                /*
                  $db_search = Engine_Api::_()->getDbtable('search', 'core')->getAdapter();
                  $db_search->beginTransaction();
                  try{
                  $table_search = $this->_helper->api()->getDbtable('search', 'core');
                  $search= $table_search->createRow();
                  $search->type= 'resume_create';
                  $search->title= $title;
                  $search->id= $resume->getIdentity();
                  $search->save();
                  $db_search->commit();
                  }
                  catch( Exception $ex )
                  {
                  $db_search->rollBack();
                  throw $ex;
                  }
                 */
            }
            // Redirect
            return $this->_helper->redirector->gotoRoute(array('id' => $resume->getIdentity()), 'resume_work', true);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    //Edit resume info function
    public function resumeInfoEditAction() {

        $resume_id = $this->_getParam('resume_id');

        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
        //list work experience
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        $this->view->works = $works;
        //list education
        $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations = $education;
        //list language
        $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages = $languages;
        //list other skill
        $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill = $group_skills;
        //list reference
        $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references = $references;
        $this->view->resume = $resume;
        
        $this->_helper->content
                ->setContentName(41) // page_id
                // ->setNoRender()
                ->setEnabled();
        
        if (!$this->getRequest()->isPost()) {
            return;
        }
        //$resume = Engine_Api::_()->getItem('resume', $resume_id);
        $title = $this->getRequest()->getPost('resume_title');
        $searchable = $this->getRequest()->getPost('searchable');
        $resume->title = $title;

        $resume->enable_search = $searchable;
        $resume->modified_date = date('Y-m-d H:i:s');
        $resume->save();
        // Redirect
        return $this->_helper->redirector->gotoRoute(array('id' => $resume_id), 'resume_work', true);
    }

    public function resumeWorkAction() {

        if (!$this->_helper->requireUser->isValid())
            return;
        $viewer = Engine_Api::_()->user()->getViewer();
        // Create form
        $this->view->form = $form = new Resumes_Form_Work_Create();

        // Populate form options
        //level
        $levelTable = Engine_Api::_()->getDbtable('levels', 'resumes');
        foreach ($levelTable->fetchAll() as $level) {
            $form->level_id->addMultiOption($level->level_id, $level->name);
        }
        //Categories
        $categoryTable = Engine_Api::_()->getDbtable('industries', 'recruiter');
        foreach ($categoryTable->fetchAll() as $category) {
            $form->category_id->addMultiOption($category->industry_id, $category->name);
        }
        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries = $countryTable->fetchAll();
        foreach ($countries as $country) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        //$country_id= $countries[0]->country_id;
        //mặc định cho viet nam
        $country_id = 230;

        //if no country then???, so city???
        //City init

        $cities = Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        foreach ($cities as $city) {
            $form->city_id->addMultiOption($city->city_id, $city->name);
        }
        //get resume_id
        $resume_id = $this->_getParam('id');
        $this->view->resume_id = $resume_id;

        //if save by ajax
        if ($this->_request->isXmlHttpRequest()) {
            $resume_id = $this->getRequest()->getPost('resume_id');
            //type submit
            $type = $this->getRequest()->getPost('type');
            /*
              check table experience existed record (if submit with type is next);

              if($type=='next'){
              $work_experiences= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);

              }
             */
            //convert datetime
            //omit because change Date format 
            /*
              $starttime = $this->getRequest()->getPost('starttime');
              $endtime = $this->getRequest()->getPost('endtime');
              //process starttime
              $starttime= explode('/', $starttime);
              $hour= $this->getRequest()->getPost('starttime_hour');
              $minute= $this->getRequest()->getPost('starttime_minute');
              $starttime_ampm= $this->getRequest()->getPost('starttime_ampm');

              if(empty($hour) || empty($minute) || empty($starttime_ampm)){
              $hour=$minute= 0;
              $starttime_ampm='AM';
              }
              if($starttime_ampm=='PM'){
              $hour+= 12;
              }
              //process endtime
              $endtime= explode('/', $endtime);
              $hour_end= $this->getRequest()->getPost('endtime_hour');
              $minute_end= $this->getRequest()->getPost('endtime_minute');
              $endtime_ampm= $this->getRequest()->getPost('endtime_ampm');
              if(empty($hour_end) || empty($minute_end) || empty($endtime_ampm)){
              $hour_end=$minute_end= 0;
              $endtime_ampm='AM';
              }
              if($endtime_ampm=='PM'){
              $hour_end+= 12;
              }
              //if not date then inform error to action dateAction();
              if(checkdate($starttime[0], $starttime[1], $starttime[2])==false || checkdate($endtime[0], $starttime[1], $starttime[2])==false){
              $this->_helper->layout->disableLayout();
              $this->dateAction(0);
              };

              //Convert endtime

              $starttime=$starttime[2].'-'.$starttime[0].'-'.$starttime[1].''. $hour.':'.$minute;
              $endtime=$endtime[2].'-'.$endtime[0].'-'.$endtime[1].''. $hour_end.':'.$minute_end;
             */

            $starttime_month = $this->getRequest()->getPost('starttime_month');
            $starttime_year = $this->getRequest()->getPost('starttime_year');
            $starttime_day = $this->getRequest()->getPost('starttime_day');
            $starttime = $starttime_year . '-' . $starttime_month . '-' . $starttime_day;
            $endtime_month = $this->getRequest()->getPost('endtime_month');
            $endtime_year = $this->getRequest()->getPost('endtime_year');
            $endtime_day = $this->getRequest()->getPost('endtime_day');
            $endtime = $endtime_year . '-' . $endtime_month . '-' . $endtime_day;
            //if not date then inform error to action dateAction();
            if (checkdate($starttime_month, $starttime_day, $starttime_year) == false || checkdate($endtime_month, $endtime_day, $endtime_year) == false) {
                $this->_helper->layout->disableLayout();
                $this->dateAction(0);
            };
            $viewer = Engine_Api::_()->user()->getViewer();
            $oldTz = date_default_timezone_get();
            date_default_timezone_set($viewer->timezone);
            $start = strtotime($starttime);
            $end = strtotime($endtime);
            date_default_timezone_set($oldTz);

            if ($start > $end) {
                $this->_helper->layout->disableLayout();
                $this->dateAction(1);
            }

            //$starttime = date('Y-m-d', $start);
            //$endtime = date('Y-m-d', $end);
            $data = array(
                'num_year' => $this->getRequest()->getPost('num_year'),
                'resume_id' => $resume_id,
                'title' => $this->getRequest()->getPost('title'),
                'company_name' => $this->getRequest()->getPost('company_name'),
                'level_id' => $this->getRequest()->getPost('level_id'),
                'category_id' => $this->getRequest()->getPost('category_id'),
                'country_id' => $this->getRequest()->getPost('country_id'),
                'city_id' => $this->getRequest()->getPost('city_id'),
                'starttime' => $starttime,
                'endtime' => $endtime,
                'description' => $this->getRequest()->getPost('description'),
                'creation_date' => date('Y-m-d H:i:s'),
                'modified_date' => date('Y-m-d H:i:s')
            );

            $experience = Engine_Api::_()->getDbtable('experiences', 'resumes')->createRow();
            $experience->setFromArray($data);
            $experience->save();
            if ($type == 'save') {
                $this->dateAction(2);
            } else {
                $this->dateAction(3);
            }
        }else{
            $this->_helper->content
                ->setContentName(41) // page_id
                // ->setNoRender()
                ->setEnabled();
        }

        
        // Not post/invalid
        if (!$this->getRequest()->isPost()) {
            //list education
            $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
            $this->view->educations = $education;
            //list language
            $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
            $this->view->languages = $languages;
            //list other skill
            $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
            $this->view->group_skill = $group_skills;
            //list reference
            $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
            $this->view->references = $references;
            return;
        }
        if (!$form->isValid($this->getRequest()->getPost())) {
            return;
        }
        // Process
        $values = $form->getValues();
        //Zend_Debug::dump(strtotime($values['starttime']));exit;
        // Convert times
        $oldTz = date_default_timezone_get();
        date_default_timezone_set($viewer->timezone);
        $start = strtotime($values['starttime']);
        $end = strtotime($values['endtime']);
        date_default_timezone_set($oldTz);
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


        $db = Engine_Api::_()->getDbtable('experiences', 'resumes')->getAdapter();
        $db->beginTransaction();

        try {
            // Create event
            $table = $this->_helper->api()->getDbtable('experiences', 'resumes');
            $experience = $table->createRow();

            $experience->setFromArray($values);
            $experience->resume_id = $resume_id;
            $experience->save();
            // Commit
            $db->commit();

            // Redirect
            return $this->_helper->redirector->gotoRoute(array('id' => $resume_id), 'resume_education', true);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    public function dateAction($error) {

        echo $error;
        exit;
    }

    public function resumeWorkEditAction() {
        //if save by ajax
        if ($this->_request->isXmlHttpRequest()) {
            $exp_id = $this->getRequest()->getPost('exp_id');
            $resume_id = $this->getRequest()->getPost('resume_id');
            //type submit
            $type = $this->getRequest()->getPost('type');
            /*
              check table experience existed record (if submit with type is next);

              if($type=='next'){
              $work_experiences= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);

              }
             */
            //convert datetime
            /*
              $starttime = $this->getRequest()->getPost('starttime');
              $endtime = $this->getRequest()->getPost('endtime');
              //process starttime
              $starttime= explode('/', $starttime);
              $hour= $this->getRequest()->getPost('starttime_hour');
              $minute= $this->getRequest()->getPost('starttime_minute');
              $starttime_ampm= $this->getRequest()->getPost('starttime_ampm');

              if(empty($hour) || empty($minute) || empty($starttime_ampm)){
              $hour=$minute= 0;
              $starttime_ampm='AM';
              }
              if($starttime_ampm=='PM'){
              $hour+= 12;
              }
              //process endtime
              $endtime= explode('/', $endtime);
              $hour_end= $this->getRequest()->getPost('endtime_hour');
              $minute_end= $this->getRequest()->getPost('endtime_minute');
              $endtime_ampm= $this->getRequest()->getPost('endtime_ampm');
              if(empty($hour_end) || empty($minute_end) || empty($endtime_ampm)){
              $hour_end=$minute_end= 0;
              $endtime_ampm='AM';
              }
              if($endtime_ampm=='PM'){
              $hour_end+= 12;
              }
              //if not date then inform error to action dateAction();
              if(checkdate($starttime[0], $starttime[1], $starttime[2])==false || checkdate($endtime[0], $starttime[1], $starttime[2])==false){
              $this->_helper->layout->disableLayout();
              $this->dateAction(0);
              };

              //Convert endtime
             */
            $starttime_month = $this->getRequest()->getPost('starttime_month');
            $starttime_year = $this->getRequest()->getPost('starttime_year');
            $starttime_day = $this->getRequest()->getPost('starttime_day');
            $starttime = $starttime_year . '-' . $starttime_month . '-' . $starttime_day;
            $endtime_month = $this->getRequest()->getPost('endtime_month');
            $endtime_year = $this->getRequest()->getPost('endtime_year');
            $endtime_day = $this->getRequest()->getPost('endtime_day');
            $endtime = $endtime_year . '-' . $endtime_month . '-' . $endtime_day;
            //if not date then inform error to action dateAction();
            if (checkdate($starttime_month, $starttime_day, $starttime_year) == false || checkdate($endtime_month, $endtime_day, $endtime_year) == false) {
                $this->_helper->layout->disableLayout();
                $this->dateAction(0);
            };
            $viewer = Engine_Api::_()->user()->getViewer();
            $oldTz = date_default_timezone_get();
            date_default_timezone_set($viewer->timezone);
            $start = strtotime($starttime);
            $end = strtotime($endtime);
            date_default_timezone_set($oldTz);

            if ($start > $end) {
                $this->_helper->layout->disableLayout();
                $this->dateAction(1);
            }

            //$starttime = date('Y-m-d', $start);
            //$endtime = date('Y-m-d', $end);
            $data = array(
                'num_year' => $this->getRequest()->getPost('num_year'),
                'resume_id' => $resume_id,
                'title' => $this->getRequest()->getPost('title'),
                'company_name' => $this->getRequest()->getPost('company_name'),
                'level_id' => $this->getRequest()->getPost('level_id'),
                'category_id' => $this->getRequest()->getPost('category_id'),
                'country_id' => $this->getRequest()->getPost('country_id'),
                'city_id' => $this->getRequest()->getPost('city_id'),
                'starttime' => $starttime,
                'endtime' => $endtime,
                'description' => $this->getRequest()->getPost('description'),
                //'creation_date'=> date('Y-m-d H:i:s'),
                'modified_date' => date('Y-m-d H:i:s')
            );

            $experience = Engine_Api::_()->getDbtable('experiences', 'resumes')->findRow($exp_id);
            $experience->setFromArray($data);
            $experience->save();
            if ($type == 'save') {
                $this->dateAction(2);
            } else {
                $this->dateAction(3);
            }
        }
    }

    public function deleteWorkAction() {

        if ($this->_request->isXmlHttpRequest()) {
            $exp_id = $this->getRequest()->getPost('expr_id');

            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();

            try {

                $event = Engine_Api::_()->getItem('experience', $exp_id);
                $event->delete();
                $this->dateAction(1);
                $db->commit();
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    //function list experience
    public function listWorkAction() {
        $this->_helper->layout->disableLayout();
        //render view in order to display list experience
        $resume_id = $this->getRequest()->getPost('resume_id');
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        $type = $this->getRequest()->getPost('type');
        if ($type == 'next') {
            if (count($works) > 0) {
                echo count($works);
                exit;
            } else {
                echo 0;
                exit;
            }
        }
        $this->view->works = $works;
    }

    public function experienceAction() {
        $this->_helper->layout->disableLayout();
        $experience_id = $this->getRequest()->getPost('experience_id');
        $exp = Engine_Api::_()->getApi('core', 'resumes')->getExperience($experience_id);
        $this->view->exp = $exp;
    }

    //get city from country
    public function cityAction() {

        $this->_helper->layout->disableLayout();
        //$this->_helper->viewRenderer->setNoRender();
        $country_id = $this->_getParam('country_id');
        if ($country_id == 0) {
            //$country_id=1;
        }
        $city = Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        $this->view->city = $city;
    }

    public function previewAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        $viewer = Engine_Api::_()->user()->getViewer();

        $this->view->user_id = $user_id = $viewer->user_id;

        $resume_id = $this->_getParam('resume_id');
        //list resume
        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
        $this->view->resume = $resume;
        $this->view->user_resume = $resume->user_id;

        //list work experience
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        //total years
        $total_year = 0;
        foreach ($works as $work) {
            $total_year+= $work->num_year;
        }
        $this->view->total_year = $total_year;
        $this->view->works = $works;
        //list education
        $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations = $education;
        //list language
        $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages = $languages;
        //list other skill
        $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill = $group_skills;
        //list reference
        $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references = $references;
        //update approved
        //tam thoi khoa cho nay lại, vì cho approve 1 lần thôi
        /*
          $resume = Engine_Api::_()->getItem('resume', $resume_id);
          $resume->approved= 2;//wait to approved
          $resume->save();
         */
        $user_inform = Engine_Api::_()->getDbtable('users', 'user')->find($user_id)->current();
        $this->view->user_inform = $user_inform;
        //gender
        $field_id_gender = Engine_Api::_()->getApi('core', 'recruiter')->getMeta('gender');
        $option = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_gender, $user_id);
        if ($option != null) {
            $gender = Engine_Api::_()->getApi('core', 'recruiter')->getOption($field_id_gender, $option);
        }
        
        //birthday
        $field_id_birthday = Engine_Api::_()->getApi('core', 'recruiter')->getMeta('birthdate');
        $birthday = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_birthday, $user_id);
        
        $field_id_from = Engine_Api::_()->getApi('core', 'recruiter')->getMetaFromAlias('from');
        $from = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_from, $user_id);
        $from = Engine_Api::_()->getApi('core', 'recruiter')->getOption($field_id_from, $from);
        
        $field_id_phone = Engine_Api::_()->getApi('core', 'recruiter')->getMetaFromAlias('phone');
        $phone = Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_phone, $user_id);
        
        $this->view->gender = $gender;
        $this->view->birthday = $birthday;
        $this->view->from = $from;
        $this->view->phone = $phone;
        
        $this->_helper->content
                ->setContentName(41) // page_id
                // ->setNoRender()
                ->setEnabled();
        // Not post/invalid
    }

    public function listAction() {
        $this->_helper->layout->disableLayout();
        $resume_id = $this->getRequest()->getPost('resume_id');
        $viewer = Engine_Api::_()->user()->getViewer();

        $this->view->user_id = $viewer->user_id;
        //list resume
        $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
        $this->view->resume = $resume;
        $this->view->user_resume = $resume->user_id;

        //list work experience
        $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        //total years
        $total_year = 0;
        foreach ($works as $work) {
            $total_year+= $work->num_year;
        }
        $this->view->total_year = $total_year;
        $this->view->works = $works;
        //list education
        $education = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations = $education;
        //list language
        $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages = $languages;
        //list other skill
        $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill = $group_skills;
        //list reference
        $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references = $references;
    }

}
