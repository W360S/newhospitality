<?php 
class Recruiter_View_Helper_Contact extends Zend_View_Helper_Abstract
{
    public function contact($contact_id){
        //get city
        $table = Engine_Api::_()->getDbtable('contacts', 'recruiter');
        $row = $table->fetchRow($table->select()->where('contact_id = ?', $contact_id));
        return $row;
    }
}