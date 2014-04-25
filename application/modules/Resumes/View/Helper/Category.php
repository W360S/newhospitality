<?php
/**
 * VietHospitality
 *
 * @category   Application_Core
 * @package    Resumes
 * 
 * @author     huynhnv
 * @status     progress
 * @change: industries thay cho occupations
 */

 /*
 Function get city
 
 */
class Resumes_View_Helper_Category extends Zend_View_Helper_Abstract
{
    public function category($category_id){
        //get city
        $table = Engine_Api::_()->getDbtable('industries', 'recruiter');
        $row = $table->fetchRow($table->select()->where('industry_id = ?', $category_id));
        return $row;
    }
}