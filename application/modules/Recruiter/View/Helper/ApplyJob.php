<?php 
class Recruiter_View_Helper_ApplyJob extends Zend_View_Helper_Abstract
{
    public function applyJob($user_id, $job_id){
        
        $table = Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        
        $row = $table->fetchRow($table->select()->where('user_id = ?', $user_id)->where('job_id = ?', $job_id));
        return $row;
        
    }
}