<?php
class Recruiter_Widget_ProfileToolsController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $apply_id= Zend_Controller_Front::getInstance()->getRequest()->getParam('apply');
        if($apply_id){
            $apply_job= Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->find($apply_id)->current();
            $user_id= $apply_job->user_id;
        }
        
        $resume_id= Zend_Controller_Front::getInstance()->getRequest()->getParam('resume_id');
        if($resume_id){
            $resume= Engine_Api::_()->getDbtable('resumes', 'resumes')->find($resume_id)->current();
            $user_id= $resume->user_id;
        }
        

        $user= Engine_Api::_()->getItem('user', $user_id);

        //Engine_Api::_()->core()->setSubject($user);

        $this->view->candidate= $user;
        $this->view->resume_id= $resume_id;
        

        
        $field_id_gender= Engine_Api::_()->getApi('core', 'recruiter')->getMeta('gender');
        $option= Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_gender, $user_id);
        if($option != null){
            $gender= Engine_Api::_()->getApi('core', 'recruiter')->getOption($field_id_gender, $option);
            $this->view->gender= $gender;
        }
        
        $field_id_birthday= Engine_Api::_()->getApi('core', 'recruiter')->getMeta('birthdate');
        $birthday= Engine_Api::_()->getApi('core', 'recruiter')->getValue($field_id_birthday, $user_id);
        
        $this->view->birthday= $birthday;
    }
}