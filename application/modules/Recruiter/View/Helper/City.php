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
class Recruiter_View_Helper_City extends Zend_View_Helper_Abstract
{
    public function city($city_id){
        //get city
        $table = Engine_Api::_()->getDbtable('cities', 'resumes');
        $row = $table->fetchRow($table->select()->where('city_id = ?', $city_id));
        return $row;
    }
}