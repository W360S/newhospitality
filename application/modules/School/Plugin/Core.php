<?php
class School_Plugin_Core
{
    public function onUserDeleteAfter($event)
    {
        $payload = $event->getPayload();
        $user_id = $payload['identity'];
        //delete resumes
        $table= Engine_Api::_()->getDbtable('schools', 'school');
        $select= $table->select()
                            ->where('user_id =?', $user_id)
                            ;
        $schools= $table->fetchAll($select);
        if(count($schools)){
            foreach($schools as $school){
                $school_id= $school->school_id;
                try{
                    //xoa artical related
                    Engine_Api::_()->getApi('core','school')->deleteArtical($school_id, $user_id);
                    //xoa activity
                    $action= Engine_Api::_()->getApi('core', 'school')->deleteSchoolActivity($school_id);
                    $action_id= $action->action_id;
                    if($action){
                        $action->delete();
                    }
                    
                    //xoa school
                    //$school->delete();          
                    Engine_Api::_()->getDbtable('schools', 'school')->find($school_id)->current()->delete();
                    //xoa comments activity
                    //Engine_Api::_()->getApi('core', 'school')->deleteCommentSchool($action_id);
                }
                catch(Exception $e ){
                    throw $e;
                }
            }
        } 
    }
}