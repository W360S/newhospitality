<?php
class Resumes_Widget_ResumeController extends Engine_Content_Widget_Abstract
{
    public function indexAction(){
        $viewer= Engine_Api::_()->user()->getViewer();
    
        $this->view->user_id= $viewer->user_id;
        
        $applyjob_id= Zend_Controller_Front::getInstance()->getRequest()->getParam('apply');
        $table= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select= $table->select()
                    ->where('applyjob_id =?', $applyjob_id);
        $candidate= $table->fetchRow($select);
        $this->view->re_candidate= $candidate;
        $resume_id= $candidate->resume_id;
        //list resume
        $resume= Engine_Api::_()->getApi('core', 'resumes')->getResume($resume_id);
        $this->view->resume= $resume;
        $this->view->user_resume= $resume->user_id;
        
        $user_inform = Engine_Api::_()->getDbtable('users', 'user')->find($resume->user_id)->current();
        $this->view->user_inform = $user_inform;
        
        //list work experience
        $works= Engine_Api::_()->getApi('core', 'resumes')->getListWork($resume_id);
        //total years
        $total_year=0;
        foreach($works as $work){
            $total_year+= $work->num_year;
        }
        $this->view->total_year= $total_year;
        $this->view->works= $works;
        //list education
        $education= Engine_Api::_()->getApi('core', 'resumes')->getListEducation($resume_id);
        $this->view->educations= $education;
        //list language
        $languages= Engine_Api::_()->getApi('core', 'resumes')->getListLanguageSkill($resume_id);
        $this->view->languages= $languages;
        //list other skill
        $group_skills= Engine_Api::_()->getApi('core', 'resumes')->getListSkillOther($resume_id);
        $this->view->group_skill= $group_skills;
        //list reference
        $references= Engine_Api::_()->getApi('core', 'resumes')->getListReference($resume_id);
        $this->view->references= $references;
        //check rate
        $this->view->rated = $candidate->rating;
    }
}