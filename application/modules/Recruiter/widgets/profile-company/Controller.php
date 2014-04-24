<?php 
class Recruiter_Widget_ProfileCompanyController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        
        //get profile company id
        $job_id= Zend_Controller_Front::getInstance()->getRequest()->getParam('id');
        
        //$job= Engine_Api::_()->getItem('job', $job_id);
        $job= Engine_Api::_()->getDbtable('jobs', 'recruiter')->find($job_id)->current();
        
        $user_id= $job->user_id;
        $profile_id= Engine_Api::_()->getApi('core', 'recruiter')->getProfile($user_id)->recruiter_id;
        if($profile_id){
            $profile = Engine_Api::_()->getDbtable('recruiters', 'recruiter')->find($profile_id)->current();
            //Zend_Debug::dump($profile);exit;
            $industries= Engine_Api::_()->getApi('core', 'recruiter')->getIndustries($profile_id);
            $this->view->industries= $industries;
            $this->view->profile= $profile;
        }
        
    }
}