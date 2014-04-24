<?php
class Recruiter_Plugin_Core
{
    public function onUserDeleteAfter($event)
    {
        $payload = $event->getPayload();
        $user_id = $payload['identity'];
        //delete information company profile
        $companyTable= Engine_Api::_()->getDbtable('recruiters', 'recruiter');
        $select_company= $companyTable->select()->where('user_id =?', $user_id);
        $company= $companyTable->fetchRow($select_company);
        if(count($company)){
            Engine_Api::_()->getApi('core', 'recruiter')->deleteProfile($company->recruiter_id);
        }
        //delete jobs
        
        $table_jobs= Engine_Api::_()->getDbtable('jobs', 'recruiter');
        $select_jobs= $table_jobs->select()
                            ->where('user_id =?', $user_id)
                            ;
        $jobs= $table_jobs->fetchAll($select_jobs);
        if(count($jobs)){
            foreach($jobs as $job){
                Engine_Api::_()->getApi('job', 'recruiter')->deleteJob($job->job_id);
            }
        }
        //delte articles
        $table_articles= Engine_Api::_()->getDbtable('articals', 'recruiter');
        $select_articles= $table_articles->select()
                            ->where('user_id =?', $user_id);
        $articles= $table_articles->fetchAll($select_articles);
        if(count($articles)){
            foreach($articles as $article){
                $artical = Engine_Api::_()->getItem('artical', $article->artical_id);
                
                if($artical->photo_id){ 
                    Engine_Api::_()->getApi('job', 'recruiter')->deleteFileArtical($artical->photo_id);
                }
                $artical->delete();
            }
        }
        /*
            only 1 function anywhere (Recruiter, Resume, Hotel, v.v..)
            delete modules
            delete data in table module core(if)
        */
        $table_module= Engine_Api::_()->getDbtable('modules', 'user');
        $select_md= $table_module->select()
                        ->where('user_id =?', $user_id);
        $record_md= $table_module->fetchAll($select_md);
        if(count($record_md)){
            foreach($record_md as $md){
                $md->delete();
            }
        }
        
    }
}