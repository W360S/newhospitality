<?php
/*
@author: huynhnv
@function: manage job

*/ 
class Recruiter_Widget_ManageJobController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //count saved job
        
        $user_id= Engine_Api::_()->user()->getViewer()->getIdentity();
        if(!$user_id){
            $this->setNoRender();
        }
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $select = $table->select()
            ->where('user_id = ?', $user_id);
        $savejob= $table->fetchAll($select);
        $this->view->savejob= count($savejob);
        //Zend_Debug::dump($savejob);
        //applied job
        $applyTable= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $selectApply= $applyTable->select()
            ->where('user_id = ?', $user_id);
        $applyjob= $applyTable->fetchAll($selectApply);
        $this->view->applyjob= count($applyjob);
    }
}