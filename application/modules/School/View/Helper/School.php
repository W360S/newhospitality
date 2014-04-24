<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    School
 * 
 * @author     huynhnv
 * @status     progress
 */

 /*
 Function get city
 
 */
class School_View_Helper_School extends Zend_View_Helper_Abstract
{
    public function school($school_id){
        //get city
        $table = Engine_Api::_()->getDbtable('schools', 'school');
        $row = $table->fetchRow($table->select()->where('school_id = ?', $school_id));
        return $row;
    }
}