<?php 
class Recruiter_View_Helper_Industry extends Zend_View_Helper_Abstract
{
    public function industry($industry_id){
        //get city
        $table = Engine_Api::_()->getDbtable('industries', 'recruiter');
        $row = $table->fetchRow($table->select()->where('industry_id = ?', $industry_id));
        
        return $row;
    }
}