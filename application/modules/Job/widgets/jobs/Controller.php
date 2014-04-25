<?php
class Job_Widget_JobsController extends Engine_Content_Widget_Abstract{
    public function indexAction(){
    	$table= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select= $table->select()
                        ->where('status =?', 2)
                        ->where('deadline > ?', date('Y-m-d'))
                        ->order('creation_date DESC')
                        ->order('num_apply DESC')
                        ->limit(10) ;
        $jobs= $table->fetchAll($select);
       
        if(count($jobs)==0){
            $this->setNoRender(true);
        }
        $this->view->jobs= $jobs;
        
        
    }
    
}