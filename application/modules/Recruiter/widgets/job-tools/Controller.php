<?php
/*
@author: huynhnv
@function: tools job

*/ 
class Recruiter_Widget_JobToolsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $user= Engine_Api::_()->user()->getViewer();
        if(!$user->getIdentity()){
            $this->setNoRender();
        }
        //dem so cong viec duoc giai quyet
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        $select_module= $table_module->select()->where('user_id = ?', $user->getIdentity())
                            ->where('name_module =?', 'job')
        ;
        $module_jobs= $table_module->fetchAll($select_module);
        $industries= array();
        
        if(count($module_jobs)==0){
            $this->setNoRender();
        }
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
                */
                $select_pending= $table->select()->where('job_id IN(?)', $job_ids)->where('status =?', 1)->where('reject =?', 0);
                //$this->view->page = $page = $this->_getParam('page', 1);
                //jobs pending
                $paginator_pending = $table->fetchAll($select_pending);
                $this->view->job_pending= count($paginator_pending);
                //jobs approved
                
                $select_approved= $table->select()->where('job_id IN(?)', $job_ids)->where('resolved_by =?', $user->getIdentity())->where('status =?', 2)->where('reject =?', 0);
                $paginator_approved = $table->fetchAll($select_approved);
                $this->view->job_approved= count($paginator_approved);
                //jobs reject
                $select_reject= $table->select()->where('job_id IN(?)', $job_ids)->where('reject =?', $user->getIdentity());
                $paginator_reject = $table->fetchAll($select_reject);
                $this->view->job_reject= count($paginator_reject);
                //Zend_Debug::dump($paginator_pending);
            }
        }
    }
}