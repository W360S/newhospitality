<?php

class Recruiter_SearchController extends Core_Controller_Action_Standard {

    public function indexAction() {
        $this->_helper->content
                ->setContentName(39) // page_id
                // ->setNoRender()
                ->setEnabled();
        
        $industry_id = $this->_getParam('industry_id');

        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $rows = $table->fetchAll(
                $table
                        ->select()
                        ->where('industry_id = ?', $industry_id)
                        ->where('job_id > ?', 0)
                        ->group('job_id')
        );
        $this->view->industry_id = $industry_id;
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
            $select = $table->select()
                    ->where('job_id IN(?)', $job_ids)
                    ->where('status =?', 2);
//                    ->where('deadline >?', date('Y-m-d H:i:s'));
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($page);
        }
    }

    //categories
    public function categoryAction() {

        $this->_helper->content
                ->setContentName(38) // page_id
                // ->setNoRender()
                ->setEnabled();

        $category_id = $this->_getParam('category_id');

        $table = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $rows = $table->fetchAll(
                $table
                        ->select()
                        ->where('category_id = ?', $category_id)
                        ->where('job_id > ?', 0)
                        ->group('job_id')
        );
        $this->view->category_id = $category_id;
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
            $select = $table->select()->where('job_id IN(?)', $job_ids)
                    ->where('status =?', 2);
//                    ->where('deadline >?', date('Y-m-d H:i:s'));
            $this->view->page = $page = $this->_getParam('page', 1);
            $paginator = $this->view->paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(10);
            $paginator->setCurrentPageNumber($page);
        }
    }

    public function searchBasicAction() {

        if ($this->getRequest()->getPost()) {

            $values = $this->getRequest()->getPost();
            $industry_id = $values['industry'];
            $country_id = $values['country_id'];
            $city_id = $values['city_id'];
            $search = $values['search_job'];
            if ($search === Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position')) {
                $search = '';
            }
            $category_id = $values['category'];
            $this->view->values = $values;
        }
        $req = $this->getRequest()->getPost();
        $pg = $this->_getParam('page');

        $this->_helper->content
                ->setContentName(37) // page_id
                // ->setNoRender()
                ->setEnabled();

        if (empty($req) && empty($pg)) {
            $this->view->no_req = 1;
            return;
        }
        $temp = $this->_getAllParams();

        if (!empty($temp)) {
            $search = $values['search_job'] = $temp['search_job'];
            if ($search === Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position')) {
                $search = '';
            }
            if (key_exists("amp;country_id", $temp)) {
                $country_id = $values['country_id'] = $temp['amp;country_id'];
            }
            if (key_exists("amp;city_id", $temp)) {
                $city_id = $values['city_id'] = $temp['amp;city_id'];
            }
            if (key_exists("amp;industry", $temp)) {
                $industry_id = $values['industry'] = $temp['amp;industry'];
            }
            if (key_exists("amp;category", $temp)) {
                $category_id = $values['category'] = $temp['amp;category'];
            }
            $this->view->values = $values;
        }
        //Zend_Debug::dump($industry_id);exit;
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $selectIndustry = $table
                ->select()
                ->where('job_id > ?', 0)
                //->where('status =?', 2)
                ->group('job_id')
        ;
        //$rows = $table->fetchAll(

        if ($industry_id != 0) {
            $selectIndustry->where('industry_id = ?', $industry_id);
        }
        $rows = $table->fetchAll($selectIndustry);

        $tableCategory = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $selectCat = $tableCategory->select()
                ->where('job_id > ?', 0)
                ->group('job_id')
        ;
        if (!empty($category_id)) {
            $selectCat->where('category_id =?', $category_id);
        }
        $rowCats = $tableCategory->fetchAll($selectCat);

        $job_ids = array();

        foreach ($rows as $row) {
            $job_ids[$row['job_id']] = $row['job_id'];
        }
        foreach ($rowCats as $rowCat) {
            $job_ids[$rowCat['job_id']] = $rowCat['job_id'];
        }

        $this->view->page = $page = $this->_getParam('page', 1);
        //$this->view->assign($values);
        $paginator = Engine_Api::_()->getApi('job', 'recruiter')->getJobsPaginator($values, $job_ids);


        $paginator->setCurrentPageNumber($page);

        $this->view->paginator = $paginator;

        //}
        $this->view->keyword = $search;
        $this->view->country_id = $country_id;
        $this->view->city_id = $city_id;
        $this->view->industry = $industry_id;
        $this->view->category = $category_id;
        //$this->view->position= $values['position'];
    }

    public function searchAdvancedAction() {
        if (!$this->_helper->requireUser()->isValid())
            return;
        //create form search advanced
        $this->view->form = $form = new Recruiter_Form_Job_Advanced();
        //Country
        //if no country then???
        $countryTable = Engine_Api::_()->getDbtable('countries', 'resumes');
        $countries = $countryTable->fetchAll();
        foreach ($countries as $country) {
            $form->country_id->addMultiOption($country->country_id, $country->name);
        }
        //$country_id= $countries[0]->country_id;
        $country_id = 0;

        //if no country then???, so city???
        //City init

        $cities = Engine_Api::_()->getApi('core', 'resumes')->getCity($country_id);
        foreach ($cities as $city) {
            $form->city_id->addMultiOption($city->city_id, $city->name);
        }
        //industries

        $industryTable = Engine_Api::_()->getDbtable('industries', 'recruiter');
        $industries = $industryTable->fetchAll();
        foreach ($industries as $industry) {
            $form->industries->addMultiOption($industry->industry_id, $industry->name);
        }
        //categories
        $categoryTable = Engine_Api::_()->getDbtable('categories', 'recruiter');
        $categories = $categoryTable->fetchAll();
        foreach ($categories as $category) {
            $form->categories->addMultiOption($category->category_id, $category->name);
        }
        //job type
        $typesTable = Engine_Api::_()->getDbtable('types', 'recruiter');
        $types = $typesTable->fetchAll();
        foreach ($types as $type) {
            $form->type->addMultiOption($type->type_id, $type->name);
        }
        //match job
        $req = $this->getRequest()->getPost();
        $pg = $this->_getParam('page');
        if (empty($req) && empty($pg)) {
            return;
        }
        if ($this->getRequest()->getPost()) {
            $values = $this->getRequest()->getPost();
            $keyword = $values['search_job'];
            $city_id = $values['city_id'];
            $country_id = $values['country_id'];
            $type = $values['type'];
            $industries = $values['industries'];
            $categories = $values['categories'];
            $match = $values['match'];
            $this->view->values = $values;
        }
        $temp = $this->_getAllParams();
        if (!empty($temp)) {
            $keyword = $values['search_job'] = $temp['search_job'];

            if (key_exists("amp;country_id", $temp)) {
                $country_id = $values['country_id'] = $temp['amp;country_id'];
            }
            if (key_exists("amp;city_id", $temp)) {
                $city_id = $values['city_id'] = $temp['amp;city_id'];
            }
            if (key_exists("amp;industries", $temp)) {
                $industries = $values['industries'] = $temp['amp;industries'];
            }
            if (key_exists("amp;categories", $temp)) {
                $categories = $values['categories'] = $temp['amp;categories'];
            }
            if (key_exists("amp;match", $temp)) {
                $match = $values['match'] = $temp['amp;match'];
            }
            if (key_exists("amp;type", $temp)) {
                $type = $values['type'] = $temp['amp;type'];
            }
            $this->view->values = $values;
        }
        //Zend_Debug::dump($temp);exit;
        //if($this->getRequest()->getPost()){
        //$values= $this->getRequest()->getPost();   
        //industries
        //$industries= $values['industries'];

        $tableIndustry = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        if (!empty($industries)) {
            $row_industries = $tableIndustry->fetchAll(
                    $tableIndustry
                            ->select()
                            ->where('industry_id IN(?)', $industries)
                            ->where('job_id > ?', 0)
                            ->group('job_id')
            );
        } else {
            $row_industries = $tableIndustry->fetchAll(
                    $tableIndustry
                            ->select()
                            //->where('industry_id IN(?)', $industries)
                            ->where('job_id > ?', 0)
                            ->group('job_id')
            );
        }
        $job_id_industries = array();
        foreach ($row_industries as $row) {
            $job_id_industries[$row['job_id']] = $row['job_id'];
        }
        //categories
        $tableCategory = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $selectCat = $tableCategory->select()
                ->where('job_id > ?', 0)
                ->group('job_id')
        ;
        if (!empty($categories)) {
            $selectCat->where('category_id IN(?)', $categories);
        }
        $row_categories = $tableCategory->fetchAll($selectCat);
        $job_id_categories = array();
        foreach ($row_categories as $row_cat) {
            $job_id_categories[$row_cat['job_id']] = $row_cat['job_id'];
        }
        $job_indus_cats = array_merge($job_id_industries, $job_id_categories);
        $type_id = $type;
        $table = Engine_Api::_()->getDbtable('jobTypes', 'recruiter');

        $rows = $table->fetchAll(
                $table
                        ->select()
                        ->where('type_id = ?', $type_id)
                        ->group('job_id')
        );
        $job_id_types = array();
        foreach ($rows as $row) {
            $job_id_types[$row['job_id']] = $row['job_id'];
        }
        $job_ids = array_merge($job_indus_cats, $job_id_types);

        $this->view->page = $page = $this->_getParam('page', 1);
        //$this->view->assign($values);
        $paginator = Engine_Api::_()->getApi('job', 'recruiter')->getJobAdvancedPaginator($values, $job_ids);
        //Zend_Debug::dump($paginator);
        $this->view->paginator = $paginator->setCurrentPageNumber($page);
        //}

        $this->view->keyword = $keyword;
        $this->view->city_id = $city_id;
        $this->view->country_id = $country_id;
        $this->view->type = $type;

        $selected_arr_type = array();
        $selected_types = $industries;

        if (!empty($selected_types)) {
            foreach ($selected_types as $key => $value) {
                $selected_arr_type[$key] = $value;
            }
        }
        $form->industries->setValue($selected_arr_type);
        //categories
        $selected_arr_categories = array();
        $selected_categories = $categories;
        if (!empty($selected_categories)) {
            foreach ($selected_categories as $key_cat => $value_cat) {
                $selected_arr_categories[$key_cat] = $value_cat;
            }
        }
        $form->categories->setValue($selected_arr_categories);
        $form->match->setValue($match);
        $this->view->industries = $industries;
        $this->view->categories = $categories;
    }

    //quick search
    public function searchQuickAction() {
        $user_id = Engine_Api::_()->user()->getViewer()->getIdentity();
        $this->view->viewer_id = $user_id;
        $data = $this->_getAllParams();
        $search = $data['quicksearch'];
        if ($search === Zend_Registry::get('Zend_Translate')->_('Enter keyword')) {
            $search = '';
        }
        $table = Engine_Api::_()->getItemTable('job');
        $db = $table->getAdapter();
        $rName = $table->info('name');
        $select = $table->select()
                ->where('status =?', 2)
                ->where('deadline >?', date('Y-m-d H:i:s'))
        ;
        if (!empty($search)) {
            $select->where($rName . ".position LIKE ? OR " . $rName . ".description LIKE ? OR " . $rName . ".salary LIKE ? OR " . $rName . ".skill LIKE ?", '%' . $search . '%');
        }

        $this->view->page = $page = $this->_getParam('page', 1);
        $paginator = $this->view->paginator_jobs = Zend_Paginator::factory($select);
        $this->view->quicksearch = $search;
        //Zend_Debug::dump($paginator);exit;
        $paginator->setItemCountPerPage(20);
        $paginator->setCurrentPageNumber($page);
    }

    public function searchResumeAction() {
        $values = $this->getRequest()->getPost();

        if (!$this->getRequest()->getPost()) {
            $this->view->no_req = 1;
            return;
        }

        if ($this->getRequest()->getPost()) {
            $country_id = 230;
            $city_id = $values['city_id'];
            $search = $search_tem = $values['search_resume'];
            if ($search == "Enter resume title,") {
                $search = $values['search_resume'] = "";
            }

            $level = $values['level'];
            $language = $values['language'];
            $degree = $values['degree'];
            $industry = $values['industry'];
            $this->view->values = $vals = $values;
            //Zend_Debug::dump($city_id);
        }

        $temp = $this->_getAllParams();
        //Zend_Debug::dump($values);
        //Zend_Debug::dump($temp);exit;
        if (!empty($temp)) {
            $search = $search_tem = $values['search_resume'] = $temp['search_resume'];
            if (($search == "Enter resume title,") || ($search == "Nhập tên hồ sơ ứng viên")) {
                $search = $values['search_resume'] = "";
            }
            //if(key_exists("amp;country_id",$temp))
            //{
            //$country_id= $values['country_id']= $temp['amp;country_id'];
            //}
            if (key_exists("amp;city_id", $temp)) {
                $city_id = $values['city_id'] = $temp['amp;city_id'];
            }
            if (key_exists("amp;level", $temp)) {
                $level = $values['level'] = $temp['amp;level'];
            }
            if (key_exists("amp;degree", $temp)) {
                $degree = $values['degree'] = $temp['amp;degree'];
            }
            if (key_exists("amp;language", $temp)) {
                $language = $values['language'] = $temp['amp;language'];
            }
            if (key_exists("amp;industry", $temp)) {
                $industry = $values['industry'] = $temp['amp;industry'];
            }
            $this->view->values = $vals = $values;
        }

        //experiences
        $tableExperience = Engine_Api::_()->getDbtable('experiences', 'resumes');
        $db_exp = $tableExperience->getAdapter();
        $rName = $tableExperience->info('name');
        $select_exp = $tableExperience->select()
                ->group('resume_id')
        ;
        if (!empty($search)) {
            $select_exp->where(new Zend_Db_Expr($db_exp->quoteInto('MATCH(' . $rName . '.`title`, ' . $rName . '.`description`, ' . $rName . '.`company_name`) AGAINST (? IN BOOLEAN MODE)', $search)))
            ;
        }
        if (!empty($city_id)) {
            $select_exp->where('city_id = ?', $city_id);
        }
        if (!empty($level)) {
            $select_exp->where('level_id =?', $level);
        }
        if (!empty($industry)) {
            $select_exp->where('category_id =?', $industry);
        }
        $exs = $tableExperience->fetchAll($select_exp);
        $resume_exps = array();
        if (count($exs) > 0) {
            foreach ($exs as $row) {
                $resume_exps[$row->resume_id] = $row->resume_id;
            }
        }
        //Zend_Debug::dump($select_exp->query());exit;
        //degrees
        /*
          $tableEducation= Engine_Api::_()->getDbtable('educations', 'resumes');
          $db_edu= $tableEducation->getAdapter();
          $rNameEdu= $tableEducation->info('name');
          $select_edu= $tableEducation
          ->select()
          ->group('resume_id')
          ;
          if(!empty($search)){
          $select_edu->where(new Zend_Db_Expr($db_edu->quoteInto('MATCH(' . $rNameEdu . '.`school_name`, ' . $rNameEdu . '.`major`, ' . $rNameEdu . '.`description`) AGAINST (? IN BOOLEAN MODE)', $search)));
          }
          if(!empty($degree)){
          $select_edu->where('degree_level_id = ?', $degree);

          }
          $edus= $tableEducation->fetchAll($select_edu);
          $resume_edus= array();
          if(count($edus)>0){
          foreach($edus as $row){
          $resume_edus[$row->resume_id]= $row->resume_id;
          }
          }
          $resume_ids_ex = array_merge($resume_exps, $resume_edus);
         */
        //language
        /*
          $tableLanguage= Engine_Api::_()->getDbtable('languageSkills', 'resumes');
          $db_lang= $tableLanguage->getAdapter();
          $rNameLang= $tableLanguage->info('name');
          $select_lg= $tableLanguage
          ->select()
          ->group('resume_id')
          ;
          if(!empty($language)){
          $select_lg->where('language_id = ?', $language);

          }
          $langs= $tableLanguage->fetchAll($select_lg);
          $resume_langs= array();
          if(count($langs)>0){
          foreach($langs as $row){
          $resume_langs[$row->resume_id]= $row->resume_id;
          }
          }
          $resume_ids= array_merge($resume_ids_ex, $resume_langs );
         */
        //Zend_Debug::dump($resume_ids);
        $resume_ids = $resume_exps;

        if (count($resume_ids)) {
            $table = Engine_Api::_()->getItemTable('resume');
            $db = $table->getAdapter();
            $rNameRe = $table->info('name');
            $select = $table->select()
                    ->where('enable_search > ?', 0)
                    ->where('approved =?', 1)
                    ->where('resume_id IN(?)', $resume_ids)
            ;
            if (!empty($search)) {
                $select->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rNameRe . '.`title`) AGAINST (? IN BOOLEAN MODE)', $search)))
                ;
            }
            $this->view->page = $page = $this->_getParam('page', 1);
            $this->view->paginator = $paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($resume_ids);exit;
            $paginator->setItemCountPerPage(20);
            $paginator->setCurrentPageNumber($page);
        } else if (empty($city_id) && empty($level) && empty($industry)) {
            $table = Engine_Api::_()->getItemTable('resume');
            $db = $table->getAdapter();
            $rNameRe = $table->info('name');
            $select = $table->select()
                    ->where('enable_search > ?', 0)
                    ->where('approved =?', 1)
            ;
            if (!empty($search)) {
                $select->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rNameRe . '.`title`) AGAINST (? IN BOOLEAN MODE)', $search)))
                ;
            }
            $this->view->page = $page = $this->_getParam('page', 1);
            $this->view->paginator = $paginator = Zend_Paginator::factory($select);
            //Zend_Debug::dump($paginator);exit;
            $paginator->setItemCountPerPage(20);
            $paginator->setCurrentPageNumber($page);
        }

        $this->view->keyword = $search_tem;
        $this->view->country_id = $country_id;
        $this->view->city_id = $city_id;
        $this->view->level = $level;
        $this->view->language = $language;
        $this->view->degree = $degree;
        $this->view->industry = $industry;
        //}
    }

    public function industryAction() {
        
    }

}
