<?php
/*
@author: huynhnv
@function: manage recruiter

*/ 
class Recruiter_Widget_ManageRecruiterController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        $sum_posted_job= Engine_Api::_()->getApi('job', 'recruiter')->countJobPosted($user->getIdentity());
        $this->view->posted_jobs= count($sum_posted_job);
        $sum_save_candidates= Engine_Api::_()->getApi('job', 'recruiter')->countSaveCandidate($user->getIdentity());
        $this->view->save_candidates= count($sum_save_candidates);
        //dem so resume da luu
        
        $sum_save_resume_candidates= Engine_Api::_()->getApi('job', 'recruiter')->countSaveResumeCandidate($user->getIdentity());
        $this->view->save_resume_candidates= count($sum_save_resume_candidates);
        //dem so cong viec duoc giai quyet
        /*
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        $select_module= $table_module->select()->where('user_id = ?', $user->getIdentity())
                            ->where('name_module =?', 'job')
        ;
        $module_jobs= $table_module->fetchAll($select_module);
        $industries= array();
        if(count($module_jobs)){
            foreach($module_jobs as $job){
                $industries[$job->module_id]= $job->industry_id;
            }
            $table_industry = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
            $rows = $table_industry->fetchAll(
                            $table_industry
                                ->select()
                                ->where('industry_id IN(?)', $industries)
                                ->where('job_id > ?', 0)
                                ->group('job_id')
                                );
            if(count($rows)>0){
                $job_ids= array();
                foreach($rows as $row){
                    $job_ids[$row['job_id']]= $row['job_id'];
                }
                
                $table = Engine_Api::_()->getItemTable('job');
                /*
                status= 1=> Pending
                status= 2=> Active
                status= 3=> Expired
                
                $select= $table->select()->where('job_id IN(?)', $job_ids)->where('status =?', 1)->where('reject =?', 0);
                $this->view->page = $page = $this->_getParam('page', 1);
                $paginator = $this->view->paginator = Zend_Paginator::factory($select);
                $this->view->authoried_to_resolve= count($paginator);
            }
        }
        */
        
    }
}