<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Resumes
 * 
 * @author     huynhnv
 * @status     progress
 */

 /*
 Function get city
 
 */
class Resumes_View_Helper_GroupSkill extends Zend_View_Helper_Abstract
{
    public function groupSkill($group_skill_id){
        //get city
        $table = Engine_Api::_()->getDbtable('groupSkills', 'resumes');
        $row = $table->fetchRow($table->select()->where('group_skill_id = ?', $group_skill_id));
        return $row;
    }
}