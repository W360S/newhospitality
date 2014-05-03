<?php 
class Recruiter_Widget_FeaturedCompaniesController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        //get user_id has many candidate applied
        $table= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select= $table->select()
                        ->order('num_apply DESC')
                        ->limit(8)
                        ->group('user_id')
                        ;
        $jobs= $table->fetchAll($select);
        $user_ids= array();
        if(count($jobs)){
            foreach($jobs as $job){
                $user_ids[$job->user_id]= $job->user_id; 
            }
        }
        //get company
        $tbCompany= Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $sl= $tbCompany->select()
                        ->where('user_id IN(?)', $user_ids) 
                        ;
        $profiles= $tbCompany->fetchAll($sl);
        if(count($profiles)< 0){
            $this->setNoRender();   
        }
        $this->view->profiles= $profiles;
        
    }
}