<?php

class Recruiter_Api_Job extends Core_Api_Abstract {

    static $title_tags = array(
    );

    //count job posted
    public function countJobPosted($user_id) {
        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $row = $table->fetchAll($table->select()->where('user_id = ?', $user_id));
        return $row;
    }

    //count job posted
    public function countSaveCandidate($user_id) {
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $row = $table->fetchAll($table->select()->where('owner_id = ?', $user_id)->where('status =?', 1));
        return $row;
    }

    //count save reusme candidates
    public function countSaveResumeCandidate($user_id) {
        $table = Engine_Api::_()->getDbtable('candidates', 'recruiter');

        $select = $table
                ->select()
                ->setIntegrityCheck(false)
                ->from($table->info('name'))
                ->where($table->info('name') . ".user_id =?", $user_id)
                ->order($table->info('name') . '.date_saved DESC');
        $row = $table->fetchAll($select);
        return $row;
    }

    //add industries
    public function createIndustries($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('reIndustries', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "industry_id" => intval($item)));
                $row->save();
            }
        }
    }

    //add categories
    public function createCategories($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('reCategories', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "category_id" => intval($item)));
                $row->save();
            }
        }
    }

    //add contact
    public function createContacts($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('contactVias', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "contact_id" => intval($item)));
                $row->save();
            }
        }
    }

    //add types
    public function createTypes($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('jobTypes', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "type_id" => intval($item)));
                $row->save();
            }
        }
    }

    //get industry
    public function getJobIndustries($job_id) {
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $row = $table->fetchAll($table->select()->where('job_id = ?', $job_id));
        return $row;
    }

    public function getJobCategories($job_id) {
        $table = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $row = $table->fetchAll($table->select()->where('job_id = ?', $job_id));
        return $row;
    }

    //get types
    public function getJobTypes($job_id) {
        $table = Engine_Api::_()->getDbtable('jobTypes', 'recruiter');
        $row = $table->fetchAll($table->select()->where('job_id = ?', $job_id));
        return $row;
    }

    //contact
    public function getJobContacts($job_id) {
        $table = Engine_Api::_()->getDbtable('contactVias', 'recruiter');
        $row = $table->fetchAll($table->select()->where('job_id = ?', $job_id));
        return $row;
    }

    /*
      job begin
     */

    //update industries of job
    public function updateIndustriesJob($new_industries = array(), $job_id) {
        // update here
        if (count($new_industries) && $job_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                // delete  old categories
                $this->deleteIndustriesJob($job_id);
                $db->commit();
                // create new data
                $this->createIndustriesJob($new_industries, $job_id);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    //update categories of job
    public function updateCategoriesJob($new_industries = array(), $job_id) {
        // update here
        if (count($new_industries) && $job_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                // delete  old categories
                $this->deleteCategoriesJob($job_id);
                $db->commit();
                // create new data
                $this->createCategoriesJob($new_industries, $job_id);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function deleteIndustriesJob($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function deleteCategoriesJob($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function createIndustriesJob($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('reIndustries', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "industry_id" => intval($item)));
                $row->save();
            }
        }
    }

    public function createCategoriesJob($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('reCategories', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "category_id" => intval($item)));
                $row->save();
            }
        }
    }

    //get industry (carrer)of job
    public function getIndustryOfJob($job_id = null) {
        if ($job_id) {
            $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
            $select = $table->select()
                    ->where('job_id = ?', $job_id)
                    ->group("industry_id");
            return $table->fetchAll($select);
        }
    }

    //get categories(industries)
    public function getCategoryOfJob($job_id = null) {
        if ($job_id) {
            $table = Engine_Api::_()->getDbtable('reCategories', 'recruiter');
            $select = $table->select()
                    ->where('job_id = ?', $job_id)
                    ->group("category_id");
            return $table->fetchAll($select);
        }
    }

    //get types of job
    public function getTypeOfJob($job_id = null) {
        if ($job_id) {
            $table = Engine_Api::_()->getDbtable('jobTypes', 'recruiter');
            $select = $table->select()
                    ->where('job_id = ?', $job_id)
                    ->group("type_id");
            return $table->fetchAll($select);
        }
    }

    //get contact via of job
    public function getContacViaOfJob($job_id = null) {
        if ($job_id) {
            $table = Engine_Api::_()->getDbtable('contactVias', 'recruiter');
            $select = $table->select()
                    ->where('job_id = ?', $job_id)
                    ->group("contact_id");
            return $table->fetchAll($select);
        }
    }

    //update industries of job
    public function updateTypesJob($new_types = array(), $job_id) {
        // update here
        if (count($new_types) && $job_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                // delete  old categories
                $this->deleteTypesJob($job_id);
                $db->commit();
                // create new data
                $this->createTypesJob($new_types, $job_id);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function deleteTypesJob($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('jobTypes', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function createTypesJob($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('jobTypes', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "type_id" => intval($item)));
                $row->save();
            }
        }
    }

    //update contact via of job
    public function updatecontactViasJob($new_contacts = array(), $job_id) {
        // update here
        if (count($new_contacts) && $job_id) {
            $db = Engine_Db_Table::getDefaultAdapter();
            $db->beginTransaction();
            try {
                // delete  old categories
                $this->deletecontactViasJob($job_id);
                $db->commit();
                // create new data
                $this->createcontactViasJob($new_contacts, $job_id);
            } catch (Exception $e) {
                $db->rollBack();
                throw $e;
            }
        }
    }

    public function deletecontactViasJob($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('contactVias', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function createcontactViasJob($categories = array(), $job_id) {
        if (count($categories)) {
            foreach ($categories as $item) {
                $row = Engine_Api::_()->getDbtable('contactVias', 'recruiter')->createRow();
                $row->setFromArray(array("job_id" => $job_id, "contact_id" => intval($item)));
                $row->save();
            }
        }
    }

    //delete job
    public function deleteJob($job_id) {
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();

        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        $result = 0;
        try {
            $job->delete();
            //delete industries
            $this->deleteIndustries($job_id);
            //delete types
            $this->deleteTypes($job_id);
            //delete contact vias
            $this->deletecontactVias($job_id);
            //delete saved job
            $this->deleteSavedJob($job_id);
            //delete apply job
            $this->delApplyJob($job_id);
            $db->commit();
            $result = 1;
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
        return $result;
    }

    public function delApplyJob($job_id) {
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function deleteSavedJob($job_id) {
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function deleteIndustries($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function deleteTypes($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('jobTypes', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    public function deletecontactVias($job_id) {
        // delete all old data 
        $table = Engine_Api::_()->getDbtable('contactVias', 'recruiter');
        $where = $table->getAdapter()->quoteInto('job_id = ?', $job_id);
        $table->delete($where);
    }

    /* job end */

    //search job
    public function getJobsPaginator($params = array(), $job_ids = array()) {
        $paginator = Zend_Paginator::factory($this->getJobsSelect($params, $job_ids));
        if (!empty($params['page'])) {
            $paginator->setCurrentPageNumber($params['page']);
        }
        if (!empty($params['limit'])) {
            $paginator->setItemCountPerPage($params['limit']);
        }

        if (empty($params['limit'])) {
            $page = 20;
            $paginator->setItemCountPerPage($page);
        }

        return $paginator;
    }

    /**
     * Gets a select object for the user's blog entries
     *
     * @param Core_Model_Item_Abstract $user The user to get the messages for
     * @return Zend_Db_Table_Select
     */
    public function getJobsSelect($params = array(), $job_ids = array()) {

        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $rName = $table->info('name');
        $select = $table->select()
                ->order('creation_date DESC')
                ->where('status =?', 2)
        // ->where('deadline >?', date('Y-m-d H:i:s'))
        ;

        if (!empty($params['city_id'])) {
            $select->where($rName . '.city_id = ?', $params['city_id']);
        }
        /*
          else if($params['city_id']==0){
          $select->orWhere($rName.'.city_id = ?', $params['city_id']);
          }
         */
        if (isset($job_ids) && !empty($job_ids)) {
            $select->where($rName . '.job_id IN(?)', $job_ids);
        }

        /*
          if( isset($params['position']) )
          {
          //I think we should user orWhere
          $select->orWhere($rName.'.job_id = ?', $params['position']);
          }
         */
        if (!empty($params['search_job'])) {
            if ($params['search_job'] != Zend_Registry::get('Zend_Translate')->_('Enter jobs title, position')) {
                $select->where($rName . ".position LIKE ? OR " . $rName . ".description LIKE ? OR " . $rName . ".salary LIKE ? OR " . $rName . ".skill LIKE ?", '%' . $params['search_job'] . '%');
            }
        }

        return $select;
    }

    //check job saved
    public function CheckJobSaved($job_id, $user_id) {
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $select = $table->select()
                ->where('user_id = ?', $user_id)
                ->where('job_id = ?', $job_id);
        if (count($table->fetchRow($select))) {
            return 1;
        } else
            return 0;
    }

    //check job applied
    public function CheckJobApplied($job_id, $user_id) {
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select = $table->select()
                ->where('user_id = ?', $user_id)
                ->where('job_id = ?', $job_id);
        if (count($table->fetchRow($select))) {
            return 1;
        } else
            return 0;
    }

    //save job
    public function SaveJob($job_id, $user_id, $status) {
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        try {
            $savedjod = $table->createRow();
            $savedjod->job_id = $job_id;
            $savedjod->user_id = $user_id;
            $savedjod->date_saved = date('Y-m-d H:i:s');
            $savedjod->status = $status;
            $savedjod->save();
        } catch (Exception $e) {
            throw $e;
        }
    }

    //list job saved
    public function ListJobSave($user_id) {
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $select = $table->select()
                ->where('user_id = ?', $user_id)
                ->group("job_id");
        return $table->fetchAll($select);
    }

    public function cleanTitle($html) {
        $chain = new Zend_Filter();
        $chain->addFilter(new Zend_Filter_StripTags(self::$title_tags));
        $chain->addFilter(new Zend_Filter_StringTrim());
        $html = $chain->filter($html);

        $tmp = $html;
        while (1) {
            // Try and replace an occurence of javascript
            $html = preg_replace('/(<[^>]*)javascript:([^>]*>)/i', '$1$2', $html);

            // If nothing changes this iteration then break loop
            if ($html == $tmp)
                break;

            $tmp = $html;
        }

        return $html;
    }

    //send mail
    public function sendmail($from, $from_name = null, $subject, $body, $emails) {
        // temporarily enable queueing if requested
        $temporary_queueing = Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing;
        if (isset($values['queueing']) && $values['queueing']) {
            Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = 1;
        }

        $mailApi = Engine_Api::_()->getApi('mail', 'core');

        $mail = $mailApi->create();
        $mail
                ->setFrom($from, $from_name)
                ->setReplyTo($from, $from_name)
                ->setSubject($subject)
                ->setBodyHtml($body)
        ;

        foreach ($emails as $email) {
            $mail->addTo($email);
        }

        $mailApi->send($mail);

        // emails have been queued (or sent); re-set queueing value to original if changed
        if (isset($values['queueing']) && $values['queueing']) {
            Engine_Api::_()->getApi('settings', 'core')->core_mail_queueing = $temporary_queueing;
        }
    }

    //delete applied job
    public function deleteApplyJob($job_id, $user_id) {
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select = $table->select()
                ->where('job_id = ?', $job_id)
                ->where('user_id = ?', $user_id);
        $jobs = $table->fetchAll($select);
        //set status of table save job
        $tableSaveJob = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $selectSaveJob = $tableSaveJob->select()
                ->where('job_id = ?', $job_id)
                ->where('user_id = ?', $user_id);
        $job_save = $tableSaveJob->fetchRow($selectSaveJob);
        //decreate 1 apply
        $job_decreate = Engine_Api::_()->getItem('job', $job_id);

        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();
        $result = 0;
        try {
            $job_decreate->num_apply -=1;
            $job_decreate->save();
            if ($job_save) {
                $job_save->status = 0;
                $job_save->save();
            }

            //if many apply to 1 job of user then delete all
            foreach ($jobs as $job) {
                // delete acttachment of apply job
                @$this->deleteFile($job->file_id);

                $job->delete();
            }

            $result = 1;
            return $result;
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    function deleteFile($file_id) {
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();

        try {
            $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($file_id)->current();
            if ($storage) {
                $file_path = $path . $storage->storage_path;
                $storage->delete();
                $db->commit();
                @unlink($file_path);
            }
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    //set status of table savejobs
    public function setStatusJob($job_id, $user_id) {
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $select = $table->select()
                ->where('job_id = ?', $job_id)
                ->where('user_id = ?', $user_id);
        $job = $table->fetchRow($select);
        $job->status = 1;
        $job->save();
    }

    //delete apply candidate job
    public function deleteApplyCandidate($applyjob_id) {
        $applyjob = Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($applyjob_id)->current();
        $job_id = $applyjob->job_id;
        $job = Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        $result = 0;
        try {
            $job->num_apply -=1;
            $job->save();
            @$this->deleteFile($applyjob->file_id);
            $applyjob->delete();
            $result = 1;
            return $result;
        } catch (Exception $e) {

            throw $e;
        }
    }

    //delete save candidate
    public function deleteSaveCandidate($applyjob_id) {
        $applyjob = Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($applyjob_id)->current();

        $result = 0;
        try {
            $applyjob->status = 0;
            $applyjob->save();
            $result = 1;
            return $result;
        } catch (Exception $e) {

            throw $e;
        }
    }

    //delete save resume candidates
    public function deleteSaveResumeCandidate($candidate_id) {
        $candidate = Engine_Api::_()->getDbtable('candidates', 'recruiter')->find($candidate_id)->current();

        $result = 0;
        try {
            //$candidate->status= 0;
            $candidate->delete();
            $result = 1;
            return $result;
        } catch (Exception $e) {

            throw $e;
        }
    }

    public function getJobAdvancedPaginator($params = array(), $job_ids = array()) {
        $paginator = Zend_Paginator::factory($this->getJobAdvancedSelect($params, $job_ids));
        if (!empty($params['page'])) {
            $paginator->setCurrentPageNumber($params['page']);
        }
        if (!empty($params['limit'])) {
            $paginator->setItemCountPerPage($params['limit']);
        }

        if (empty($params['limit'])) {
            $page = 20;
            $paginator->setItemCountPerPage($page);
        }

        return $paginator;
    }

    public function getJobAdvancedSelect($params = array(), $job_ids = array()) {

        $table = Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $db = $table->getAdapter();
        $rName = $table->info('name');
        $select = $table->select()
                ->order('creation_date DESC')
                ->where('status =?', 2)
                ->where('deadline >?', date('Y-m-d H:i:s'))
        ;

        if (!empty($params['city_id'])) {
            $select->where($rName . '.city_id = ?', $params['city_id']);
        }
        /*
          else if($params['city_id']){
          $select->orWhere($rName.'.city_id = ?', $params['city_id']);
          }
         */
        //job_ids base on types job
        if (isset($job_ids) && !empty($job_ids)) {
            //I think we should orWhere
            $select->where($rName . '.job_id IN(?)', $job_ids);
        }

        if ($params['match'] == 1) {
            if (!empty($params['search_job'])) {
                $select
                        ->where($rName . ".position LIKE ? OR " . $rName . ".description LIKE ? OR " . $rName . ".salary LIKE ? OR " . $rName . ".contact_name LIKE ? OR " . $rName . ".contact_address LIKE ? OR " . $rName . ".skill LIKE ?", '%' . $params['search_job'] . '%')

                //->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rName . '.`position`, ' . $rName . '.`description`, ' . $rName . '.`salary`, ' . $rName . '.`skill`, '.$rName . '.`contact_name`, '.$rName . '.`contact_address`) AGAINST (? IN BOOLEAN MODE)', $params['search_job'])))                      
                ;
            }
        } else if ($params['match'] == 2) {
            if (!empty($params['search_job'])) {
                $select->where($rName . ".position =? OR " . $rName . ".description =? OR " . $rName . ".skill =? OR " . $rName . ".contact_name =? OR " . $rName . ".contact_address =? OR " . $rName . ".salary =?", $params['search_job'])
                //->orWhere($rName.".description =?", $params['search_job'])
                //->orWhere($rName.".skill =?", $params['search_job'])
                //->orWhere($rName.".contact_name =?", $params['search_job'])
                //->orWhere($rName.".contact_address =?", $params['search_job'])
                //->orWhere($rName.".salary =?", $params['search_job'])
                ;
            }
        } else {
            if (!empty($params['search_job'])) {
                $pieces = explode(" ", $params['search_job']);
                $pieces[] = $params['search_job'];
                //$select->where($rName.".position LIKE ? OR ".$rName.".description LIKE ? OR ".$rName.".skill LIKE ? OR ".$rName.".contact_name LIKE ? OR ".$rName.".contact_address LIKE ?", $val)
                //->orWhere($rName.".position IN(?)", $pieces)
                //->orWhere($rName.".description IN(?)", $pieces)
                //->orWhere($rName.".skill IN(?)", $pieces)
                //->orWhere($rName.".contact_name IN(?)", $pieces)
                //->orWhere($rName.".contact_address IN(?)", $pieces)
                $select->where(new Zend_Db_Expr($db->quoteInto('MATCH(' . $rName . '.`position`, ' . $rName . '.`salary`, ' . $rName . '.`description`, ' . $rName . '.`skill`, ' . $rName . '.`contact_name`, ' . $rName . '.`contact_address`) AGAINST (? IN BOOLEAN MODE)', $params['search_job'])))

                ;
                //Zend_Debug::dump($select->assemble());exit;
            }
        }
        return $select;
    }

    // delete image
    function deleteFileArtical($file_id) {
        $path = APPLICATION_PATH . DIRECTORY_SEPARATOR;
        $db = Engine_Db_Table::getDefaultAdapter();
        $db->beginTransaction();

        try {
            $storage = Engine_Api::_()->getDbtable('files', 'storage')->find($file_id)->current();
            $file_path = $path . $storage->storage_path;
            $file_path = str_replace("/", "\\", $file_path);
            //Zend_Debug::dump($file_path);exit;
            $storage->delete();
            $db->commit();
            @unlink($file_path);
        } catch (Exception $e) {
            $db->rollBack();
            throw $e;
        }
    }

    // get other articals
    function getOtherArticals($artical_id, $cat_id) {
        $table = Engine_Api::_()->getItemTable('artical');

        $select1 = $table->select()
                //->from($table, new Zend_Db_Expr('artical_id, title, photo_id'))
                ->order('created DESC')
                ->where('category_id =?', $cat_id)
                ->where('artical_id <?', $artical_id)
                ->limit(2);
        $old = $table->fetchAll($select1);


        $select2 = $table->select()
                //->from($table,new Zend_Db_Expr('artical_id, title, photo_id'))
                ->order('created DESC')
                ->where('category_id =?', $cat_id)
                ->where('artical_id >?', $artical_id)
                ->limit(8);
        $new = $table->fetchAll($select2);

        return array("new" => $new, "old" => $old);
    }

    public function getJobLabels($selected_types) {
        $type = "pt-fulltime";
        $text = "fulltime";
        if (count($selected_types) >= 1) {
            foreach ($selected_types as $key => $selected_type) {
                if ($selected_type['type_id'] == 1) {
                    break;
                }
                if ($selected_type['type_id'] == 2 || $selected_type['type_id'] == 4) {
                    $type = "pt-temporary";
                    $text = "temporary";
                    break;
                }

                if ($selected_type['type_id'] == 3) {
                    $type = "pt-parttime";
                    $text = "parttime";
                    break;
                }

                if ($selected_type['type_id'] == 6) {
                    $type = "pt-intership";
                    $text = "internship";
                    break;
                }
            }
        }
        
        return array($type,$text);
        
    }

}
