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
class Resumes_View_Helper_Language extends Zend_View_Helper_Abstract
{
    public function language($language_id){
        //get city
        $table = Engine_Api::_()->getDbtable('languages', 'resumes');
        $row = $table->fetchRow($table->select()->where('language_id = ?', $language_id));
        return $row;
    }
}