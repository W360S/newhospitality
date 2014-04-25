<?php
class Recruiter_Widget_MyApplyController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $applyjob= Zend_Controller_Front::getInstance()->getRequest()->getParam('apply');
        $this->view->apply= $applyjob;
        $table= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select= $table->select()
                    ->where('applyjob_id =?', $applyjob);
        $candidate= $table->fetchRow($select);
        $this->view->candidate= $candidate;
        if(!empty($candidate->file_id)){
            $storage= Engine_Api::_()->getDbtable('files', 'storage')->find($candidate->file_id)->current();
            $this->view->storage= $storage;
        }
        
        
    }
}