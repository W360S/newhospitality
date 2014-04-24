<?php 
class Recruiter_View_Helper_SaveJob extends Zend_View_Helper_Abstract
{
    public function saveJob($job_id, $user_id){
        $table = Engine_Api::_()->getDbtable('saveJobs', 'recruiter');
        $row = $table->fetchRow($table->select()->where('user_id = ?', $user_id)->where('job_id = ?', $job_id));
        return $row;
    }
}