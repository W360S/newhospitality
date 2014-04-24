<?php 
//get country
class Recruiter_View_Helper_Country extends Zend_View_Helper_Abstract
{
    public function country($country_id){
        //get city
        $table = Engine_Api::_()->getDbtable('countries', 'resumes');
        $row = $table->fetchRow($table->select()->where('country_id = ?', $country_id));
        return $row;
    }
}