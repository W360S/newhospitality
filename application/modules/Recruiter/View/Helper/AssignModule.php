<?php
class Recruiter_View_Helper_AssignModule extends Zend_View_Helper_Abstract
{
    //view members assigned
      public function assignModule($job_id){
        //Tìm những ngành / nghề có $job_id
        
        $table_industry= Engine_Api::_()->getDbtable('reIndustries', 'recruiter');
        $select_idustry= $table_industry->select()
                        ->where('job_id =?', $job_id)
                        ;
        $industries= $table_industry->fetchAll($select_idustry);
        $inds= array();
        foreach($industries as $industry){
            $inds[$industry->reindustry_id]= $industry->industry_id;
        }
        
        //Tìm những user có thể giải quyết công việc này
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        if(count($inds)){
            $select_module= $table_module->select()
                        ->where('name_module =?', 'job')
                        ->where('industry_id IN(?)', $inds)
                        //->group('module_id')
                        ;
            $users_modules= $table_module->fetchAll($select_module);
            //Zend_Debug::dump($users_modules);exit;
            $users= array();
            if(count($users_modules)){
                foreach($users_modules as $user){
                    $users[$user->user_id]= $user->user_id;
                }
                return $users;
            }else return 0;
        }
      }
}