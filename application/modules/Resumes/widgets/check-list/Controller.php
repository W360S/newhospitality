<?php
/*
@author: huynhnv
@function: checklist
@description: List step by stepy create a resume
*/ 
class Resumes_Widget_CheckListController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $params = Zend_Controller_Front::getInstance()->getRequest()->getParams();
        
        $step = 0;
        if(isset($params['module']) && isset($params['controller']) && isset($params['action'])){
            $module = $params['module'];
            $controller = $params['controller'];
            $action = $params['action'];
            if($module == "resumes" && $controller=="index" && $action=="resume-info"){
                $step = 1;
            }
            if($module == "resumes" && $controller=="index" && $action=="resume-work"){
                $step = 2;
            }
            if($module == "resumes" && $controller=="education" && $action=="index"){
                $step = 3;
            }
            if($module == "resumes" && $controller=="skill" && $action=="index"){
                $step = 4;
            }
            if($module == "resumes" && $controller=="reference" && $action=="index"){
                $step = 5;
            }
            if($module == "resumes" && $controller=="index" && $action=="preview"){
                
                $viewer = Engine_Api::_()->user()->getViewer();
                $resume_id = Zend_Controller_Front::getInstance()->getRequest()->getParam('resume_id');
                $resume = Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
                $works = Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
                $total_year = 0;
                foreach ($works as $work) {
                    $total_year+= $work->num_year;
                }
                $educations = Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
                $languages = Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
                $group_skills = Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
                $references = Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
                
                if(count($works) < 1){
                    $step = 1;
                }else{
                    if(count($educations) < 1){
                        $step = 2;
                    }else{
                        $step = 6;
                    }
                }
                
                
                    
                
            }
        }
        
        
       
        $this->view->step = $step;
    }
}