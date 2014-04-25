<?php
class Recruiter_Widget_CandidatesController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $applyjob= Zend_Controller_Front::getInstance()->getRequest()->getParam('apply');
        $this->view->apply= $applyjob;
        $table= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select= $table->select()
                    ->where('applyjob_id =?', $applyjob);
        $candidate= $table->fetchRow($select);
        $user_id= Engine_Api::_()->user()->getViewer()->getIdentity();
        $job_id= $candidate->job_id;
        $job= Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        $posted_user_job_id= $job->user_id;
        //Nếu không phải là người tạo job thì không được xem các apply khác.
        if($user_id != $posted_user_job_id){
            $this->setNoRender(true);
        }
        $this->view->candidate= $candidate;
        if(!empty($candidate->file_id)){
            $storage= Engine_Api::_()->getDbtable('files', 'storage')->find($candidate->file_id)->current();
            $this->view->storage= $storage;
        }
        //lay du lieu notes
        $table_note= Engine_Api::_()->getDbtable('notes', 'recruiter');
        if(!empty($candidate->owner_id)){
            $select_note= $table_note->select()->where('applyjob_id =?', $applyjob)->where('user_id =?', $candidate->owner_id)->order('note_id ASC');
            $this->view->notes= $table_note->fetchAll($select_note);
        }
        
    }
}