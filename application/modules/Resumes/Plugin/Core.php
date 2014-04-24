<?php
class Resumes_Plugin_Core
{
    public function onUserDeleteAfter($event)
    {
        $payload = $event->getPayload();
        $user_id = $payload['identity'];
        //delete resumes
        $table= Engine_Api::_()->getDbtable('resumes', 'resumes');
        $select= $table->select()
                            ->where('user_id =?', $user_id)
                            ;
        $resumes= $table->fetchAll($select);
        if(count($resumes)){
            foreach($resumes as $resume){
                $resume_id= $resume->resume_id;
                try{
                    //delete skill other if exist
                    Engine_Api::_()->getApi('core', 'resumes')->deleteSkillOther($resume_id);
                    //delelte skill language
                    Engine_Api::_()->getApi('core', 'resumes')->deleteSkillLanguage($resume_id);
                    //delete reference
                    Engine_Api::_()->getApi('core', 'resumes')->deleteReference($resume_id);
                    //delete Education
                    Engine_Api::_()->getApi('core', 'resumes')->deleteEducation($resume_id);
                    //delete Experience
                    Engine_Api::_()->getApi('core', 'resumes')->deleteExperience($resume_id);
                    //delete search
                    Engine_Api::_()->getApi('core', 'resumes')->deleteSearch($resume_id);
                    //delete job if applied
                    Engine_Api::_()->getApi('core', 'resumes')->deleteJobApplied($resume_id);
                    //delete save resume candidate: 2011-09-12
                    Engine_Api::_()->getApi('core', 'resumes')->deleteSaveResumeCandidate($resume_id);
                    //delete resume
                    Engine_Api::_()->getApi('core', 'resumes')->deleteResume($resume_id);
                    
                }
                catch( Exception $e )
                {	
        			throw $e;
                }
            }
        } 
    }
}