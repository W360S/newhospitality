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
class Resumes_View_Helper_Degree extends Zend_View_Helper_Abstract
{
    public function degree($degree_id){
        //get city
        $table = Engine_Api::_()->getDbtable('degrees', 'resumes');
        $row = $table->fetchRow($table->select()->where('degree_id = ?', $degree_id));
        return $row;
    }
}