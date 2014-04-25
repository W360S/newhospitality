<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Recruiter
 * 
 * @author     huynhnv
 * @status     progress
 */

 /*
 Function get city
 
 */
class Recruiter_View_Helper_Note extends Zend_View_Helper_Abstract
{
    public function note($applyjob){
        $table= Engine_Api::_()->getDbtable('applyJobs', 'recruiter');
        $select= $table->select()
                    ->where('applyjob_id =?', $applyjob);
        $candidate= $table->fetchRow($select);
        $table_note= Engine_Api::_()->getDbtable('notes', 'recruiter');
        if(!empty($candidate->owner_id)){
            $select_note= $table_note->select()->where('applyjob_id =?', $applyjob)->where('user_id =?', $candidate->owner_id)->order('note_id ASC');
            $notes= $table_note->fetchAll($select_note);
            return $notes;
        }
    }
}