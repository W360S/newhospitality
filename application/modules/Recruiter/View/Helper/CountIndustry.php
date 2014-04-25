<?php 
class Recruiter_View_Helper_CountIndustry extends Zend_View_Helper_Abstract
{
    public function countIndustry($industry_id){
        //get city
        $table = Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $row = $table->fetchAll(
                        $table
                            ->select()
                            ->where('industry_id = ?', $industry_id)
                            ->where('job_id > ?', 0)
                            //->where('status =?', 2)
                            );
        $sum= 0;
        foreach($row as $val){
            $job= Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($val->job_id)->current();
            if($job->status ==2){
                $sum +=1;
            }
        }
        return $sum;
    }
}