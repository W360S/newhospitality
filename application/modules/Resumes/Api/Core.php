<?php
class Resumes_Api_Core extends Core_Api_Abstract
{
    // get city of country_id
    public function getCity($country_id)
    {
        $table = $this->api()->getDbtable('cities', 'resumes');
        $row = $table->fetchAll($table->select()->where('country_id = ?', $country_id)->order('name ASC'));
        return $row;
    }
    //list work experience of resume_id
    public function getListWork($resume_id){
        $table = $this->api()->getDbtable('experiences', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    public function getResume($resume_id){
        $table = $this->api()->getDbtable('resumes', 'resumes');
        $row = $table->fetchRow($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    //get resume all
    public function getListResume($user_id){
        $table = $this->api()->getDbtable('resumes', 'resumes');
        $row = $table->fetchAll($table->select()->where('user_id=?', $user_id)->order('modified_date DESC'));
        return $row;
    }
    public function getListEducation($resume_id){
        $table = $this->api()->getDbtable('educations', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    public function getExperience($experience_id){
        $table = $this->api()->getDbtable('experiences', 'resumes');
        $row = $table->fetchRow($table->select()->where('experience_id = ?', $experience_id));
        return $row;
    }
    public function getListSkill($resume_id){
        $table = $this->api()->getDbtable('languageSkills', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    public function getListLanguage(){
        $table = $this->api()->getDbtable('languages', 'resumes');
        $row = $table->fetchAll();
        return $row;
    }
    public function getListGroupSkill(){
        $table = $this->api()->getDbtable('groupSkills', 'resumes');
        $row = $table->fetchAll();
        return $row;
    }
    //get list skill other
    public function getListSkillOther($resume_id){
        $table = $this->api()->getDbtable('skills', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    public function getListReference($resume_id){
        $table = $this->api()->getDbtable('references', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    //get language follow resume_id
    public function getListLanguageSkill($resume_id){
        $table = $this->api()->getDbtable('languageSkills', 'resumes');
        $row = $table->fetchAll($table->select()->where('resume_id = ?', $resume_id));
        return $row;
    }
    public function deleteSkillOther($resume_id){
        Engine_Api::_()->getDbtable('skills', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteSkillLanguage($resume_id){
        Engine_Api::_()->getDbtable('languageSkills', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteReference($resume_id){
        Engine_Api::_()->getDbtable('references', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteEducation($resume_id){
        Engine_Api::_()->getDbtable('educations', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteExperience($resume_id){
        Engine_Api::_()->getDbtable('experiences', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteSearch($resume_id){
        Engine_Api::_()->getDbtable('search', 'core')->delete(array(
            'id = ?' => $resume_id,
            'type= ?'=>'resumes_resume'
        ));
    }
    public function deleteResume($resume_id){
        Engine_Api::_()->getDbtable('resumes', 'resumes')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function deleteJobApplied($resume_id){
         Engine_Api::_()->getDbtable('applyJobs', 'recruiter')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    //delete all resume_id save candidate
    public function deleteSaveResumeCandidate($resume_id){
         Engine_Api::_()->getDbtable('candidates', 'recruiter')->delete(array(
            'resume_id = ?' => $resume_id,
        ));
    }
    public function decreaseNumApplyJob($resume_id){
        $table= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $table_job= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select= $table->select()
                    ->where('resume_id =?', $resume_id)
                    ;
        $records= $table->fetchAll($select);
        foreach($records as $item){
            $job= $table_job->find($item->job_id)->current();
            $job->num_apply -=1;
            $job->save();
        }
    }   
}